import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phosphor_icons/flutter_phosphor_icons.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../editor/create_article.dart';

/// Capture whether user wants to connect medium account
/// And then optionally create account or use Google sign-in preferably
class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
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

  @override
  Widget build(BuildContext context) {
    bool isVisible = false;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Create Account"),
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
                child: InkWell(
                  onTap: () {},
                  child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      onPressed: () {},
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            PhosphorIcons.medium_logo_bold,
                            color: Colors.black,
                          ),
                          const SizedBox(width: 5),
                          Text(
                            "Connect medium account",
                            style: GoogleFonts.roboto(
                                fontSize: 16, color: Colors.black),
                          )
                        ],
                      )),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: SizedBox(
                width: double.maxFinite,
                height: 55,
                child: InkWell(
                  onTap: () {},
                  child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey.shade800,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      onPressed: () {},
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            PhosphorIcons.google_logo_bold,
                            color: Colors.white,
                          ),
                          const SizedBox(width: 5),
                          Text(
                            "Sign Up with Google",
                            style: GoogleFonts.roboto(
                              fontSize: 16,
                            ),
                          )
                        ],
                      )),
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: TextField(
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(hintText: "Email"),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                keyboardType: TextInputType.visiblePassword,
                obscureText: isVisible,
                decoration: InputDecoration(
                    hintText: "Password (min. 8 characters)",
                    suffixIcon: IconButton(
                        onPressed: () {
                          setState(() {
                            isVisible = !isVisible;
                            logger.i(isVisible);
                          });
                        },
                        icon: const Icon(
                          Icons.visibility,
                        ))),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: SizedBox(
                width: double.maxFinite,
                height: 55,
                child: InkWell(
                  onTap: () {},
                  child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      onPressed: () {
                        Navigator.pushNamed(context, "/navigation");
                      },
                      child: Text(
                        "Sign Up with email",
                        style: GoogleFonts.roboto(
                          fontSize: 16,
                        ),
                      )),
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 8.0),
              child: Text(
                "If you click  'Connect medium account'  your medium articles will be fetched from an online service and displayed in the app for you to reflect upon.",
                style: TextStyle(),
              ),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 8.0),
              child: Text(
                "If you click  'Sign Up with google ' or 'Sign up with email' and are not a writefolio user, you will be registered nad agree to writefolio's Terms and Conditions and Privacy Policy.",
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
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
  }
}
