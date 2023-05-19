class Vehicle {
  String id;
  String name;
  int initialMileage;

  Vehicle({
    required this.id,
    required this.name,
    required this.initialMileage,
  });

  /// A method to create a Vehicle object from a document in Firestore
  static Vehicle fromFirestore(Map<String, dynamic> firestoreDoc) {
    return Vehicle(
      id: firestoreDoc['id'],
      name: firestoreDoc['name'],
      initialMileage: firestoreDoc['initialMileage'],
    );
  }

  /// A method to convert the Vehicle object to a map to be stored in Firestore
  Map<String, dynamic> toFirestore() {
    return {
      'id': id,
      'name': name,
      'initialMileage': initialMileage,
    };
  }
}
