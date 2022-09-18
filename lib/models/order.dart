import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class Order {
  String? id;
  Map<String, dynamic>? cart;
  String? locationString;
  LatLng? locationGeo;
  double? totalPrice;
  OrderStatus? status;
  bool? confirmDelivery;
  DateTime? dateTime;
  List<String>? pharmacyIds;

  Order({
    this.id,
    this.cart,
    this.pharmacyIds,
    this.locationString,
    this.locationGeo,
    this.totalPrice,
    this.status,
    this.confirmDelivery,
    this.dateTime,
  });

  Order.fromFirestore(Map<String, dynamic> map, String oId) {
    id = oId;
    cart = map['cart'];
    locationString = map['locationString'];
    locationGeo =
        LatLng(map['locationGeo'].latitude, map['locationGeo'].latitude);
    totalPrice = map['totalPrice'].toDouble();
    status = OrderStatus.values[map['status']];
    confirmDelivery = map['confirmDelivery'];
    dateTime = DateTime.fromMillisecondsSinceEpoch(
        (map['dateTime'] as Timestamp).millisecondsSinceEpoch);
  }

  Map<String, dynamic> toMap() => {
        'patientId': FirebaseAuth.instance.currentUser!.uid,
        'cart': cart,
        'pharmacyIds': pharmacyIds,
        'locationString': locationString,
        'locationGeo': GeoPoint(locationGeo!.latitude, locationGeo!.longitude),
        'totalPrice': totalPrice,
        'status': status!.index,
        'confirmDelivery': confirmDelivery,
        'dateTime': dateTime,
      };

  @override
  bool operator ==(other) =>
      other is Order &&
      cart == other.cart &&
      pharmacyIds == other.pharmacyIds &&
      locationString == other.locationString &&
      locationGeo == other.locationGeo &&
      totalPrice == other.totalPrice &&
      status == other.status &&
      dateTime == other.dateTime &&
      confirmDelivery == other.confirmDelivery;

  @override
  int get hashCode => hashValues(
        cart,
        hashList(pharmacyIds),
        locationString,
        locationGeo,
        totalPrice,
        status,
        confirmDelivery,
        dateTime,
      );
}

enum OrderStatus { delivered, enroute, pending, canceled }