import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phosphor_icons/flutter_phosphor_icons.dart';
import 'package:hive/hive.dart';
import 'package:writefolio/editor/create_article.dart';

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
    final themeBox = Hive.box<bool>('themeBox');

    return Scaffold(
      appBar: AppBar(
        title: const Text("Settings"),
      ),
      body: ListView(
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
              _CustomListTile(
                title: "dark mode",
                icon: PhosphorIcons.moon,
                trailing: Switch(
                  value:
                      themeBox.get('isDarkMode', defaultValue: null) ?? false,
                  onChanged: (value) {
                    themeBox.put('isDarkMode', value);
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
                    context: context,
                    builder: (_) => SizedBox(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
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
          const _SingleSection(title: "Social", children: [
            _CustomListTile(
              title: "Medium",
              icon: PhosphorIcons.medium_logo,
            )
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
