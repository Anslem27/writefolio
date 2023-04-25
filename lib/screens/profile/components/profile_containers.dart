// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:flutter_phosphor_icons/flutter_phosphor_icons.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:writefolio/editor/create_article.dart';
import 'package:writefolio/utils/widgets/loader.dart';

import '../../../models/user/medium_user_model.dart';
import '../../../services/reddit_user_fecth_service.dart';
import '../../../services/user_service.dart';

class ConnectedAccountsAvatars extends StatefulWidget {
  const ConnectedAccountsAvatars({super.key});

  @override
  _ConnectedAccountsAvatarsState createState() =>
      _ConnectedAccountsAvatarsState();
}

class _ConnectedAccountsAvatarsState extends State<ConnectedAccountsAvatars> {
  int _selectedItem = 0;
  final settingsBox = Hive.box("settingsBox");

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
        valueListenable: settingsBox.listenable(),
        builder: (_, settingsBoxVariable, ___) {
          String currentMediumUser =
              settingsBoxVariable.get('mediumUsername', defaultValue: "");

          String currentRedditUser =
              settingsBoxVariable.get("redditUsername", defaultValue: "");
          return Row(
            children: List.generate(
              2,
              (index) {
                bool isSelected = index == _selectedItem;

                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectedItem = index;
                      });
                    },
                    child: Card(
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        width: isSelected
                            ? MediaQuery.of(context).size.width / 2.5
                            : MediaQuery.of(context).size.width / 3.5,
                        height: isSelected ? 220 : 180,
                        decoration: BoxDecoration(
                          borderRadius:
                              BorderRadius.circular(isSelected ? 20 : 8),
                        ),
                        child: Center(
                          child: index == 0
                              ? currentRedditUser == "" ||
                                      currentRedditUser == "null"
                                  ? connectRedditComponent()
                                  : FutureBuilder(
                                      future:
                                          fetchRedditInfo(currentRedditUser),
                                      builder: (_, snapshot) {
                                        if (snapshot.hasError) {
                                          logger.i(snapshot.error);
                                          return const Center(
                                            child: Icon(
                                              PhosphorIcons.reddit_logo,
                                              size: 35,
                                            ),
                                          );
                                        }
                                        if (!snapshot.hasData) {
                                          return const Center(
                                            child: LoadingAnimation(),
                                          );
                                        } else {
                                          var imageUrl =
                                              snapshot.data!.snoovatarImg;
                                          return Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              AnimatedContainer(
                                                duration: const Duration(
                                                    milliseconds: 300),
                                                height: isSelected ? 150 : 100,
                                                decoration: BoxDecoration(
                                                  image: DecorationImage(
                                                    image:
                                                        NetworkImage(imageUrl!),
                                                  ),
                                                ),
                                              ),
                                              Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: Text(
                                                  "Karma : ${snapshot.data!.totalKarma}",
                                                  textAlign: TextAlign.center,
                                                  style: GoogleFonts.roboto(
                                                    fontSize: 12,
                                                    color: Colors.orange,
                                                  ),
                                                ),
                                              )
                                            ],
                                          );
                                        }
                                      },
                                    )
                              : currentMediumUser == "" ||
                                      currentMediumUser == "null"
                                  ? nullMediumUserObject(context)
                                  : FutureBuilder<MediumUser?>(
                                      future: fetchUserInfo(currentMediumUser),
                                      builder: (context, snapshot) {
                                        if (snapshot.hasError) {
                                          logger.i(snapshot.error);
                                          return const Center(
                                            child: Icon(
                                              PhosphorIcons.medium_logo,
                                              size: 35,
                                            ),
                                          );
                                        }
                                        if (snapshot.connectionState ==
                                            ConnectionState.waiting) {
                                          return const CircularProgressIndicator();
                                        } else if (snapshot.hasError) {
                                          return Text(
                                              'Error: ${snapshot.error}');
                                        } else {
                                          return Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Column(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                CircleAvatar(
                                                  radius: 65,
                                                  backgroundImage: NetworkImage(
                                                    snapshot.data!.feed.image,
                                                  ),
                                                ),
                                                Text(
                                                  "connected medium",
                                                  textAlign: TextAlign.center,
                                                  style: GoogleFonts.roboto(
                                                    fontSize: 12,
                                                  ),
                                                )
                                              ],
                                            ),
                                          );
                                        }
                                      },
                                    ),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          );
        });
  }

  nullMediumUserObject(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        const Icon(
          PhosphorIcons.medium_logo,
          size: 45,
        ),
        TextButton(
          onPressed: () {
            Navigator.pushNamed(context, "settings");
          },
          child: const Text(
            "Connect medium",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 13),
          ),
        ),
      ],
    );
  }

  connectRedditComponent() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        const Icon(
          PhosphorIcons.reddit_logo,
          size: 45,
        ),
        TextButton(
          onPressed: () {
            Navigator.pushNamed(context, "settings");
          },
          child: const Text(
            "Connect reddit",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 13),
          ),
        ),
      ],
    );
  }
}
