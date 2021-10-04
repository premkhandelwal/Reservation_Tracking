import 'dart:convert';

class Reservation {
  final String? reservationCode;
  final String? customerID;
  final String? trainName;
  final String? trainCode;
  final String? sourceStation;
  final String? destinationStation;
  final num? ageofPassenger;
  final String? dateofTravel;
  Reservation({
    this.reservationCode,
    this.customerID,
    required this.trainName,
    required this.trainCode,
    required this.sourceStation,
    required this.destinationStation,
    required this.ageofPassenger,
    required this.dateofTravel,
  });

  static Map<String, dynamic> toMap(Reservation reservation) {
    return {
      'TrainID': reservation.trainName,
      'CustomerID':reservation.customerID,
      'Source': reservation.sourceStation,
      'Destination': reservation.destinationStation,
      'AgeofPassenger': reservation.ageofPassenger,
      'DateofTravel': reservation.dateofTravel,
    };
  }

  static List<Reservation> fromList(
      List<Map<String, dynamic>> reservationListMap) {
    List<Reservation> reservList = [];
    for (var reservation in reservationListMap) {
      reservList.add(Reservation.fromMap(reservation));
    }
    return reservList;
  }

  factory Reservation.fromMap(Map<String, dynamic> map) {
    return Reservation(
      trainName: map['TrainID'],
      reservationCode: "R${map['Sr_No']}",
      customerID: map["CustomerID"],
      trainCode: map['TrainID'],
      sourceStation: map['Source'],
      destinationStation: map['Destination'],
      ageofPassenger: map['AgeofPassenger'],
      dateofTravel: map['DateofTravel'],
    );
  }

  // String toJson() => json.encode(toMap());

  factory Reservation.fromJson(String source) =>
      Reservation.fromMap(json.decode(source));
}
