import 'package:clicandeats/firebaseFirestore/menuCategoriesOp.dart';
import 'package:clicandeats/main.dart';
import 'package:clicandeats/models/Settings.dart';
import 'package:clicandeats/models/extras.dart';
import 'package:clicandeats/models/menu.dart';
import 'package:clicandeats/models/dish.dart';
import 'package:clicandeats/pages/PlatPage.dart';
import 'package:clicandeats/utils/common.dart';
import 'package:cloud_firestore/cloud_firestore.dart' as firestore;
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:multi_select_flutter/chip_field/multi_select_chip_field.dart';
import 'package:multi_select_flutter/util/multi_select_item.dart';
import 'package:provider/provider.dart';

// class MyModel extends ChangeNotifier{
//   String? value ;
//   Future<String?> fetchData() async {
//     if(value==null){
//       try {
//         final response = await FirebaseMenuCategoriesOp().getCategories("")
//             .toList();
//         print("response response");
//     }
//     catch(e){
//         print('Exception in MyModel $e');
//     }
//     }
//     return value;
//   }
// }
class Menu extends StatefulWidget {
  final String resId;
  final String resName;
  final String uId;

  Menu({required this.uId, required this.resId, required this.resName});

  @override
  State<Menu> createState() => _MenuState();
}

class _MenuState extends State<Menu> {
  List<String> selectedCategoryList = [];
  List<String> categoryList = [];
  @override
  Widget build(BuildContext context) {
    var _settings = Provider.of<AppStateManager>(context);

    return Container(
      color: _settings.themeLight
          ? Colors.white
          : Theme.of(context).scaffoldBackgroundColor,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Menu',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                        // color:
                        //     _settings.themeLight ? Colors.black : Colors.white,
                      ),
                    ),
                  ],
                ),
                // SizedBox(
                //   height: 10,
                // ),

                FutureBuilder<List<String?>>(
                    future:
                        _settings.fetchData(widget.resId, selectedCategoryList),
                    builder: (context, snapshot) {
                      if (snapshot.hasError) {
                        return Center(child: Text('$errorText'));
                      } else if (snapshot.hasData) {
                        if (snapshot.data!.length > 0) {
                          categoryList.clear();
                          snapshot.data!.forEach((element) {
                            categoryList.add(element!);
                          });

                          return MultiSelectChipField<String>(
                            chipColor: Theme.of(context).scaffoldBackgroundColor,
                            textStyle: TextStyle(color: _settings.themeLight ? Theme.of(context).accentColor : Colors.white70),

                            items: categoryList
                                .map((String e) => MultiSelectItem(e, e))
                                .toList(),
                            icon: Icon(Icons.check),
                            onTap: (values) {
                              setState(() {
                                selectedCategoryList = values;
                              });
                            },
                            initialValue: List.from(selectedCategoryList),
                            showHeader: false,
                            headerColor: _settings.themeLight
                                ? Colors.grey[200]
                                : Theme.of(context).scaffoldBackgroundColor,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10)),
                            selectedTextStyle: TextStyle(color: Colors.black),
                            validator: (val) {
                              if (val == [])
                                return "Categori list can not be empty";
                            },
                          );
                        } else
                          return Container();
                      } else
                        return Center(child: Text(''));
                    }),

                StreamBuilder(
                    stream: FirebaseMenuCategoriesOp()
                        .getCategories(widget.resId, selectedCategoryList),
                    builder: (context,
                        AsyncSnapshot<firestore.QuerySnapshot> snapshot) {
                      if (snapshot.hasData) {
                        if (snapshot.data!.size > 0) {
                          return Container(
                            width: MediaQuery.of(context).size.width,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: snapshot.data!.docs.map((e) {
                                List<dynamic> mealIds = e['mealIds'];
                                List<dynamic> meals = e['meals'];
                                List<Map<String, dynamic>> mealsList = [];
                                meals.forEach((element) {
                                  mealsList.add(element);
                                });
                                MenuCategory category = MenuCategory(
                                    name: e['name'],
                                    meals: mealsList,
                                    mealIds: mealIds);
                                return meals.isNotEmpty
                                    ? Container(
                                        height: 250,
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 8),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                '${e['name']}',
                                                style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 14,
                                                  // color: _settings.themeLight
                                                  //     ? Colors.black
                                                  //     : Colors.white,
                                                ),
                                              ),
                                              mealCard(category, _settings),
                                            ],
                                          ),
                                        ),
                                      )
                                    : Container();
                              }).toList(),
                            ),
                          );
                        } else
                          return Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 25, vertical: 45),
                            child: Column(
                              children: [
                                SvgPicture.asset(
                                  'assets/images/res.svg',
                                  height: 100,
                                  width: 100,
                                  // height: width / 3,
                                  // width: width / 3,
                                ),
                                Text(
                                  'vos délicieux plats de votre '
                                  'restaurant arrivent tr ès vite',
                                  style: TextStyle(fontSize: 16),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          );
                      } else if (snapshot.hasError) {
                        return Center(child: Text('$errorText...'));
                      } else
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Center(child: CircularProgressIndicator()),
                        );
                    })
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget mealCard(MenuCategory category, _settings) {
    return Expanded(
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: category.mealIds
            .map(
              (plat) => Padding(
                padding: const EdgeInsets.all(4.0),
                child: FutureBuilder(
                    future: FirebaseMenuCategoriesOp()
                        .getMealDetails(plat, widget.resId),
                    builder: (context,
                        AsyncSnapshot<firestore.DocumentSnapshot> snapshot) {
                      if (snapshot.hasData) {
                        Dish dish = Dish.fromDocumentSnapshot(snapshot.data);
                        //  Extras extras = Extras.fromJson(dish.extras);
                        print('EXTRAS ${dish.extras}');
                        List<Extras> extras = [];
                        extras = dish.extras!
                            .map((i) => Extras.fromJson(i))
                            .toList();

                        return Container(
                          width: MediaQuery.of(context).size.width * 0.5,
                          // height: 180,
                          decoration: BoxDecoration(
                            border: Border.all(color: _settings.themeLight ?  Colors.grey.shade300 : darkAccentColor),
                            borderRadius: BorderRadius.circular(10),
                            color: _settings.themeLight ?  Colors.grey[50] : Theme.of(context).scaffoldBackgroundColor,
                            // boxShadow: [
                            //   BoxShadow(
                            //     blurRadius: 10,
                            //     color: Colors
                            //         .grey
                            //         .shade50,
                            //   )
                            // ],
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: GestureDetector(
                                  onTap: () => dish.isAvailable
                                      ? Navigator.of(context)
                                          .push(MaterialPageRoute(
                                          builder: (context) => PlatePage(
                                            uId: widget.uId,
                                            platId: plat,
                                            plat: dish,
                                            extras: extras.length > 0
                                                ? extras
                                                : null,
                                            onclick: () =>
                                                _settings.changeTab(2),
                                            resId: widget.resId,
                                            resName: widget.resName,
                                          ),
                                        ))
                                      : null,
                                  child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(30),
                                          topRight: Radius.circular(30)),
                                      // boxShadow: [
                                      //   BoxShadow(
                                      //     blurRadius: 10,
                                      //     color: Colors.grey.shade50,
                                      //   )
                                      // ],
                                    ),
                                    child: ClipRRect(
                                        borderRadius: BorderRadius.only(
                                            topLeft: Radius.circular(10),
                                            topRight: Radius.circular(10)),
                                        child: Container(
                                            // color: Theme.of(context)
                                            //     .accentColor
                                            //     .withOpacity(0.3),
                                            child: Image.network(
                                              '${dish.image}',
                                              height: 60,
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.5,
                                              fit: BoxFit.cover,
                                            ))),
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.only(left: 6, right: 12),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Expanded(
                                      child: Text(
                                        '${dish.name}',
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 1,
                                        textAlign: TextAlign.left,
                                        style:  _settings.themeLight ? TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                         color: dish.isAvailable
                                              ? Colors.black
                                              : Theme.of(context).accentColor,
                                        ) : TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                         color: dish.isAvailable
                                              ? Colors.white
                                              : Theme.of(context).accentColor,
                                        ),
                                      ),
                                    ),
                                    Column(
                                      children: [
                                        dish.discountedPrice > 0
                                            ? Text(
                                                '${((dish.price - (dish.price * dish.discountedPrice / 100)).toStringAsFixed(2)).toString()} €',
                                                overflow: TextOverflow.ellipsis,
                                                maxLines: 1,
                                                textAlign: TextAlign.left,
                                                style:_settings.themeLight ? TextStyle(
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.black,
                                                ): TextStyle(
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.white,
                                                ),
                                              )
                                            : Container(),
                                        Text(
                                          '${dish.price} €',
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 1,
                                          textAlign: TextAlign.left,
                                          style: _settings.themeLight ? TextStyle(
                                            decoration: dish.discountedPrice > 0
                                                ? TextDecoration.lineThrough
                                                : TextDecoration.none,
                                            fontStyle: dish.discountedPrice > 0
                                                ? FontStyle.italic
                                                : FontStyle.normal,
                                            fontSize: 12,
                                            fontWeight: FontWeight.bold,
                                            color: dish.discountedPrice > 0
                                                ? Colors.grey
                                                : Colors.black,
                                          ) : TextStyle(
                                            decoration: dish.discountedPrice > 0
                                                ? TextDecoration.lineThrough
                                                : TextDecoration.none,
                                            fontStyle: dish.discountedPrice > 0
                                                ? FontStyle.italic
                                                : FontStyle.normal,
                                            fontSize: 12,
                                            fontWeight: FontWeight.bold,
                                            color: dish.discountedPrice > 0
                                                ? Colors.grey
                                                : Colors.white,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 8),
                                child: Text(
                                  dish.dsc,
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                  textAlign: TextAlign.left,
                                  style: TextStyle(
                                   // color: _settings.themeLight ? Colors.grey.shade700 : Colors.grey.shade300,
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 4,
                              ),
                              dish.isAvailable == true
                                  ? Align(
                                      alignment: Alignment.center,
                                      child: Text(
                                        'En stock',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            color:
                                                Theme.of(context).primaryColor,
                                            fontWeight: FontWeight.bold),
                                      ))
                                  : Align(
                                      alignment: Alignment.center,
                                      child: Text(
                                        'INDISPONIBLE',
                                        style: TextStyle(
                                          color: Theme.of(context).accentColor,
                                        ),
                                      )),
                              SizedBox(
                                height: 3,
                              ),
                            ],
                          ),
                        );
                      }
                      return Container(
                        width: MediaQuery.of(context).size.width * 0.5,
                        // height: 180,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey.shade300),
                          borderRadius: BorderRadius.circular(10),
                          //color: Colors.grey[50],
                          // boxShadow: [
                          //   BoxShadow(
                          //     blurRadius: 10,
                          //     color: Colors.grey.shade50,
                          //   )
                          // ],
                        ),
                      );
                    }),
              ),
            )
            .toList(),
      ),
    );
  }
}
