import 'package:cached_network_image/cached_network_image.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phosphor_icons/flutter_phosphor_icons.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../animations/fade_in_animation.dart';
import '../editor/create_article.dart';
import '../models/user_model.dart';
import '../services/user_service.dart';
import '../utils/widgets/shimmer_component.dart';
import 'settings/components/avatar_picker.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen>
    with TickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    var currentDate = DateTime.now();
    var formattedDate = DateFormat.yMMMd().format(currentDate);

    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {},
        label: const Text("Profile"),
        icon: const Icon(Icons.person),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              automaticallyImplyLeading: false,
              title: Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Text(
                  "Your Profile",
                  style: GoogleFonts.urbanist(
                    fontWeight: FontWeight.bold,
                    fontSize: 25,
                  ),
                ),
              ),
              pinned: true,
              centerTitle: false,
              actions: [
                IconButton(
                  onPressed: () {
                    Navigator.pushNamed(context, "settings");
                  },
                  icon: const Icon(
                    EvaIcons.settings2Outline,
                  ),
                ),
              ],
            ),
            SliverFillRemaining(
              child: SingleChildScrollView(
                physics: const ScrollPhysics(),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          const Padding(
                              padding: EdgeInsets.all(8.0),
                              child: AvatarComponent(radius: 40)),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 8.0),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: const [
                                Padding(
                                  padding: EdgeInsets.symmetric(vertical: 5.0),
                                  child: Text(
                                    "Anslem",
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                                Text("@username")
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10.0, vertical: 5),
                      child: Text(
                        "43 drafts    |    40 saved poems",
                        style: GoogleFonts.roboto(
                          fontSize: 17,
                        ),
                      ),
                    ),
                    TextButton(
                      onPressed: () {},
                      child: const Text("Add a bio"),
                    ),
                    Row(children: [
                      TextButton.icon(
                        onPressed: () {},
                        icon: const Icon(PhosphorIcons.medium_logo),
                        label: const Text("add medium"),
                      ),
                      TextButton.icon(
                        onPressed: () {},
                        icon: const Icon(PhosphorIcons.twitch_logo),
                        label: const Text("add social"),
                      ),
                    ]),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10.0, vertical: 5),
                      child: Text("joined $formattedDate"),
                    ),
                    const ListTile(
                      leading: Text(
                        "23",
                        style: TextStyle(
                          fontSize: 35,
                          color: Colors.grey,
                        ),
                      ),
                      title: Text("Published medium articles",
                          style: TextStyle(fontWeight: FontWeight.w500)),
                      //else not Connected
                    ),
                    const SizedBox(height: 20),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Text(
                        "your articles",
                        style: GoogleFonts.urbanist(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    FutureBuilder<MediumUser>(
                        future: fetchUserInfo("anslemAnsy"),
                        builder: (_, snapshot) {
                          if (snapshot.hasError) {
                            return Center(
                              child: SizedBox(
                                child: Padding(
                                  padding: const EdgeInsets.only(top: 30.0),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: const [
                                      Icon(PhosphorIcons.cloud_slash),
                                      SizedBox(width: 5),
                                      Text("Seems like you are offline"),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          }
                          if (!snapshot.hasData) {
                            return ListView.builder(
                              shrinkWrap: true,
                              physics: const ScrollPhysics(),
                              itemCount: 10,
                              itemBuilder: (_, index) {
                                return ShimmerComponent(
                                  deviceWidth:
                                      MediaQuery.of(context).size.width,
                                  deviceHeight:
                                      MediaQuery.of(context).size.height,
                                );
                              },
                            );
                          } else {
                            var articles = snapshot.data!.items;
                            return ListView.builder(
                                physics: const ScrollPhysics(),
                                shrinkWrap: true,
                                itemCount: articles.length,
                                itemBuilder: (_, index) {
                                  return FloatInAnimation(
                                    delay: (1.0 + index) / 4,
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          InkWell(
                                            onTap: () {
                                              logger.i(articles[index].pubDate);
                                            },
                                            child: Container(
                                              width: MediaQuery.of(context)
                                                  .size
                                                  .width,
                                              padding: const EdgeInsets.all(3),
                                              decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(5)),
                                              height: MediaQuery.of(context)
                                                      .size
                                                      .height /
                                                  7,
                                              child: Row(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: <Widget>[
                                                  Expanded(
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: <Widget>[
                                                        SizedBox(
                                                          width:
                                                              double.infinity,
                                                          child: Text(
                                                            articles[index]
                                                                .title
                                                                .trim()
                                                                .toUpperCase(),
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                            style: GoogleFonts
                                                                .urbanist(
                                                                    fontSize:
                                                                        16.5,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold),
                                                          ),
                                                        ),
                                                        const Padding(
                                                          padding: EdgeInsets
                                                              .symmetric(
                                                                  vertical:
                                                                      2.0),
                                                        ),
                                                        SizedBox(
                                                          width:
                                                              double.infinity,
                                                          child: Text(
                                                            "By ${articles[index].author}",
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                          ),
                                                        ),
                                                        const Padding(
                                                          padding: EdgeInsets
                                                              .symmetric(
                                                                  vertical:
                                                                      2.0),
                                                        ),
                                                        const Spacer(),
                                                        Row(
                                                          children: [
                                                            Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                          .only(
                                                                      right:
                                                                          5.0),
                                                              child: SizedBox(
                                                                child: Text(
                                                                  "Published : ${articles[index].pubDate}",
                                                                ),
                                                              ),
                                                            ),
                                                          ],
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                  const Padding(
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                            horizontal: 8.0),
                                                  ),
                                                  Container(
                                                      width: 80.0,
                                                      height: 80.0,
                                                      decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(5),
                                                      ),
                                                      child: CachedNetworkImage(
                                                        imageUrl:
                                                            articles[index]
                                                                .thumbnail,
                                                      )),
                                                ],
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            width: MediaQuery.of(context)
                                                .size
                                                .width,
                                            child:
                                                const Divider(thickness: 0.5),
                                          )
                                        ],
                                      ),
                                    ),
                                  );
                                });
                          }
                        }),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  ListView shimmerLoader() {
    return ListView.builder(
      itemCount: 10,
      itemBuilder: (_, index) {
        return ShimmerComponent(
          deviceWidth: MediaQuery.of(context).size.width,
          deviceHeight: MediaQuery.of(context).size.height,
        );
      },
    );
  }
}
