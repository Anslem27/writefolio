class WritefolioUser {  
  // String? userName;
  // String? email;
  String? mediumUsername;
  String? redditUsername;
  String? bio; //short bio description
  Gender? gender;
  List<String>? readingInterests;

  WritefolioUser({
    this.mediumUsername,
    this.redditUsername,
    this.bio,
    this.gender,
    this.readingInterests,
  });

  Map<String, dynamic> toJson() {
    return {
      'mediumUsername': mediumUsername,
      'redditUsername': redditUsername,
      'bio': bio,
      'gender': gender?.toString().split('.').last,
      'readingInterests': readingInterests,
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
