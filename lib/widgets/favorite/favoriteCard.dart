import 'package:clicandeats/models/Settings.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../main.dart';

class FavoriteCard extends StatelessWidget {
  final String img;
  final String name;
  final bool isAsset;
  FavoriteCard({required this.name, required this.img, required this.isAsset});
  @override
  Widget build(BuildContext context) {
    var _settings = Provider.of<AppStateManager>(context);
    return GestureDetector(
      onTap: () {},
      child: Container(
       // width: MediaQuery.of(context).size.width * 0.5,
       // height: 134,
        padding: EdgeInsets.all(0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(0),
          color: _settings.themeLight ? Colors.white : darkAccentColor,
          boxShadow: [
            BoxShadow(
              blurRadius: 10,
              color: _settings.themeLight? Colors.grey[100]! : Colors.black26,
            )
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 150,
              width: double.maxFinite,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(0),
                child:isAsset
                    ? Image.asset(
                  img,
                  fit: BoxFit.contain,
                ): Image.network(
                  img,
                  width: MediaQuery.of(context).size.width ,
                  height: MediaQuery.of(context).size.height * 0.2,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            SizedBox(
              height: 5,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 8, right: 8, top: 5, bottom: 10),
              child: Text(
                name,
                style: TextStyle(
                  //fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
