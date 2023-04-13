// ignore_for_file: use_build_context_synchronously

import 'package:animated_snack_bar/animated_snack_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_phosphor_icons/flutter_phosphor_icons.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:writefolio/services/auth_service.dart';
import 'package:writefolio/utils/widgets/loader.dart';
import '../../../editor/create_article.dart';

/// And then optionally use Google sign-in preferably
class SignInPage extends StatefulWidget {
  const SignInPage({super.key});

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  LongPressGestureRecognizer _longPressRecognizer =
      LongPressGestureRecognizer();

  final emailController = TextEditingController();
  final passwordController = TextEditingController();

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

  void signIn() async {
    showDialog(
        context: context,
        builder: (_) {
          return const Center(child: LoadingAnimation());
        });

    if (emailController.text.isEmpty || passwordController.text.isEmpty) {
      AnimatedSnackBar.material(
        "Fields are not properly filled",
        type: AnimatedSnackBarType.error,
        mobileSnackBarPosition: MobileSnackBarPosition.bottom,
      ).show(context);
      Navigator.pop(context); //pop to loading animation

      logger.wtf("Fields are not properly filled");
    } else {
      try {
        await FirebaseAuth.instance
            .signInWithEmailAndPassword(
          email: emailController.text.trim(),
          password: passwordController.text.trim(),
        )
            .then((value) {
          AnimatedSnackBar.material(
            "Successfully logged in as ${emailController.text}",
            type: AnimatedSnackBarType.success,
            mobileSnackBarPosition: MobileSnackBarPosition.bottom,
          ).show(context);
        });
        Navigator.pop(context); //pop to loading animation
        logger.i("signing in...");
      } on FirebaseAuthException catch (e) {
        if (e.code == "user-not-found") {
          AnimatedSnackBar.material(
            "Oops user not found",
            type: AnimatedSnackBarType.error,
            mobileSnackBarPosition: MobileSnackBarPosition.bottom,
          ).show(context);
          logger.e("Error: ${e.code}");
          Navigator.pop(context); //pop to loading animation
        } else if (e.code == "wrong-password") {
          AnimatedSnackBar.material(
            "Wrong Password",
            type: AnimatedSnackBarType.info,
            mobileSnackBarPosition: MobileSnackBarPosition.bottom,
          ).show(context);
          logger.e("Error: ${e.code}");
          Navigator.pop(context); //pop to loading animation
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    bool isVisible = false;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Sign In"),
      ),
      body: SafeArea(
        child: ListView(
          physics: const ScrollPhysics(),
          children: [
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
                    onPressed: () => GoogleAuthService().signInWithGoogle(),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          PhosphorIcons.google_logo_bold,
                          color: Colors.white,
                        ),
                        const SizedBox(width: 5),
                        Text(
                          "Sign in with Google",
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
                obscureText: isVisible,
                controller: passwordController,
                decoration: InputDecoration(
                  hintText: "Password",
                  suffixIcon: IconButton(
                    onPressed: () {
                      setState(() {
                        isVisible = !isVisible;
                        logger.i(isVisible);
                      });
                    },
                    icon: const Icon(
                      Icons.visibility,
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  InkWell(
                    onTap: () {},
                    child: Text(
                      "Forgot password?",
                      style: GoogleFonts.roboto(
                        color: Colors.grey,
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
                child: InkWell(
                  child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      onPressed: signIn,
                      child: Text(
                        "Continue",
                        style: GoogleFonts.roboto(
                          fontSize: 16,
                        ),
                      )),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  const Text("Dont have an account?"),
                  const SizedBox(width: 5),
                  InkWell(
                    onTap: () {
                      Navigator.pushNamed(context, "/createAccount");
                    },
                    child: Text(
                      "Create account",
                      style: GoogleFonts.roboto(
                        color: Colors.blue,
                      ),
                    ),
                  )
                ],
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

  void _handlePress() {
    logger.i("Privacy Policy clicked");
    HapticFeedback.vibrate();
  }
}
