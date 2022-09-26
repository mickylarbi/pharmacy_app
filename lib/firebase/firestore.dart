import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:pharmacy_app/models/drug.dart';
import 'package:pharmacy_app/models/order.dart';
import 'package:pharmacy_app/models/patient.dart';
import 'package:pharmacy_app/models/pharmacy.dart';

class FirestoreService {
  FirebaseAuth auth = FirebaseAuth.instance;

  FirebaseFirestore instance = FirebaseFirestore.instance;

  // PATIENT

  DocumentReference<Map<String, dynamic>> patientDocument([String? id]) =>
      instance.collection('patients').doc(id ?? auth.currentUser!.uid);

  Future<void> addPatient(Patient patient) =>
      patientDocument().set(patient.toFirestore());

  Future<void> updatePatient(Patient patient) =>
      patientDocument().update(patient.toFirestore());

  Future<void> deletePatient() => patientDocument().delete();

  // ADMIN

  CollectionReference<Map<String, dynamic>> get adminsCollection =>
      instance.collection('admins');

  Query<Map<String, dynamic>> get pharmaciesCollection =>
      adminsCollection.where('adminRole', isEqualTo: 'pharmacy');

  DocumentReference<Map<String, dynamic>> pharmacyDocument([String? id]) =>
      adminsCollection.doc(id ?? auth.currentUser!.uid);

  Future<void> addAdmin(Pharmacy admin) =>
      pharmacyDocument().set(admin.toMap());

  Future<void> updateAdmin(Pharmacy admin) =>
      pharmacyDocument().update(admin.toMap());

  // PHARMACY

  CollectionReference<Map<String, dynamic>> get drugsCollection =>
      instance.collection('drugs');

  Query<Map<String, dynamic>> get myDrugs =>
      drugsCollection.where('pharmacyId', isEqualTo: auth.currentUser!.uid);

  DocumentReference<Map<String, dynamic>> drugDocument(String id) =>
      drugsCollection.doc(id);

  Future<DocumentReference<Map<String, dynamic>>> addDrug(Drug drug) =>
      drugsCollection.add(drug.toMap());
      
  Future<void> updateDrug(Drug drug) =>
      drugsCollection.doc(drug.id).update(drug.toMap());
      
  Future<void> deleteDrug(String drugId) =>
      drugsCollection.doc(drugId).delete();

  CollectionReference<Map<String, dynamic>> get orderCollection =>
      instance.collection('orders');

  DocumentReference<Map<String, dynamic>> orderDocument(String id) =>
      orderCollection.doc(id);

  Query<Map<String, dynamic>> get myOrders => orderCollection.where('patientId',
      isEqualTo: FirebaseAuth.instance.currentUser!.uid);

  Future<DocumentReference<Map<String, dynamic>>> addOrder(Order order) =>
      orderCollection.add(order.toMap());
}
