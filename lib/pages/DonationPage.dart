import 'package:clicandeats/firebaseFirestore/associationsOp.dart';
import 'package:clicandeats/main.dart';
import 'package:clicandeats/models/Settings.dart';
import 'package:clicandeats/pages/HomePage.dart';
import 'package:clicandeats/utils/appBar.dart';
import 'package:clicandeats/utils/common.dart';
import 'package:clicandeats/widgets/drawer/myDrawer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Association {
  String id;
  String name;
  String img;
  String dsc;
  Association({required this.id, required this.dsc,required this.img,required this.name});

  factory Association.fromSnapshot(snap) => Association(
    id: snap.id,
    name: snap['name'],
    img: snap['img'],
    dsc: snap['dsc'],
  );
}

class DonationPage extends StatefulWidget {
  final List<String>? myAssoc ;
  final String uId;
  DonationPage({this.myAssoc, required this.uId});
  @override
  _DonationPageState createState() => _DonationPageState();
}

class _DonationPageState extends State<DonationPage> {
  List<String> _selectedAssoc = [];


  @override
  void initState() {
    if(widget.myAssoc != null){
      _selectedAssoc = widget.myAssoc!;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var _settings = Provider.of<AppStateManager>(context);
    return Scaffold(
      appBar: MyAppBar(
        title: 'Soutenir',
        back: true,
        uId: widget.uId,
      ),
      drawer: MyDrawer(),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          //padding: const EdgeInsets.all(20.0),
          children: [
            Center(
              child: Text(
                'Choisissez deux associaitons qui vous tiennent au coeur',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                 // color: Colors.black,
                ),
              ),
            ),
            Center(
              child: Text(
                'Les dons seront versé par Clic&eats',
                textAlign: TextAlign.center,
                style: TextStyle(
                 // fontWeight: FontWeight.bold,
                  fontSize: 12,
                  color: Colors.green.shade700,
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Expanded(
              child: StreamBuilder(
                  stream: FirebaseAssociationOp().getAllAssociations(),
                  builder: (context, AsyncSnapshot<QuerySnapshot> snapshot){
                    if (!snapshot.hasData)
                      return Center(child: Text('$loadingText...')); //loading
                    else if (snapshot.hasError)
                      return Center(child: Text('Une erreur s\'est produite!')); //An error occurred
                    else {
                      if(snapshot.data!.size > 0)
                      {
                        return ListView(
                          physics: BouncingScrollPhysics(),
                          children: snapshot.data!.docs.map((DocumentSnapshot e) {
                            Association association = Association.fromSnapshot(e);

                            return Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Container(
                                padding: const EdgeInsets.all(20.0),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: _settings.themeLight ? Colors.white : darkAccentColor,
                                  // boxShadow: [
                                  //   BoxShadow(
                                  //     blurRadius: 10,
                                  //     color: Colors.grey[100]!,
                                  //   )
                                  // ],
                                ),
                                child: ListTile(
                                  contentPadding: EdgeInsets.all(0),
                                  leading: Container(
                                    width: 60,
                                    height: 60,
                                   // color: Color(0xffe6e4fa),
                                    child: Image.network(
                                      association.img,
                                      width: 50,
                                      height: 50,
                                    ),
                                  ),
                                  title: Text(
                                    association.name,
                                    style: TextStyle(
                                      fontWeight: FontWeight.w700,
                                      fontSize: 14,
                                      color: _settings.themeLight ? Colors.black : Colors.white,
                                    ),
                                  ),
                                  subtitle: Text(association.dsc, style: TextStyle(color:  _settings.themeLight ? Colors.black54 : Colors.white60),),
                                  trailing: Column(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      InkWell(
                                        onTap: () {
                                          setState(() {
                                            print(association.name.toString());
                                            if (_selectedAssoc.contains(association.id)) {
                                              _selectedAssoc.remove(association.id);
                                            } else
                                            {
                                              if(_selectedAssoc.length == 2)
                                              {
                                                final snackBar = SnackBar(
                                                    backgroundColor: Colors.red.shade700,
                                                    content: Text(
                                                        'Seules 2 associations peuvent être sélectionnées à la fois')); //An error occurred. Card not added
                                                ScaffoldMessenger.of(context)
                                                    .showSnackBar(snackBar);
                                              }
                                              else
                                                _selectedAssoc.add(association.id);
                                            }
                                          });
                                        },
                                        child: Container(
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(30),
                                            color: _settings.themeLight ? Colors.white : darkAccentColor,
                                            boxShadow: [
                                              BoxShadow(
                                                blurRadius: 10,
                                                color: _settings.themeLight ? Colors.grey[300]!  : Colors.black54,
                                              )
                                            ],
                                          ),
                                          child: CircleAvatar(
                                            backgroundColor: _settings.themeLight ? Colors.white : darkAccentColor,
                                            radius: 15,
                                            child: Icon(
                                              Icons.check,
                                              color: _selectedAssoc.contains(association.id)
                                                  ? Theme.of(context).primaryColor
                                                  : Theme.of(context).accentColor,
                                              size: 20,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          }).toList(),
                        );
                      }
                      else return Center(child: Text('Ajouter une nouvelle catégorie'),); //Add new category
                    }
                  }),
            ),

            SizedBox(
              height: 10,
            ),
            _selectedAssoc.length < 2 ? Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text('2 associations requises', style: TextStyle(color: Colors.red.shade600),),
            ) : Container(),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: SizedBox(
                width: double.infinity,
                child: MaterialButton(
                  height: 45,

                  enableFeedback: false,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  color: _selectedAssoc.length < 2 ? Colors.grey : Theme.of(context).primaryColor,
                  onPressed: () async {
                    if(_selectedAssoc.length == 2) {
                      await FirebaseAssociationOp().addAssociations(widget.uId, _selectedAssoc);
                      // Navigator.of(context)
                      //     .pushAndRemoveUntil(MaterialPageRoute(builder: (context) => HomePage(uId: widget.uId)), (route) => false);

                      Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
                    }
                  },
                  child: Text(
                    'Enregistrer',
                    style: TextStyle(
                      fontSize: 15,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                ),
              ),
            ),
            SizedBox(
              height: 10,
            ),
          ],
        ),
      ),
    );
  }
}
