import 'package:clicandeats/firebaseFirestore/auth.dart';
import 'package:clicandeats/widgets/signup/registrationFormField.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';

class ForgetPassword extends StatelessWidget {
  final _email = TextEditingController();
  final _formKey = new GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        titleTextStyle: TextStyle(color: Colors.black, fontSize: 16),
        elevation: 0,
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_rounded,
            size: 30,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Stack(
                alignment: Alignment.topCenter,
                children: [
                  Padding(
                    padding: EdgeInsets.only(top: width / 8),
                    child: Container(
                      decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                            blurRadius: 10,
                            color: Colors.grey[100]!,
                          ),
                        ],
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.white,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 40, vertical: 100),
                        child: Column(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Icon(
                              Icons.lock_outline_rounded,
                              color: Color(0xfffc9568),
                              size: width / 4.5,
                            ),
                            SizedBox(
                              height: 30,
                            ),
                            Text(
                              'Processus de récupération du mot de passe',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                               // fontSize: 16,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            SizedBox(
                              height: 60,
                            ),
                            RegistrationTextFormField(
                              icon: Icons.mail_outline,
                              isObsecure: false,
                              label: "Email",
                              controller: _email,
                              keyboard: TextInputType.emailAddress,
                            ),
                            SizedBox(
                              height: 30,
                            ),
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                onPressed: () async {
                                  if(_formKey.currentState!.validate()){
                                    await Authentication().resetPassword(_email.text);
                                    _resetConfirmation(context);
                                    _email.text = '';
                                  }
                                  // _resetConfirmation(context);
                                },
                                child: Text(
                                  'Récupérer le mot de passe',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  CircleAvatar(
                    backgroundColor: Colors.white,
                    radius: width / 8,
                    child: Image.asset(
                      'assets/images/logo.png',
                      height: width / 6,
                      width: width / 6,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  _resetConfirmation(context) {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          contentPadding: EdgeInsets.all(30),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(10.0))),
          // title: Row(
          //   mainAxisAlignment: MainAxisAlignment.end,
          //   children: [
          //     IconButton(
          //       icon: Icon(
          //         FlutterIcons.x_fea,
          //         color: Theme.of(context).accentColor,
          //       ),
          //       onPressed: () => Navigator.of(context).pop(),
          //     ),
          //   ],
          // ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Center(
                child: Image.asset(
                  'assets/images/icons/done.png',
                  width: 50,
                  height: 50,
                ),
              ),
              SizedBox(
                height: 30,
              ),
              Text(
                'Veuillez vérifier votre mail',
                textAlign: TextAlign.left,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Text(
                'suivez les instructions pour réinitialiser votre mot de passe.',
                textAlign: TextAlign.center,
                style: TextStyle(
                 // fontSize: 15,
                  fontWeight: FontWeight.normal,
                  color: Colors.black,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
