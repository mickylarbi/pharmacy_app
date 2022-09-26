import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class Order {
  String? id;
  String? patientId;
  Map<String, dynamic>? cart;
  String? locationString;
  GeoPoint? locationGeo;
  double? totalPrice;
  OrderStatus? status;
  DateTime? dateTime;
  List<String>? pharmacyIds;

  Order({
    this.id,
    this.patientId,
    this.cart,
    this.locationString,
    this.locationGeo,
    this.totalPrice,
    this.status,
    this.dateTime,
    this.pharmacyIds,
  });

  Order.fromFirestore(Map<String, dynamic> map, String oId) {
    id = oId;
    patientId = map['patientId'];
    cart = map['cart'];
    locationString = map['locationString'];
    locationGeo = map['locationGeo'];
    totalPrice = map['totalPrice'].toDouble();
    status = OrderStatus.values[map['status']];
    dateTime = DateTime.fromMillisecondsSinceEpoch(
        (map['dateTime'] as Timestamp).millisecondsSinceEpoch);
    pharmacyIds = map['pharmacyIds'];
  }

  Map<String, dynamic> toMap() => {
        'patientId': FirebaseAuth.instance.currentUser!.uid,
        'cart': cart,
        'locationString': locationString,
        'locationGeo': GeoPoint(locationGeo!.latitude, locationGeo!.longitude),
        'totalPrice': totalPrice,
        'status': status!.index,
        'dateTime': dateTime,
        'pharmacyIds': pharmacyIds,
      };

  @override
  bool operator ==(other) =>
      other is Order &&
      patientId == other.patientId &&
      cart == other.cart &&
      locationString == other.locationString &&
      locationGeo == other.locationGeo &&
      totalPrice == other.totalPrice &&
      status == other.status &&
      dateTime == other.dateTime &&
      pharmacyIds == other.pharmacyIds;

  @override
  int get hashCode => Object.hash(
        patientId,
        cart,
        locationString,
        locationGeo,
        totalPrice,
        status,
        dateTime,
        Object.hashAll(pharmacyIds!.where((element) => true)),
      );
}

enum OrderStatus { delivered, enroute, pending, canceled }
