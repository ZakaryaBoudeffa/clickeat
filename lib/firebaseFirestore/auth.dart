import 'dart:convert';
import 'dart:math';

import 'package:clicandeats/models/client.dart';
import 'package:clicandeats/pages/HomePage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crypto/crypto.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_login_facebook/flutter_login_facebook.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:http/http.dart' as http;
import '../main.dart';

class Authentication {
  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseAuth auth2 = FirebaseAuth.instance;
  //String collectionName = 'restos';
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  /// register restaurant
  Future<User?> registerUsingEmailPassword(BuildContext context,
      {String? name,
      String? email,
      String? password,
      required Client clientData}) async {
    User? user;
    try {
      print("EMAIL: $email - user Data ${clientData.email}");

      /// Account creation
      UserCredential userCredential = await auth.createUserWithEmailAndPassword(
        email: clientData.email!,
        password: password!,
      );

      user = userCredential.user;
      await user!.updateDisplayName(name);
      await user.reload();

      /// send user email for verification
      //await user.sendEmailVerification();


      /// Save restaurant data to fire-store db
      await firestore
          .collection('client')
          .doc(user.uid)
          .set({
            'email': clientData.email,
            'firstName': clientData.firstName,
            'lastName': clientData.lastName,
            'phone': clientData.phone,
            'address': clientData.address,
            'associations': {},
            'cusId': "",
            'avatar': "",
            'donatedAmount': 0.0,
            //'location': coords.data
          },SetOptions(merge: true))
          .then((value) => firestore
                  .collection('client')
                  .doc(user!.uid)
                  .collection('shippingInfo')
                  .doc('shippingInfo')
                  .set({
                'firstName': clientData.firstName,
                'lastName': clientData.lastName,
                'phone': clientData.phone,
                'address': clientData.address,
                'city': "",
                'doorNumber': "",
                'entrance': "",
                'roadNumber': "",
                'stage': ""
              }))
          .whenComplete(() => print(
              'Created client in database with. Name: ${clientData.firstName}'))
          .catchError((error) {
            print('Firestore error ${error.toString()}');
          });

      user = auth.currentUser;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        print('The password provided is too weak.');
        final snackBar = SnackBar(
            backgroundColor: Colors.red[700],
            content: Text(
                'Le mot de passe fourni est trop faible')); //The password provided is too weak
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      } else if (e.code == 'email-already-in-use') {
        final snackBar = SnackBar(
            backgroundColor: Colors.red[700],
            content: Text(
                'Email déjà utilisé. Entrez une adresse email différente')); //Email already in use. Enter a different email address
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      } else
        print('firebaseException $e');
    } catch (e) {
      print(e);
    }
    return user;
  }

  /// sign in
  Future<User?> signInUsingEmailPassword({
    required String email,
    required String password,
    required BuildContext context,
  }) async {
    //FirebaseAuth auth = FirebaseAuth.instance;
    User? user;

    try {
      UserCredential userCredential = await auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      user = userCredential.user;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        print('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        print('Wrong password provided.');
      }
    }

    return user;
  }
  String generateNonce([int length = 32]) {
    final charset =
        '0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._';
    final random = Random.secure();
    return List.generate(length, (_) => charset[random.nextInt(charset.length)])
        .join();
  }

  /// Returns the sha256 hash of [input] in hex notation.
  String sha256ofString(String input) {
    final bytes = utf8.encode(input);
    final digest = sha256.convert(bytes);
    return digest.toString();
  }


  Future<UserData?> signIWithApple(context) async {
    User? user;
    try {
      bool isNewuser = false;
      bool isExistInFirestore = false;
      final rawNonce = generateNonce();
      final nonce = sha256ofString(rawNonce);

      // Request credential for the currently signed in Apple account.
      final appleCredential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
        nonce: nonce,
      );

      // Create an `OAuthCredential` from the credential returned by Apple.
      final oauthCredential = OAuthProvider("apple.com").credential(
        idToken: appleCredential.identityToken,
        rawNonce: rawNonce,
      );

      // Sign in the user with Firebase. If the nonce we generated earlier does
      // not match the nonce in `appleCredential.identityToken`, sign in will fail.
      final result = await FirebaseAuth.instance.signInWithCredential
        (oauthCredential);

      user = result.user;
      // final profile = await fb.getUserProfile();
      // print('Hello, ${profile?.name}! You ID: ${profile?.userId}');
      // final email = await fb.getUserEmail();
      //
      // if (email != null) print('And your email is $email');
      isNewuser = result.additionalUserInfo!.isNewUser;
      isExistInFirestore = await checkExist(user!.uid);
      print('isNEW: $isNewuser');
      if (!isNewuser && isExistInFirestore) {
        print("apple User logged in ");
        return UserData(user: user, isNew: isNewuser);
      }
      else {
        await addUserToFirestore(user);
      }
      // print("credential identityToken: ${credential.identityToken}");
      return UserData(user: user, isNew: isNewuser);
    } on SignInWithAppleException catch (e) {
      print("SignInWithAppleException: $e");
    } catch (e) {
      print("EXCEPTION $e");
    }
   // return user;
  }

  Future<UserData?> signInWithGoogle(context) async {

    User? user;
    try {
      bool isNewuser = false;
      bool isExistInFirestore = false;
      GoogleSignInAccount? googleUser =
      await GoogleSignIn(scopes: <String>["email"]).signIn();
      final GoogleSignInAuthentication googleAuth =
      await googleUser!.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      final result =
      await auth.signInWithCredential(credential);
      user = result.user;
      //bool isNewuser = await checkExist(user!.uid);
      isNewuser = result.additionalUserInfo!.isNewUser;
      isExistInFirestore = await checkExist(user!.uid);
      print('isNEW: $isNewuser');
      if (!isNewuser && isExistInFirestore) {
        print("google User logged in ");
        return UserData(user: user, isNew: isNewuser);
      }
      else {
        await addUserToFirestore(user);
        return UserData(user: user, isNew: isNewuser);
      }


      // return user;
    } on FirebaseAuthException catch (e) {
      firebaseExceptionHandle(e, context);
    } catch (e) {
      print("EXCEPTION $e");
    }
  }

  Future<UserData?> signInWithFacebook(context) async {
    User? user;

    final fb = FacebookLogin();
    try {
      final res = await fb.logIn(permissions: [
        FacebookPermission.publicProfile,
        FacebookPermission.email,
        FacebookPermission.userFriends
      ]);
      print("res $res");
      // Check result status
      bool isNewuser = false;
      bool isExistInFirestore = false;
      switch (res.status) {
        case FacebookLoginStatus.success:
          final FacebookAccessToken accessToken = res.accessToken!;
          final AuthCredential authCredential =
          FacebookAuthProvider.credential(accessToken.token);
          final result =
          await FirebaseAuth.instance.signInWithCredential(authCredential);

          user = result.user;
          final profile = await fb.getUserProfile();
          print('Hello, ${profile?.name}! You ID: ${profile?.userId}');
          final email = await fb.getUserEmail();

          if (email != null) print('And your email is $email');
           isNewuser = result.additionalUserInfo!.isNewUser;
          isExistInFirestore = await checkExist(user!.uid);
          print('isNEW: $isNewuser');
          if (!isNewuser && isExistInFirestore) {
            print("fb User logged in ");
            return UserData(user: user, isNew: isNewuser);
          }
          else {
            await addUserToFirestore(user);
          }
          user = result.user;
          break;
        case FacebookLoginStatus.cancel:
          print("LOGIN status ");
          // In case the user cancels the login process
          break;
        case FacebookLoginStatus.error:
        // Login procedure failed
          print('Error while log in: ${res.error}');
          break;
      }
      return UserData(user: user, isNew: isNewuser);
    } on FirebaseAuthException catch (e) {
      firebaseExceptionHandle(e, context);
    } catch (e) {
      print("EXCEPTION $e");
    }
  }

  /// for social logins add user to firestore if it not exists already
  addUserToFirestore(User user) async {
    await user.updateDisplayName(user.displayName);
    await user.reload();

    /// send user email for verification
    //await user.sendEmailVerification();

    /// Save restaurant data to fire-store db
    await firestore
        .collection('client')
        .doc(user.uid)
        .set({
      'email': user.email,
      'firstName': user.displayName??"",
      'lastName': user.displayName??"",
      'phone': user.phoneNumber??"",
      'address': "",
      'associations': {},
      'cusId': "",
      'avatar': "",
      'donatedAmount': 0.0,
      //'location': coords.data
    },SetOptions(merge: true))
        .then((value) => firestore
        .collection('client')
        .doc(user.uid)
        .collection('shippingInfo')
        .doc('shippingInfo')
        .set({
      'firstName': user.displayName??"",
      'lastName': user.displayName??"",
      'phone': user.phoneNumber??"",
      'address': "",
      'city': "",
      'doorNumber': "",
      'entrance': "",
      'roadNumber': "",
      'stage': ""
    }))
        .whenComplete(() => print(
        'Created client in database with. Name: ${user.displayName}'))
        .catchError((error) {
      print('Firestore error ${error.toString()}');
    });
    print("Google User added in firestore");
  }

  /// handle firebase auth exceptions in social logins
  firebaseExceptionHandle(e, context) {
    if (e.code == 'weak-password') {
      print('The password provided is too weak.');
      final snackBar = SnackBar(
          backgroundColor: Colors.red[700],
          content:
          Text('Le mot de passe fourni est trop faible.')); //The password
      // provided is too weak
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    } else if (e.code == 'email-already-in-use') {
      final snackBar = SnackBar(
          backgroundColor: Colors.red[700],
          content: Text('Email déjà utilisé. '
              'Entrez une adresse email différente.'));
      //Email already in use. Enter a different email address
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    } else if (e.code == 'account-exists-with-different-credential') {
      print("ERROR: account exists with different credential");
      final snackBar = SnackBar(
          backgroundColor: Colors.red[700],
          content: Text('Le compte existe déjà avec des '
              'identifiants différents. Essayez un autre compte.'));
      //Email already in use. Enter a different email address
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    } else
      print('firebaseException ${e.code} ');
  }

  /// refresh user if required
  Future<User?> refreshUser(User user) async {
    await user.reload();

    User? refreshedUser = auth.currentUser;
    return refreshedUser;
  }

  /// Password reset
  Future<void> resetPassword(String email) async {
    await auth.sendPasswordResetEmail(email: email);
  }

  /// Signout
  signOut() async {
    myCart.shippingAddress = "";
    myCart.resId = null;
    myCart.items = null;
    inCart.clear();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    final GoogleSignIn googleUser = GoogleSignIn(scopes: <String>["email"]);
    await auth.signOut();
    googleUser.signOut();
  }

  bool exist = false;
  Future<bool> checkExist(String docID) async {
    try {
      await firestore.collection('client').doc("$docID").get().then((doc) {
        exist = doc.exists;
      });
      return exist;
    } catch (e) {
      // If any error
      return false;
    }
  }




}

class UserData {
  User? user;
  bool isNew;

  UserData({required this.user, required this.isNew});
}