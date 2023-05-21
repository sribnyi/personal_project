import 'package:carbon_icons/carbon_icons.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:personal_project/firebase/firestore-controller.dart';
import 'package:personal_project/styles/row-padding.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../components/add-refuel-dialog.dart';
import '../components/add-vehicle-dialog.dart';
import '../components/vehicle-dropdown.dart';
import '../model/refuel.dart';
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
  List<Vehicle> vehicles = [];
  Vehicle defaultVehicle =
      Vehicle(id: '1', name: 'No Vehicle Selected', initialMileage: 0);
  Refuel defaultRefuel = Refuel(
      id: '1',
      vehicleId: "vehicleId",
      date: DateTime.now(),
      liters: 0,
      price: 0,
      mileage: 0);
  String selectedVehicleId = '';
  late Vehicle dropdownValue = defaultVehicle;
  late Refuel latestRefuel = defaultRefuel;

  @override
  void initState() {
    super.initState();
    _updateVehicles();
    _loadSelectedVehicleId();
  }

  final Vehicle addNewVehicle =
      Vehicle(name: 'Add New Vehicle', initialMileage: 0);

  Future<void> _showAddRefuelDialog() async {
    showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AddRefuelDialog(
          onRefuelAdded: (newRefuel) async {
            newRefuel.vehicleId = dropdownValue!.id!;
            await _firestoreController.addFuelRecord(newRefuel);
            // You might want to update some state here
          },
        );
      },
    );
  }

  Future<void> _updateVehicles() async {
    vehicles = await _firestoreController.getAllVehicles();
  }

  Future<List<Vehicle>> _getAllVehicles() async {
    return await _firestoreController.getAllVehicles();
  }

  Future<bool> _vehicleHasRefuels(String id) async {
    return await _firestoreController.vehicleHasRefuels(id);
  }

  Future<void> _loadSelectedVehicleId() async {
    final prefs = await SharedPreferences.getInstance();

    if (prefs.getString('selectedVehicleId') != null) {
      selectedVehicleId = prefs.getString('selectedVehicleId')!;
      if (await _vehicleHasRefuels(selectedVehicleId)) {
        latestRefuel =
            await _firestoreController.getLatestRefuel(selectedVehicleId);
      } else {
        latestRefuel = defaultRefuel;
      }
      _updateVehicles();
      if (vehicles.isNotEmpty) {
        dropdownValue =
            await _firestoreController.getVehicleById(selectedVehicleId!);
      } else {
        dropdownValue = defaultVehicle;
      }
      return Future.value();
    } else {
      dropdownValue = defaultVehicle;
      latestRefuel = defaultRefuel;
      vehicles.add(defaultVehicle);
    }
  }

  Future<void> _saveSelectedVehicleId(String id) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('selectedVehicleId', id);
  }

  Future<Refuel> getLatestRefuel(String vehicleId) async {
    QuerySnapshot<Map<String, dynamic>> refuelsSnapshot =
        await FirebaseFirestore.instance
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

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _loadSelectedVehicleId(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Container();
          } else {
            print("printing dropdown before " + dropdownValue.name);
            print(selectedVehicleId);
            print(vehicles);

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
                          child: VehicleDropdown(
                        vehicles: vehicles,
                        dropdownValue: dropdownValue,
                        selectedVehicleId: selectedVehicleId,
                        onVehicleChanged: (newValue) {
                          setState(() {
                            dropdownValue = newValue;
                          });
                          _saveSelectedVehicleId(newValue.id!);
                        },
                        onVehicleAdded: (newVehicle) {
                          setState(() {
                            vehicles.add(newVehicle);
                            dropdownValue = newVehicle;
                          });
                          _saveSelectedVehicleId(newVehicle.id!);
                        },
                      )),
                      Flexible(
                        child: Text(dropdownValue.initialMileage.toString() ??
                            'No Mileage'),
                      ),
                    ],
                  ),
                  const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text("Last Refuel:"),
                  ),
                  PaddedRow(
                    icon: CarbonIcons.calendar,
                    text: latestRefuel != null
                        ? 'Last Refuel Date: ${latestRefuel!.date}'
                        : 'No refuel data available',
                  ),
                  PaddedRow(
                    icon: CarbonIcons.gas_station,
                    text: latestRefuel != null
                        ? 'Last Refuel Amount: ${latestRefuel!.liters} L'
                        : 'No refuel data available',
                  ),
                  PaddedRow(
                    icon: CarbonIcons.currency,
                    text: latestRefuel != null
                        ? 'Last Refuel Cost: \$${latestRefuel!.price}'
                        : 'No refuel data available',
                  ),
                  Divider(color: Colors.grey),
                  PaddedRow(
                    icon: CarbonIcons.piggy_bank,
                    text: latestRefuel != null
                        ? 'Price per Liter: \$${latestRefuel!.price / latestRefuel!.liters}'
                        : 'No refuel data available',
                  ),
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
                              onPressed: _showAddRefuelDialog),
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
