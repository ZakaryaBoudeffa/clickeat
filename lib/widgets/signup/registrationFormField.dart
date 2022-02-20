import 'dart:developer';

import 'package:clicandeats/main.dart';
import 'package:clicandeats/models/Settings.dart';
import 'package:clicandeats/services/placesServices.dart';
import 'package:clicandeats/utils/addressSearch.dart';
import 'package:clicandeats/utils/inputFieldValidator.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

class RegistrationTextFormField extends StatelessWidget {
  final IconData icon;
  final String label;
  final TextEditingController controller;
  final TextInputType keyboard;
  final isObsecure;
  RegistrationTextFormField(
      {required this.icon,
      required this.label,
      required this.controller,
      required this.keyboard,
      this.isObsecure});
  @override
  Widget build(BuildContext context) {
    var _settings = Provider.of<AppStateManager>(context);
    return Container(
      decoration: BoxDecoration(
          // boxShadow: [
          //   BoxShadow(
          //     blurRadius: 10,
          //     color: Colors.grey[100]!,
          //   )
          // ],
          ),
      child: TextFormField(
        style: TextStyle(
          color: _settings.themeLight ? Colors.black : Colors.white,
        ),
        onTap: () async {
          if (label == 'Adresse') {
            final sessionToken = Uuid().v4();
            final Suggestion result = await showSearch(
              context: context,
              delegate: AddressSearch(sessionToken),
            );
            // This will change the text displayed in the TextField
            if (result != null) {
              controller.text = result.description;
              final placeDetails = await PlaceApiProvider(sessionToken)
                  .getPlaceDetailFromId(result.placeId);
              log(placeDetails.toString());
            }
          }
        },
        validator: (value) => label == 'Email'
            ? Validator.validateEmail(value?.trim())
            : label == 'Mot de passe'
                ? Validator.validatePassword(value?.trim())
                : Validator.validateField(value?.trim()),
        keyboardType: keyboard,
        controller: controller,
        obscureText: isObsecure,
        decoration: InputDecoration(
          prefixIcon: Icon(
            icon,
            color: Color(0xfffc9568),
          ),
          contentPadding: const EdgeInsets.all(0),
          labelText: label,
          labelStyle: TextStyle(
              color: _settings.themeLight ? Colors.grey : Colors.white),
          alignLabelWithHint: true,
          fillColor: _settings.themeLight ? Colors.white : darkAccentColor,
          filled: true,
          border: OutlineInputBorder(
            borderSide: BorderSide.none,
            borderRadius: BorderRadius.circular(30),
          ),
        ),
      ),
    );
  }
}
