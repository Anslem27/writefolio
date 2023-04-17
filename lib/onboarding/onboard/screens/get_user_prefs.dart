// ignore_for_file: library_private_types_in_public_api

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phosphor_icons/flutter_phosphor_icons.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../editor/create_article.dart';
import '../../../models/user/user.dart';
import '../../../utils/constants.dart';

class WritefolioUserPage extends StatefulWidget {
  const WritefolioUserPage({super.key});

  @override
  _WritefolioUserPageState createState() => _WritefolioUserPageState();
}

class _WritefolioUserPageState extends State<WritefolioUserPage> {
  final _formKey = GlobalKey<FormState>();

  String? _mediumUsername;
  String? _redditUsername;
  String? _bio;
  Gender? _gender;
  // ignore: unnecessary_nullable_for_final_variable_declarations
  final List<String>? _readingInterests = ["noteworthy"];

  final loggedInWritefolioUser = FirebaseAuth.instance.currentUser!;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Setup preferances'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              Text(
                "Hey ${loggedInWritefolioUser.email}",
                style: GoogleFonts.roboto(
                  fontSize: 30,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  "To get the best experience from Writefolio, tell us about yourself!, all your details will be kept private.",
                  style: GoogleFonts.roboto(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Medium Username',
                  prefixIcon: Icon(PhosphorIcons.medium_logo),
                ),
                onSaved: (value) {
                  _mediumUsername = value;
                },
              ),
              TextFormField(
                decoration: const InputDecoration(
                    labelText: 'Reddit Username',
                    prefixIcon: Icon(
                      PhosphorIcons.reddit_logo,
                    )),
                onSaved: (value) {
                  _redditUsername = value;
                },
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Bio',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8)),
                  ),
                  onSaved: (value) {
                    _bio = value;
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  "Your gender?",
                  style: GoogleFonts.roboto(
                    fontSize: 20,
                    color: Colors.grey,
                  ),
                ),
              ),
              Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: RadioListTile<Gender>(
                          title: const Text('Male'),
                          value: Gender.male,
                          groupValue: _gender,
                          onChanged: (value) {
                            setState(() {
                              _gender = value;
                            });
                          },
                        ),
                      ),
                      Expanded(
                        child: RadioListTile<Gender>(
                          title: const Text('Female'),
                          value: Gender.female,
                          groupValue: _gender,
                          onChanged: (value) {
                            setState(() {
                              _gender = value;
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                  RadioListTile<Gender>(
                    title: const Text('They/Them'),
                    value: Gender.they,
                    groupValue: _gender,
                    onChanged: (value) {
                      setState(() {
                        _gender = value;
                      });
                    },
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  "What are your reading preferances?",
                  style: GoogleFonts.roboto(
                    fontSize: 20,
                    color: Colors.grey,
                  ),
                ),
              ),
              Wrap(
                spacing: 8,
                children: [
                  for (final interest in readingPrefs)
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          if (_readingInterests?.contains(interest) ?? false) {
                            _readingInterests!.remove(interest);
                          } else {
                            _readingInterests!.add(interest);
                          }
                        });
                      },
                      child: Card(
                        color: _readingInterests!.contains(interest)
                            ? Theme.of(context)
                                .colorScheme
                                .secondary
                                .withOpacity(0.5)
                            : null,
                        child: Padding(
                          padding: const EdgeInsets.all(8),
                          child: Text(interest),
                        ),
                      ),
                    ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState?.validate() ?? false) {
                      _formKey.currentState?.save();
                      final user = WritefolioUser(
                        mediumUsername: _mediumUsername,
                        redditUsername: _redditUsername,
                        bio: _bio,
                        gender: _gender,
                        readingInterests: _readingInterests,
                      );
                      logger.i(user.toJson());
                    }
                  },
                  child: const Text('Finish setup'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
