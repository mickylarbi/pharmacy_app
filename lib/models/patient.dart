import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';

class Patient {
  String? id;
  String? firstName;
  String? surname;
  String? phone;

  Patient({
    this.id,
    this.firstName,
    this.surname,
    this.phone,
  });

  Patient.fromFirestore(Map<String, dynamic> map, String pId) {
    id = pId;
    firstName = map['firstName'] as String?;
    surname = map['surname'] as String?;
    phone = map['phone'] as String?;
  }

  Map<String, dynamic> toFirestore() => {
        'firstName': firstName,
        'surname': surname,
        'phone': phone,
      };

  String get name => '$firstName $surname';

  @override
  bool operator ==(other) =>
      other is Patient &&
      firstName == other.firstName &&
      surname == other.surname &&
      phone == other.phone;

  @override
  int get hashCode => hashValues(
        firstName,
        surname,
        phone,
      );
}
