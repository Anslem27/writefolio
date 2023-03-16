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
import '../utils/constants.dart';
import '../utils/widgets/shimmer_component.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen>
    with TickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    TabController tabcontroller = TabController(length: 3, vsync: this);
    var currentDate = DateTime.now();
    var formattedDate = DateFormat.yMMMd().format(currentDate);

    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {},
        label: const Text("Profile"),
        icon: const Icon(Icons.person),
      ),
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            automaticallyImplyLeading: false,
            expandedHeight: 110,
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
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(40),
              child: Align(
                alignment: Alignment.centerLeft,
                child: TabBar(
                  controller: tabcontroller,
                  isScrollable: true,
                  splashFactory: NoSplash.splashFactory,
                  overlayColor: MaterialStateProperty.resolveWith<Color?>(
                    (Set<MaterialState> states) {
                      return states.contains(MaterialState.focused)
                          ? null
                          : Colors.transparent;
                    },
                  ),
                  tabs: _tabs,
                ),
              ),
            ),
          ),
          SliverFillRemaining(
            child: TabBarView(
              controller: tabcontroller,
              children: [
                SingleChildScrollView(
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
                              child: CircleAvatar(
                                radius: 40,
                              ),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 8.0),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Padding(
                                    padding:
                                        EdgeInsets.symmetric(vertical: 5.0),
                                    child: Text(
                                      "Anslem",
                                      style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                  const Text(
                                    "43 drafts | 40 saved poems",
                                    style: TextStyle(
                                      fontSize: 17,
                                    ),
                                  ),
                                  OutlinedButton.icon(
                                    style: OutlinedButton.styleFrom(
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                    ),
                                    onPressed: () {},
                                    icon: const Icon(PhosphorIcons.medium_logo),
                                    label: const Text("Connected to medium"),
                                  )
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Text(
                          "Stats".toUpperCase(),
                          style: GoogleFonts.urbanist(
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      ListTile(
                        leading: const Icon(Icons.date_range),
                        title: Text("Joined $formattedDate"),
                      ),
                      const ListTile(
                        leading: Icon(PhosphorIcons.medium_logo),
                        title: Text("Published medium articles"),
                        subtitle: Text("23 articles."),
                      ),
                      const SizedBox(height: 10),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Text(
                          "Your articles".toUpperCase(),
                          style: GoogleFonts.urbanist(
                            fontWeight: FontWeight.w500,
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
                                        Icon(EvaIcons.cloudDownloadOutline),
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
                                                logger
                                                    .i(articles[index].pubDate);
                                              },
                                              child: Container(
                                                width: MediaQuery.of(context)
                                                    .size
                                                    .width,
                                                padding:
                                                    const EdgeInsets.all(3),
                                                decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            5)),
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
                                                        decoration:
                                                            BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(5),
                                                        ),
                                                        child:
                                                            CachedNetworkImage(
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
                shimmerLoader(),
                _aboutMe(),
              ],
            ),
          )
        ],
      ),
    );
  }

  _aboutMe() {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: SingleChildScrollView(
        child: Column(
          children: [
            OutlinedButton(
                onPressed: () {},
                child: Text(
                  "Short Bio about you",
                  style: GoogleFonts.urbanist(fontSize: 17),
                )),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                loremText,
                style: const TextStyle(fontSize: 15.5),
              ),
            ),
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

  final List<Tab> _tabs = [
    Tab(
      child: Text(
        "Profile",
        style: GoogleFonts.urbanist(
          fontSize: 18,
          fontWeight: FontWeight.w400,
        ),
      ),
    ),
    Tab(
      child: Text(
        "Lists",
        style: GoogleFonts.urbanist(
          fontSize: 18,
          fontWeight: FontWeight.w400,
        ),
      ),
    ),
    Tab(
      child: Text(
        "About",
        style: GoogleFonts.urbanist(
          fontSize: 18,
          fontWeight: FontWeight.w400,
        ),
      ),
    ),
  ];
}
