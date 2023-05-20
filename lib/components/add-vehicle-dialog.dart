import 'package:flutter/material.dart';
import 'package:personal_project/firebase/firestore-controller.dart';
import 'package:personal_project/model/vehicle.dart';

class AddVehicleDialog extends StatefulWidget {
  final Function(Vehicle) onVehicleAdded;

  const AddVehicleDialog({super.key, required this.onVehicleAdded});

  @override
  _AddVehicleDialogState createState() => _AddVehicleDialogState();
}

class _AddVehicleDialogState extends State<AddVehicleDialog> {
  final TextEditingController vehicleNameController = TextEditingController();
  final TextEditingController initialMileageController = TextEditingController();
  final _firestoreController = FirestoreController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Add New Vehicle'),
      content: SingleChildScrollView(
        child: ListBody(
          children: <Widget>[
            TextField(
              controller: vehicleNameController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Vehicle Name',
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: initialMileageController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Initial Mileage',
              ),
              keyboardType: TextInputType.number,
            ),
          ],
        ),
      ),
      actions: <Widget>[
        TextButton(
          child: const Text('Cancel'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        TextButton(
          child: const Text('Add'),
          onPressed: () async {
            final navigator = Navigator.of(context); // Get the navigator before the async gap.
            var newVehicle = Vehicle(
              name: vehicleNameController.text,
              initialMileage: int.parse(initialMileageController.text),
            );
            // Save the new vehicle to Firestore and get the document id
            String id = await _firestoreController.saveVehicle(newVehicle);
            // Update the id of the new vehicle
            newVehicle.id = id;
            // Invoke the callback to notify about the new vehicle
            widget.onVehicleAdded(newVehicle);
            navigator.pop();
          },
        )      ],
    );
  }
}
