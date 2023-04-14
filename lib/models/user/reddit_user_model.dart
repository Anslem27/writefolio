// https://www.reddit.com/user/USER_NAME/about.json

class RedditModel {
  final String? kind;
  final Data? data;

  RedditModel({
    this.kind,
    this.data,
  });

  RedditModel.fromJson(Map<String, dynamic> json)
      : kind = json['kind'] as String?,
        data = (json['data'] as Map<String, dynamic>?) != null
            ? Data.fromJson(json['data'] as Map<String, dynamic>)
            : null;
}

class Data {
  final String? snoovatarImg;
  final int? coins;
  final int? awarderKarma;
  final int? awardeeKarma;
  final int? linkKarma;
  final int? totalKarma;
  final String? name;
  final int? created;
  final int? commentKarma;

  Data(
    this.awardeeKarma, {
    this.snoovatarImg,
    this.coins,
    this.awarderKarma,
    this.linkKarma,
    this.totalKarma,
    this.name,
    this.created,
    this.commentKarma,
  });

  Data.fromJson(Map<String, dynamic> json)
      : snoovatarImg = json['snoovatar_img'] as String?,
        coins = json['coins'] as int?,
        awarderKarma = json['awarder_karma'] as int?,
        awardeeKarma = json['awardee_karma'] as int?,
        linkKarma = json['link_karma'] as int?,
        totalKarma = json['total_karma'] as int?,
        name = json['name'] as String?,
        created = json['created'] as int?,
        commentKarma = json['comment_karma'] as int?;
}
