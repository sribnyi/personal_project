import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:personal_project/firebase/persistence-controller.dart';

import '../model/refuel.dart';
import '../model/vehicle.dart';

class FirestoreController extends PersistenceController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Future<List<Vehicle>> getAllVehicles() async {
    var snapshot = await _firestore.collection('vehicles').get();
    return snapshot.docs
        .map((doc) => Vehicle.fromFirestore(doc))
        .toList();

  }

  @override
  Future<String> saveVehicle(Vehicle vehicle) async {
    DocumentReference ref =
    await _firestore.collection('vehicles').add(vehicle.toFirestore());
    return ref.id;
  }

  @override
  Future<List<Refuel>> getRefuels() async {
    var snapshot = await _firestore.collection('refuels').get();
    return snapshot.docs
        .map((doc) => Refuel.fromFirestore(doc))
        .toList();
  }

  @override
  Future<void> addFuelRecord(Refuel refuel) async {
    await _firestore.collection('refuels').add(refuel.toFirestore());
  }

  @override
  Future<void> updateVehicleMileage(String vehicleId, int newMileage) async {
    await _firestore.collection('vehicles').doc(vehicleId).update({
      'mileage': newMileage,
    });
  }
  @override
  Future<Refuel> getLatestRefuel(String vehicleId) async {
    final QuerySnapshot<Map<String, dynamic>> refuelsSnapshot =
    await _firestore
        .collection('refuels')
        .where('vehicleId', isEqualTo: vehicleId)
        .orderBy('date', descending: true)
        .limit(1)
        .get();

    if (refuelsSnapshot.docs.isEmpty) {
      throw Exception('No refuels found for this vehicle.');
    }

    return Refuel.fromFirestore(refuelsSnapshot.docs.first);
  }


}
