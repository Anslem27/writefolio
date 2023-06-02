import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AccountDialog extends StatelessWidget {
  final User user;

  const AccountDialog({Key? key, required this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      contentPadding: const EdgeInsets.only(
        top: 8.0,
        right: 8.0,
        left: 8.0,
      ),
      actionsPadding: const EdgeInsets.all(12.0),
      insetPadding: const EdgeInsets.all(24.0),
      title: SizedBox(
        height: 40,
        child: Stack(
          children: [
            const Center(
              child: Text(
                'Writefolio',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 25,
                  fontFamily: "Chomsky",
                ),
              ),
            ),
            IconButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              icon: const Icon(Icons.close),
            ),
          ],
        ),
      ),
      content: Container(
        width: 1000,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.background,
          borderRadius: BorderRadius.circular(28.0),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: Stack(
                children: [
                  user.photoURL != null
                      ? CircleAvatar(
                          backgroundImage: NetworkImage("${user.photoURL}"),
                        )
                      : const CircleAvatar(
                          child: Icon(Icons.person_rounded),
                        ),
                ],
              ),
              title: Text(
                "${user.displayName}",
                style: Theme.of(context).textTheme.titleMedium,
              ),
              subtitle: Text("${user.email}"),
            ),
            Divider(color: Theme.of(context).colorScheme.surfaceVariant),
            ListTile(
              leading: CircleAvatar(
                backgroundColor: Theme.of(context).colorScheme.background,
                child: const Icon(Icons.palette_outlined),
              ),
              title: const Text('Themes'),
              onTap: () {},
            ),
            ListTile(
              leading: CircleAvatar(
                backgroundColor: Theme.of(context).colorScheme.background,
                child: const Icon(Icons.person_outline_rounded),
              ),
              title: const Text('Profile'),
              onTap: () {},
            ),
            ListTile(
              leading: CircleAvatar(
                backgroundColor: Theme.of(context).colorScheme.background,
                child: const Icon(Icons.translate_rounded),
              ),
              title: const Text('Language'),
              onTap: () {},
            ),
            ListTile(
              leading: CircleAvatar(
                backgroundColor: Theme.of(context).colorScheme.background,
                child: const Icon(Icons.settings_outlined),
              ),
              title: const Text('Settings'),
              onTap: () {},
            ),
            Divider(color: Theme.of(context).colorScheme.surfaceVariant),
            ListTile(
              leading: CircleAvatar(
                backgroundColor: Theme.of(context).colorScheme.background,
                child: const Icon(Icons.cloud),
              ),
              title: const Text('Storage used'),
              subtitle: const Text('1 of 15 products'),
            ),
            Divider(color: Theme.of(context).colorScheme.surfaceVariant),
            ListTile(
              leading: CircleAvatar(
                backgroundColor: Theme.of(context).colorScheme.background,
                child: const Icon(Icons.logout),
              ),
              title: const Text('Sign out'),
              onTap: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        ),
      ),
      actions: const [
        /* Center(
          child: PrivacyPolicyAndUserAgreementRichText(),
        ), */
      ],
    );
  }
}
