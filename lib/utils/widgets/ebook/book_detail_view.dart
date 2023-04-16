// ignore_for_file: library_private_types_in_public_api, use_build_context_synchronously

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phosphor_icons/flutter_phosphor_icons.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:vocsy_epub_viewer/epub_viewer.dart';
import '../../../models/home/e-book_category_feed.dart';
import '../../../screens/home/tools/e_book_detailservice.dart';
import '../loader.dart';
import 'book_description_text.dart';
import 'book_list_item.dart';

class Details extends StatefulWidget {
  final Entry entry;
  final String imgTag;
  final String titleTag;
  final String authorTag;

  const Details({
    Key? key,
    required this.entry,
    required this.imgTag,
    required this.titleTag,
    required this.authorTag,
  }) : super(key: key);

  @override
  _DetailsState createState() => _DetailsState();
}

class _DetailsState extends State<Details> {
  final DetailsProvider detailsProvider = DetailsProvider();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        children: <Widget>[
          const SizedBox(height: 10.0),
          _buildImageTitleSection(detailsProvider),
          const SizedBox(height: 30.0),
          _buildSectionTitle('Description'),
          const SizedBox(height: 10.0),
          DescriptionTextWidget(
            text: '${widget.entry.summary!.t}',
          ),
          const SizedBox(height: 30.0),
         /*   _buildSectionTitle('More from Author'),
          const SizedBox(height: 10.0),
          _buildMoreBook(detailsProvider), */
        ],
      ),
    );
  }

  _buildImageTitleSection(DetailsProvider detailsProvider) {
    return SizedBox(
      child: Row(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Hero(
            tag: widget.imgTag,
            child: CachedNetworkImage(
              imageUrl: '${widget.entry.link![1].href}',
              placeholder: (context, url) =>
                  const Center(child: LoadingAnimation()),
              errorWidget: (context, url, error) =>
                  const Icon(PhosphorIcons.warning_octagon),
              fit: BoxFit.cover,
              height: 200.0,
              width: 130.0,
            ),
          ),
          const SizedBox(width: 20.0),
          Flexible(
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                const SizedBox(height: 5.0),
                Hero(
                  tag: widget.titleTag,
                  child: Material(
                    type: MaterialType.transparency,
                    child: Text(
                      widget.entry.title!.t!.replaceAll(r'\', ''),
                      style: const TextStyle(
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 3,
                    ),
                  ),
                ),
                const SizedBox(height: 5.0),
                Hero(
                  tag: widget.authorTag,
                  child: Material(
                    type: MaterialType.transparency,
                    child: Text(
                      '${widget.entry.author!.name!.t}',
                      style: const TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.w800,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 5.0),
                _buildCategory(widget.entry, context),
              ],
            ),
          ),
        ],
      ),
    );
  }

  _buildSectionTitle(String title) {
    return Text(
      title,
      style: GoogleFonts.roboto(
        color: Theme.of(context).colorScheme.secondary,
        fontSize: 20.0,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  openBook(DetailsProvider provider) async {
    List dlList = await provider.getDownload();
    if (dlList.isNotEmpty) {
      // dlList is a list of the downloads relating to this Book's id.
      // The list will only contain one item since we can only
      // download a book once. Then we use `dlList[0]` to choose the
      // first value from the string as out local book path
      Map dl = dlList[0];
      String path = dl['path'];

      VocsyEpub.open(
        path,
        /* lastLocation: EpubLocator.fromJson({
          "bookId": "2239",
          "href": "/OEBPS/ch06.xhtml",
          "created": 1539934158390,
          "locations": {"cfi": "epubcfi(/0!/4/4[simple_book]/2/2/6)"}
        }), // first page will open up if the value is null */
      );

      /*  Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => EpubReader.open(path),
        ),
      ); */
    }
  }


  // ignore: unused_element
  _buildMoreBook(DetailsProvider provider) {
    if (provider.loading) {
      return const SizedBox(
        height: 100.0,
        child: Center(child: LoadingAnimation()),
      );
    } else {
      return ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: provider.related.feed!.entry!.length,
        itemBuilder: (BuildContext context, int index) {
          Entry entry = provider.related.feed!.entry![index];
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 5.0),
            child: BookListItem(
              entry: entry,
            ),
          );
        },
      );
    }
  }

  _buildCategory(Entry entry, BuildContext context) {
    if (entry.category == null) {
      return const SizedBox();
    } else {
      return SizedBox(
        height: entry.category!.length < 3 ? 55.0 : 95.0,
        child: GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: entry.category!.length > 4 ? 4 : entry.category!.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 210 / 80,
          ),
          itemBuilder: (BuildContext context, int index) {
            Category cat = entry.category![index];
            return Padding(
              padding: const EdgeInsets.fromLTRB(0.0, 5.0, 5.0, 5.0),
              child: Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.background,
                  borderRadius: const BorderRadius.all(
                    Radius.circular(20),
                  ),
                  border: Border.all(
                    color: Theme.of(context).colorScheme.secondary,
                  ),
                ),
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 2.0),
                    child: Text(
                      '${cat.label}',
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.secondary,
                        fontSize: cat.label!.length > 18 ? 6.0 : 10.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      );
    }
  }
}
