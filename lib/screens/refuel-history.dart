import 'package:carbon_icons/carbon_icons.dart';
import 'package:flutter/material.dart';
import '../model/refuel.dart';
import '../firebase/firestore-controller.dart';

final _firestoreController = FirestoreController();

class RefuelHistoryScreen extends StatefulWidget {
  final String vehicleId;

  RefuelHistoryScreen({Key? key, required this.vehicleId}) : super(key: key);

  @override
  _RefuelHistoryScreenState createState() => _RefuelHistoryScreenState();
}

class _RefuelHistoryScreenState extends State<RefuelHistoryScreen> {
  List<Refuel> refuels = [];

  @override
  void initState() {
    super.initState();
    _loadRefuels();
  }

  Future<void> _loadRefuels() async {
    refuels = await _firestoreController.getAllRefuelsForVehicle(widget.vehicleId);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Refuel History'),
      ),
      body: ListView.builder(
        itemCount: refuels.length,
        itemBuilder: (context, index) {
          final refuel = refuels[index];
          return ListTile(
            leading: const Icon(CarbonIcons.gas_station_filled, size: 40,),
            title: Text('Refuel on ${refuel.date}'),
            subtitle: Text('Liters: ${refuel.liters}, Price: ${refuel.price}, Mileage: ${refuel.mileage}'),
          );
        },
      ),
    );
  }
}
