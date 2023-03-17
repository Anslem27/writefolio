// ignore_for_file: use_build_context_synchronously

import 'package:animated_snack_bar/animated_snack_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_phosphor_icons/flutter_phosphor_icons.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:logger/logger.dart';
import '../../animations/onboarding_pulse_animation.dart';
import 'verify_user.dart';

var logger = Logger(); //debugging variable

class GetUsername extends StatefulWidget {
  const GetUsername({super.key});

  @override
  State<GetUsername> createState() => _GetUsernameState();
}

class _GetUsernameState extends State<GetUsername> {
  TextEditingController usernameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            const Align(
              alignment: AlignmentDirectional(-2, -1.5),
              child: SizedBox(
                height: 250,
                child: OnboardingPulseAnimation(),
              ),
            ),
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
                          Row(
                            children: [
                              IconButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                icon: const Icon(CupertinoIcons.chevron_back),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 8.0),
                                child: Text(
                                  "Get Started",
                                  style: GoogleFonts.lora(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 30,
                                  ),
                                ),
                              ),
                            ],
                          ),
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
                  const Align(
                    alignment: Alignment.center,
                    child: OnboardingPulseAnimation(),
                  ),
                  Align(
                    alignment: Alignment.center,
                    child: Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: Text(
                        "One step at a time",
                        textAlign: TextAlign.center,
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
                        const Text(
                          "Enter your medium username.",
                          style: TextStyle(fontSize: 16),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: TextField(
                            controller: usernameController,
                            decoration: InputDecoration(
                              suffixIcon: const Icon(
                                PhosphorIcons.medium_logo_fill,
                              ),
                              enabledBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(width: 1),
                                  borderRadius: BorderRadius.circular(12)),
                              focusedBorder: OutlineInputBorder(
                                borderSide: const BorderSide(width: 1),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              labelText: 'Enter medium username...',
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: SizedBox(
                            width: MediaQuery.of(context).size.width / 0.8,
                            child: OutlinedButton(
                              onPressed: () {
                                //check internet availability
                                /* bool result = await InternetConnectionChecker()
                                      .hasConnection; */

                                //check for null value
                                if (usernameController.text == "") {
                                  AnimatedSnackBar.material(
                                    'User name can not be empty.',
                                    type: AnimatedSnackBarType.warning,
                                    duration: const Duration(seconds: 4),
                                    mobileSnackBarPosition:
                                        MobileSnackBarPosition.bottom,
                                  ).show(context);
                                } else {
                                  AnimatedSnackBar.material(
                                    "Please check your internet connection.",
                                    type: AnimatedSnackBarType.info,
                                    duration: const Duration(seconds: 4),
                                    mobileSnackBarPosition:
                                        MobileSnackBarPosition.bottom,
                                  ).show(context);
                                  //Navigator.pushNamed(context, "/noInternet");
                                  Navigator.push(
                                    context,
                                    CupertinoPageRoute(
                                      builder: (_) => VerifyUser(
                                        username:
                                            usernameController.text.trim(),
                                      ),
                                    ),
                                  );
                                }
                                //authorize if internet is available
                                /*   if (result == true) {
                                    AnimatedSnackBar.material(
                                      "Medium username: ${usernameController.text}",
                                      type: AnimatedSnackBarType.info,
                                      duration: const Duration(seconds: 4),
                                      mobileSnackBarPosition:
                                          MobileSnackBarPosition.bottom,
                                    ).show(context);
                        
                                    await fetchUserInfo(usernameController.text)
                                        .then((value) => {logger.i(value.items)});
                                    logger.i(
                                        "Medium username: ${usernameController.text}");
                                  } */
                              },
                              child: const Text("Continue"),
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
