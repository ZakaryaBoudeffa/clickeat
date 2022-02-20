import 'package:clicandeats/firebaseFirestore/profileOp.dart';
import 'package:clicandeats/models/Settings.dart';
import 'package:clicandeats/models/client.dart';
import 'package:clicandeats/pages/HomePage.dart';
import 'package:clicandeats/utils/common.dart';
import 'package:clicandeats/widgets/signup/registrationFormField.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

Future editShippingInfos(context, isEdit, {String? infoId, ShippingInfo? info,required uId,  required VoidCallback onclick}) {
  print('infoId $infoId');
  final _nom = TextEditingController();
  final _prenom = TextEditingController();
  final _phone = TextEditingController();
  final _adr = TextEditingController();
  final _city = TextEditingController();
  final _roadNum = TextEditingController();
  final _stage = TextEditingController();
  final _doorNumber = TextEditingController();
  final _entrence = TextEditingController();
  final _formKey = new GlobalKey<FormState>();

  bool loading = false;
  return showDialog(
    context: context,
    builder: (BuildContext context) {
      var _settings = Provider.of<AppStateManager>(context);
      if (info != null) {
        _nom.text = info.firstName!;
        _prenom.text = info.lastName!;
        _phone.text = info.phone!;
        _city.text = info.city!;
        _adr.text = info.address!;
        _roadNum.text = info.roadNumber!;
        _stage.text = info.stage!;
        _doorNumber.text = info.doorNumber!;
        _entrence.text = info.entrance!;
      }

      return AlertDialog(
        backgroundColor: _settings.themeLight ? Colors.white : Theme.of(context).scaffoldBackgroundColor,
        // contentPadding: EdgeInsets.zero,
        insetPadding: EdgeInsets.all(10),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(10.0))),
        title: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Center(
            child: FittedBox(
              child: Text(
                'Informations de livraison',
                textAlign: TextAlign.center,
                style: TextStyle(
                  //fontSize: 19,
                  fontWeight: FontWeight.w600,
                  color: _settings.themeLight ? Colors.black : Colors.white,
                ),
              ),
            ),
          ),
        ),
        content: StatefulBuilder(builder: (context, setState) {
          return SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  RegistrationTextFormField(
                    icon: Icons.person_outline,
                    label: "Nom",
                    controller: _nom,
                    isObsecure: false,
                    keyboard: TextInputType.text,
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  RegistrationTextFormField(
                    icon: Icons.person_outline,
                    label: "Prénom",
                    isObsecure: false,
                    controller: _prenom,
                    keyboard: TextInputType.text,
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  RegistrationTextFormField(
                    icon: Icons.phone_outlined,
                    label: "Numéro telephone",
                    isObsecure: false,
                    controller: _phone,
                    keyboard: TextInputType.number,
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  RegistrationTextFormField(
                    icon: Icons.location_on_outlined,
                    label: "Adresse",
                    isObsecure: false,
                    controller: _adr,
                    keyboard: TextInputType.streetAddress,
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  RegistrationTextFormField(
                    icon: Icons.location_city,
                    label: "Ville",
                    isObsecure: false,
                    controller: _city,
                    keyboard: TextInputType.text,
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                        flex: 1,
                        child: RegistrationTextFormField(
                          icon: Icons.add_road_sharp,
                          label: "N° rue",
                          isObsecure: false,
                          controller: _roadNum,
                          keyboard: TextInputType.number,
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Flexible(
                        flex: 1,
                        child: RegistrationTextFormField(
                          icon: Icons.location_on_outlined,
                          label: "étage",
                          isObsecure: false,
                          controller: _stage,
                          keyboard: TextInputType.number,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                        flex: 1,
                        child: RegistrationTextFormField(
                          icon: Icons.house_siding_rounded,
                          label: "N° porte",
                          isObsecure: false,
                          controller: _doorNumber,
                          keyboard: TextInputType.text,
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Flexible(
                        flex: 1,
                        child: RegistrationTextFormField(
                          icon: Icons.location_on_outlined,
                          label: "entrée",
                          isObsecure: false,
                          controller: _entrence,
                          keyboard: TextInputType.text,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: MaterialButton(
                          height: 45,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                          //color: Theme.of(context).primaryColor,
                          onPressed: () {
                            // setState((){
                            //   loading = false;
                            // });
                            Navigator.pop(context);
                          },
                          child: Text(
                            'Annuler',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: _settings.themeLight ? Colors.black : Colors.white,
                              //   color: Colors.white
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: MaterialButton(
                          elevation: 0,
                          height: 45,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(6),
                              side: BorderSide(
                                  color: Theme.of(context).primaryColor)),
                          color: Theme.of(context).primaryColor,
                          onPressed: () async {
                            if (loading == false) {
                              Map<String, dynamic> info = ShippingInfo(
                                      firstName: _nom.text,
                                      lastName: _prenom.text,
                                      phone: _phone.text,
                                      address: _adr.text,
                                      city: _city.text,
                                      roadNumber: _roadNum.text,
                                      stage: _stage.text,
                                      doorNumber: _doorNumber.text,
                                      entrance: _entrence.text)
                                  .toMap();

                              setState(() {
                                myCart.shippingAddress = _adr.text;
                                loading = true;
                              });


                              isEdit
                                  ? await FirebaseProfileOp()
                                      .editShippingInfo(context, info, infoId, uId)
                                  : FirebaseProfileOp()
                                      .addShippingInfo(context, info, infoId, uId);
                              setState(() {
                                loading = false;
                              });
                              Navigator.pop(context);
                             // print("INFO: $info");
                              onclick();
                            }
                            // Navigator.pop(context);
                          },
                          child: Text(
                            loading
                                ? '$loadingText...'
                                : isEdit
                                    ? 'Mettre à jour'
                                    : 'Ajouter',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, color: Colors.white
                                // color: Colors.white
                                ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        }),
      );
    },
  );
}
