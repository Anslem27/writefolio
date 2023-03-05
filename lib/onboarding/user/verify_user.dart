import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:writefolio/models/user_model.dart';
import '../../animations/onboarding_pulse_animation.dart';
import '../../services/user_service.dart';
import 'package:logger/logger.dart';

var logger = Logger();

class VerifyUser extends StatefulWidget {
  final String username;
  const VerifyUser({super.key, required this.username});

  @override
  State<VerifyUser> createState() => _VerifyUserState();
}

class _VerifyUserState extends State<VerifyUser> {
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
                                  "Verify Account",
                                  style: GoogleFonts.lora(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 35,
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
                        "Is this your medium account?",
                        textAlign: TextAlign.center,
                        style: GoogleFonts.lora(
                          fontSize: 30.45,
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
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: FutureBuilder<MediumUser>(
                              future: fetchUserInfo(widget.username),
                              builder: (context, snapshot) {
                                if (!snapshot.hasData) {
                                  return const Center(
                                    child: CircularProgressIndicator(),
                                  );
                                }
                                if (snapshot.hasError) {
                                  logger.w(
                                      snapshot.error.toString()); //debug error
                                  return Text(
                                    "Error looking up: @${widget.username}",
                                    textAlign: TextAlign.center,
                                    style: GoogleFonts.urbanist(fontSize: 16),
                                  );
                                }
                                return AnimatedContainer(
                                  curve: Curves.bounceInOut,
                                  duration: const Duration(milliseconds: 1000),
                                  child: CircleAvatar(
                                    radius: 80,
                                    backgroundImage:
                                        NetworkImage(snapshot.data!.feed.image),
                                  ),
                                );
                              }),
                        ),
                        SizedBox(
                          height: 28,
                          child: Padding(
                            padding: const EdgeInsets.only(bottom: 5.0),
                            child: Text(
                              "@${widget.username}",
                              style: GoogleFonts.urbanist(fontSize: 16),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(5),
                          child: Container(
                              width: MediaQuery.of(context).size.width / 1.5,
                              decoration: BoxDecoration(boxShadow: [
                                BoxShadow(
                                    color: Colors.grey.shade200,
                                    spreadRadius: 1,
                                    blurRadius: 15)
                              ]),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(5),
                                      ),
                                    ),
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    child: const Text("Try Again"),
                                  ),
                                  ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(5),
                                      ),
                                    ),
                                    onPressed: () {
                                      Navigator.pushNamed(context, "/home");
                                    },
                                    child: const Text("Continue"),
                                  ),
                                ],
                              )),
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
