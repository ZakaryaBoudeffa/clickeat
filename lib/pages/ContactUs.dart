import 'package:clicandeats/firebaseFirestore/supportOp.dart';
import 'package:clicandeats/utils/inputFieldValidator.dart';
import 'package:clicandeats/utils/appBar.dart';
import 'package:flutter/material.dart';

import '../main.dart';

class ContactUs extends StatefulWidget {
  final String uId;
  ContactUs({required this.uId});
  @override
  _ContactUsState createState() => _ContactUsState();
}

class _ContactUsState extends State<ContactUs> {
  final _formKey = new GlobalKey<FormState>();
  TextEditingController supportMessage = TextEditingController();
  bool loading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(
        title: 'Nous contacter',
        back: true,
        uId: widget.uId,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                children: [
                  Image.asset(
                    'assets/images/contact.png',
                    height: MediaQuery.of(context).size.width * 0.5,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    'Nous contacter',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 26,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    'Comment pouvons-nous vous aider?',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 14,
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Form(
                    key: _formKey,
                    child: TextFormField(
                      validator: (value) => Validator.validateField(value!.trim()),
                      controller: supportMessage,
                      minLines: 8,
                      maxLines: 10,
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.all(20),
                        labelText: 'Votre message ici',
                        alignLabelWithHint: true,
                      //  labelStyle:
                       // TextStyle(fontSize: 14, fontWeight: FontWeight.n),
                        fillColor: Colors.white,
                        filled: true,
                        border: OutlineInputBorder(
                          borderSide: BorderSide.none,
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                ],
              ),
              SizedBox(
                width: double.infinity,
                child: Container(
                  child: MaterialButton(
                    height: 45,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    color: Theme.of(context).primaryColor,
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        setState(() {
                          loading = true;
                        });
                        await FirebaseOpSupport().supportRequired(
                            supportMessage.text, widget.uId);
                        supportMessage.text = "";
                        messageAlert(context);
                        setState(() {
                          loading = false;
                        });
                      }
                    },
                    child: Text(
                      "Envoyer",
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  messageAlert(context) {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Plainte enregistrée'),
          insetPadding: EdgeInsets.all(20),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(10.0))),
          content: Builder(builder: (context) {
            // Get available height and width of the build area of this widget. Make a choice depending on the size.
            var width = MediaQuery.of(context).size.width;

            return Container(
              width: width - 20,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Text(
                      'Votre réclamation est enregistrée. L\'un de nos membres d\'assistance vous contactera sous peu par e-mail!',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        //fontWeight: FontWeight.bold,
                        color: Colors.black,
                        fontSize: 14,
                      ),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: Text(
                            "OK",
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              // fontSize: 10,
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                            padding: EdgeInsets.symmetric(
                                horizontal: 20, vertical: 10),
                            primary: Theme.of(context).primaryColor,
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            );
          }),
        );
      },
    );
  }
}
