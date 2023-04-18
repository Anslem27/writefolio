// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:flutter_phosphor_icons/flutter_phosphor_icons.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:writefolio/editor/create_article.dart';
import 'package:writefolio/models/user/reddit_user_model.dart';
import 'package:writefolio/utils/widgets/loader.dart';

import '../services/reddit_user_fecth_service.dart';

class ConnectedAccountsAvatars extends StatefulWidget {
  const ConnectedAccountsAvatars({super.key});

  @override
  _ConnectedAccountsAvatarsState createState() =>
      _ConnectedAccountsAvatarsState();
}

class _ConnectedAccountsAvatarsState extends State<ConnectedAccountsAvatars> {
  int _selectedItem = 0;
  final getUserRedditFuture = fetchRedditInfo("Infamous-Date-355");

  @override
  Widget build(BuildContext context) {
    FutureBuilder<Data?> getUserRedditAvatar(bool isSelected) {
      return FutureBuilder(
        future: getUserRedditFuture,
        builder: (_, snapshot) {
          if (snapshot.hasError) {
            logger.i(snapshot.error);
            return const Center(
              child: Icon(PhosphorIcons.reddit_logo),
            );
          }
          if (!snapshot.hasData) {
            return const Center(
              child: LoadingAnimation(),
            );
          } else {
            var imageUrl = snapshot.data!.snoovatarImg;
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  height: isSelected ? 150 : 100,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: NetworkImage(imageUrl!),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    "Karma : ${snapshot.data!.totalKarma}",
                    style: GoogleFonts.roboto(
                      fontSize: 15,
                      color: Colors.orange,
                    ),
                  ),
                )
              ],
            );
          }
        },
      );
    }

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
                    borderRadius: BorderRadius.circular(isSelected ? 20 : 8),
                  ),
                  child: Center(
                    child: index == 0
                        ? getUserRedditAvatar(isSelected)
                        : Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(
                                PhosphorIcons.medium_logo,
                                size: 45,
                              ),
                              TextButton(
                                onPressed: () {},
                                child: const Text(
                                  "Connect medium",
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ],
                          ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Column connectRedditComponent() {
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
          onPressed: () {},
          child: const Text(
            "Connect reddit",
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }
}
