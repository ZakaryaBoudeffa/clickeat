import 'package:clicandeats/models/Settings.dart';
import 'package:clicandeats/utils/inputFieldValidator.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../main.dart';

class LoginTextFormField extends StatelessWidget {
  final IconData icon;
  final String label;
  final TextEditingController controller;
  final bool isObsecure;
  LoginTextFormField({required this.icon,required this.label,required this.controller,required this.isObsecure});
  @override
  Widget build(BuildContext context) {
    var _settings = Provider.of<AppStateManager>(context);
    return Stack(
      alignment: Alignment.centerLeft,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 30),
          child: TextFormField(
            validator: (value) => label == 'Email'
                ? Validator.validateEmail(value?.trim())
                : Validator.validatePassword(value?.trim()),

            controller: controller,
            obscureText: isObsecure,
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.only(left: 50.0),
            //  floatingLabelBehavior: FloatingLabelBehavior.never,
              labelText: label,
              labelStyle: TextStyle(color: _settings.themeLight ? Colors.grey : Colors.white),
              fillColor: _settings.themeLight? Colors.white : darkAccentColor,
              filled: true,
              border: OutlineInputBorder(
                borderSide: BorderSide.none,
                borderRadius: BorderRadius.circular(30),
              ),
            ),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                blurRadius: 10,
                color: Colors.grey[400]!,
              )
            ],
          ),
          child: CircleAvatar(
            backgroundColor: Colors.white,
            child: Icon(
              icon,
              color: Color(0xfffc9568),
            ),
            radius: 30,
          ),
        ),
      ],
    );
  }
}
