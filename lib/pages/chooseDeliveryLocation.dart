import 'dart:developer';

import 'package:clicandeats/models/Settings.dart';
import 'package:clicandeats/pages/HomePage.dart';
import 'package:clicandeats/pages/layout.dart';
import 'package:clicandeats/services/placesServices.dart';
import 'package:clicandeats/utils/addressSearch.dart';
import 'package:clicandeats/utils/inputFieldValidator.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

class ChooseDeliveryLocation extends StatelessWidget {
  ChooseDeliveryLocation({Key? key}) : super(key: key);
  final _search = TextEditingController();
  final _formKey = new GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    var _settings = Provider.of<AppStateManager>(context);
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            "assets/images/logo.png",
            height: 150,
          ),
          //SvgPicture.asset('assets/images/decor.svg', height: 200,),
          SizedBox(
            height: 50,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            child: Text(
              'Définir l\'emplacement',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.headline6,
            ),
          ),
          Text("Trouvez des restaurants près de chez vous!"),
          Form(
            key: _formKey,
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: TextFormField(
                onTap: () async {
                  final sessionToken = Uuid().v4();
                  final Suggestion result = await showSearch(
                    context: context,
                    delegate: AddressSearch(sessionToken),
                  );
                  myCart.shippingAddress = result.description;
                  _search.text = result.description;
                  final placeDetails = await PlaceApiProvider(sessionToken)
                      .getPlaceDetailFromId(result.placeId);
                  log(placeDetails.toString());
                },
                readOnly: true,
                // style: TextStyle(
                //     color: Theme.of(context).primaryColor,
                //     fontWeight: FontWeight.w500),
                controller: _search,
                validator: (value) => Validator.validateField(value),
                decoration: InputDecoration(
                  prefixIcon: Icon(
                    Icons.location_on,
                    color: Theme.of(context).primaryColor,
                  ),
                  contentPadding: const EdgeInsets.all(0),
                  hintText: 'Livré à',
                  alignLabelWithHint: true,
                  // labelStyle: TextStyle(
                  //   fontSize: 18,
                  // ),
                  fillColor: Colors.white,
                  filled: true,
                  border: OutlineInputBorder(
                    borderSide: BorderSide.none,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide.none,
                    //  borderRadius: BorderRadius.circular(15),
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Align(
              alignment: Alignment.center,
              child: MaterialButton(
                color: Theme.of(context).primaryColor,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Layout()));
                  }
                },
                child: Text(
                  "Trouver des restaurants",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
