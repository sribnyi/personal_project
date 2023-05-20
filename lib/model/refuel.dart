class Refuel {
  String id;
  String vehicleId;
  DateTime date;
  double liters;
  double price;
  int mileage;

  Refuel({
    required this.id,
    required this.vehicleId,
    required this.date,
    required this.liters,
    required this.price,
    required this.mileage,
  });

  Refuel.fromFirestore(Map<String, dynamic> firestoreDoc)
      : id = firestoreDoc['id'],
        vehicleId = firestoreDoc['vehicleId'],
        date = firestoreDoc['date'].toDate(),
        liters = firestoreDoc['liters'],
        price = firestoreDoc['price'],
        mileage = firestoreDoc['mileage'];

  Map<String, dynamic> toFirestore() => {
        'id': id,
        'vehicleId': vehicleId,
        'date': date,
        'liters': liters,
        'price': price,
        'mileage': mileage,
      };
}
