import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:personal_project/firebase/persistence-controller.dart';
import 'package:personal_project/model/vehicle.dart';

class FirestoreController extends PersistenceController {
  late FirebaseFirestore db;

  Future<void> init() async {
    // db = FirebaseFirestore.instance;
    // await Firebase.initializeApp(
    //   options: DefaultFirebaseOptions.currentPlatform,
    // );
  }

  @override
  Future<List<Vehicle>> getAllVehicles() {
    // TODO: implement getAllVehicles
    throw UnimplementedError();
  }

  @override
  Future<void> saveVehicle(Vehicle vehicle) {
    // TODO: implement saveVehicle
    throw UnimplementedError();
  }
}
