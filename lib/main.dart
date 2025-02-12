import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:collection/collection.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:matrix/matrix.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'package:fluffychat/config/app_config.dart';
import 'package:fluffychat/utils/client_manager.dart';
import 'package:fluffychat/utils/platform_infos.dart';
import 'package:fluffychat/widgets/error_widget.dart';
import 'config/setting_keys.dart';
import 'utils/background_push.dart';
import 'widgets/fluffy_chat_app.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';

Future<void> main() async {
  Logs().i('Welcome to ${AppConfig.applicationName} <3');

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await dotenv.load(fileName: ".env");

  print("AAAAA ${dotenv.env['REVENUE_CAT_ANDROID_KEY']!}");

  try {
    PurchasesConfiguration? configuration;
    if (Platform.isAndroid) {
      configuration = PurchasesConfiguration(
          dotenv.env['REVENUE_CAT_ANDROID_KEY']!); // NEED ANDROID API KEY
    } else if (Platform.isIOS) {
      configuration =
          PurchasesConfiguration(dotenv.env['REVENUE_CAT_IOS_KEY']!);
    }

    print("Config $configuration");
    if (configuration != null) {
      await Purchases.setDebugLogsEnabled(true);
      configuration.usesStoreKit2IfAvailable = false;
      await Purchases.configure(configuration);
    }
    // ignore: empty_catches
  } catch (error) {}

  Logs().nativeColors = !PlatformInfos.isIOS;
  final store = await SharedPreferences.getInstance();
  final clients = await ClientManager.getClients(store: store);

  // If the app starts in detached mode, we assume that it is in
  // background fetch mode for processing push notifications. This is
  // currently only supported on Android.
  if (PlatformInfos.isAndroid &&
      AppLifecycleState.detached == WidgetsBinding.instance.lifecycleState) {
    // Do not send online presences when app is in background fetch mode.
    for (final client in clients) {
      client.backgroundSync = false;
      client.syncPresence = PresenceType.offline;
    }

    // In the background fetch mode we do not want to waste ressources with
    // starting the Flutter engine but process incoming push notifications.
    BackgroundPush.clientOnly(clients.first);
    // To start the flutter engine afterwards we add an custom observer.
    WidgetsBinding.instance.addObserver(AppStarter(clients, store));
    Logs().i(
      '${AppConfig.applicationName} started in background-fetch mode. No GUI will be created unless the app is no longer detached.',
    );
    return;
  }

  // Started in foreground mode.
  Logs().i(
    '${AppConfig.applicationName} started in foreground mode. Rendering GUI...',
  );
  await startGui(clients, store);
}

/// Fetch the pincode for the applock and start the flutter engine.
Future<void> startGui(List<Client> clients, SharedPreferences store) async {
  // Fetch the pin for the applock if existing for mobile applications.
  String? pin;
  if (PlatformInfos.isMobile) {
    try {
      pin =
          await const FlutterSecureStorage().read(key: SettingKeys.appLockKey);
    } catch (e, s) {
      Logs().d('Unable to read PIN from Secure storage', e, s);
    }
  }

  // Preload first client
  final firstClient = clients.firstOrNull;
  await firstClient?.roomsLoading;
  await firstClient?.accountDataLoading;

  ErrorWidget.builder = (details) => FluffyChatErrorWidget(details);
  runApp(FluffyChatApp(clients: clients, pincode: pin, store: store));
}

/// Watches the lifecycle changes to start the application when it
/// is no longer detached.
class AppStarter with WidgetsBindingObserver {
  final List<Client> clients;
  final SharedPreferences store;
  bool guiStarted = false;

  AppStarter(this.clients, this.store);

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (guiStarted) return;
    if (state == AppLifecycleState.detached) return;

    Logs().i(
      '${AppConfig.applicationName} switches from the detached background-fetch mode to ${state.name} mode. Rendering GUI...',
    );
    // Switching to foreground mode needs to reenable send online sync presence.
    for (final client in clients) {
      client.backgroundSync = true;
      client.syncPresence = PresenceType.online;
    }
    startGui(clients, store);
    // We must make sure that the GUI is only started once.
    guiStarted = true;
  }
}
