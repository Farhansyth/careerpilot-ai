import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../features/auth/login_screen.dart';
import '../features/dashboard/dashboard_screen.dart';

class CareerPilotAI extends StatelessWidget {
  const CareerPilotAI({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'CareerPilot AI',
      theme: ThemeData(useMaterial3: true, colorSchemeSeed: Colors.indigo),
      home: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          }

          if (snapshot.hasData) {
            return const DashboardScreen();
          }

          return const LoginScreen();
        },
      ),
    );
  }
}
