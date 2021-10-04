import 'package:reservation_tracking/logic/data/enums.dart';
import 'package:reservation_tracking/logic/data/reservation.dart';
import 'package:reservation_tracking/logic/data/trains.dart';
import 'package:reservation_tracking/logic/providers/dataProvider.dart';

abstract class BaseDataRepository {
  Future<void> addNewReservation(Map<String, dynamic> rows);
  Future<List<Reservation>> fetchReservation();
  List<Reservation> applyFilters(List<Reservation> reservationList, SearchBy searchBy, String query);
  Future<String> addNewTrain(Map<String, dynamic> rows);
  Future<List<Trains>> fetchAllTrains();
}

class DataRepository extends BaseDataRepository {
  final DataProvider dataProvider = DataProvider();

  @override
  Future<void> addNewReservation(Map<String, dynamic> rows) =>
      dataProvider.addNewReservation(rows);
  @override
  Future<List<Reservation>> fetchReservation() =>
      dataProvider.fetchAllReservation();

  @override
  Future<String> addNewTrain(Map<String, dynamic> rows) =>
       dataProvider.addNewTrain(rows);
  @override
  Future<List<Trains>> fetchAllTrains() =>
      dataProvider.fetchAllTrains();

  @override
  List<Reservation> applyFilters(List<Reservation> reservationList, SearchBy searchBy, String query) =>
      dataProvider.applyFilters(reservationList, searchBy, query);
     
}
