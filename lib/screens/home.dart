import 'package:flutter/material.dart';
import 'package:personal_project/firebase/firestore-controller.dart';
import 'package:unicons/unicons.dart';

import '../model/vehicle.dart';

final _firestoreController = FirestoreController();

List<Vehicle> vehicles = [];
Vehicle? dropdownValue;

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
                var newVehicle = Vehicle(
                  id: '', // Temporarily empty id
                  name: vehicleNameController.text,
                  initialMileage: int.parse(initialMileageController.text),
                );
                // Save the new vehicle to Firestore and get the document id
                String id = await _firestoreController.saveVehicle(newVehicle);
                // Update the id of the new vehicle
                newVehicle.id = id;
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              children: <Widget>[
                const Icon(UniconsLine.car),
                FutureBuilder<List<Vehicle>>(
                  future: _firestoreController.getAllVehicles(),
                  // get the Future returned from getVehicles()
                  builder: (BuildContext context,
                      AsyncSnapshot<List<Vehicle>> snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const CircularProgressIndicator();
                    } else if (snapshot.hasError) {
                      return Text('Error: ${snapshot.error}');
                    } else {
                      /// When the Future completes successfully, build the DropdownButton
                      vehicles = snapshot.data!;

                      if (vehicles.isNotEmpty) {
                        dropdownValue = vehicles[0];
                      }
                      return DropdownButton<Vehicle>(
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
                          if (newValue != null) {
                            if (newValue.name == 'Add New Vehicle') {
                              _showAddVehicleDialog();
                            } else {
                              setState(() {
                                dropdownValue = newValue;
                              });
                            }
                          }
                        },
                        items: vehicles
                            .map<DropdownMenuItem<Vehicle>>((Vehicle vehicle) {
                          return DropdownMenuItem<Vehicle>(
                            value: vehicle,
                            child: Text(vehicle.name),
                          );
                        }).toList()
                          ..add(
                            DropdownMenuItem(
                              value: Vehicle(
                                  id: '0',
                                  name: 'Add New Vehicle',
                                  initialMileage: 0),
                              child: const Text('Add New Vehicle'),
                            ),
                          ),
                      );
                    }
                  },
                ),

                /** The ?? 'No Mileage' part is a null-coalescing operator, which means that if the expression before ?? is null,
                 * it will use the value after ?? instead. So in this case, if dropdownValue is null, the text will display 'No Mileage'. */
                Text(dropdownValue?.initialMileage.toString() ?? 'No Mileage'),
              ],
            ),
            const Text("Last Refuel:"),
            Row(
              children: const <Widget>[
                Icon(Icons.date_range),
                Text("/* Placeholder for Last Refuel Date */"),
              ],
            ),
            Row(
              children: const <Widget>[
                Icon(Icons.local_gas_station),
                Text("/* Placeholder for Last Refuel Amount */"),
              ],
            ),
            Row(
              children: const <Widget>[
                Icon(Icons.attach_money),
                Text("/* Placeholder for Last Refuel Cost */"),
              ],
            ),
            const Divider(color: Colors.grey),
            Row(
              children: const <Widget>[
                Icon(Icons.euro_symbol),
                Text("/* Placeholder for Price per Liter Overall */"),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
