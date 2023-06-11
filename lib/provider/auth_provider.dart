import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../constants/constant.dart';
import '../enums/app_conection_status.dart';
import '../helper/sp_helper.dart';
import '../helper/sp_key_helper.dart';
import '../pages/main_page/main_page.dart';

class AuthProvider with ChangeNotifier {
  final googleSignIn = GoogleSignIn();
  final Constants _constants = Constants();
  AppConnectionStatus connectionStatus = AppConnectionStatus.none;

  bool dataSyncing = false;
  bool authLoading = false;
  bool sendingNotification = false;

  navigateToNextPage({required BuildContext context}) {
    Navigator.of(context).push(MaterialPageRoute(builder: (context) {
      return MainPage();
    }));
  }

  Future googleLogin({required BuildContext context}) async {
    connectionStatus = AppConnectionStatus.loading;
    notifyListeners();
    try {
      final googleUser = await googleSignIn.signIn();
      if (googleUser == null) {
        throw ("google login error : google user is null");
      }
      final googleAuth = await googleUser.authentication;

      final credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken, idToken: googleAuth.idToken);
      await FirebaseAuth.instance.signInWithCredential(credential);
      await SpHelper().saveBool(SpKey().authByGoogle, true);
      await navigateToNextPage(context: context);

      _constants.getToast("User Login Successfully");
    } catch (e) {
      log("error while login with google: $e");
      _constants.getToast("Something went wrong");
    } finally {
      connectionStatus = AppConnectionStatus.success;
      notifyListeners();
    }
  }

  Future emailLogin(
      {required String email,
      required String password,
      required BuildContext context}) async {
    connectionStatus = AppConnectionStatus.loading;
    notifyListeners();
    log("message");
    try {
      UserCredential credential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      if (credential.user == null) {
        throw "user not login properly";
      }
      await navigateToNextPage(context: context);
      await SpHelper().saveBool(SpKey().authByGoogle, false);
      _constants.getToast("User Login Successfully");
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        _constants.getToast('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        _constants.getToast('Wrong password provided for that user.');
      }
    } catch (e) {
      _constants.getToast('something went wrong');
      log(e.toString());
    } finally {
      connectionStatus = AppConnectionStatus.success;
      notifyListeners();
    }
  }

  Future emailSignup(
      {required String email,
      required String password,
      required BuildContext context}) async {
    connectionStatus = AppConnectionStatus.loading;
    notifyListeners();
    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      navigateToNextPage(context: context);
      await SpHelper().saveBool(SpKey().authByGoogle, false);
      _constants.getToast("User Login Successfully");
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        _constants.getToast('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        _constants.getToast('The account already exists for that email.');
      }
    } catch (e) {
      _constants.getToast('something went wrong');
      log(e.toString());
    } finally {
      connectionStatus = AppConnectionStatus.success;
      notifyListeners();
    }
  }

  Future resetEmailPassword(
      {required String email, required BuildContext context}) async {
    connectionStatus = AppConnectionStatus.loading;
    notifyListeners();
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
      Navigator.of(context).pop();
      _constants.getSnackBar(
          context: context, msg: "Password Reset Email Sent");
    } catch (e) {
      _constants.getSnackBar(context: context, msg: "Something went wrong");
    } finally {
      connectionStatus = AppConnectionStatus.success;
      notifyListeners();
    }
  }

  Future logout({required BuildContext context}) async {
    authLoading = true;
    notifyListeners();
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        throw "user not found";
      }
      SharedPreferences preferences = await SharedPreferences.getInstance();

      // logout user
      bool isAuthByGoogle =
          await SpHelper().loadBool(SpKey().authByGoogle) ?? false;
      FirebaseAuth.instance.signOut();

      if (isAuthByGoogle) {
        await googleSignIn.disconnect();
      }

      await preferences.clear();

      _constants.getToast("User Logout Successfully");
      Phoenix.rebirth(context);
    } catch (e) {
      _constants.getToast("Something went wrong");
      log("error : ${e.toString()}");
    } finally {
      authLoading = false;
      notifyListeners();
    }
  }


}
