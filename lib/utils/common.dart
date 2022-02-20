import 'package:clicandeats/models/extras.dart';
import 'package:flutter/material.dart';

Color boxShadowColor  = Colors.grey[200]!;
String errorText = 'Une erreur s\'est produite'; //An error occurred
String loadingText = 'Chargement'; //loading

double calculateDishTotalOnly(originalPrice, discountedPrice){
  return (originalPrice - (originalPrice * discountedPrice / 100))  ;
}

Widget placeholderCard(dynamic _settings){

  return Row(
    children: [
      Container(
        width: 250,
        height: 190,
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: _settings.themeLight? Colors.white : Color(0xff393E46),
          // boxShadow: [
          //   BoxShadow(
          //     blurRadius: 10,
          //     color: _settings.themeLight? Colors.grey[100]! : Colors.blueGrey.shade700,
          //   )
          // ],
        ),),
      SizedBox(width: 10,),
      Container(
        width: 250,
        height: 190,
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: _settings.themeLight? Colors.white : Color(0xff393E46),
          // boxShadow: [
          //   BoxShadow(
          //     blurRadius: 10,
          //     color: _settings.themeLight? Colors.grey[100]! : Colors.blueGrey.shade700,
          //   )
          // ],
        ),),
    ],
  );
}