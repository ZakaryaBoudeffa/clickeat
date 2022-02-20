import 'package:clicandeats/firebaseFirestore/associationsOp.dart';
import 'package:clicandeats/main.dart';
import 'package:clicandeats/models/Settings.dart';
import 'package:clicandeats/pages/DonationPage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DonatedMoney extends StatelessWidget {
  final String uId;
  DonatedMoney({required this.uId});
  @override
  Widget build(BuildContext context) {
    var _settings = Provider.of<AppStateManager>(context);
    return StreamBuilder<DocumentSnapshot>(
        stream: FirebaseAssociationOp().getMyAssociationsStream(uId),
        builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          if (snapshot.hasData) {
            var donatedAmount = 0.0;
            List<String> _assoc = [];
            DocumentSnapshot<Object?>? s = snapshot.data;
            // print("Donated Amount: ${s!.data().toString().contains('donatedAmount')}");
            if (s!.data().toString().contains('donatedAmount')) {
              donatedAmount = s.get('donatedAmount');
            }
            if (s.data().toString().contains('associations')) {
              if (s.get('associations').toString() != '{}')
                _assoc = List.from(s.get('associations'));
            }
            if (_assoc.length > 0)
              return GestureDetector(
                onTap: () => _showDonations(context, donatedAmount, _assoc),
                child: Stack(
                  alignment: Alignment.centerLeft,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 35.0),
                      child: Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 15, vertical: 3),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: _settings.themeLight ? Colors.white : Color(0xff393E46),
                          boxShadow: [
                            BoxShadow(
                              blurRadius: 10,
                              color: _settings.themeLight ? Colors.grey[300]! : Color(0xff393E46),
                            )
                          ],
                        ),
                        child: Text(
                          '${donatedAmount.toStringAsFixed(2)}€',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                            color:_settings.themeLight ? Theme.of(context).accentColor : Colors.white,
                          ),
                        ),
                      ),
                    ),
                    _assoc.length > 0
                        ? Padding(
                            padding: const EdgeInsets.only(left: 15.0),
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(30),
                                border: Border.all(color: _settings.themeLight ? Colors.white : Color(0xff393E46)),
                                color: Colors.white,
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(30),
                                child: Image.asset(
                                  "assets/images/associations/${_assoc[0]}.png",
                                  height: 30,
                                  width: 30,
                                ),
                              ),
                            ),
                          )
                        : Container(),
                    _assoc.length > 0
                        ? Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(30),
                              border: Border.all(color: _settings.themeLight ? Colors.white : Color(0xff393E46)),
                              color: Colors.white,
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(30),
                              child: Image.asset(
                                "assets/images/associations/${_assoc[1]}.png",
                                height: 30,
                                width: 30,
                              ),
                            ),
                          )
                        : Container()
                  ],
                ),
              );
            else
              return GestureDetector(
                onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => DonationPage(uId: uId))),
                child: Stack(
                  alignment: Alignment.centerLeft,
                  children: [
                    Container(
                      width: 120,
                      alignment: Alignment.center,
                      padding:
                          EdgeInsets.symmetric(horizontal: 5, vertical: 6),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: _settings.themeLight ? Colors.white : Color(0xff393E46),
                        boxShadow: [
                          BoxShadow(
                            blurRadius: 10,
                            color: _settings.themeLight ? Colors.grey[300]! : Color(0xff393E46),
                          )
                        ],
                      ),
                      child: Text(
                        'sélectionner des\nassociations',
                        softWrap: true,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 11,
                          color: Theme.of(context).accentColor,
                        ),
                      ),
                    ),
                  ],
                ),
              );
          } else
            return Container();
        });
  }

  _showDonations(context, double donatedAmount, assoc) {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(30.0))),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              IconButton(
                icon: Icon(
                  Icons.close,
                  color: Theme.of(context).accentColor,
                ),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ],
          ),
          content: SingleChildScrollView(
            child: Column(
              children: [
                Center(
                  child: Image.asset(
                    'assets/images/donations.png',
                    height: 150,
                    width: 300,
                  ),
                ),
                SizedBox(
                  height: 30,
                ),
                Text(
                  'Dons totaux',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Text(
                  '${donatedAmount.toStringAsFixed(2)}€',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                assoc.length > 0
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            width: 40,
                            height: 40,
                            color: Color(0xffe6e4fa),
                            child: Image.asset(
                              'assets/images/associations/${assoc[0]}.png',
                              width: 30,
                              height: 30,
                            ),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Container(
                            width: 40,
                            height: 40,
                            color: Color(0xffe6e4fa),
                            child: Image.asset(
                              "assets/images/associations/${assoc[1]}.png",
                              width: 30,
                              height: 30,
                            ),
                          ),
                        ],
                      )
                    : Container(),
                SizedBox(
                  height: 20,
                ),
                SizedBox(
                  width: double.infinity,
                  child: MaterialButton(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(7),
                        side:
                            BorderSide(color: Theme.of(context).primaryColor)),
                    onPressed: () {
                      Navigator.pop(context);
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => DonationPage(
                                    myAssoc: assoc,
                                    uId: uId,
                                  )));
                      // Navigator.popAndPushNamed(context, '/soutenir');
                    },
                    child: Text(
                      'Changer les associations',
                      style: TextStyle(
                        fontSize: 13,
                        //fontWeight: FontWeight.w900,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
