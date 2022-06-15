// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:google_sign_in/google_sign_in.dart';

// FirebaseAuth auth = FirebaseAuth.instance;

// final googleSignIn = GoogleSignIn();

// Future<bool> googleSignIn() async {
//   GoogleSignInAccount? googleSignInAccount = await googleSignIn.signIn();
//   if (googleSignInAccount != null) {
//     GoogleSignInAuthentication googleSignInAuthentication =
//         await googleSignInAccount.authentication;

//     AuthCredential credential = GoogleAuthProvider.credential(
//         idToken: googleSignInAuthentication.idToken,
//         accessToken: googleSignInAuthentication.accessToken);

//     UserCredential result = await auth.signInWithCredential(credential);
//     User? user = await auth.currentUser;
//     print(user!.uid);
//     return Future.value(true);
//   }
// }

// Future<bool> signUp(String email, String password) async {
//   try {
//     UserCredential result = await auth.createUserWithEmailAndPassword(
//         email: email, password: password);

//     User? user = result.user;
//     return Future.value(true);
//   } catch (e.) {
//     switch(e.code){

//     }
//   }
// }
