import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../user_alert_dialog.dart';

class CustomAppBarWithSearchBar extends StatefulWidget {
  final User user;
  final String title;

  const CustomAppBarWithSearchBar(
      {Key? key, required this.user, required this.title})
      : super(key: key);

  @override
  State<CustomAppBarWithSearchBar> createState() =>
      _CustomAppBarWithSearchBarState();
}

class _CustomAppBarWithSearchBarState extends State<CustomAppBarWithSearchBar> {
  late TextEditingController _textEditingController;
  bool _showClearButton = false;

  @override
  void initState() {
    super.initState();
    _textEditingController = TextEditingController()
      ..addListener(_updateClearButtonVisibility);
  }

  void _updateClearButtonVisibility() {
    setState(() {
      _showClearButton = _textEditingController.text.isNotEmpty;
    });
  }

  void _clearTextField() {
    setState(() {
      _textEditingController.clear();
      _showClearButton = false;
    });
  }

  @override
  void dispose() {
    _textEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: SizedBox(
            height: kToolbarHeight * 0.9,
            child: SearchBar(
              controller: _textEditingController,
              leading: IconButton(
                icon: const Icon(Icons.search_rounded),
                onPressed: () {},
              ),
              trailing: [
                _showClearButton
                    ? IconButton(
                        onPressed: _clearTextField,
                        icon: const Icon(Icons.clear))
                    : const Text('')
              ],
              hintText: 'Search in ${widget.title}',
              shadowColor:
                  MaterialStateProperty.all<Color?>(Colors.transparent),
            ),
          ),
        ),
        IconButton(
          onPressed: () {},
          icon: const Icon(Icons.notifications_none_rounded),
        ),
        widget.user.photoURL != null
            ? IconButton(
                onPressed: _openAccountDialog,
                icon: CircleAvatar(
                  backgroundImage: NetworkImage("${widget.user.photoURL}"),
                  radius: 12,
                ))
            : IconButton(
                onPressed: _openAccountDialog,
                icon: const Icon(Icons.person_outline_rounded),
              ),
      ],
    );
  }

  void _openAccountDialog() {
    showDialog(
      context: context,
      builder: (_) {
        return AccountDialog(user: widget.user);
      },
    );
  }
}
