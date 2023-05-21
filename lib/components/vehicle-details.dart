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

  const VehicleDetailsRow({super.key,
    required this.vehicles,
    required this.dropdownValue,
    required this.selectedVehicleId,
    required this.onVehicleChanged,
    required this.onVehicleAdded,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Icon(CarbonIcons.car, size: 50, color: Colors.grey[700]), // the car icon
        Flexible(
          child: VehicleDropdown(
            vehicles: vehicles,
            dropdownValue: dropdownValue,
            selectedVehicleId: selectedVehicleId,
            onVehicleChanged: onVehicleChanged,
            onVehicleAdded: onVehicleAdded,
          ),
        ),
        Flexible(
          child: Text(dropdownValue.initialMileage.toString()),
        ),
      ],
    );
  }
}
