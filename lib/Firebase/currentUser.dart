import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
FirebaseUser user;
getCurrentUser() async {
 user  = await FirebaseAuth.instance.currentUser();

  if (user != null) {
    return user;
  } else {
    return null;
  }
}
