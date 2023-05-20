import 'package:carbon_icons/carbon_icons.dart';
import 'package:flutter/material.dart';
import 'package:personal_project/firebase/firestore-controller.dart';
import 'package:personal_project/styles/row-padding.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../components/add-vehicle-dialog.dart';
import '../model/vehicle.dart';
import '../styles/app-styles.dart';

final _firestoreController = FirestoreController();

class FuelApp extends StatelessWidget {
  const FuelApp({Key? key}) : super(key: key);

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
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

String? selectedVehicleId;

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    _updateVehicles();
    _loadSelectedVehicleId();
  }

  List<Vehicle> vehicles = [];

  final Vehicle addNewVehicle =
      Vehicle(name: 'Add New Vehicle', initialMileage: 0);
  Vehicle? dropdownValue;

  Vehicle defaultVehicle =
      Vehicle(name: 'No Vehicle Selected', initialMileage: 0);

  Future<void> _loadSelectedVehicleId() async {
    final prefs = await SharedPreferences.getInstance();
    String? id = prefs.getString('selectedVehicleId');

    // Fetch the vehicles from Firestore
    vehicles = await _firestoreController.getAllVehicles();

    if (id != null && vehicles.isNotEmpty) {
      dropdownValue = vehicles.firstWhere((vehicle) => vehicle.id == id);
    }

    return Future.value();
  }

  Future<void> _updateVehicles() async {
    vehicles = await _firestoreController.getAllVehicles();
  }

  Future<void> _saveSelectedVehicleId(String id) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('selectedVehicleId', id);
  }

  // Future<void> _showAddVehicleDialog() async {
  //   showDialog<void>(
  //     context: context,
  //     builder: (BuildContext context) {
  //       return AddVehicleDialog(
  //         onVehicleAdded: (newVehicle) async {
  //           await _updateVehicles();
  //           setState(() {
  //             dropdownValue = newVehicle;
  //           });
  //         },
  //       );
  //     },
  //   );
  //   _loadSelectedVehicleId();
  // }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _loadSelectedVehicleId(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Container(
            );
          } else {
            return Scaffold(
              appBar: AppBar(
                title: const Text('FuelApp'),
              ),
              body: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      iconStyle(CarbonIcons.car),
                      Flexible(
                        child: FutureBuilder<List<Vehicle>>(
                          future: Future.value(vehicles),
                          // get the Future returned from getVehicles()
                          builder: (BuildContext context,
                              AsyncSnapshot<List<Vehicle>> snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return const CircularProgressIndicator();
                            } else if (snapshot.hasError) {
                              return Text('Error: ${snapshot.error}');
                            } else {
                              /// When the Future completes successfully, build the DropdownButton
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
                                  if (newValue != null &&
                                      newValue.name == 'Add New Vehicle') {
                                    showDialog(
                                      context: context,
                                      builder: (context) {
                                        return AddVehicleDialog(
                                          onVehicleAdded: (newVehicle) {
                                            setState(() {
                                              vehicles.add(newVehicle);
                                              dropdownValue = newVehicle;
                                            });
                                            _saveSelectedVehicleId(
                                                newVehicle.id!);
                                          },
                                        );
                                      },
                                    );
                                  } else if (newValue != null) {
                                    setState(() {
                                      dropdownValue = newValue;
                                    });
                                    _saveSelectedVehicleId(newValue.id!);
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
                                      value: addNewVehicle,
                                      child: const Text('Add New Vehicle'),
                                    ),
                                  ),
                              );
                            }
                          },
                        ),
                      ),
                      Flexible(
                        child: Text(dropdownValue?.initialMileage.toString() ??
                            'No Mileage'),
                      ),
                    ],
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
            );
          }
        });
  }
}
