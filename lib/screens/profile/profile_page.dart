// ignore_for_file: use_build_context_synchronously

import 'package:animated_snack_bar/animated_snack_bar.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phosphor_icons/flutter_phosphor_icons.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:intl/intl.dart';
import '../../animations/fade_in_animation.dart';
import 'components/profile_containers.dart';
import '../../editor/create_article.dart';
import '../../models/user/medium_user_model.dart';
import '../../services/user_service.dart';
import '../../utils/tools/date_parser.dart';
import '../../utils/widgets/loader.dart';
import '../../utils/widgets/medium_article_viewer.dart';
import '../../utils/widgets/shimmer_component.dart';
import '../library/tools/draft_count.dart';
import '../settings/components/avatar_picker.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen>
    with TickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    final loggedInWritefolioUser = FirebaseAuth.instance.currentUser!;
    final settingsBox = Hive.box("settingsBox");
    return Scaffold(
      body: ValueListenableBuilder(
        valueListenable: settingsBox.listenable(),
        builder: (_, settingsBoxVariable, ___) {
          String currentMediumUser =
              settingsBoxVariable.get('mediumUsername', defaultValue: "");

          String currentRedditUser =
              settingsBoxVariable.get("redditUsername", defaultValue: "");
          return Padding(
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
                                    Text("${loggedInWritefolioUser.email}")
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10.0, vertical: 5),
                          child: Row(
                            children: [
                              const DraftCount(),
                              Text(
                                "  |  ",
                                style: GoogleFonts.roboto(
                                  fontSize: 17,
                                ),
                              ),
                              const SavedPoemCount(),
                            ],
                          ),
                        ),
                        TextButton(
                          onPressed: () {},
                          child: const Text("Add a bio"),
                        ),
                        Row(children: [
                          TextButton.icon(
                            onPressed: () {
                              if (currentMediumUser == "" ||
                                  currentMediumUser == "null") {
                                Navigator.pushNamed(context, "settings");
                              } else {
                                AnimatedSnackBar.material(
                                  "You already have a medium username set.",
                                  type: AnimatedSnackBarType.success,
                                  mobileSnackBarPosition:
                                      MobileSnackBarPosition.bottom,
                                ).show(context);
                              }
                            },
                            icon: const Icon(PhosphorIcons.medium_logo),
                            label: Text(currentMediumUser == "" ||
                                    currentRedditUser == "null"
                                ? "add medium"
                                : currentMediumUser),
                          ),
                          TextButton.icon(
                            onPressed: () {
                              if (currentRedditUser == "" ||
                                  currentRedditUser == "null") {
                                Navigator.pushNamed(context, "settings");
                              } else {
                                AnimatedSnackBar.material(
                                  "You already have a reddit username set.",
                                  type: AnimatedSnackBarType.success,
                                  mobileSnackBarPosition:
                                      MobileSnackBarPosition.bottom,
                                ).show(context);
                              }
                            },
                            icon: const Icon(PhosphorIcons.reddit_logo),
                            label: Text(currentRedditUser == "" ||
                                    currentRedditUser == "null"
                                ? "add reddit"
                                : currentRedditUser),
                          ),
                        ]),
                        const ConnectedAccountsAvatars(),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10.0, vertical: 5),
                          child: Text(
                              "joined ${DateFormat.yMMMd().format(loggedInWritefolioUser.metadata.creationTime!)}"),
                        ),
                        currentMediumUser == ""
                            ? const SizedBox()
                            : FutureBuilder<MediumUser>(
                                future: fetchUserInfo(currentMediumUser),
                                builder: (_, snapshot) {
                                  if (snapshot.hasError) {
                                    return nullMediumArticleCount();
                                  }
                                  if (!snapshot.hasData) {
                                    return Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: const [LoadingAnimation()],
                                    );
                                  } else {
                                    var articles = snapshot.data!.items;
                                    return ListTile(
                                      leading: Text(
                                        articles.length.toString(),
                                        style: GoogleFonts.roboto(
                                          fontSize: 35,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.grey,
                                        ),
                                      ),
                                      title: const Text(
                                        "published medium articles",
                                        style: TextStyle(
                                            fontWeight: FontWeight.w500),
                                      ),
                                      //else not Connected
                                    );
                                  }
                                },
                              ),
                        const SizedBox(height: 20),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Text(
                            "your articles",
                            style: GoogleFonts.roboto(
                              color: Colors.grey,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        currentMediumUser == ""
                            ? const Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Text(
                                  "You need to set your medium username to see your articles",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(color: Colors.grey),
                                ),
                              )
                            : FutureBuilder<MediumUser>(
                                future: fetchUserInfo(currentMediumUser),
                                builder: (_, snapshot) {
                                  if (snapshot.hasError) {
                                    return noInternetComponent();
                                  }
                                  if (!snapshot.hasData) {
                                    return shimmerBuilder(context);
                                  } else {
                                    var articles = snapshot.data!.items;
                                    return userArticlceBuilder(
                                        articles, context);
                                  }
                                },
                              ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          );
        },
      ),
    );
  }

  ListTile nullMediumArticleCount() {
    return ListTile(
      leading: Text(
        "--",
        style: GoogleFonts.roboto(
          fontSize: 35,
          fontWeight: FontWeight.bold,
          color: Colors.grey,
        ),
      ),
      title: const Text(
        "published medium articles",
        style: TextStyle(fontWeight: FontWeight.w500),
      ),
      //else not Connected
    );
  }

  userArticlceBuilder(List<Items> articles, BuildContext context) {
    return ListView.builder(
        physics: const ScrollPhysics(),
        shrinkWrap: true,
        itemCount: articles.length,
        itemBuilder: (_, index) {
          return FloatInAnimation(
            delay: (1.0 + index) / 4,
            child: mediumArticleComponent(articles, index, context),
          );
        });
  }

  shimmerBuilder(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const ScrollPhysics(),
      itemCount: 10,
      itemBuilder: (_, index) {
        return ShimmerComponent(
          deviceWidth: MediaQuery.of(context).size.width,
          deviceHeight: MediaQuery.of(context).size.height,
        );
      },
    );
  }

  noInternetComponent() {
    return Center(
      child: SizedBox(
        child: Padding(
          padding: const EdgeInsets.only(top: 30.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SvgPicture.asset(
                "assets/illustrations/network-failure.svg",
                height: 200,
              ),
              const SizedBox(width: 5),
              const Text("Seems like you are offline"),
            ],
          ),
        ),
      ),
    );
  }

  Padding mediumArticleComponent(
      List<Items> articles, int index, BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          InkWell(
            borderRadius: BorderRadius.circular(8),
            onTap: () {
              logger.i(articles[index].content);
              var component = articles[index];
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => MediumArticleViewer(component: component),
                ),
              );
            },
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height / 6,
                padding: const EdgeInsets.all(3),
                decoration:
                    BoxDecoration(borderRadius: BorderRadius.circular(5)),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          SizedBox(
                            width: double.infinity,
                            child: Text(
                              articles[index].title.trim().toUpperCase(),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: GoogleFonts.roboto(
                                fontSize: 16.5,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          const Padding(
                            padding: EdgeInsets.symmetric(
                              vertical: 2.0,
                            ),
                          ),
                          Expanded(
                            child: Wrap(
                              children: List.generate(
                                articles[index].categories.take(1).length,
                                (categoryIndex) => Padding(
                                  padding: const EdgeInsets.all(5.0),
                                  child: Card(
                                    child: Padding(
                                      padding: const EdgeInsets.all(3.0),
                                      child: Text(
                                        articles[index]
                                            .categories[categoryIndex],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const Padding(
                            padding: EdgeInsets.symmetric(vertical: 2.0),
                          ),
                          const Spacer(),
                          Row(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(right: 5.0),
                                child: SizedBox(
                                  child: Text(
                                    "${dateParser(articles[index].pubDate)}",
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8.0),
                    ),
                    Container(
                      width: 80.0,
                      height: 80.0,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: CachedNetworkImage(
                          imageUrl: articles[index].thumbnail,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          SizedBox(
            width: MediaQuery.of(context).size.width,
            child: const Divider(thickness: 0.5),
          )
        ],
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
