import 'dart:ui';

import 'package:firebase_auth/firebase_auth.dart';

// import 'package:firebase_auth/firebase_auth.dart';

class Drug {
  String? id;
  String? pharmacyId;
  String? group;
  String? genericName;
  String? brandName;
  double? price;
  bool? inStock;
  String? otherDetails;

  Drug({
    this.id,
    this.pharmacyId,
    this.group,
    this.genericName,
    this.brandName,
    this.price,
    this.inStock,
    this.otherDetails,
  });

  Drug.fromFirestore(Map<String, dynamic> map, String dId) {
    id = dId;
    pharmacyId = map['pharmacyId'];
    group = map['group'];
    genericName = map['genericName'];
    brandName = map['brandName'];
    price = map['price'].toDouble();
    inStock = map['qtyInStock'] ?? true;
    otherDetails = map['otherDetails'];
  }

  Map<String, dynamic> toMap() => {
        'pharmacyId': FirebaseAuth.instance.currentUser!.uid,
        'group': group,
        'genericName': genericName,
        'brandName': brandName,
        'price': price,
        'otherDetails': otherDetails,
      };

  @override
  bool operator ==(other) =>
      other is Drug &&
      pharmacyId == other.pharmacyId &&
      group == other.group &&
      genericName == other.genericName &&
      brandName == other.brandName &&
      price == other.price &&
      inStock == other.inStock &&
      otherDetails == other.otherDetails;

  @override
  int get hashCode => Object.hash(
        pharmacyId,
        group,
        genericName,
        brandName,
        price,
        inStock,
        otherDetails,
      );
}
