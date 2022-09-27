import 'package:firebase_auth/firebase_auth.dart';

class Drug {
  String? id;
  String? pharmacyId;
  String? group;
  String? genericName;
  String? brandName;
  double? price;
  int? quantityInStock;
  String? otherDetails;

  Drug({
    this.id,
    this.pharmacyId,
    this.group,
    this.genericName,
    this.brandName,
    this.price,
    this.quantityInStock,
    this.otherDetails,
  });

  Drug.fromFirestore(Map<String, dynamic> map, String dId) {
    id = dId;
    pharmacyId = map['pharmacyId'];
    group = map['group'];
    genericName = map['genericName'];
    brandName = map['brandName'];
    price = map['price'].toDouble();
    quantityInStock = map['quantityInStock'].toInt();
    otherDetails = map['otherDetails'];
  }

  Map<String, dynamic> toMap() => {
        'pharmacyId': FirebaseAuth.instance.currentUser!.uid,
        'group': group,
        'genericName': genericName,
        'brandName': brandName,
        'price': price,
        'quantityInStock': quantityInStock,
        'otherDetails': otherDetails,
  };

  @override
  bool operator ==(other) =>
      other is Drug &&
      group == other.group &&
      genericName == other.genericName &&
      brandName == other.brandName &&
      price == other.price &&
      quantityInStock == other.quantityInStock &&
      otherDetails == other.otherDetails;

  @override
  int get hashCode => Object.hash(
        group,
        genericName,
        brandName,
        price,
        quantityInStock,
        otherDetails,
      );
}

