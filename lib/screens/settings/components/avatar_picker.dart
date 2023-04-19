// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:writefolio/editor/create_article.dart';

import '../../../utils/constants.dart';

class AvatarList extends StatefulWidget {
  final List<String> imageUrls = avatars;

  AvatarList({super.key});

  @override
  _AvatarListState createState() => _AvatarListState();
}

class _AvatarListState extends State<AvatarList> {
  int selectedIndex = -1;

  late Box<String> avatarBox; // add Hive box

  @override
  void initState() {
    super.initState();
    avatarBox = Hive.box<String>('avatarBox'); // open Hive box
    final savedUrl = avatarBox.get('selectedAvatarUrl'); // get saved URL
    if (savedUrl != null) {
      selectedIndex = widget.imageUrls
          .indexOf(savedUrl); // set selected index from saved URL
    }
  }

  void _onAvatarTapped(int index) {
    setState(() {
      selectedIndex = index;
      final selectedUrl = widget.imageUrls[index];
      logger.i("Avatar changed to URL: $selectedUrl");
      avatarBox.put(
          'selectedAvatarUrl', selectedUrl); // save selected URL to Hive box
    });
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Wrap(
      alignment: WrapAlignment.center,
      children: widget.imageUrls.asMap().entries.map((entry) {
        final index = entry.key;
        final imageUrl = entry.value;
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: InkWell(
            borderRadius: BorderRadius.circular(100),
            onTap: () => _onAvatarTapped(index),
            child: Stack(
              children: [
                CircleAvatar(
                  backgroundImage: AssetImage(imageUrl),
                  radius: selectedIndex == index ? 60 : 40,
                ),
                if (selectedIndex == index)
                  const Positioned(
                    bottom: 0,
                    right: 0,
                    child: Icon(Icons.check_circle, color: Colors.green),
                  ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }
}

class AvatarComponent extends StatelessWidget {
  final double radius;
  const AvatarComponent({Key? key, required this.radius}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final avatarBox = Hive.box<String>('avatarBox');
    final selectedAvatarUrl =
        avatarBox.get('selectedAvatarUrl', defaultValue: avatars[0]);

    final ValueNotifier<String> avatarUrlNotifier =
        ValueNotifier<String>(selectedAvatarUrl!);

    final ValueListenableBuilder<String> avatarBuilder =
        ValueListenableBuilder<String>(
      valueListenable: avatarUrlNotifier,
      builder: (BuildContext context, String avatarUrl, Widget? child) {
        return CircleAvatar(
          radius: radius,
          backgroundImage: AssetImage(avatarUrl),
        );
      },
    );

    return avatarBuilder;
  }
}
