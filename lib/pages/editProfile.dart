import 'dart:io';
import 'package:clicandeats/firebaseFirestore/commonOp.dart';
import 'package:clicandeats/firebaseFirestore/profileOp.dart';
import 'package:clicandeats/main.dart';
import 'package:clicandeats/models/client.dart';
import 'package:clicandeats/utils/appBar.dart';
import 'package:clicandeats/widgets/signup/registrationFormField.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class EditProfile extends StatefulWidget {
  String uId;
  Client profileInfo;
  EditProfile({required this.profileInfo, required this.uId});
  @override
  _EditProfileState createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  String imageLink = "";
  String updatedImageLink = "";
  File? _image;
  bool loading = false;
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _firstName = TextEditingController();
  final TextEditingController _lastName = TextEditingController();
  final TextEditingController _adr = TextEditingController();
  final TextEditingController _email = TextEditingController();
  final TextEditingController _phone = TextEditingController();
  bool themeLight = false;


  _imgFromCamera() async {
    PickedFile? image = await ImagePicker()
        .getImage(source: ImageSource.camera, imageQuality: 50);
    var link = await FirebaseCommonOperations().uploadFile(
        image!, '${DateTime.now().millisecondsSinceEpoch}', 'profile');
    print("${DateTime.now().millisecondsSinceEpoch} generated link $link");
    setState(() {
      try {
        _image = File(image.path);
        imageLink = link;
        updatedImageLink = link;
      } catch (e) {
        _image = null;
      }
    });
  }

  _imgFromGallery() async {
    PickedFile? image = await ImagePicker()
        .getImage(source: ImageSource.gallery, imageQuality: 50);
    var link = await FirebaseCommonOperations().uploadFile(
        image!, '${DateTime.now().millisecondsSinceEpoch}', 'profile');
    print("${DateTime.now().millisecondsSinceEpoch} generated link $link");
    setState(() {
      try {
        _image = File(image.path);
        imageLink = link;
        updatedImageLink = link;
        print("IMAGE LINK: $imageLink");
      } catch (e) {
        _image = null;
      }
    });
  }

  Future<void> _showPicker(context) async {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return SafeArea(
            child: Container(
              child: new Wrap(
                children: <Widget>[
                  new ListTile(
                      leading: new Icon(Icons.photo_library),
                      title: new Text('Gallery'),
                      onTap: () async {
                        await _imgFromGallery();
                        Navigator.of(context).pop();
                      }),
                  new ListTile(
                    leading: new Icon(Icons.photo_camera),
                    title: new Text('Camera'),
                    onTap: () async {
                      await _imgFromCamera();
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
            ),
          );
        });
  }

  final style = TextStyle(
    fontWeight: FontWeight.w700,
    fontSize: 14,
  );

  @override
  void initState() {
    // TODO: implement initState
    _firstName.text = widget.profileInfo.firstName!;
    _lastName.text = widget.profileInfo.lastName!;
    _adr.text = widget.profileInfo.address!;
    _email.text = widget.profileInfo.email!;
    _phone.text = widget.profileInfo.phone!;
    themeLight = widget.profileInfo.themeLight!;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(
        title: 'Editer le profil',
        back: true,
        uId: widget.uId,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(30.0),
          child: Column(
            children: [
              Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: GestureDetector(
                          onTap: () {
                            _showPicker(context);
                          },
                          child: Stack(
                            alignment: Alignment.bottomRight,
                            children: [
                              _image != null ? Image.file(
                                _image!,
                                height: 85,
                                width: 85,
                                fit: BoxFit.cover,
                              ) :
                              widget.profileInfo.avatar == null ||
                                  widget.profileInfo.avatar ==
                                      ""
                                  ? Padding(
                                padding:
                                const EdgeInsets.all(10.0),
                                child: ClipRRect(
                                  borderRadius:
                                  BorderRadius.circular(30),
                                  child: Image.asset(
                                    'assets/man.png',
                                    height: 85,
                                    width: 85,
                                    fit: BoxFit.cover,
                                  )

                                ),
                              )
                                  : Padding(
                                padding:
                                const EdgeInsets.all(15.0),
                                child: ClipRRect(
                                  borderRadius:
                                  BorderRadius.circular(15),
                                  child: Image.network(
                                   widget.profileInfo.avatar!,
                                    height: 85,
                                    width: 85,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              CircleAvatar(
                                radius: 15,
                                child: Icon(
                                  Icons.file_upload,
                                ),
                                backgroundColor: Colors.white,
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                    // Text(
                    //   'Nom',
                    //   style: style,
                    // ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: RegistrationTextFormField(
                        icon: Icons.person_outline,
                        label: "Votre nom",
                        isObsecure: false,
                        controller: _firstName,
                        keyboard: TextInputType.text,
                      ),
                    ),
                    // Text(
                    //   'Prenom',
                    //   style: style,
                    // ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: RegistrationTextFormField(
                        icon: Icons.person_outline,
                        label: "Votre prenom",
                        isObsecure: false,
                        controller: _lastName,
                        keyboard: TextInputType.text,
                      ),
                    ),
                    // Text(
                    //   'Adresse',
                    //   style: style,
                    // ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10.0),
                      child: RegistrationTextFormField(
                        icon: Icons.location_on_outlined,
                        label: "Adresse",
                        isObsecure: false,
                        controller: _adr,
                        keyboard: TextInputType.streetAddress,
                      ),
                    ),
                    // Text(
                    //   'Email',
                    //   style: style,
                    // ),
                    // Padding(
                    //   padding: const EdgeInsets.symmetric(vertical: 10.0),
                    //   child: RegistrationTextFormField(
                    //     icon: Icons.email_outlined,
                    //     label: "Email",
                    //     isObsecure: false,
                    //     controller: _email,
                    //     keyboard: TextInputType.emailAddress,
                    //   ),
                    // ),
                    // Text(
                    //   'Phone',
                    //   style: style,
                    // ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10.0),
                      child: RegistrationTextFormField(
                        icon: Icons.phone,
                        label: "Phone",
                        isObsecure: false,
                        controller: _phone,
                        keyboard: TextInputType.phone,
                      ),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    InkWell(
                      onTap: () => Navigator.of(context).pushNamed('/reset'),
                      child: Center(
                        child: Text(
                          'Réinitialiser le mot de passe',
                          style: TextStyle(
                            //fontSize: 17,
                            color: Theme.of(context).primaryColor,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    SizedBox(
                      width: double.infinity,
                      child: MaterialButton(
                        color: Theme.of(context).primaryColor,
                        height: 45,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                        onPressed: () async {
                          Client clientData = Client(
                              avatar: updatedImageLink == ""
                                  ? imageLink
                                  : updatedImageLink,
                              firstName: _firstName.text,
                              lastName: _lastName.text,
                              email: _email.text,
                              phone: _phone.text,
                              address: _adr.text);
                          setState(() {
                            loading = true;
                          });
                          await FirebaseProfileOp().editProfile(clientData, widget.uId);
                          setState(() {
                            loading = false;
                          });
                          final snackBar = SnackBar(
                              content: Text(
                                  'Données mises à jour avec succès!')); //data updated successfully
                          ScaffoldMessenger.of(context)
                              .showSnackBar(snackBar);
                          Navigator.pop(context);
                          Navigator.pop(context);

                        },
                        child: Text(
                          'Modifier',
                          style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SwitchListTile(onChanged: (bool value) {

              }, value: themeLight)
            ],
          ),
        ),
      ),
    );
  }
}
