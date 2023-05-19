import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:personal_project/firebase/persistence-controller.dart';
import 'package:personal_project/model/vehicle.dart';

import '../model/refuel.dart';

class FirestoreController extends PersistenceController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Future<List<Vehicle>> getAllVehicles() async {
    var snapshot = await _firestore.collection('vehicles').get();
    return snapshot.docs
        .map((doc) => Vehicle.fromFirestore(doc.data()))
        .toList();
  }

  @override
  Future<String> saveVehicle(Vehicle vehicle) async {
    DocumentReference ref = await _firestore.collection('vehicles').add(vehicle.toFirestore());
    return ref.id;
  }

  @override
  Future<List<Refuel>> getRefuels() async {
    var snapshot = await _firestore.collection('refuels').get();
    return snapshot.docs
        .map((doc) => Refuel.fromFirestore(doc.data()))
        .toList();
  }

  @override
  Future<void> saveRefuel(Refuel refuel) async {
    await _firestore
        .collection('refuels')
        .doc(refuel.id)
        .set(refuel.toFirestore());
  }
}
