import 'package:personal_project/model/refuel.dart';
import 'package:personal_project/model/vehicle.dart';

abstract class PersistenceController {
  Future<List<Vehicle>> getAllVehicles();

  Future<String> saveVehicle(Vehicle vehicle); // returns a Future<String>

  Future<List<Refuel>> getRefuels();

  Future<void> addFuelRecord(Refuel refuel); // added this line

  Future<void> updateVehicleMileage(String vehicleId, int newMileage);

  Future<Vehicle> getVehicleById(String id);

  Future<bool> vehicleHasRefuels(String id);
}
