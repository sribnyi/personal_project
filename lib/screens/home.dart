import 'package:carbon_icons/carbon_icons.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:intl/intl.dart';
import 'package:personal_project/components/app-bar.dart';
import 'package:personal_project/firebase/firestore-controller.dart';
import 'package:personal_project/styles/row-padding.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../components/action-buttons.dart';
import '../components/add-refuel-dialog.dart';
import '../components/vehicle-details.dart';
import '../model/refuel.dart';
import '../model/vehicle.dart';
import '../utilities/date-time-formatter.dart';

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

String selectedVehicleId = '';

class _HomePageState extends State<HomePage> {
  List<Vehicle> vehicles = [];
  Vehicle defaultVehicle = Vehicle(
      id: '1',
      name: 'No Vehicle Selected',
      initialMileage: 0,
      currentMileage: 0);
  Refuel defaultRefuel = Refuel(
      id: 'No refuel data available',
      vehicleId: "No refuel data available",
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
      Vehicle(name: 'Add New Vehicle', initialMileage: 0, currentMileage: 0);

  Future<void> showAddRefuelDialog() async {
    showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AddRefuelDialog(
          currentMileage: dropdownValue.currentMileage,
          onRefuelAdded: (newRefuel) async {
            newRefuel.vehicleId = dropdownValue.id!;
            await _firestoreController.addFuelRecord(newRefuel);
            dropdownValue.currentMileage = newRefuel.mileage;
            await _firestoreController.updateVehicle(dropdownValue);
            setState(() {});
          },
        );
      },
    );
  }

  Future<void> _updateVehicles() async {
    vehicles = await _firestoreController.getAllVehicles();
  }

  // Future<List<Vehicle>> _getAllVehicles() async {
  //   return await _firestoreController.getAllVehicles();
  // }

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
            await _firestoreController.getVehicleById(selectedVehicleId);
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
            return const Scaffold(
              body: Center(
                child: SpinKitCircle(
                  color: Colors.grey,
                  size: 100.0,
                ),
              ),
            );
          } else {
            return Scaffold(
              appBar: const CustomAppBar(),
              body: Stack(
                children: [
                  Container(
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.center,
                        colors: [Color(0xFFcccccc), Color(0xFFfeffff)],
                      ),
                    ),
                  ),
                  Container(
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.bottomCenter,
                        end: Alignment.center,
                        colors: [Color(0xFFcccccc), Color(0xFFfeffff)],
                      ),
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      VehicleDetailsRow(
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
                      ),
                      const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text("Last Refuel:"),
                      ),
                      PaddedRow(
                        icon: CarbonIcons.calendar,
                        text: DateTimeFormat.formatDateTime(latestRefuel.date),
                        size: 50,
                      ),
                      PaddedRow(
                          icon: CarbonIcons.gas_station,
                          text: "${latestRefuel.liters} liters",
                          size: 50),
                      PaddedRow(
                          icon: CarbonIcons.currency,
                          text: "${latestRefuel.price} eur",
                          size: 50),
                      const Divider(color: Colors.grey),
                      PaddedRow(
                          icon: CarbonIcons.piggy_bank,
                          text:
                              "${(latestRefuel.price / latestRefuel.liters).toStringAsFixed(4)} eur/liter",
                          size: 50),
                      Divider(color: Colors.grey[800]),
                      ActionButtonRow(
                        dropdownValue: dropdownValue,
                        showAddRefuelDialog: showAddRefuelDialog,
                      ),
                    ],
                  ),
                ],
              ),
            );
          }
        });
  }
}
