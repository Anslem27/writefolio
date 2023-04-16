import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class GoogleAuthService {
  /// sign in with Google
  signInWithGoogle() async {
    //being interactive sign in process
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    //obtain auth details from  request
    final GoogleSignInAuthentication gAuth = await googleUser!.authentication;

    //create new user credential
    final credentials = GoogleAuthProvider.credential(
      accessToken: gAuth.accessToken,
      idToken: gAuth.idToken,
    );
    //sign in with firebase
    return await FirebaseAuth.instance.signInWithCredential(credentials);
  }
}
