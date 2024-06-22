// import 'dart:developer';

// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:social_sphere/model/usermodel.dart';

// class Sample{
//   CollectionReference firestore=FirebaseFirestore.instance.collection("users");

//   Stream<List<UserModel>> getUsers(){
//     return firestore.snapshots().map((snapshot){
// //       return snapshot.docs.map((doc){
// //         return UserModel.fromJson(doc.data() as Map<String,dynamic>);
// //       }).toList();
// //     });
// //   }

// //   void printUsertoConsole(){
// //     getUsers().listen((users){
// //       for (var user in users) {
// //         log('${user.username}');
// //       }
// //     });
// //   }
// // }
// // import 'package:cloud_firestore/cloud_firestore.dart';
// // import 'package:social_sphere/model/usermodel.dart';

// // class Sample {
// //   CollectionReference firestore =
// //       FirebaseFirestore.instance.collection("users");

// //   Stream<List<UserModel>> getUsers() {
// //     return firestore.snapshots().map((snapshot) {
// //       return snapshot.docs.map((docs) {
// //         return UserModel.fromJson(docs.data() as Map<String, dynamic>);
// //       }).toList();
// //     });
// //   }

// //   void printUsersToConsole() {
// //     List userss = [];
// //     getUsers().listen((users) {
// //       for (var user in users) {
// //         userss.add(user.username);
// //       }
// //       print(userss);
// //     });
// //   }
// // }

// import 'dart:developer';

// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:social_sphere/model/usermodel.dart';

// class Sample {
//   CollectionReference firestore =
//       FirebaseFirestore.instance.collection("users");

//   Stream<List<UserModel>> getUser() {
//     return firestore.snapshots().map((snapshot) {
//       return snapshot.docs.map((docs) {
//         return UserModel.fromJson(docs.data() as Map<String, dynamic>);
//       }).toList();
//     });
//   }

//   void printUsersToConsole() {
//     getUser().listen((users) {
//       for (var user in users) {
//         log('${user.username}');
//       }
//     });
//   }
// }
