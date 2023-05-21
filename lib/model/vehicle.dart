import 'package:cloud_firestore/cloud_firestore.dart';

class Vehicle {
  String? id;
  String name;
  int initialMileage;

  Vehicle({
    this.id,
    required this.name,
    required this.initialMileage,
  });

  /// A method to create a Vehicle object from a document in Firestore. Id is got from the docref
  static Vehicle fromFirestore(DocumentSnapshot<Map<String, dynamic>> firestoreDoc) {
    return Vehicle(
      id: firestoreDoc.id,
      name: firestoreDoc['name'],
      initialMileage: firestoreDoc['initialMileage'],
    );
  }

  /// A method to convert the Vehicle object to a map to be stored in Firestore. Omitting the Id
  Map<String, dynamic> toFirestore() {
    return {
      'name': name,
      'initialMileage': initialMileage,
    };
  }
  @override
  String toString() {
    return 'Vehicle{id: $id, name: $name, initialMileage: $initialMileage}';
  }

  static Vehicle? getById(List<Vehicle> vehicles, String id) {
    try {
      return vehicles.firstWhere((vehicle) => vehicle.id == id);
    } catch (e) {
      // Handle the case where there is no vehicle with the given id
      return null;
    }
  }
}
