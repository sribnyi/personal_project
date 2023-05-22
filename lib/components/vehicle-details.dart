import 'package:carbon_icons/carbon_icons.dart';
import 'package:flutter/material.dart';
import 'package:personal_project/components/vehicle-dropdown.dart';

import '../model/vehicle.dart';

class VehicleDetailsRow extends StatelessWidget {
  final List<Vehicle> vehicles;
  final Vehicle dropdownValue;
  final String selectedVehicleId;
  final Function(Vehicle) onVehicleChanged;
  final Function(Vehicle) onVehicleAdded;

  const VehicleDetailsRow({
    super.key,
    required this.vehicles,
    required this.dropdownValue,
    required this.selectedVehicleId,
    required this.onVehicleChanged,
    required this.onVehicleAdded,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: <Widget>[
          Icon(CarbonIcons.car, size: 50, color: Colors.grey[700]),
          const SizedBox(
            width: 10,
          ),
          Flexible(
            flex: 2,
            child: VehicleDropdown(
              vehicles: vehicles,
              dropdownValue: dropdownValue,
              selectedVehicleId: selectedVehicleId,
              onVehicleChanged: onVehicleChanged,
              onVehicleAdded: onVehicleAdded,
            ),
          ),
          const SizedBox(
            width: 10,
          ),
          Expanded(
            flex: 2,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Initial Mileage: ${dropdownValue.initialMileage}"),
                Text("Current Mileage: ${dropdownValue.currentMileage}"),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
