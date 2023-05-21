import 'package:carbon_icons/carbon_icons.dart';
import 'package:flutter/material.dart';

import '../model/vehicle.dart';
import '../screens/refuel-history.dart';

class ActionButtonRow extends StatelessWidget {
  final Vehicle dropdownValue;

  final Function showAddRefuelDialog;

  const ActionButtonRow(
      {Key? key,
      required this.dropdownValue,
      required this.showAddRefuelDialog})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        Column(
          children: [
            IconButton(
              icon: const Icon(CarbonIcons.gas_station_filled),
              color: Colors.grey[800],
              iconSize: 100,
              onPressed: () => showAddRefuelDialog(),
            ),
            Text("Add Fuel", style: TextStyle(color: Colors.grey[800])),
          ],
        ),
        Column(
          children: [
            IconButton(
              icon: const Icon(CarbonIcons.recently_viewed),
              color: Colors.grey[800],
              iconSize: 100,
              onPressed: () {
                if (dropdownValue.id != null) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          RefuelHistoryScreen(vehicleId: dropdownValue.id!),
                    ),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text("Please select a vehicle first",
                          style: TextStyle(color: Colors.grey[800])),
                    ),
                  );
                }
              },
            ),
            Text("Refuel History", style: TextStyle(color: Colors.grey[800])),
          ],
        ),
      ],
    );
  }
}
