import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../routes/app_routes.dart';

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }
        
        if (snapshot.hasData) {
          // User is signed in
          return Navigator(
            onGenerateRoute: (settings) {
              return MaterialPageRoute(
                builder: (context) => const EntryPointPage(),
              );
            },
          );
        } else {
          // User is not signed in
          return Navigator(
            onGenerateRoute: (settings) {
              return MaterialPageRoute(
                builder: (context) => const OnboardingPage(),
              );
            },
          );
        }
      },
    );
  }
}

// Temporary placeholder widgets - these should be imported from your existing views
class EntryPointPage extends StatelessWidget {
  const EntryPointPage({super.key});

  @override
  Widget build(BuildContext context) {
    // This should be replaced with your actual entry point page
    return const Scaffold(
      body: Center(
        child: Text('Entry Point - User is signed in'),
      ),
    );
  }
}

class OnboardingPage extends StatelessWidget {
  const OnboardingPage({super.key});

  @override
  Widget build(BuildContext context) {
    // This should be replaced with your actual onboarding page
    return const Scaffold(
      body: Center(
        child: Text('Onboarding - User is not signed in'),
      ),
    );
  }
}
