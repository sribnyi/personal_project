import 'package:cloud_firestore/cloud_firestore.dart';

class Refuel {
  String id;
  DateTime date;
  int volume;
  int cost;
  int odometer;

  Refuel({required this.id, required this.date, required this.volume, required this.cost, required this.odometer});

  Refuel.fromFirestore(Map<String, dynamic> firestoreData) :
        id = (firestoreData['id']),
        date = (firestoreData['date'] as Timestamp).toDate(),
        volume = firestoreData['volume'],
        cost = firestoreData['cost'],
        odometer = firestoreData['odometer'];

  Map<String, dynamic> toFirestore() => {
    'id': id,
    'date': Timestamp.fromDate(date),
    'volume': volume,
    'cost': cost,
    'odometer': odometer
  };
}
