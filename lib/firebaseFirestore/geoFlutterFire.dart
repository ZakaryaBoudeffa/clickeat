// import 'package:geocoder/geocoder.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geoflutterfire/geoflutterfire.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:geolocator/geolocator.dart';

class FlutterFireOpGeo {
// Init firestore and geoFlutterFire
  final geo = Geoflutterfire();
  final _firestore = FirebaseFirestore.instance;

  Future<GeoFirePoint> convertAddressToCoordinates(String address) async {
    print(" convertAddressToCoordinates ADDRESS: ${address}");
    var addresses;
    List<Location> locations = [];
    GeoFirePoint point = geo.point(latitude: 0.0, longitude: 0.0);
    try {

      //addresses = await Geocoder.local.findAddressesFromQuery(address);
     // print("address result length: ${addresses.length} "
     //      "${addresses.first.postalCode} "
     //      "${addresses.first.addressLine} ${addresses.first.featureName}");
      locations = await locationFromAddress(address);
     point = geo.point(
          latitude: locations.first.latitude,
          longitude: locations.first.longitude);
    }

    catch (e) {
      print("EXCEPTION IN FIND ADDESS $e");
    }
    print(
        'GEOCODING::: latitude: ${point.latitude}, longitude: ${point.longitude}');
    return point;
  }

  double calculateDistance(GeoFirePoint source, GeoFirePoint destination) {
    return source.distance(
        lat: destination.latitude, lng: destination.longitude);
  }
}
