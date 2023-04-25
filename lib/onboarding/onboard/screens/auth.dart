import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
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

  final internetAvailabilityStream = InternetConnectionChecker().onStatusChange;
  // ignore: unused_field
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
    return StreamBuilder<InternetConnectionStatus>(
      stream: internetAvailabilityStream,
      builder: (_, internetConnectionSnapshot) {
        if (internetConnectionSnapshot.connectionState ==
                ConnectionState.waiting ||
            internetConnectionSnapshot.connectionState ==
                ConnectionState.none) {
          return const Center(
            child: LoadingAnimation(),
          );
        }

        final status = internetConnectionSnapshot.data;
        if (status == InternetConnectionStatus.connected) {
          return Scaffold(
            body: StreamBuilder<User?>(
              stream: _authStateStream,
              builder: (_, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: LoadingAnimation(),
                  );
                } else if (snapshot.connectionState == ConnectionState.none) {
                  return errorScreen(context);
                }

                if (snapshot.hasData) {
                  return const Navigation();
                } else {
                  return const SignInPage();
                }
              },
            ),
          );
        } else {
          return noInternetBody(context);
        }
      },
    );
  }

  Scaffold noInternetBody(BuildContext context) {
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: _checkInternetConnectivity,
        child: Center(
          child: Column(
            // physics: const ScrollPhysics(),
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SvgPicture.asset(
                "assets/illustrations/no-connection.svg",
                height: 200,
              ),
              const SizedBox(height: 16),
              Text(
                "It looks like your offline",
                style: GoogleFonts.roboto(fontSize: 16),
              ),
              const Text("Check your connection and try again"),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    _checkInternetConnectivity();
                  });
                },
                child: const Text("Refresh"),
              ),
              OutlinedButton(
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
      ),
    );
  }

  Scaffold errorScreen(BuildContext context) {
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: _checkInternetConnectivity,
        child: Center(
          child: Column(
            // physics: const ScrollPhysics(),
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SvgPicture.asset(
                "assets/illustrations/none-found.svg",
                height: 200,
              ),
              const SizedBox(height: 16),
              Text(
                "Its not you its us",
                style: GoogleFonts.roboto(fontSize: 16),
              ),
              const Text("Check your connection and try again"),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    _checkInternetConnectivity();
                  });
                },
                child: const Text("Refresh"),
              ),
              OutlinedButton(
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
      ),
    );
  }
}
