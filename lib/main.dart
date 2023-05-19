import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:personal_project/firebase/firestore-controller.dart';
import 'package:personal_project/styles/app-styles.dart';

import 'model/vehicle.dart';

final _firestoreService = FirestoreController();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const FuelApp());
}

Vehicle dropdownValue = vehicles[0];
List<Vehicle> vehicles = [
  Vehicle(id: '1', name: 'Vehicle 1', initialMileage: 0)
];

class FuelApp extends StatelessWidget {
  const FuelApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FuelApp',
      theme: ThemeData(
        primarySwatch: Colors.blueGrey,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Future<void> _showAddVehicleDialog() async {
    final TextEditingController vehicleNameController = TextEditingController();
    final TextEditingController initialMileageController =
        TextEditingController();

    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Add New Vehicle'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                TextField(
                  controller: vehicleNameController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Vehicle Name',
                  ),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: initialMileageController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Initial Mileage',
                  ),
                  keyboardType: TextInputType.number,
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Add'),
              onPressed: () async {
                // Add async keyword
                // Create new Vehicle instance
                var newVehicle = Vehicle(
                  id: '2',
                  name: vehicleNameController.text,
                  initialMileage: int.parse(initialMileageController.text),
                );
                // Save the new vehicle to Firestore
                await _firestoreService
                    .saveVehicle(newVehicle); // Add this line
                // Add new vehicle to vehicles list
                setState(() {
                  vehicles.add(newVehicle);
                  dropdownValue = vehicles.last;
                });
                Navigator.of(context).pop();
              },
            )
          ],
        );
      },
    );
  }

  // TODO: Implement methods to fetch the data for selected car
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
      ),
      body: Center(
        child: DropdownButton<Vehicle>(
          value: dropdownValue,
          icon: const Icon(Icons.arrow_downward),
          iconSize: 24,
          elevation: 16,
          style: const TextStyle(color: Colors.black),
          underline: Container(
            height: 2,
            color: Colors.black,
          ),
          onChanged: (Vehicle? newValue) {
            if (newValue!.name == 'Add New Vehicle') {
              _showAddVehicleDialog();
            } else {
              setState(() {
                dropdownValue = newValue;
                // fetch data for selected vehicle here
              });
            }
          },
          items: vehicles.map<DropdownMenuItem<Vehicle>>((Vehicle vehicle) {
            return DropdownMenuItem<Vehicle>(
              value: vehicle,
              child: Text(vehicle.name),
            );
          }).toList()
            ..add(
              DropdownMenuItem(
                value: Vehicle(
                    id: '0', name: 'Add New Vehicle', initialMileage: 0),
                child: const Text('Add New Vehicle'),
              ),
            ),
        ),
      ),
    );
  }
}
