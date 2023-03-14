import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phosphor_icons/flutter_phosphor_icons.dart';
import 'package:hive/hive.dart';
import 'package:writefolio/editor/create_article.dart';

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
          const ListTile(
            leading: Icon(
              Icons.push_pin_outlined,
              color: Colors.red,
            ),
            title: Text("Speak to us and share your thoughts."),
          ),
          _SingleSection(
            title: "General",
            children: [
              _CustomListTile(
                title: "Dark Mode",
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
              const _CustomListTile(
                  title: "In app updater", icon: CupertinoIcons.cloud_download),
            ],
          ),
          const _SingleSection(title: "Social", children: [
            _CustomListTile(
              title: "Medium",
              icon: PhosphorIcons.medium_logo,
            )
          ]),
          const _SingleSection(
            title: "About Writefolio",
            children: [
              _CustomListTile(
                title: "Help",
                icon: PhosphorIcons.info,
              ),
              _CustomListTile(
                title: "Terms of service",
                icon: PhosphorIcons.shield,
              ),
              _CustomListTile(
                title: "Privacy Policy",
                icon: Icons.shield,
              ),
              _CustomListTile(
                title: "Rate on the Play Store",
                icon: PhosphorIcons.star,
              )
            ],
          ),
          const _SingleSection(title: "The Boring zone", children: [
            _CustomListTile(
              title: "Opensource licences",
              icon: PhosphorIcons.list,
            ),
          ]),
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Text(
              "v0.8.0(8000)",
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
  final Widget? trailing;
  const _CustomListTile(
      {Key? key, required this.title, required this.icon, this.trailing})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        ListTile(
          title: Text(
            title,
            style: const TextStyle(),
          ),
          leading: Icon(icon, size: 21.5),
          trailing: trailing ?? const Icon(CupertinoIcons.forward, size: 15),
          onTap: () {},
        ),
        const SizedBox(width: double.maxFinite, child: Divider())
      ],
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
    return Column(
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
            child: Container(
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(8)),
              width: double.infinity,
              child: Column(
                children: children,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
