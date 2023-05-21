import 'package:flutter/material.dart';
import 'package:personal_project/components/add-vehicle-dialog.dart';
import 'package:carbon_icons/carbon_icons.dart';
import 'package:personal_project/screens/home.dart';
import '../model/vehicle.dart';

class VehicleDropdown extends StatelessWidget {
  final List<Vehicle> vehicles;
  final Vehicle dropdownValue;
  final String selectedVehicleId;
  final Function(Vehicle) onVehicleChanged;
  final Function(Vehicle) onVehicleAdded;

  const VehicleDropdown({
    Key? key,
    required this.vehicles,
    required this.selectedVehicleId,
    required this.dropdownValue,
    required this.onVehicleChanged,
    required this.onVehicleAdded,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Vehicle addNewVehicle =
    Vehicle(name: 'Add New Vehicle', initialMileage: 0);
    return DropdownButton<Vehicle>(
      value: Vehicle.getById(vehicles, selectedVehicleId!),
      icon: const Icon(CarbonIcons.arrow_down),
      iconSize: 24,
      elevation: 16,
      style: const TextStyle(color: Colors.black),
      underline: Container(
        height: 2,
        color: Colors.black,
      ),

      onChanged: (Vehicle? newValue) {
        if (newValue != null && newValue.name == 'Add New Vehicle') {
          showDialog(
            context: context,
            builder: (context) {
              return AddVehicleDialog(
                onVehicleAdded: onVehicleAdded,
              );
            },
          );
        } else if (newValue != null) {
          onVehicleChanged(newValue);
        }
      },
      items: vehicles.map<DropdownMenuItem<Vehicle>>((Vehicle vehicle) {
        print(vehicle.name);
        return DropdownMenuItem(
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
}
