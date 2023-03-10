import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phosphor_icons/flutter_phosphor_icons.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:writefolio/onboarding/user/get_username.dart';

import '../../animations/deep_pulse_animation.dart';
import '../../animations/onboarding_pulse_animation.dart';
import '../../utils/widgets/theme_button.dart';

class WelcomePage extends StatefulWidget {
  const WelcomePage({super.key});

  @override
  State<WelcomePage> createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        width: double.infinity,
        height: double.infinity,
        child: Stack(
          alignment: const AlignmentDirectional(0, 1),
          children: [
            Align(
              alignment: const AlignmentDirectional(1, -1.4),
              child: Container(
                width: 500,
                height: 500,
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor.withOpacity(0.5),
                  shape: BoxShape.circle,
                ),
              ),
            ),
            const Align(
              alignment: AlignmentDirectional(-2, -1.5),
              child: DeepPulseAnimation(),
            ),
            Align(
              alignment: const AlignmentDirectional(-1.25, -1.5),
              child: Container(
                  width: 600,
                  height: 600,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                  ),
                  child: const OnboardingPulseAnimation()),
            ),
            Align(
              alignment: const AlignmentDirectional(2.5, -1.2),
              child: Container(
                width: 300,
                height: 300,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                ),
                child: const DeepPulseAnimation(),
              ),
            ),
            Align(
              alignment: const AlignmentDirectional(1, -0.95),
              child: Container(
                  width: 700,
                  height: 700,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                  ),
                  child: const Expanded(child: OnboardingPulseAnimation())),
            ),
            Align(
              alignment: const AlignmentDirectional(0, 1),
              child: ClipRRect(
                child: BackdropFilter(
                  filter: ImageFilter.blur(
                    sigmaX: 40,
                    sigmaY: 40,
                  ),
                  child: Align(
                    alignment: const AlignmentDirectional(0, 1),
                    child: Container(
                      width: double.infinity,
                      height: double.infinity,
                      alignment: const AlignmentDirectional(0, 1),
                      child: Align(
                        alignment: const AlignmentDirectional(0, 1),
                        child: Column(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Padding(
                              padding: const EdgeInsetsDirectional.fromSTEB(
                                  0, 64, 0, 24),
                              child: Row(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Stack(
                                    children: [
                                      Text(
                                        "WriteFolio",
                                        style: GoogleFonts.lora(
                                          fontWeight: FontWeight.w400,
                                          fontSize: 50,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            Flexible(
                              child: Text(
                                "Write your story, your way.",
                                style: GoogleFonts.urbanist(),
                              ),
                            ),
                            Expanded(
                                child: RichText(
                                    text: TextSpan(children: [
                              TextSpan(
                                text: "Tell your",
                                style: GoogleFonts.lora(
                                  color: Colors.black,
                                  fontSize: 32.45,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                              TextSpan(
                                text: " story",
                                style: GoogleFonts.urbanist(
                                  color: Colors.black,
                                  fontSize: 32.45,
                                  fontStyle: FontStyle.italic,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              TextSpan(
                                text: " with us",
                                style: GoogleFonts.lora(
                                  color: Colors.black,
                                  fontSize: 32.45,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ]))),
                            Expanded(
                              child: Align(
                                alignment: const AlignmentDirectional(0, 1),
                                child: Container(
                                  width: double.infinity,
                                  height: 500,
                                  constraints: const BoxConstraints(
                                    maxWidth: 570,
                                  ),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.max,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            "Connect with medium",
                                            style: GoogleFonts.urbanist(
                                              color: Colors.deepOrange,
                                            ),
                                          ),
                                          const SizedBox(width: 10),
                                          const Icon(
                                            PhosphorIcons.medium_logo,
                                          )
                                        ],
                                      ),
                                      Text(
                                        "You Ready?",
                                        style: GoogleFonts.urbanist(),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(5),
                                        child: Container(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width /
                                              2.5,
                                          decoration: BoxDecoration(boxShadow: [
                                            BoxShadow(
                                                color: Colors.grey.shade200,
                                                spreadRadius: 1,
                                                blurRadius: 15)
                                          ]),
                                          child: SButton(
                                            text: "Get Started",
                                            width: 270,
                                            ontap: () {
                                              Navigator.push(
                                                context,
                                                CupertinoPageRoute(
                                                  builder: (_) =>
                                                      const GetUsername(),
                                                ),
                                              );
                                            },
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
