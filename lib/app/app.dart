import 'package:flutter/material.dart';

import '../features/onboarding/onboarding_screen.dart';

class CareerPilotAI extends StatelessWidget {
  const CareerPilotAI({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'CareerPilot AI',
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.indigo,
      ),
      home: const OnboardingScreen(),
    );
  }
}