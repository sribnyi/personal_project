// import 'package:carbon_icons/carbon_icons.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
//
// import '../firebase/firestore-controller.dart';
// import '../model/vehicle.dart';
//
// class VehicleDropdown extends StatefulWidget {
//   final Function(Vehicle) onVehicleSelected;
//   final Function() onAddVehicle;
//
//   VehicleDropdown({
//     required this.onVehicleSelected,
//     required this.onAddVehicle,
//     Key? key,
//   }) : super(key: key);
//
//   @override
//   _VehicleDropdownState createState() => _VehicleDropdownState();
// }
//
// class _VehicleDropdownState extends State<VehicleDropdown> {
//   final _firestoreController = FirestoreController();
//   List<Vehicle> vehicles = [];
//   Vehicle? dropdownValue;
//
//   @override
//   Widget build(BuildContext context) {
//     return FutureBuilder<List<Vehicle>>(
//       future: _firestoreController.getAllVehicles(),
//       builder: (BuildContext context, AsyncSnapshot<List<Vehicle>> snapshot) {
//         if (snapshot.connectionState == ConnectionState.waiting) {
//           return const CircularProgressIndicator();
//         } else if (snapshot.hasError) {
//           return Text('Error: ${snapshot.error}');
//         } else {
//           vehicles = snapshot.data!;
//           return DropdownButton<Vehicle>(
//             value: dropdownValue,
//             icon: const Icon(CarbonIcons.arrow_down),
//             iconSize: 24,
//             elevation: 16,
//             style: const TextStyle(color: Colors.black),
//             underline: Container(
//               height: 2,
//               color: Colors.black,
//             ),
//             onChanged: (Vehicle? newValue) {
//               if (newValue != null && newValue.name == 'Add New Vehicle') {
//                 widget.onAddVehicle();
//               } else if (newValue != null) {
//                 setState(() {
//                   dropdownValue = newValue;
//                 });
//                 widget.onVehicleSelected(newValue);
//               }
//             },
//             items: vehicles.map<DropdownMenuItem<Vehicle>>((Vehicle vehicle) {
//               return DropdownMenuItem<Vehicle>(
//                 value: vehicle,
//                 child: Text(vehicle.name),
//               );
//             }).toList()
//               ..add(
//                 DropdownMenuItem(
//                   value: Vehicle(id: '', name: 'Add New Vehicle', initialMileage: 0),
//                   child: const Text('Add New Vehicle'),
//                 ),
//               ),
//           );
//         }
//       },
//     );
//   }
// }
