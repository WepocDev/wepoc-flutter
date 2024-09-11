import 'package:fluffychat/pages/onboarding/onboarding_step_view.dart';
import 'package:fluffychat/widgets/fluffy_chat_app.dart';
import 'package:flutter/material.dart';
import 'package:onboarding/onboarding.dart';

class OnBoardingView extends StatefulWidget {
  const OnBoardingView({super.key});

  @override
  OnboardingViewState createState() => OnboardingViewState();
}

class OnboardingViewState extends State<OnBoardingView> {
  int pageIndex = 0;

  // TODO: Get translations for this but client's focusing only in US
  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFF16181D),
      padding: const EdgeInsets.only(bottom: 28.0),
      alignment: Alignment.topCenter,
      child: Column(
        children: [
          Expanded(
            child: Onboarding(
              swipeableBody: [
                OnboardingStepView(
                  image: Image.asset("assets/onboarding_connect.png"),
                  title: "Connect",
                  description:
                      "In this pubic lounge, you can foster relationships and stay in touch with people. It offers features for social networking, communication, and building connections with friends, family, and colleagues.",
                ),
                OnboardingStepView(
                  image: Image.asset("assets/onboarding_consult.png"),
                  title: "Consult",
                  description:
                      "This public room serves as a platform for seeking expert advice and guidance. It connects users with professionals or experts in various fields, facilitating consultations, advice-seeking, and problem-solving.",
                ),
                OnboardingStepView(
                  image: Image.asset("assets/onboarding_create.png"),
                  title: "Create",
                  description:
                      "This public Lounge is about unleashing your creativity. It provides tools and features to design, craft, and produce various digital content, whether it's art, music, documents, or other creative projects.",
                ),
              ],
              startIndex: 0,
              onPageChanges: (
                netDragDistance,
                pagesLength,
                currentIndex,
                slideDirection,
              ) =>
                  setState(() {
                pageIndex++;
              }),
            ),
          ),
          Container(
            width: 50.0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: new List<Widget>.generate(
                3,
                (i) => Container(
                  height: 6.0,
                  width: 6.0,
                  decoration: BoxDecoration(
                    color: (i == pageIndex)
                        ? Theme.of(context).colorScheme.primary
                        : Colors.grey,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 50.0),
          FilledButton(
            onPressed: () => FluffyChatApp.router.go('/home/login'),
            child: Text("Create account"),
          ),
          const SizedBox(height: 10.0),
          TextButton(
            onPressed: () => FluffyChatApp.router.go('/home/login'),
            child: Text("I already have an account"),
          ),
        ],
      ),
    );
  }
}
