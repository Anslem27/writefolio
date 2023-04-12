import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../oss_licenses.dart';

class LicencesPage extends StatelessWidget {
  const LicencesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Opensource licences"),
      ),
      body: ListView.builder(
        physics: const ScrollPhysics(),
        itemCount: ossLicenses.length,
        itemBuilder: (_, index) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: BorderRadius.circular(8),
              ),
              child: ListTile(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => LicenceDetailPage(
                        title: ossLicenses[index].name[0].toUpperCase() +
                            ossLicenses[index].name.substring(1),
                        licence: ossLicenses[index].license!,
                      ),
                    ),
                  );
                },
                //capitalize the first letter of the string
                title: Text(
                  ossLicenses[index].name[0].toUpperCase() +
                      ossLicenses[index].name.substring(1),
                  style: GoogleFonts.roboto(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                subtitle: Text(ossLicenses[index].description),
              ),
            ),
          );
        },
      ),
    );
  }
}

/// Detail page for the licence
class LicenceDetailPage extends StatelessWidget {
  final String title, licence;
  const LicenceDetailPage(
      {super.key, required this.title, required this.licence});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          padding: const EdgeInsets.all(5),
          decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: BorderRadius.circular(8)),
          child: SingleChildScrollView(
            physics: const ScrollPhysics(),
            child: Column(
              children: [
                Text(
                  licence,
                  style: const TextStyle(fontSize: 15),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
