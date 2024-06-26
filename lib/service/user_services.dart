import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:social_sphere/model/usermodel.dart';

class UserService {
  CollectionReference firestore =
      FirebaseFirestore.instance.collection("users");
  Stream<List<UserModel>> getUser() {
    return firestore.snapshots().map((querySnapshot) {
      return querySnapshot.docs.map((doc) {
        return UserModel.fromJson(doc.data() as Map<String, dynamic>);
      }).toList();
    });
  }
}
