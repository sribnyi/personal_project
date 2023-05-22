import 'package:flutter/material.dart';
import 'package:personal_project/screens/home.dart';
import '../model/refuel.dart';

typedef OnRefuelAdded = Function(Refuel newRefuel);

class AddRefuelDialog extends StatefulWidget {
  final OnRefuelAdded onRefuelAdded;
  final int currentMileage;

  const AddRefuelDialog({required this.onRefuelAdded, Key? key, required this.currentMileage})
      : super(key: key);

  @override
  _AddRefuelDialogState createState() => _AddRefuelDialogState();
}

class _AddRefuelDialogState extends State<AddRefuelDialog> {
  final _formKey = GlobalKey<FormState>();
  final _litersController = TextEditingController();
  final _priceController = TextEditingController();
  final _mileageController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Add Refuel'),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              controller: _litersController,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter the amount of fuel.';
                }
                return null;
              },
              decoration: const InputDecoration(
                labelText: 'Fuel (in liters)',
              ),
            ),
            TextFormField(
              controller: _priceController,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter the price per liter.';
                }
                return null;
              },
              decoration: const InputDecoration(
                labelText: 'Price (total)',
              ),
            ),
            TextFormField(
              controller: _mileageController,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter the new mileage.';
                }
                return null;
              },
              decoration: InputDecoration(
                labelText: 'Mileage',
                hintText: 'Current mileage is ${widget.currentMileage}',  // Add this line
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          child: const Text('Cancel'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        TextButton(
          child: const Text('Add'),
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              final newRefuel = Refuel(
                vehicleId: selectedVehicleId,
                date: DateTime.now(),
                liters: double.parse(_litersController.text),
                price: double.parse(_priceController.text),
                mileage: int.parse(_mileageController.text),
              );
              widget.onRefuelAdded(newRefuel);
              Navigator.of(context).pop();
            }
          },
        ),
      ],
    );
  }
}
