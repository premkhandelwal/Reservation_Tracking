import 'package:reservation_tracking/logic/data/reservation.dart';
import 'package:reservation_tracking/logic/services/databaseHelper.dart';

abstract class BaseProvider {
  Future<void> addNewReservation(Map<String, dynamic> rows);
  Future<List<Reservation>> fetchAllReservation();
}

class DataProvider extends BaseProvider {
  DatabaseHelper databaseHelper = DatabaseHelper.instance;
  @override
  Future<void> addNewReservation(Map<String, dynamic> rows) async {
    int result = await databaseHelper.insert("Reservation", rows);
    print(result);
  }

  @override
  Future<List<Reservation>> fetchAllReservation() async {
    List<Map<String, dynamic>> result =
        await databaseHelper.fetch("Reservation");
    print(result);
    return Reservation.fromList(result);
  }
}
