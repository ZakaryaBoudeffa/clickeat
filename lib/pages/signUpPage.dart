import 'package:clicandeats/firebaseFirestore/auth.dart';
import 'package:clicandeats/models/client.dart';
import 'package:clicandeats/pages/DonationPage.dart';
import 'package:clicandeats/widgets/signup/registrationFormField.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
// import 'package:geocoder/geocoder.dart';

class SignUp extends StatefulWidget {
  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final _formKey = new GlobalKey<FormState>();

  final _nom = TextEditingController();
  final _prenom = TextEditingController();
  final _email = TextEditingController();
  final _password = TextEditingController();
  final _password2 = TextEditingController();
  final _adr = TextEditingController();
  final _phone = TextEditingController();
  final _ville = TextEditingController();
  final _postal = TextEditingController();
  final _date = TextEditingController();
  late String _sexe ;

  var _genders = [
    "Homme",
    "Femme",
  ];

  bool loading = false;
  bool passwordMatched = true;

  @override
  void initState() {
    _sexe = _genders[0];
  }

  Client toClient() {
    Client res = Client(
      email: _email.text,
      //avatar: imageLink,
      firstName: _nom.text,
      lastName: _prenom.text,
      address: _adr.text,
      phone: _phone.text,
      themeLight: true,
    );
    return res;
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        titleTextStyle: TextStyle(color: Colors.black, fontSize: 16),
        elevation: 0,
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            size: 40,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(30),
              child: Column(
                children: [
                  Text(
                    'Créer un compte',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w900,
                      color: Color(0xfffc9568),
                    ),
                  ),
                  Text(
                    'Bienvenue, Crééz votre compte en toute sécurité',
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                        flex: 1,
                        child: RegistrationTextFormField(
                          icon: Icons.person_outline,
                          label: "Nom",
                          controller: _nom,
                          isObsecure: false,
                          keyboard: TextInputType.text,
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Flexible(
                        flex: 1,
                        child: RegistrationTextFormField(
                          icon: Icons.person_outline,
                          label: "Prénom",
                          isObsecure: false,
                          controller: _prenom,
                          keyboard: TextInputType.text,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  RegistrationTextFormField(
                    icon: Icons.mail_outline,
                    label: "Email",
                    isObsecure: false,
                    controller: _email,
                    keyboard: TextInputType.emailAddress,
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  RegistrationTextFormField(
                    icon: Icons.phone,
                    label: "Téléphone",
                    isObsecure: false,
                    controller: _phone,
                    keyboard: TextInputType.phone,
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  RegistrationTextFormField(
                    icon: Icons.lock_outline,
                    label: "Mot de passe",
                    isObsecure: true,
                    controller: _password,
                    keyboard: TextInputType.text,
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  RegistrationTextFormField(
                    icon: Icons.lock_outline,
                    label: "Réécrire mot de passe",
                    isObsecure: true,
                    controller: _password2,
                    keyboard: TextInputType.text,
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  RegistrationTextFormField(
                    icon: Icons.location_on_outlined,
                    label: "Adresse",
                    isObsecure: false,
                    controller: _adr,
                    keyboard: TextInputType.streetAddress,
                  ),
                  // SizedBox(
                  //   height: 30,
                  // ),
                  // Row(
                  //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  //   children: [
                  //     Flexible(
                  //       flex: 1,
                  //       child: RegistrationTextFormField(
                  //         icon: Icons.location_on_outlined,
                  //         label: "Ville",
                  //         isObsecure: false,
                  //         controller: _ville,
                  //         keyboard: TextInputType.text,
                  //       ),
                  //     ),
                  //     SizedBox(
                  //       width: 10,
                  //     ),
                  //     Flexible(
                  //       flex: 1,
                  //       child: RegistrationTextFormField(
                  //         icon: Icons.lock_outline,
                  //         label: "Code postal",
                  //         isObsecure: false,
                  //         controller: _postal,
                  //         keyboard: TextInputType.number,
                  //       ),
                  //     ),
                  //   ],
                  // ),
                  // SizedBox(
                  //   height: 30,
                  // ),
                  // Row(
                  //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  //   children: [
                  //     Flexible(
                  //       flex: 3,
                  //       child: RegistrationTextFormField(
                  //         icon: Icons.location_on_outlined,
                  //         label: "Date de naissance",
                  //         isObsecure: false,
                  //         keyboard: TextInputType.datetime,
                  //         controller: _date,
                  //       ),
                  //     ),
                  //     SizedBox(
                  //       width: 10,
                  //     ),
                  //     Flexible(
                  //         flex: 2,
                  //         child: FormField<String>(
                  //           builder: (FormFieldState<String> state) {
                  //             return InputDecorator(
                  //               decoration: InputDecoration(
                  //                 prefixIcon: Icon(
                  //                   Icons.person_outline,
                  //                   color: Color(0xfffc9568),
                  //                 ),
                  //                 contentPadding: const EdgeInsets.all(0),
                  //                 floatingLabelBehavior:
                  //                     FloatingLabelBehavior.never,
                  //                 labelText: 'Sexe',
                  //                 fillColor: Colors.white,
                  //                 filled: true,
                  //                 border: OutlineInputBorder(
                  //                   borderSide: BorderSide.none,
                  //                   borderRadius: BorderRadius.circular(30),
                  //                 ),
                  //               ),
                  //               isEmpty: _sexe == '',
                  //               child: DropdownButtonHideUnderline(
                  //                 child: DropdownButton<String>(
                  //                   hint: Text('Sexe'),
                  //                   iconEnabledColor: Color(0xfffc9568),
                  //                   value: _sexe,
                  //                   isDense: true,
                  //                   onChanged: (String? newValue) {
                  //                     setState(() {
                  //                       _sexe = newValue!;
                  //                       state.didChange(newValue);
                  //                     });
                  //                   },
                  //                   items: _genders.map((String value) {
                  //                     return DropdownMenuItem<String>(
                  //                       value: value,
                  //                       child: Text(value),
                  //                     );
                  //                   }).toList(),
                  //                 ),
                  //               ),
                  //             );
                  //           },
                  //         )),
                  //   ],
                  // ),
                  SizedBox(
                    height: 30,
                  ),
                  loading
                      ? CircularProgressIndicator()
                      :  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        processSignUp();
                      },
                      child: Text(
                        'CREER UN COMPTE',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Avez-vous déjà un compte?',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      GestureDetector(
                        onTap: () => Navigator.of(context).pop(),
                        child: Text(
                          'Connectez-vous!',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            color: Color(0xfffc9568),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
  processSignUp() async {
    if (_formKey.currentState!.validate()) {
      if (_password.text != _password2.text) {
        setState(() {
          passwordMatched = false;
          final snackBar = SnackBar(
              backgroundColor: Colors.red[700],
              content: Text(
                  'Le mot de passe ne correspond pas')); //password does not match
          ScaffoldMessenger.of(context)
              .showSnackBar(snackBar);
        });
      } else {
        var addresses = await locationFromAddress(_adr.text);
        var first = addresses.first;
       // print("${first.featureName} : ${first.coordinates}");
        setState(() {
          passwordMatched = true;
        });
        Client client = toClient();
        setState(() {
          loading = true;
        });

        User? user = await Authentication()
            .registerUsingEmailPassword(
            context,
            email: _email.text.trim(),
            password: _password.text.trim(),
            clientData: client);
        if (user != null) {
          // call setup Intent API here to register user with stripe account and save cusId to firestore
          Navigator.push(context, MaterialPageRoute(builder: (context) => DonationPage(uId: user.uid)));
        } else {
          setState(() {
            loading = false;
          });
          //print('something went wrong - sign in');
        }
      }
    }
  }
}
