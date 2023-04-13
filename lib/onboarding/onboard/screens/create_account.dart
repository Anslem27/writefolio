// ignore_for_file: use_build_context_synchronously

import 'package:animated_snack_bar/animated_snack_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phosphor_icons/flutter_phosphor_icons.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../editor/create_article.dart';
import '../../../services/auth_service.dart';
import '../../../utils/widgets/loader.dart';

/// Capture whether user wants to connect medium account in precending steps
/// And then optionally create account or use Google sign-in preferably
class CreateAccountPage extends StatefulWidget {
  const CreateAccountPage({super.key});

  @override
  State<CreateAccountPage> createState() => _CreateAccountPageState();
}

class _CreateAccountPageState extends State<CreateAccountPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final rechechpasswordsController = TextEditingController();

  LongPressGestureRecognizer _longPressRecognizer =
      LongPressGestureRecognizer();

  @override
  void initState() {
    _longPressRecognizer = LongPressGestureRecognizer()
      ..onLongPress = _handlePress;
    super.initState();
  }

  @override
  void dispose() {
    _longPressRecognizer.dispose();
    super.dispose();
  }

  void signUp() async {
    showDialog(
        context: context,
        builder: (_) {
          return const Center(child: LoadingAnimation());
        });

    try {
      if (passwordController.text == rechechpasswordsController.text) {
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: emailController.text.trim(),
          password: passwordController.text.trim(),
        );

        logger.i("signing up...");
      } else {
        AnimatedSnackBar.material(
          "Passwords do not match",
          type: AnimatedSnackBarType.warning,
          mobileSnackBarPosition: MobileSnackBarPosition.bottom,
        ).show(context);

        logger.wtf("Passwords do not match");
      }
      Navigator.pop(context); //pop to loading animation
    } on FirebaseAuthException {
      Navigator.pop(context); //pop to loading animation
      AnimatedSnackBar.material(
        "Something unexpected occured",
        type: AnimatedSnackBarType.error,
        mobileSnackBarPosition: MobileSnackBarPosition.bottom,
      ).show(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Create account"),
      ),
      body: SafeArea(
        child: ListView(
          physics: const ScrollPhysics(),
          children: [
            //create account with google
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: SizedBox(
                width: double.maxFinite,
                height: 55,
                child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey.shade800,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    onPressed: () async {
                      try {
                        await GoogleAuthService().signInWithGoogle();
                      } catch (e) {
                        AnimatedSnackBar.material(
                          "Failed to authenticate with Google",
                          type: AnimatedSnackBarType.warning,
                          mobileSnackBarPosition: MobileSnackBarPosition.bottom,
                        ).show(context);
                      }
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          PhosphorIcons.google_logo_bold,
                          color: Colors.white,
                        ),
                        const SizedBox(width: 5),
                        Text(
                          "Sign up with Google",
                          style: GoogleFonts.roboto(
                            fontSize: 16,
                          ),
                        )
                      ],
                    )),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(hintText: "Email"),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                keyboardType: TextInputType.visiblePassword,
                controller: passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  hintText: "Password (min. 8 characters)",
                  suffixIcon: IconButton(
                    onPressed: () {
                      setState(() {});
                    },
                    icon: const Icon(
                      Icons.visibility,
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                keyboardType: TextInputType.visiblePassword,
                controller: rechechpasswordsController,
                obscureText: true,
                decoration: InputDecoration(
                  hintText: "Repeat Password",
                  suffixIcon: IconButton(
                    onPressed: () {},
                    icon: const Icon(
                      Icons.visibility,
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  const Text("Already have an account?"),
                  const SizedBox(width: 5),
                  InkWell(
                    onTap: () {
                      Navigator.pushNamedAndRemoveUntil(context, "/signIn",
                          (route) => false); //TODO: Add a welcome page instead
                    },
                    child: Text(
                      "Log In",
                      style: GoogleFonts.roboto(
                        color: Colors.blue,
                      ),
                    ),
                  )
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: SizedBox(
                width: double.maxFinite,
                height: 55,
                child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    onPressed: signUp,
                    child: Text(
                      "Create account",
                      style: GoogleFonts.roboto(
                        fontSize: 16,
                      ),
                    )),
              ),
            ),

            const Padding(
              padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 5),
              child: Text(
                "If you click  'Connect medium account'  your medium articles will be fetched from an online service and displayed in the app for you to reflect upon.",
                style: TextStyle(),
              ),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 5),
              child: Text(
                "If you click  'Sign Up with google ' or 'Sign up with email' and are not a writefolio user, you will be registered nad agree to writefolio's Terms and Conditions and Privacy Policy.",
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 5),
              child: RichText(
                text: TextSpan(
                  children: [
                    const TextSpan(
                      text:
                          "We may use information you provide to us to make better suggestions, for further details kindly refer to our ",
                      style: TextStyle(
                        color: Colors.grey,
                      ),
                    ),
                    TextSpan(
                      text: "Privacy Policy.",
                      recognizer: _longPressRecognizer,
                      style: const TextStyle(
                        color: Colors.blue,
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  void _handlePress() {}
}
