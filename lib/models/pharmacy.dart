import 'package:cloud_firestore/cloud_firestore.dart';

class Pharmacy {
  String? id;
  String? name;
  String? phone;
  GeoPoint? location;

  Pharmacy({id, this.name, this.phone, this.location});

  Pharmacy.fromFirestore(Map<String, dynamic> map, String aId) {
    id = aId;
    name = map['name'];
    phone = map['phone'];
    location = map['location'];
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'phone': phone,
      'location': location,
      'adminRole': 'pharmacy',
    };
  }

  @override
  bool operator ==(other) =>
      other is Pharmacy &&
      other.id == id &&
      other.name == name &&
      phone == other.phone &&
      location == other.location;

  @override
  int get hashCode => Object.hash(id, name, phone, location);
}
