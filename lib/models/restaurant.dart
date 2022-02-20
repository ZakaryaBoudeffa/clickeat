import 'day.dart';

class Restaurant {
  String id;
  String? avatar;
  String? name;
  List<dynamic>? category;
  String? dsc;
  List<Day>? hours;
  String? address;
  String? phone;
  String? email;
  bool? availability;
  // List<String>? tags;

  Restaurant({
    required this.id,
    this.avatar,
    this.address,
    this.category,
    this.dsc,
    this.hours,
    this.name,
    this.email,
    this.phone,
    this.availability
    //this.tags,
  });

  factory Restaurant.fromSnapshot(snap) => Restaurant(
    id: snap.id,
    name: snap['name'],
        avatar: snap['avatar'],
        address: snap['address'],
        category: snap['category'],
        dsc: snap['dsc'],
      availability: snap['availability']
      // hours: List.from(snap['hours']),
      );

  factory Restaurant.fromSnapsho(snap) { return Restaurant(
    id: snap.id,
    name: snap['name'],
    avatar: snap['avatar'],
    address: snap['address'],
    category: snap['category'],
    dsc: snap['dsc'],
      availability: snap['availability']
    // hours: List.from(snap['hours']),
  );}
}
