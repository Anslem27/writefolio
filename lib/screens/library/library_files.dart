import 'package:flutter/material.dart';

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
        return Container(
          decoration: BoxDecoration(color: Colors.grey[300] as Color),
          width: double.maxFinite,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                "Please Start Wriring Better Commits",
                overflow: TextOverflow.ellipsis,
                style: TextStyle(),
              )
            ],
          ),
        );
      },
    );
    ;
  }
}
