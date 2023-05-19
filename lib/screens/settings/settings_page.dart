// ignore_for_file: use_build_context_synchronously

import 'package:animated_snack_bar/animated_snack_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phosphor_icons/flutter_phosphor_icons.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:writefolio/editor/create_article.dart';
import '../../models/user/medium_user_model.dart';
import '../../models/user/reddit_user_model.dart';
import '../../onboarding/onboard/screens/get_user_prefs.dart';
import '../../services/reddit_user_fecth_service.dart';
import '../../services/user_service.dart';
import '../../utils/theme/theme_colors.dart';
import 'components/avatar_picker.dart';
import 'components/legalities.dart';
import 'components/licences.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    final settingsBox = Hive.box("settingsBox");
    TextEditingController mediumUsernameController = TextEditingController();
    TextEditingController redditUsernameController = TextEditingController();
    Future<MediumUser?>? future;
    Future<Data?>? redditFuture;
    final loggedInWritefolioUser = FirebaseAuth.instance.currentUser!;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Settings"),
      ),
      body: ValueListenableBuilder(
        valueListenable: settingsBox.listenable(),
        builder: (_, settingsBoxVariable, ___) {
          String mediumUsername = "";
          String redditUsername = "";
          String currentMediumUser =
              settingsBoxVariable.get('mediumUsername', defaultValue: "");

          String currentRedditUser =
              settingsBoxVariable.get("redditUsername", defaultValue: "");
          return ListView(
            shrinkWrap: true,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextButton.icon(
                  onPressed: () {},
                  icon: const Icon(PhosphorIcons.link),
                  label: const Text("Speak to us and share your thoughts."),
                ),
              ),
              _SingleSection(
                title: "General",
                children: [
                  ListTile(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8)),
                    title: const Text(
                      "email",
                      style: TextStyle(),
                    ),
                    subtitle: Text(loggedInWritefolioUser.email.toString()),
                    leading: const AvatarComponent(radius: 17),
                    onTap: () {}, //update password page
                  ),
                  _CustomListTile(
                    title: "profile",
                    icon: PhosphorIcons.user,
                    ontap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const WritefolioUserPage(),
                        ),
                      );
                    },
                  ),
                  _CustomListTile(
                    title: "dark mode",
                    icon: PhosphorIcons.moon,
                    trailing: Switch(
                      value:
                          settingsBox.get('isDarkMode', defaultValue: null) ??
                              false,
                      onChanged: (value) {
                        settingsBox.put('isDarkMode', value);
                        setState(() {});
                        logger.i(value); //value to be stored.
                      },
                    ),
                  ),
                  _CustomListTile(
                    title: "theme color",
                    icon: PhosphorIcons.drop,
                    ontap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const ThemePage(),
                        ),
                      );
                    },
                  ),
                  _CustomListTile(
                    title: "writefolio avatar",
                    icon: Icons.person,
                    ontap: () {
                      showModalBottomSheet(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8)),
                        context: context,
                        builder: (_) => SizedBox(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              const Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Text(
                                  "Pick your Avatar",
                                  style: TextStyle(fontSize: 18),
                                ),
                              ),
                              AvatarList(),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
              _SingleSection(title: "Social", children: [
                _CustomListTile(
                  title:
                      "medium ${currentMediumUser == "" || currentMediumUser == "null" ? "" : ": $currentMediumUser"}",
                  icon: PhosphorIcons.medium_logo,
                  ontap: () {
                    showModalBottomSheet(
                        isScrollControlled: true,
                        useRootNavigator: true,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8)),
                        context: context,
                        builder: (_) => Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: SizedBox(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Icon(
                                      PhosphorIcons.medium_logo,
                                      size: 50,
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                        "Your medium\naccount username!",
                                        textAlign: TextAlign.center,
                                        style: GoogleFonts.roboto(
                                          fontSize: 20,
                                        ),
                                      ),
                                    ),
                                    Text(
                                      "Currently username is ${settingsBox.get('mediumUsername') == null ? "empty" : {
                                          settingsBox.get('mediumUsername')
                                        }}",
                                      style: const TextStyle(
                                        color: Colors.blue,
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 8.0),
                                      child: TextFormField(
                                        controller: mediumUsernameController,
                                        decoration: InputDecoration(
                                          labelText: 'Medium username',
                                          border: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(8)),
                                        ),
                                        onEditingComplete: () {
                                          mediumUsername =
                                              mediumUsernameController.text;
                                          future = fetchUserInfo(
                                              mediumUsernameController.text
                                                  .trim()
                                                  .toString());
                                          setState(() {});
                                        },
                                      ),
                                    ),
                                    future == null
                                        ? const SizedBox.shrink()
                                        : FutureBuilder<MediumUser?>(
                                            future: future,
                                            builder: (context, snapshot) {
                                              if (snapshot.connectionState ==
                                                  ConnectionState.waiting) {
                                                return const CircularProgressIndicator();
                                              } else if (snapshot.hasError) {
                                                return Text(
                                                    'Error: ${snapshot.error}');
                                              } else {
                                                return Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: CircleAvatar(
                                                    radius: 60,
                                                    backgroundImage:
                                                        NetworkImage(snapshot
                                                            .data!.feed.image),
                                                  ),
                                                );
                                              }
                                            },
                                          ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: SizedBox(
                                        width: double.maxFinite,
                                        child: OutlinedButton(
                                          onPressed: () async {
                                            await settingsBox.get(
                                                'mediumUsername',
                                                defaultValue: "");

                                            settingsBox.put('mediumUsername',
                                                mediumUsername);
                                            setState(() {});
                                            logger.i(
                                                "Medium username changed to ${settingsBox.get('mediumUsername')}");
                                            Navigator.pop(context);
                                          },
                                          child: const Text("Confirm and save"),
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ));
                  },
                ),
                _CustomListTile(
                  title:
                      "reddit${currentRedditUser == "" || currentRedditUser == "null" ? "" : ": $currentRedditUser"}",
                  icon: PhosphorIcons.reddit_logo,
                  ontap: () {
                    showModalBottomSheet(
                        isScrollControlled: true,
                        useRootNavigator: true,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8)),
                        context: context,
                        builder: (_) => Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: SizedBox(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Icon(
                                      PhosphorIcons.reddit_logo,
                                      size: 50,
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                        "Your reddit\naccount username!",
                                        textAlign: TextAlign.center,
                                        style: GoogleFonts.roboto(
                                          fontSize: 20,
                                        ),
                                      ),
                                    ),
                                    Text(
                                      settingsBox
                                                      .get('redditUsername')
                                                      .toString() ==
                                                  "null" ||
                                              settingsBox
                                                      .get('redditUsername')
                                                      .toString() ==
                                                  ""
                                          ? "No reddit username specified"
                                          : "Currently username is ${settingsBox.get('redditUsername')}",
                                      style: const TextStyle(
                                        color: Colors.blue,
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 8.0),
                                      child: TextFormField(
                                        controller: redditUsernameController,
                                        decoration: InputDecoration(
                                          labelText: 'Reddit username',
                                          hintText:
                                              "Drastic-Warrior-103", //Infamous-Date-355
                                          border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(8),
                                          ),
                                        ),
                                        onEditingComplete: () {
                                          redditUsername =
                                              redditUsernameController.text;
                                          redditFuture = fetchRedditInfo(
                                            redditUsernameController.text
                                                .trim()
                                                .toString(),
                                          );
                                          setState(() {});
                                        },
                                      ),
                                    ),
                                    redditFuture == null
                                        ? const SizedBox.shrink()
                                        : FutureBuilder<Data?>(
                                            future: redditFuture,
                                            builder: (context, snapshot) {
                                              if (snapshot.connectionState ==
                                                  ConnectionState.waiting) {
                                                return const CircularProgressIndicator();
                                              } else if (snapshot.hasError) {
                                                return Text(
                                                    'Error: ${snapshot.error}');
                                              } else {
                                                return Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: CircleAvatar(
                                                    radius: 60,
                                                    backgroundImage:
                                                        NetworkImage(snapshot
                                                            .data!
                                                            .snoovatarImg!),
                                                  ),
                                                );
                                              }
                                            },
                                          ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: SizedBox(
                                        width: double.maxFinite,
                                        child: OutlinedButton(
                                          onPressed: () async {
                                            await settingsBox.get(
                                                'redditUsername',
                                                defaultValue: "");

                                            settingsBox.put('redditUsername',
                                                redditUsername);
                                            setState(() {});
                                            logger.i(
                                                "Reddit username changed to ${settingsBox.get('redditUsername')}");
                                            Navigator.pop(context);
                                          },
                                          child: const Text("Confirm and save"),
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ));
                  },
                ),
              ]),
              _SingleSection(title: "Preferances", children: [
                _CustomListTile(
                  title: "hide navbar labels",
                  icon: PhosphorIcons.eye_closed,
                  trailing: Switch(
                    value: settingsBox.get('hideNavbarLabels',
                        defaultValue: false),
                    onChanged: (value) {
                      settingsBox.put('hideNavbarLabels', value);
                      setState(() {});
                      logger.i(
                          "Hide Navbar set to :$value"); //value to be stored.
                    },
                  ),
                ),
              ]),
              _SingleSection(
                title: "about Writefolio",
                children: [
                  const _CustomListTile(
                    title: "faq/contact us",
                    icon: PhosphorIcons.info,
                  ),
                  _CustomListTile(
                    title: "terms of service",
                    icon: PhosphorIcons.shield,
                    ontap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const TermsOfUse(),
                        ),
                      );
                    },
                  ),
                  _CustomListTile(
                    title: "privacy policy",
                    icon: Icons.shield,
                    ontap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const PrivacyPolicy(),
                        ),
                      );
                    },
                  ),
                  const _CustomListTile(
                    title: "rate on the play store",
                    icon: PhosphorIcons.star,
                  )
                ],
              ),
              _SingleSection(title: "The Boring zone", children: [
                _CustomListTile(
                  title: "opensource licences",
                  icon: PhosphorIcons.list,
                  ontap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const LicencesPage(),
                      ),
                    );
                  },
                ),
                _CustomListTile(
                  title: "sign out",
                  icon: PhosphorIcons.sign_out,
                  ontap: () async {
                    showModalBottomSheet(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8)),
                      context: context,
                      builder: (BuildContext context) {
                        return SizedBox(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              ListTile(
                                leading: const Icon(Icons.exit_to_app),
                                title: const Text('Sign out'),
                                onTap: () async {
                                  Navigator.pop(context);
                                  bool confirmSignOut = await showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        title: const Text(
                                            'Are you sure you want to sign out?'),
                                        actions: <Widget>[
                                          TextButton(
                                            child: const Text('Cancel'),
                                            onPressed: () {
                                              Navigator.pop(context, false);
                                            },
                                          ),
                                          TextButton(
                                            child: const Text('Sign out'),
                                            onPressed: () {
                                              Navigator.pop(context, true);
                                            },
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                  try {
                                    if (confirmSignOut) {
                                      /* AnimatedSnackBar.material(
                                        "Successfuly signed out",
                                        type: AnimatedSnackBarType.error,
                                        mobileSnackBarPosition:
                                            MobileSnackBarPosition.bottom,
                                      ).show(context); */
                                      await FirebaseAuth.instance.signOut();
                                    }
                                  } catch (e) {
                                    AnimatedSnackBar.material(
                                      "Error signing out",
                                      type: AnimatedSnackBarType.error,
                                      mobileSnackBarPosition:
                                          MobileSnackBarPosition.bottom,
                                    ).show(context);
                                  }
                                },
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  },
                ),
              ]),
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                  "version 23.03.16 (1020906)",
                  style: TextStyle(
                    fontSize: 17,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _CustomListTile extends StatelessWidget {
  final String title;
  final IconData icon;
  final Function()? ontap;
  final Widget? trailing;
  const _CustomListTile(
      {Key? key,
      required this.title,
      required this.icon,
      this.trailing,
      this.ontap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: ListTile(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        title: Text(
          title,
          style: const TextStyle(),
        ),
        leading: Icon(icon, size: 21.5),
        trailing: trailing ?? const Icon(CupertinoIcons.forward, size: 15),
        onTap: ontap,
      ),
    );
  }
}

class _SingleSection extends StatelessWidget {
  final String title;
  final List<Widget> children;
  const _SingleSection({
    Key? key,
    required this.title,
    required this.children,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              title.toUpperCase(),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Material(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8)),
              child: Container(
                decoration:
                    BoxDecoration(borderRadius: BorderRadius.circular(8)),
                width: double.infinity,
                child: Column(
                  children: children,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
