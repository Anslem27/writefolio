import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:writefolio/onboarding/user/get_username.dart';

class WelcomePage extends StatefulWidget {
  const WelcomePage({super.key});

  @override
  State<WelcomePage> createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Align(
                alignment: Alignment.topCenter,
                child: Stack(
                  children: [
                    Align(
                      alignment: Alignment.center,
                      child: Column(
                        children: [
                          const SizedBox(height: 30),
                          Text(
                            "WriteFolio",
                            style: GoogleFonts.lora(
                              fontWeight: FontWeight.w400,
                              fontSize: 50,
                            ),
                          ),
                          Text(
                            "Write your story, your way",
                            style: GoogleFonts.urbanist(),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Align(
              alignment: Alignment.center,
              child: Stack(
                children: [
                  Align(
                    alignment: Alignment.center,
                    child: Image.asset("assets/images/Grad.png"),
                  ),
                  Align(
                    alignment: Alignment.center,
                    child: Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: Text(
                        "Tell your story with us",
                        style: GoogleFonts.lora(
                          fontSize: 32.45,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
            Align(
              child: Stack(
                children: [
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "You Ready?",
                          style: GoogleFonts.urbanist(),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(5),
                          child: Container(
                            width: MediaQuery.of(context).size.width / 2.5,
                            decoration: BoxDecoration(boxShadow: [
                              BoxShadow(
                                  color: Colors.grey.shade200,
                                  spreadRadius: 1,
                                  blurRadius: 15)
                            ]),
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5),
                                ),
                              ),
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  CupertinoPageRoute(
                                    builder: (_) => const GetUsername(),
                                  ),
                                );
                              },
                              child: const Text("Get Started"),
                            ),
                          ),
                        ),
                        const SizedBox(height: 40)
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
