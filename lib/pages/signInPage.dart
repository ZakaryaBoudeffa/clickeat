import 'dart:developer';
import 'dart:io';

import 'package:clicandeats/firebaseFirestore/auth.dart';
import 'package:clicandeats/pages/DonationPage.dart';
import 'package:clicandeats/pages/layout.dart';
import 'package:clicandeats/widgets/signin/loginFormFeild.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SignIn extends StatefulWidget {
  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final _email = TextEditingController();
  final _password = TextEditingController();
  final _formKey = new GlobalKey<FormState>();

  bool loading = false;
  bool googleLoading = false;
  bool appleLoading = false;
  bool fbLoading = false;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                flex: 2,
                child: Container(
                    // color: Colors.pink,
                    ),
              ),
              Expanded(
                flex: 10,
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Image.asset(
                        'assets/images/logo.png',
                        height: width / 3,
                        width: width / 3,
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      Text(
                        'Bienvenue a nouveau',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      Text(
                        'Connectez-vous avec votre adresse mail',
                        style: TextStyle(
                          fontSize: 14,
                        ),
                      ),
                      SizedBox(
                        height: 50,
                      ),
                      LoginTextFormField(
                        icon: Icons.mail_outline,
                        label: 'Email',
                        controller: _email,
                        isObsecure: false,
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      LoginTextFormField(
                        icon: Icons.lock_outline_rounded,
                        label: 'Mot de passe',
                        controller: _password,
                        isObsecure: true,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          GestureDetector(
                            onTap: () =>
                                Navigator.of(context).pushNamed('/reset'),
                            child: Text(
                              'Mot de passe oublié?',
                              style: TextStyle(
                                  fontSize: 11,
                                  //fontWeight: FontWeight.bold,
                                  color: Colors.red.shade600),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      loading
                          ? CircularProgressIndicator()
                          : SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                onPressed: () {
                                  processSignIn();
                                },
                                child: Text(
                                  'SE CONNECTER',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white),
                                ),
                              ),
                            ),
                      SizedBox(
                        height: 10,
                      ),
                      Text('or continue with'),
                      SizedBox(height: 10),
                      socialLogins(),
                      SizedBox(height: 10),
                      Text(
                        'Vous n\'avez pas de compte ?',
                        style: TextStyle(
                            // fontSize: 11,
                            // fontWeight: FontWeight.bold,
                            ),
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      GestureDetector(
                        onTap: () => Navigator.of(context).pushNamed('/signup'),
                        child: Text(
                          'Créez Un Compte',
                          style: TextStyle(
                            // fontSize: 11,
                            fontWeight: FontWeight.bold,
                            color: Color(0xfffc9568),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Expanded(child: Container(color: Colors.pink,),),
            ],
          ),
        ),
      ),
    );
  }

  processSignIn() async {
    if (_formKey.currentState!.validate()) {
      print('validated - sign in');
      setState(() {
        loading = true;
      });
      //
      User? user = await Authentication().signInUsingEmailPassword(
          email: _email.text.trim(),
          password: _password.text.trim(),
          context: context);
      postSignInCall(user);
      if (user != null) {
        Navigator.of(context).pushNamedAndRemoveUntil('/', (route) => false);
      } else {
        setState(() {
          loading = false;
        });
        final snackBar = SnackBar(
            backgroundColor: Colors.red[700],
            content: Text(
                'Identifiants non valides ou l\'utilisateur n\'existe pas'));
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
        log('something went wrong - sign in');
      }
    }
  }

  Widget socialLogins() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        /// APPLE
        Platform.isIOS
            ? OutlinedButton(
                style: ButtonStyle(

                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                            side: BorderSide(color: Colors.red)))),
                onPressed: () async {
                  UserData? user =
                      await Authentication().signIWithApple(context);
                  if (user!.isNew) {
                    await Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                DonationPage(uId: user.user!.uid)));
                  } else {
                    print("OLD USR");
                    Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(builder: (context) => Layout()),
                        (route) => false);
                  }
                  // postSignInCall(user);
                },
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            'assets/images/icons/apple.png',
                            height: 30,
                            width: 30,
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Text(
                            'Apple',
                            style: TextStyle(color: Colors.black),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              )
            : Container(),
        Platform.isIOS ? SizedBox(width: 10) : Container(),

        /// GOOGLE
        googleLoading
            ? CircularProgressIndicator()
            : Platform.isAndroid
                ? InkWell(
                    onTap: () async {
                      setState(() {
                        googleLoading = true;
                      });
                      UserData? user =
                          await Authentication().signInWithGoogle(context);
                      print('isNEW user ${user!.isNew}');
                      if (user.isNew) {
                       // if (mounted)
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      DonationPage(uId: user.user!.uid)));
                      } else {
                        print("OLD USR");
                    //    if (mounted)
                    //       Navigator.of(context).pushAndRemoveUntil(
                    //           MaterialPageRoute(builder: (context) => Layout()),
                    //           (route) => false);

                        Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
                      }
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            'assets/images/icons/google.png',
                            height: 30,
                            width: 30,
                          ),
                        ],
                      ),
                    ),
                  )
                : Container(),
        SizedBox(width: 10),

        /// FACEBOOK
        Platform.isAndroid
            ? InkWell(
                onTap: () async {
                  UserData? user =
                      await Authentication().signInWithFacebook(context);
                  print('isNEW user ${user!.isNew}');
                  if (user.isNew) {
                    await Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                DonationPage(uId: user.user!.uid)));
                  } else {
                    print("OLD USR");
                    Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(builder: (context) => Layout()),
                        (route) => false);
                  }
                },
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        'assets/images/icons/facebook.png',
                        height: 30,
                        width: 30,
                      ),
                    ],
                  ),
                ),
              )
            : Container(),
        SizedBox(height: 15),
      ],
    );
  }

  postSignInCall(User? user) async {
    if (user != null) {
      print("Sign in useer ${user.uid}");
    } else {
      setState(() {
        loading = false;
        googleLoading = false;
        appleLoading = false;
        fbLoading = false;
      });
      final snackBar = SnackBar(
          backgroundColor: Colors.red[700],
          content: Text('Invalid credentials or the user does not exist'));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      print('something went wrong - sign in');
    }
  }
}
