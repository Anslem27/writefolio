# Writefolio

<b>Writefolio</b> is a unique app designed for writers, providing them with a personalized writing space to showcase their published articles and write new ones. With Writefolio, writers can easily access their previous work and also note down new ideas in a distraction-free environment. Whether you're an aspiring writer or a seasoned pro, Writefolio is the perfect companion to help you refine your craft and take your writing to the next level.

## Api's

- Poetry db [link](https://poetrydb.org/)
- rss2json for r/self ,medium user and the guardian contents [rss api](https://api.rss2json.com/v1/api.json?rss_url=https://medium.com/feed/@medium-username)

- Reddit user endpoint [here](https://www.reddit.com/user/USER_NAME/about.json)

## Build

- Generate Licences

  - `flutter pub run flutter_oss_licenses:generate.dart`

- Generate Hive Adaptors

  - `flutter packages pub run build_runner build`

- Get firebase sha1 and sha256
  - `keytool -list -v -keystore c:\users\user-name\.android\debug.keystore -alias androiddebugkey -storepass android -keypass android`
