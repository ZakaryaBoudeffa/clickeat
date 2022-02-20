import 'package:clicandeats/firebaseFirestore/profileOp.dart';
import 'package:clicandeats/main.dart';
import 'package:clicandeats/models/client.dart';
import 'package:clicandeats/pages/editProfile.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class UserInfos extends StatelessWidget {
  String uId;
  UserInfos({required this.uId});
  @override
  Widget build(BuildContext context) {
    //print('CURRENT USER : USER INFOS: $uId');
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(0),
      ),
      child: Column(
        children: [
          FutureBuilder(
              future: FirebaseProfileOp().getMyInfo(uId),
              builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
                if (snapshot.hasData) {
                 // print("USERDATA: ${snapshot.data!.exists}");
                  Client profileInfo = Client.fromSnapshot(snapshot.data);
                  return Column(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(40),
                        child: snapshot.data!.get('avatar') == ""
                            ? Image.asset('assets/man.png', height: 80,)
                            : Image.network(snapshot.data!.get('avatar'), height: 80, width: 80, fit: BoxFit.cover,),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Text(
                        '${snapshot.data!['firstName']} ${snapshot.data!.get('lastName')}',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                         // color: Colors.black,
                        ),
                      ),
                      Text(
                        '${snapshot.data!.get('email')}',
                        style: TextStyle(
                            fontWeight: FontWeight.w500,
                           // color: Colors.black,
                            height: 1.5),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      ElevatedButton(
                        //onPressed:(){},
                        onPressed: () => Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => EditProfile(profileInfo: profileInfo, uId: uId,)),
                        ),
                        child: Text(
                          'Modifier',
                          style: TextStyle(
                           // fontSize: 10,
                            letterSpacing: 0.5,
                            fontWeight: FontWeight.w600,
                            color: Colors.white
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          elevation: 0,
                          padding: EdgeInsets.symmetric(horizontal: 15),
                          primary: Color(0xff767676),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(7)),
                        ),
                      ),
                    ],
                  );
                } else
                  return Text('');
              }),
        ],
      ),
    );
  }
}
