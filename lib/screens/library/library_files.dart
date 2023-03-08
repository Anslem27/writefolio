import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:writefolio/screens/library/components/article_view.dart';
import '../../constants.dart';
import '../../widgets/theme_button.dart';

var logger = Logger();

class LibraryFiles extends StatefulWidget {
  const LibraryFiles({super.key});

  @override
  State<LibraryFiles> createState() => _LibraryFilesState();
}

class _LibraryFilesState extends State<LibraryFiles> {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: 10,
      itemBuilder: (_, index) {
       var date = DateTime.now();
        return Padding(
          padding: const EdgeInsets.all(5.0),
          child: Container(
            padding: const EdgeInsets.all(5),
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(12),
            ),
            width: double.maxFinite,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    "Please Start Writing Better Commits",
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.start,
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 4.0, bottom: 4),
                  child: Row(
                    children: [
                      _userIcon(),
                      const SizedBox(width: 3),
                      const Text("Travis Aaron Wagner"),
                      const Spacer(),
                      Text(
                        "${date.month}/${date.day}th/${date.year}",
                      ),
                      const SizedBox(width: 8),
                      const Text(
                        "4 min read",
                        style: TextStyle(fontStyle: FontStyle.italic),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  width: double.maxFinite,
                  child: Divider(),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    loremText,
                    maxLines: 5,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(),
                  ),
                ),
                SButton(
                  text: "See details",
                  ontap: () {
                    Navigator.push(
                      context,
                      CupertinoPageRoute(
                        builder: (_) => const ArticleView(),
                      ),
                    );
                  },
                )
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _userIcon() {
    return const CircleAvatar(
      radius: 17,
      backgroundImage: AssetImage("assets/avatars/Oval-3.png"),
    );
  }
}
