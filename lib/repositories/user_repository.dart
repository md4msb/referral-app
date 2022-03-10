import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:referral/model/referee_model.dart';
import 'package:referral/model/user_model.dart';
import '../services/auth_service.dart';
import '../services/code_generator.dart';
import '../services/deep_link_service.dart';

class UserRepository {
  UserRepository._();
  static UserRepository? _instance;

  static UserRepository get instance {
    _instance ??= UserRepository._();
    return _instance!;
  }

  ValueNotifier<UserModel> currentUserNotifier =
      ValueNotifier<UserModel>(UserModel.empty());

  UserModel get user {
    return currentUserNotifier.value;
  }

  listenToCurrentUser(String uid) {
    final snapshot =
        FirebaseFirestore.instance.collection('users').doc(uid).snapshots();
    snapshot.listen((event) {
      final user = UserModel.fromJson(event.data() as Map<String, dynamic>);
      currentUserNotifier.value = user;
      notifyListenersUser();
    });
  }

  Future<UserModel?> logIn(String email, String password) async {
    final authUser = await AuthService.instance?.logIn(email, password);
    if (authUser != null) {
      final user = await getUser(authUser.uid);
      currentUserNotifier.value = user;
      notifyListenersUser();
      listenToCurrentUser(user.uid);
      return user;
    } else {
      return null;
    }
  }

  Future<User?> registerUser(String name, String email, String password,
      {String referrerCode = ''}) async {
    final uid = await AuthService.instance?.signUp(email, password);
    final referCode = CodeGenerator.generateCode('refer');

    final referLink =
        await DeepLinkService.instance?.createReferLink(referCode);

    await FirebaseFirestore.instance.collection('users').doc(uid).set({
      'name': name,
      'email': email,
      'uid': uid,
      'refer_link': referLink,
      'refer_code': referCode,
      "referral_code": referrerCode,
      'reward': 0,
    });

    currentUserNotifier.value = await getUser(uid!);
    listenToCurrentUser(uid);
    notifyListenersUser();

    if (referrerCode.isNotEmpty) {
      await rewardUser(uid, name, referrerCode);
    }
    return null;
  }

  Future<UserModel> getUser(String uid) async {
    DocumentSnapshot userSnapshot =
        await FirebaseFirestore.instance.collection('users').doc(uid).get();

    if (userSnapshot.exists) {
      return UserModel.fromJson(userSnapshot.data() as Map<String, dynamic>);
    } else {
      return UserModel.empty();
    }
  }

  Future<UserModel> getReferrerUser(String referCode) async {
    final docSnapshots = await FirebaseFirestore.instance
        .collection('users')
        .where('refer_code', isEqualTo: referCode)
        .get();

    final userSnapshot = docSnapshots.docs.first;

    if (userSnapshot.exists) {
      return UserModel.fromJson(userSnapshot.data());
    } else {
      return UserModel.empty();
    }
  }

  Future<void> rewardUser(
    String currentUserUID,
    String currentUserName,
    String referrerCode,
  ) async {
    try {
      final referer = await getReferrerUser(referrerCode);

      final checkIfUserAlreadyExist = await FirebaseFirestore.instance
          .collection('users')
          .doc(referer.uid)
          .collection('referrers')
          .doc(currentUserUID)
          .get();

      if (!checkIfUserAlreadyExist.exists) {
        await FirebaseFirestore.instance
            .collection('users')
            .doc(referer.uid)
            .collection('referrers')
            .doc(currentUserUID)
            .set({
          "uid": currentUserUID,
          "name": currentUserName,
          "createdAt": DateTime.now().toUtc().millisecondsSinceEpoch,
        });

        await FirebaseFirestore.instance
            .collection('users')
            .doc(referer.uid)
            .update({
          "reward": FieldValue.increment(100),
        });
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Stream<List<RefereeModel>> getRefereeDetails() {
    final currentUserUID = currentUserNotifier.value.uid;
    return FirebaseFirestore.instance
        .collection("users")
        .doc(currentUserUID)
        .collection("referrers")
        .snapshots()
        .map((event) => event.docs
            .map(
              (e) => RefereeModel.fromJson(
                e.data(),
              ),
            )
            .toList());
  }

  Future<void> listenToCurrentAuth() async {
    if (UserRepository.instance.user == null) {
      var fbUser = auth.FirebaseAuth.instance.currentUser;
      if (fbUser == null) {
        try {
          fbUser = await auth.FirebaseAuth.instance.authStateChanges().first;
          if (fbUser != null) {
            currentUserNotifier.value = await getUser(fbUser.uid);
            notifyListenersUser();
          }
        } catch (_) {}
      }
      if (fbUser == null) {
        debugPrint("no  user");
      } else {
        final user = await getUser(fbUser.uid);
        currentUserNotifier.value = user;
        debugPrint(user.uid);
        listenToCurrentUser(user.uid);
        notifyListenersUser();
      }
    }
  }

  notifyListenersUser() {
    currentUserNotifier.notifyListeners();
  }

  logOutUser() async {
    currentUserNotifier.value = UserModel.empty();
    notifyListenersUser();
    await AuthService.instance?.logOut();
  }
}
