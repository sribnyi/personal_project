import 'package:carbon_icons/carbon_icons.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:personal_project/firebase/firestore-controller.dart';
import 'package:personal_project/styles/row-padding.dart';

import '../components/add-vehicle-dialog.dart';
import '../model/vehicle.dart';
import '../styles/app-styles.dart';

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
    showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AddVehicleDialog(
          onVehicleAdded: (newVehicle) {
            // Update state when a new vehicle is added
            setState(() {
              vehicles.add(newVehicle);
              dropdownValue = vehicles.last;
            });
          },
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
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: <Widget>[
                  iconStyle(CarbonIcons.car),
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
                          icon: const Icon(CarbonIcons.arrow_down),
                          iconSize: 24,
                          elevation: 16,
                          style: const TextStyle(color: Colors.black),
                          underline: Container(
                            height: 2,
                            color: Colors.black,
                          ),
                          onChanged: (Vehicle? newValue) {
                            if (newValue != null) {
                              setState(() {
                                dropdownValue = newValue;
                              });
                            }
                          },
                          items: vehicles.map<DropdownMenuItem<Vehicle>>(
                              (Vehicle vehicle) {
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
                  Text(
                      dropdownValue?.initialMileage.toString() ?? 'No Mileage'),
                ],
              ),
            ),
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text("Last Refuel:"),
            ),
            const PaddedRow(
              icon: CarbonIcons.calendar,
              text: "/* Placeholder for Last Refuel Date */",
            ),
            const PaddedRow(
              icon: CarbonIcons.gas_station,
              text: "/* Placeholder for Last Refuel Amount */",
            ),
            const PaddedRow(
              icon: CarbonIcons.currency,
              text: "/* Placeholder for Last Refuel Cost */",
            ),
            const Divider(color: Colors.grey),
            const PaddedRow(
                icon: CarbonIcons.piggy_bank,
                text: "/* Placeholder for Price per Liter Overall */"),
            const Divider(color: Colors.grey),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Column(
                  children: [
                    IconButton(
                      icon: const Icon(CarbonIcons.gas_station_filled),
                      color: Colors.blueGrey[500],
                      iconSize: 100,
                      onPressed: () {
                        // Here, you can define what the button should do upon being pressed
                      },
                    ),
                    Text("Add Fuel",
                        style: TextStyle(color: Colors.blueGrey[500])),
                  ],
                ),
                Column(
                  children: [
                    IconButton(
                      icon: const Icon(CarbonIcons.recently_viewed),
                      color: Colors.blueGrey[500],
                      iconSize: 100,
                      onPressed: () {
                        // Here, you can define what the button should do upon being pressed
                        print("See History Button Pressed");
                      },
                    ),
                    Text("Refuel History",
                        style: TextStyle(color: Colors.blueGrey[500])),
                  ],
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
