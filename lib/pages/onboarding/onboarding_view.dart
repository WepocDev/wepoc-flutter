import 'package:fluffychat/pages/onboarding/onboarding_step_view.dart';
import 'package:flutter/material.dart';
import 'package:onboarding/onboarding.dart';

class OnboardingView extends StatelessWidget {
  const OnboardingView({super.key});

  @override
  Widget build(BuildContext context) {
    return Onboarding(
      swipeableBody: const [
        OnboardingStepView(),
        OnboardingStepView(),
        OnboardingStepView(),
      ],
      startIndex: 0,
    );
  }
}
