import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:pharmacy_app/models/order.dart';
import 'package:pharmacy_app/models/patient.dart';

class FirestoreService {
  FirebaseAuth auth = FirebaseAuth.instance;

  FirebaseFirestore instance = FirebaseFirestore.instance;

  // PATIENT

  DocumentReference<Map<String, dynamic>> get patientDocument =>
      instance.collection('patients').doc(auth.currentUser!.uid);

  Future<void> addPatient(Patient patient) =>
      patientDocument.set(patient.toFirestore());

  Future<void> updatePatient(Patient patient) =>
      patientDocument.update(patient.toFirestore());

  Future<void> deletePatient() => patientDocument.delete();

  // ADMIN

  CollectionReference<Map<String, dynamic>> get adminsCollection =>
      instance.collection('admins');

  // PHARMACY

  CollectionReference<Map<String, dynamic>> get drugsCollection =>
      instance.collection('drugs');

  DocumentReference<Map<String, dynamic>> drugDocument(String id) =>
      drugsCollection.doc(id);

  CollectionReference<Map<String, dynamic>> get orderCollection =>
      instance.collection('orders');

  DocumentReference<Map<String, dynamic>> orderDocument(String id) =>
      orderCollection.doc(id);

  Query<Map<String, dynamic>> get myOrders => orderCollection.where('patientId',
      isEqualTo: FirebaseAuth.instance.currentUser!.uid);

  Future<DocumentReference<Map<String, dynamic>>> addOrder(Order order) =>
      orderCollection.add(order.toMap());
}
