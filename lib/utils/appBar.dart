import 'package:clicandeats/models/Settings.dart';
import 'package:clicandeats/pages/FavoritePage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MyAppBar extends StatelessWidget implements PreferredSizeWidget {
  Size get preferredSize => new Size.fromHeight(kToolbarHeight);
  final dynamic title;
  final bool back;
  final String uId;
  MyAppBar({this.title, required this.back, required this.uId});

  @override
  Widget build(BuildContext context) {
    var _settings = Provider.of<AppStateManager>(context);
    return AppBar(
      titleTextStyle: TextStyle(color: Colors.black, fontSize: 16),
      title: title is String
          ? Text(
              title,
              style: TextStyle(fontSize: 16, color: _settings.themeLight ? Colors.black : Colors.white),
            )
          : title,
      leading: back
          ? IconButton(
              icon: Icon(
                Icons.arrow_back,
                //size: 40,
              ),
              onPressed: () => Navigator.of(context).pop(),
            )
          : Builder(builder: (BuildContext context) {
              return IconButton(
                  icon: Icon(
                    Icons.menu_rounded,
                    size: 35,
                  ),
                  onPressed: () {
                    Scaffold.of(context).openDrawer();
                  });
            }),
      actions: [
        IconButton(
          icon:
              Icon(CupertinoIcons.heart, color: Theme.of(context).primaryColor),
          onPressed: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => FavoritePage(uId: uId)),
          ),
        ),
      ],
    );
  }
}



