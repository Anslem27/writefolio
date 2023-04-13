class WritefolioUser {
  String? userName;
  String? email;
  String? mediumUsername;
  String? redditUsername;
  String? bio; //short bio description
  Gender? gender;
  List<String>? readingInterests;
  DateTime? joinedDate;

  WritefolioUser({
    this.userName,
    this.mediumUsername,
    this.redditUsername,
    this.bio,
    this.email,
    this.gender,
    this.joinedDate,
    this.readingInterests,
  });

  Map<String, dynamic> toJson() {
    return {
      'userName': userName,
      'email': email,
      'mediumUsername': mediumUsername,
      'redditUsername': redditUsername,
      'bio': bio,
      'gender': gender?.toString().split('.').last,
      'readingInterests': readingInterests,
      'joinedDate': joinedDate?.toIso8601String(),
    };
  }
}

enum Gender { male, female, they }
/// var userJson = json.encode(user.toJson());
/// var user = WritefolioUser(
///    userName: 'example',
///    mediumUsername: 'example_medium',
///    redditUsername: 'example_reddit',
///    bio: 'Example bio description',
///    gender: Gender.male,
///    readingInterests: ['Science Fiction', 'Fantasy'],
///    joinedDate: DateTime.now(),
///  );
