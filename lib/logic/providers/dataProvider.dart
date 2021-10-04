import 'package:reservation_tracking/logic/data/enums.dart';
import 'package:reservation_tracking/logic/data/reservation.dart';
import 'package:reservation_tracking/logic/data/trains.dart';
import 'package:reservation_tracking/services/databaseHelper.dart';
import 'package:reservation_tracking/services/sessionConstants.dart';
import 'package:reservation_tracking/services/sharedObjects.dart';

abstract class BaseProvider {
  Future<bool> addNewReservation(Map<String, dynamic> rows);
  Future<List<Reservation>> fetchAllReservation();
  List<Reservation> applyFilters(
      List<Reservation> reservationList, SearchBy searchBy, String query);
  Future<String> addNewTrain(Map<String, dynamic> rows);
  Future<List<Trains>> fetchAllTrains();
}

class DataProvider extends BaseProvider {
  DatabaseHelper databaseHelper = DatabaseHelper.instance;
  @override
  Future<bool> addNewReservation(Map<String, dynamic> rows) async {
    int result = await databaseHelper.insert("Reservation", rows);
    if (result > 0) {
      return true;
    }
    return false;
  }

  @override
  Future<List<Reservation>> fetchAllReservation() async {
    List<Map<String, dynamic>> result = await databaseHelper.fetch(
        "Reservation",
        "CustomerID = '${SharedObjects.prefs?.getString(SessionConstants.sessionUid)}'");
    print(result);
    return Reservation.fromList(result);
  }

  @override
  Future<String> addNewTrain(Map<String, dynamic> rows) async {
    List<Map<String, dynamic>> trainAlreadyExistes = await databaseHelper.fetch(
        "Trains", "TrainName ==  '${rows["TrainName"]}'");
    if (trainAlreadyExistes.isEmpty) {
      int result = await databaseHelper.insert("Trains", rows);
      if (result > 0) {
        return "Success";
      }
      return "Failure";
    } else {
      return "Train Already Exists";
    }
  }

  @override
  Future<List<Trains>> fetchAllTrains() async {
    List<Map<String, dynamic>> result = await databaseHelper.fetch("Trains");
    print(result);
    return Trains.fromList(result);
  }

  @override
  List<Reservation> applyFilters(
      List<Reservation> reservationList, SearchBy searchBy, String query) {
    if (query != "") {
      if (searchBy == SearchBy.SourceStation) {
        return reservationList.where((reservation) {
          return reservation.sourceStation!
              .toLowerCase()
              .startsWith(query.toLowerCase());
        }).toList();
      } else if (searchBy == SearchBy.DestinationStation) {
        return reservationList.where((reservation) {
          return reservation.destinationStation!
              .toLowerCase()
              .startsWith(query.toLowerCase());
        }).toList();
      } else if (searchBy == SearchBy.DateofTravel) {
        return reservationList.where((reservation) {
          return reservation.dateofTravel!
              .toLowerCase()
              .startsWith(query.toLowerCase());
        }).toList();
      }
      return reservationList.where((reservation) {
        return reservation.trainName!.startsWith(query);
      }).toList();
    }
    return reservationList;
  }
}
