// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:flutter_phosphor_icons/flutter_phosphor_icons.dart';
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
    FutureBuilder<Data?> getUserRedditAvatar() {
      return FutureBuilder(
        future: getUserRedditFuture,
        builder: (_, snapshot) {
          if (!snapshot.hasData) {
            return const LoadingAnimation();
          }

          logger.i(snapshot.data!.snoovatarImg!);
          return SizedBox(
            child: Image.network(snapshot.data!.snoovatarImg!),
          );
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
                        ? getUserRedditAvatar()
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
