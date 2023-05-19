// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:writefolio/editor/create_article.dart';
import 'package:linkfy_text/linkfy_text.dart';

class BioButton extends StatefulWidget {
  const BioButton({Key? key}) : super(key: key);

  @override
  _BioButtonState createState() => _BioButtonState();
}

class _BioButtonState extends State<BioButton> {
  bool _isEditing = false;
  String _bioText = '';

  @override
  void initState() {
    String userBio = Hive.box("settingsBox").get("userBio", defaultValue: "");
    _bioText = userBio;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: Hive.box("settingsBox").listenable(),
      builder: (_, settingsBox, ___) {
        return _isEditing
            ? _buildBioTextField(settingsBox)
            : _buildAddBioButton(settingsBox);
      },
    );
  }

  String? getUserBio() {
    String userBio = Hive.box("settingsBox").get("userBio", defaultValue: "");
    if (userBio == "") {
      return "Add a bio";
    } else {
      return userBio;
    }
  }

  Widget _buildBioTextField(Box settingsBox) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextField(
            maxLines: 4,
            onChanged: (value) {
              _bioText = value.trim();
              settingsBox.put('userBio', value);
              logger.wtf("Updated useBio to : $value");
            },
            decoration: InputDecoration(
              labelText: getUserBio(),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: _bioText.isNotEmpty ? _updateBio : null,
                  child: const Text('Done'),
                ),
              ),
              const SizedBox(width: 5),
              Expanded(
                child: OutlinedButton(
                  onPressed: () {
                    _isEditing = false;
                    setState(() {});
                  },
                  child: const Text('Cancel'),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildAddBioButton(Box settingsBox) {
    return TextButton(
      onPressed: () {
        setState(() {
          _isEditing = true;
        });
      },
      child: LinkifyText(
        getUserBio()!,
        linkStyle: const TextStyle(color: Colors.blue),
        onTap: (link) {},
      ),
    );
  }

  void _updateBio() {
    setState(() {
      _isEditing = false;
      // Perform any action with the submitted _bioText value here
      logger.i('Updated bio: $_bioText');
    });
  }
}
