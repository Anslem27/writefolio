import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phosphor_icons/flutter_phosphor_icons.dart';
import 'package:uuid/uuid.dart';
import 'package:writefolio/utils/widgets/loader.dart';

import '../../../models/home/e-book_category_feed.dart';
import 'book_detail_view.dart';

class BookCard extends StatelessWidget {
  final String img;
  final Entry entry;

  BookCard({
    Key? key,
    required this.img,
    required this.entry,
  }) : super(key: key);

  static const uuid = Uuid();
  final String imgTag = uuid.v4();
  final String titleTag = uuid.v4();
  final String authorTag = uuid.v4();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 120.0,
      child: Card(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(10.0),
          ),
        ),
        elevation: 4.0,
        child: InkWell(
          borderRadius: const BorderRadius.all(
            Radius.circular(10.0),
          ),
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => Details(
                    entry: entry,
                    imgTag: imgTag,
                    titleTag: titleTag,
                    authorTag: authorTag,
                  ),
                ));
          },
          child: ClipRRect(
            borderRadius: const BorderRadius.all(
              Radius.circular(10.0),
            ),
            child: Hero(
              tag: imgTag,
              child: CachedNetworkImage(
                imageUrl: img,
                placeholder: (context, url) =>
                    const Center(child: LoadingAnimation()),
                errorWidget: (context, url, error) =>
                    const Icon(PhosphorIcons.book),
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
