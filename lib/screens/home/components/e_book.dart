// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:writefolio/utils/widgets/loader.dart';
import '../../../models/home/e-book_category_feed.dart';
import '../../../utils/widgets/home/ebook/book_card.dart';
import '../../../utils/widgets/home/ebook/book_list_item.dart';
import '../tools/e_book_tools.dart';

class EbookListScreen extends StatefulWidget {
  const EbookListScreen({super.key});

  @override
  _EbookListScreenState createState() => _EbookListScreenState();
}

class _EbookListScreenState extends State<EbookListScreen>
    with AutomaticKeepAliveClientMixin {
  final HomeProvider homeProvider = HomeProvider();
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      body: FutureBuilder<void>(
        future: homeProvider.getFeeds(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: LoadingAnimation(),
            );
          } else {
            return RefreshIndicator(
              onRefresh: () => homeProvider.getFeeds(),
              child: ListView(
                children: <Widget>[
                  _buildFeaturedSection(homeProvider),
                  const SizedBox(height: 20.0),
                  _buildSectionTitle('Categories'),
                  const SizedBox(height: 10.0),
                  _buildGenreSection(homeProvider),
                  const SizedBox(height: 20.0),
                  _buildSectionTitle('Recently Added'),
                  const SizedBox(height: 20.0),
                  _buildNewSection(homeProvider),
                ],
              ),
            );
          }
        },
      ),
    );
  }

  _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(
            title,
            style: const TextStyle(
              fontSize: 20.0,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  _buildFeaturedSection(HomeProvider homeProvider) {
    List<Entry> entryList =
        homeProvider.top.feed?.entry ?? []; // get the list of entries

    // shuffle the list randomly
    entryList.shuffle();

    return SizedBox(
      height: 200.0,
      child: Center(
        child: ListView.builder(
          primary: false,
          padding: const EdgeInsets.symmetric(horizontal: 15.0),
          scrollDirection: Axis.horizontal,
          itemCount: entryList.length, // use the shuffled list length
          shrinkWrap: true,
          itemBuilder: (BuildContext context, int index) {
            Entry entry = entryList[index]; // use the shuffled list item
            return Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 5.0, vertical: 10.0),
              child: BookCard(
                img: entry.link![1].href!,
                entry: entry,
              ),
            );
          },
        ),
      ),
    );
  }

  _buildGenreSection(HomeProvider homeProvider) {
    return SizedBox(
      height: 50.0,
      child: Center(
        child: ListView.builder(
          primary: false,
          padding: const EdgeInsets.symmetric(horizontal: 15.0),
          scrollDirection: Axis.horizontal,
          itemCount: homeProvider.top.feed?.link?.length ?? 0,
          shrinkWrap: true,
          itemBuilder: (BuildContext context, int index) {
            Link link = homeProvider.top.feed!.link![index];

            // We don't need the tags from 0-9 because
            // they are not categories
            if (index < 10) {
              return const SizedBox();
            }

            return Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 5.0, vertical: 10.0),
              child: Card(
                /*    decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.secondary,
                  borderRadius: const BorderRadius.all(
                    Radius.circular(20.0),
                  ),
                ), */
                child: InkWell(
                  borderRadius: const BorderRadius.all(
                    Radius.circular(20.0),
                  ),
                  onTap: () {},
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10.0),
                      child: Text(
                        '${link.title}',
                        style: const TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  _buildNewSection(HomeProvider homeProvider) {
    return ListView.builder(
      primary: false,
      padding: const EdgeInsets.symmetric(horizontal: 15.0),
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: homeProvider.recent.feed?.entry?.length ?? 0,
      itemBuilder: (BuildContext context, int index) {
        Entry entry = homeProvider.recent.feed!.entry![index];

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 5.0, vertical: 5.0),
          child: BookListItem(
            entry: entry,
          ),
        );
      },
    );
  }

  @override
  bool get wantKeepAlive => true;
}
