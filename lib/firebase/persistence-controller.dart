import 'package:personal_project/model/refuel.dart';
import 'package:personal_project/model/vehicle.dart';

abstract class PersistenceController {
  Future<List<Vehicle>> getAllVehicles();

  Future<void> saveVehicle(Vehicle vehicle);

  Future<List<Refuel>> getRefuels();
  Future<void> saveRefuel(Refuel refuel);


}