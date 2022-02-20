import 'package:clicandeats/firebaseFirestore/menuCategoriesOp.dart';
import 'package:flutter/material.dart';

class AppStateManager extends ChangeNotifier {
  int _currentTab = 0;
  bool _loggedIn = false;
  bool themeLight = true;

  int get currentTab => _currentTab;
  bool get isLoggedIn => _loggedIn;

  void changeTab(int index) {
    _currentTab = index;
    notifyListeners();
  }

  void switchTheme(bool val){
    themeLight = val;
    notifyListeners();
  }

  void login(bool val) {
    _loggedIn = val;
    notifyListeners();
  }
  void logout() {
    _loggedIn = false;
    notifyListeners();
  }


  Future<List<String?>> fetchData(String resId, List<String> filter) async {
    List<String> cat = [];

    try {
      print("fetching menu categories");
      await FirebaseMenuCategoriesOp()
          .getCategories(resId, filter)
          .first
          .then((value) {
        value.docs.forEach((element) {
          cat.add(element.get('name'));
        });
      });
      print("response menu categories ${cat.length}");
    } catch (e) {
      print('Exception in fetching menu categories  $e');
    }

    return cat;
  }
}
