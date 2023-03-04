// ignore_for_file: use_build_context_synchronously

import 'package:animated_snack_bar/animated_snack_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_phosphor_icons/flutter_phosphor_icons.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:logger/logger.dart';
import 'package:writefolio/services/user_service.dart';

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
                                    fontWeight: FontWeight.w400,
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
                  Align(
                    alignment: Alignment.center,
                    child: Image.asset("assets/images/Grad.png"),
                  ),
                  Align(
                    alignment: Alignment.center,
                    child: Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: Text(
                        "One step at a time",
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
                          "Enter your medium username.",
                          style: GoogleFonts.urbanist(fontSize: 16),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: TextField(
                            controller: usernameController,
                            decoration: InputDecoration(
                              suffixIcon: const Icon(
                                PhosphorIcons.medium_logo_fill,
                              ),
                              filled: true,
                              fillColor: Theme.of(context)
                                  .primaryColor
                                  .withOpacity(.2),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Theme.of(context).primaryColor,
                                    width: 2),
                                borderRadius:
                                    BorderRadius.circular(100).copyWith(
                                  bottomRight: const Radius.circular(0),
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Theme.of(context).primaryColor,
                                  width: 2,
                                ),
                                borderRadius:
                                    BorderRadius.circular(100).copyWith(
                                  bottomRight: const Radius.circular(0),
                                ),
                              ),
                              labelText: 'Enter medium username...',
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(5),
                          child: Container(
                            width: MediaQuery.of(context).size.width / 2.5,
                            decoration: BoxDecoration(boxShadow: [
                              BoxShadow(
                                color: Colors.grey.shade200,
                                spreadRadius: 1,
                                blurRadius: 15,
                              )
                            ]),
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5),
                                ),
                              ),
                              clipBehavior: Clip.antiAlias,
                              onPressed: () async {
                                //check internet availability
                                bool result = await InternetConnectionChecker()
                                    .hasConnection;

                                //check for null value
                                if (usernameController.text == "") {
                                  AnimatedSnackBar.material(
                                    'User name can not be empty.',
                                    type: AnimatedSnackBarType.warning,
                                    duration: const Duration(seconds: 4),
                                    mobileSnackBarPosition:
                                        MobileSnackBarPosition.bottom,
                                  ).show(context);
                                }
                                //authorize if internet is available
                                if (result == true) {
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
                                } else {
                                  AnimatedSnackBar.material(
                                    "Please check your internet connection.",
                                    type: AnimatedSnackBarType.info,
                                    duration: const Duration(seconds: 4),
                                    mobileSnackBarPosition:
                                        MobileSnackBarPosition.bottom,
                                  ).show(context);
                                }
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
