import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:writefolio/onboarding/onboard/screens/sign_in.dart';
import 'package:writefolio/screens/library/libary.dart';
import 'package:writefolio/screens/navigation.dart';
import 'package:writefolio/utils/widgets/loader.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({Key? key}) : super(key: key);

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  final Stream<User?> _authStateStream =
      FirebaseAuth.instance.authStateChanges();
  StreamSubscription<InternetConnectionStatus>? _connectionSubscription;
  bool _isOnline = true;

  @override
  void initState() {
    super.initState();
    // Check the internet connectivity when the widget is initialized
    _checkInternetConnectivity();
  }

  @override
  void dispose() {
    super.dispose();
    // Cancel the internet connectivity subscription
    _connectionSubscription?.cancel();
  }

  Future<void> _checkInternetConnectivity() async {
    // Wait for the future to complete and then set the value of _isOnline
    _isOnline = await InternetConnectionChecker().hasConnection;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    if (!_isOnline) {
      // Show the offline widget if there is no internet connectivity
      return Scaffold(
        body: Center(
          child: Column(
            // physics: const ScrollPhysics(),
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.wifi_off, size: 64),
              const SizedBox(height: 16),
              const Text("No internet connection."),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    _checkInternetConnectivity();
                  });
                },
                child: const Text("Refresh"),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const LibraryScreen(),
                    ),
                  );
                },
                child: const Text("Open Library"),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      body: StreamBuilder<User?>(
        stream: _authStateStream,
        builder: (_, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: LoadingAnimation(),
            );
          }

          if (snapshot.hasData) {
            return const Navigation();
          } else {
            return const SignInPage();
          }
        },
      ),
    );
  }
}
