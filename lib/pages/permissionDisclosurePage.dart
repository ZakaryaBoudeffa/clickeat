
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

import '../main.dart';
// import 'package:geolocator/geolocator.dart';

class PermissionsGranted {
  //bool cameraPermissionGranted;
  bool locationPermissionGranted;
  //bool storagePermissionGranted;

  PermissionsGranted(
      {
        //required this.cameraPermissionGranted,
     // required this.storagePermissionGranted,
      required this.locationPermissionGranted});
}

class PermissionDisclosurePage extends StatefulWidget {
  const PermissionDisclosurePage({Key? key}) : super(key: key);

  @override
  State<PermissionDisclosurePage> createState() =>
      _PermissionDisclosurePageState();
}

class _PermissionDisclosurePageState extends State<PermissionDisclosurePage> {
  bool cameraPermissionGranted = false;

  bool locationPermissionGranted = false;

  bool storagePermissionGranted = false;

  bool permissionsGranted = true;

  Future<PermissionsGranted> checkPermissions() async {
   // cameraPermissionGranted = await Permission.camera.isGranted;
    locationPermissionGranted = await Permission.location.isGranted;
    //storagePermissionGranted = await Permission.storage.isGranted;
    PermissionsGranted p = PermissionsGranted(
       // cameraPermissionGranted: cameraPermissionGranted,
        //storagePermissionGranted: storagePermissionGranted,
        locationPermissionGranted: locationPermissionGranted);
    // if (cameraPermissionGranted &&
    //     locationPermissionGranted &&
    //     storagePermissionGranted)
    //print("checkPermissions: $locationPermissionGranted, $storagePermissionGranted, $cameraPermissionGranted");
    //  else
    print(
        "checkPermissions: $locationPermissionGranted, $storagePermissionGranted, $cameraPermissionGranted");

    return p;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(0.0),
          child: FutureBuilder<PermissionsGranted>(
            future: checkPermissions(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(height: 50),
                    Image.asset(
                      'assets/images/logo.png',
                      height: 100,
                    ),
                    SizedBox(height: 20),
                    Text(
                      'Permissions disclosure page',
                      style: Theme.of(context).textTheme.headline5,
                    ),
                    Expanded(flex: 1, child: Container()),
                    SizedBox(height: 40),
                    // Icon(Icons.location_pin),
                    SizedBox(height: 20),
                    !snapshot.data!.locationPermissionGranted
                        ? ListTile(
                            leading: Icon(Icons.location_pin),
                            title: Text(
                              'Clic&Eats restaurant requires location permission to enable identification of nearby carriers when order is placed',
                              textAlign: TextAlign.left,
                            ),
                            subtitle: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                MaterialButton(
                                  color: Colors.grey,
                                  onPressed: () async {
                                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                        content: Text('Location Permission required')));
                                    //Navigator.pop(context);
                                  },
                                  child: Text(
                                    'Deny',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                                SizedBox(
                                  width: 20,
                                ),
                                MaterialButton(
                                  color: Theme.of(context).primaryColor,
                                  onPressed: () async {
                                    //open runtime permission
                                    await Permission.location.status
                                        .then((value) => print(value));
                                    await Permission.location.status.isDenied.then(
                                        (value) async => await Permission.location
                                                .request()
                                                .then((value) async {
                                              await checkPermissions()
                                                  .then((value) {
                                                setState(() {});
                                                if (
                                                //value.storagePermissionGranted &&
                                                    //value.cameraPermissionGranted &&
                                                    value
                                                        .locationPermissionGranted)
                                                  Navigator.pushReplacement(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (context) =>
                                                              LandingPage()));
                                                else {
                                                  print(
                                                      "not all permissions granted");
                                                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                                      content: Text('Location Permission required')));
                                                }
                                              });
                                            }));
                                    // Permission.location.status.isGranted.then((value) async {
                                    //
                                    // });
                                    //Permission.location.request();
                                  },
                                  child: Text('Accept',
                                      style: TextStyle(color: Colors.white)),
                                ),
                              ],
                            ),
                          )
                        : Container(),
                    SizedBox(height: 20),
                    // !snapshot.data!.storagePermissionGranted
                    //     ? ListTile(
                    //         leading: Icon(Icons.folder),
                    //         title: Text(
                    //           'Clic&Eats restaurant requires storage permission to enable user to upload pictures of menu items',
                    //           textAlign: TextAlign.left,
                    //         ),
                    //         subtitle: Row(
                    //           mainAxisAlignment: MainAxisAlignment.center,
                    //           children: [
                    //             MaterialButton(
                    //               color: Colors.grey,
                    //               onPressed: () async {
                    //                 //Navigator.pop(context);
                    //               },
                    //               child: Text(
                    //                 'Deny',
                    //                 style: TextStyle(color: Colors.white),
                    //               ),
                    //             ),
                    //             SizedBox(
                    //               width: 20,
                    //             ),
                    //             MaterialButton(
                    //               color: Theme.of(context).primaryColor,
                    //               onPressed: () async {
                    //                 //open runtime permission
                    //                 Permission.storage.status
                    //                     .then((value) => print(value));
                    //                 await Permission.storage.status.isDenied
                    //                     .then((value) =>
                    //                         Permission.storage.request());
                    //                 await Permission.storage.status.isGranted
                    //                     .then((value) async {
                    //                   await checkPermissions().then((value) {
                    //                     setState(() {});
                    //                     if (value.storagePermissionGranted &&
                    //                         value.cameraPermissionGranted &&
                    //                         value.locationPermissionGranted)
                    //                       Navigator.pushReplacement(
                    //                           context,
                    //                           MaterialPageRoute(
                    //                               builder: (context) =>
                    //                                   LandingPage()));
                    //                     else
                    //                       print("not all permissions granted");
                    //                   });
                    //                 });
                    //
                    //                 //Permission.location.request();
                    //               },
                    //               child: Text('Accept',
                    //                   style: TextStyle(color: Colors.white)),
                    //             ),
                    //           ],
                    //         ),
                    //       )
                    //     : Container(),
                    // SizedBox(height: 20),
                    // !snapshot.data!.cameraPermissionGranted
                    //     ? ListTile(
                    //         leading: Icon(Icons.camera_alt),
                    //         title: Text(
                    //           'Clic&Eats restaurant requires camera permission to enable user to capture pictures of menu items',
                    //           textAlign: TextAlign.left,
                    //         ),
                    //         subtitle: Row(
                    //           mainAxisAlignment: MainAxisAlignment.center,
                    //           children: [
                    //             MaterialButton(
                    //               color: Colors.grey,
                    //               onPressed: () async {
                    //                 //Navigator.pop(context);
                    //               },
                    //               child: Text(
                    //                 'Deny',
                    //                 style: TextStyle(color: Colors.white),
                    //               ),
                    //             ),
                    //             SizedBox(
                    //               width: 20,
                    //             ),
                    //             MaterialButton(
                    //               color: Theme.of(context).primaryColor,
                    //               onPressed: () async {
                    //                 //open runtime permission
                    //                 await Permission.camera.status
                    //                     .then((value) => print(value));
                    //                 await Permission.camera.status.isDenied.then(
                    //                     (value) => Permission.camera.request());
                    //                 await Permission.camera.status.isGranted
                    //                     .then((value) async {
                    //                   await checkPermissions().then((value) {
                    //                     setState(() {
                    //
                    //                     });
                    //                     if (value.storagePermissionGranted &&
                    //                         value.cameraPermissionGranted &&
                    //                         value.locationPermissionGranted)
                    //                       Navigator.pushReplacement(
                    //                           context,
                    //                           MaterialPageRoute(
                    //                               builder: (context) =>
                    //                                   LandingPage()));
                    //                     else
                    //                       print("not all permissions granted");
                    //                   });
                    //
                    //                 });
                    //
                    //                 //Permission.location.request();
                    //               },
                    //               child: Text(
                    //                 'Accept',
                    //                 style: TextStyle(color: Colors.white),
                    //               ),
                    //             ),
                    //           ],
                    //         ),
                    //       )
                    //     : Container(),
                    Expanded(flex: 2, child: Container()),
                  ],
                );
              } else
                return Text('Checking permissions. Please wait...');
            },
          ),
        ),
      ),
    );
  }
}
