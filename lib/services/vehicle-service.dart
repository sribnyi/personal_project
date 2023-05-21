// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import '../components/add-refuel-dialog.dart';
// import '../firebase/firestore-controller.dart';
// import '../model/refuel.dart';
// import '../model/vehicle.dart';
// import '../screens/home.dart';
//
// class VehicleService {
//   final _firestoreController = FirestoreController();
//   final defaultVehicle =
//       Vehicle(id: '1', name: 'No Vehicle Selected', initialMileage: 0);
//   late List<Vehicle> vehicles = [];
//   final defaultRefuel = Refuel(
//       id: 'No refuel data available',
//       vehicleId: "No refuel data available",
//       date: DateTime.now(),
//       liters: 0,
//       price: 0,
//       mileage: 0);
//
//   Future<void> showAddRefuelDialog() async {
//     showDialog<void>(
//       context: context,
//       builder: (BuildContext context) {
//         return AddRefuelDialog(
//           onRefuelAdded: (newRefuel) async {
//             newRefuel.vehicleId = dropdownValue!.id!;
//             await _firestoreController.addFuelRecord(newRefuel);
//           },
//         );
//       },
//     );
//   }
//
//   Future<void> _updateVehicles() async {
//     vehicles = await _firestoreController.getAllVehicles();
//   }
//
//   Future<List<Vehicle>> _getAllVehicles() async {
//     return await _firestoreController.getAllVehicles();
//   }
//
//   Future<bool> _vehicleHasRefuels(String id) async {
//     return await _firestoreController.vehicleHasRefuels(id);
//   }
//
//   Future<void> _loadSelectedVehicleId() async {
//     final prefs = await SharedPreferences.getInstance();
//     if (prefs.getString('selectedVehicleId') != null) {
//       selectedVehicleId = prefs.getString('selectedVehicleId')!;
//       if (await _vehicleHasRefuels(selectedVehicleId)) {
//         latestRefuel =
//             await _firestoreController.getLatestRefuel(selectedVehicleId);
//       } else {
//         latestRefuel = defaultRefuel;
//       }
//       _updateVehicles();
//       if (vehicles.isNotEmpty) {
//         dropdownValue =
//             await _firestoreController.getVehicleById(selectedVehicleId);
//       } else {
//         dropdownValue = defaultVehicle;
//       }
//       return Future.value();
//     } else {
//       dropdownValue = defaultVehicle;
//       latestRefuel = defaultRefuel;
//       vehicles.add(defaultVehicle);
//     }
//   }
//
//   Future<void> _saveSelectedVehicleId(String id) async {
//     final prefs = await SharedPreferences.getInstance();
//     prefs.setString('selectedVehicleId', id);
//   }
//
//   Future<Refuel> getLatestRefuel(String vehicleId) async {
//     QuerySnapshot<Map<String, dynamic>> refuelsSnapshot =
//         await FirebaseFirestore.instance
//             .collection('refuels')
//             .where('vehicleId', isEqualTo: vehicleId)
//             .orderBy('date', descending: true)
//             .limit(1)
//             .get();
//     if (refuelsSnapshot.docs.isEmpty) {
//       throw Exception('No refuels found for this vehicle.');
//     }
//     return Refuel.fromFirestore(refuelsSnapshot.docs.first);
//   }
// }
