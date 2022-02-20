import 'package:clicandeats/models/Settings.dart';
import 'package:clicandeats/models/extras.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../main.dart';

class Option {
  String name;
  double? price;
  bool checked = false;
  Option({
    required this.name,
    this.price,
  });
}

class Additions extends StatefulWidget {
  final Extras extra;
  final String title;
  final List<Map<String, dynamic>>? options;
  final Function(double, int, List<Map<String, dynamic>>) onExtraAmountChanged;
  Additions(
      {required this.extra,
      required this.title,
      required this.options,
      required this.onExtraAmountChanged});

  @override
  _AdditionsState createState() => _AdditionsState();
}

class _AdditionsState extends State<Additions> {
  List<Option> opt = [];

  List<Map<String, dynamic>> selectedExtrasItems = [];
  late int selected;
  @override
  void initState() {
    selected = 0;
    widget.options!.forEach((e) {
      opt.add(Option(
        name: e['name'],
        price: e['price'],
      ));
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var _settings = Provider.of<AppStateManager>(context);
    return Container(
      padding: EdgeInsets.all(0),
      decoration: BoxDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ExpansionTile(
            initiallyExpanded: true,
            title: Text(
              widget.extra.isRequired > 0
                  ? '${widget.title} (Requis)'
                  : '${widget.title} (Facultatif)',
              style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Theme.of(context).primaryColor),
            ),
            subtitle: widget.extra.noOfSelectableExtras > 0
                ? Text(
              widget.extra.noOfSelectableExtras > 1 ? '${widget.extra.noOfSelectableExtras} choix possibles': '${widget.extra.noOfSelectableExtras} choix possible',
                    style: TextStyle(fontSize: 12),
                  )
                : null,
            children: [
              ...opt.map((e) {
                return CheckboxListTile(
                  value: e.checked,
                  onChanged: (bool? value) {


                    if ((widget.extra.isRequired == 0 &&
                            widget.extra.noOfSelectableExtras == 0)) {
                      print("OPTIONAL EXTRAS");
                      setState(() {
                        e.checked = value!;
                        if(e.checked){
                          selectedExtrasItems.add(ExtrasItem(name: e.name,
                              price: e.price,
                              isAvailable: e.checked).toMap());
                          print('${widget.extra.name} SELECTED EXTRA ITEMS '
                              '$selectedExtrasItems');
                        }
                        else {
                          selectedExtrasItems.removeWhere((element) => element.containsValue(e.name));
                          print(selectedExtrasItems);
                         // print('removed: $v');
                        }
                        e.checked ? widget.onExtraAmountChanged(e.price!, selected,
                         selectedExtrasItems)
                            : widget.onExtraAmountChanged(-e.price!,
                          selected, selectedExtrasItems);
                      });
                    } else {
                      print("REQUIRED EXTRAS");
                      if (value == false) {
                        setState(() {
                          e.checked = false;
                          selected--;
                          selectedExtrasItems.removeWhere((element) => element.containsValue(e.name));
                          print(selectedExtrasItems);

                          widget.onExtraAmountChanged(-e.price!, selected,
                              selectedExtrasItems);
                        });
                      } else if (value == true) {
                        if (selected < widget.extra.noOfSelectableExtras)
                          setState(() {
                            selected++;

                              selectedExtrasItems.add(ExtrasItem(name: e
                                  .name,price: e.price,
                                  isAvailable: e.checked).toMap());
                              print('${widget.extra.name} SELECTED EXTRA ITEMS '
                                  '${selectedExtrasItems}');

                            widget.onExtraAmountChanged(e.price!, selected,
                                selectedExtrasItems);
                            e.checked = true;
                          });
                      }
                    }

                    print("Selected : $selected");
                  },
                  controlAffinity: ListTileControlAffinity.leading,
                  title: Text(
                    e.name,
                    style: TextStyle(
                      fontSize: 14,
                      color: _settings.themeLight ?  Theme.of(context).accentColor : Colors.white,
                    ),
                  ),
                  secondary: e.price == null
                      ? null
                      : Text(
                          '+${e.price!.toStringAsFixed(2)}' + ' €',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: _settings.themeLight ?  Theme.of(context).accentColor : Colors.white,
                          ),
                        ),
                  activeColor: Theme.of(context).primaryColor,
                  checkColor: Colors.white,
                );
              }).toList()
            ],
          )
        ],
      ),
    );
  }
}
