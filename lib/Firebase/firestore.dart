import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:facebook/Firebase/currentUser.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

addLikesToPoast(List likes, String id) async {
  if(user!=null){
    if (checkUserLikeToThisPoast(likes)) {
    print('liked');
    Firestore.instance.collection('poasts').document(id).updateData({
      'like': FieldValue.arrayRemove([user?.uid])
    });
  } else {
    print('removed');
    Firestore.instance.collection('poasts').document(id).updateData({
      'like': FieldValue.arrayUnion([user?.uid])
    });
  }
  }
}

bool checkUserLikeToThisPoast(List likes) {
  if (user != null) {
    if (user?.uid != null) {
    if (likes != null) {
      if (likes.contains(user?.uid)) {
        return true;
      } else {
        return false;
      }
    }
    return false;
  }
  }
 
  return false;
}
