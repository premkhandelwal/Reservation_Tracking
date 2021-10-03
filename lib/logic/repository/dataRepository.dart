import 'package:reservation_tracking/logic/data/reservation.dart';
import 'package:reservation_tracking/logic/providers/dataProvider.dart';

abstract class BaseDataRepository {
  Future<void> addNewReservation(Map<String, dynamic> rows);
  Future<void> fetchReservation();
}

class DataRepository extends BaseDataRepository {
  final DataProvider dataProvider = DataProvider();

  @override
  Future<void> addNewReservation(Map<String, dynamic> rows) =>
      dataProvider.addNewReservation(rows);
  @override
  Future<List<Reservation>> fetchReservation() =>
      dataProvider.fetchAllReservation();
}
