import 'dart:convert';

class Trains {
  String? trainName;
  String? trainID;
  String? sourceStation;
  String? destinationStation;
  String? arrivalTime;
  String? departureTime;

  Trains({
    this.trainName,
    this.trainID,
    this.sourceStation,
    this.destinationStation,
    this.arrivalTime,
    this.departureTime,
  });

  static Map<String, dynamic> toMap(Trains trains) {
    return {
      'TrainName': trains.trainName,
      'SourceStation': trains.sourceStation,
      'DestinationStation': trains.destinationStation,
      'ArrivalTime': trains.arrivalTime,
      'DepartureTime': trains.departureTime,
    };
  }

  factory Trains.fromMap(Map<String, dynamic> map) {
    return Trains(
      trainName: map['TrainName'],
      trainID: "T${map['Sr_No']}",
      sourceStation: map['SourceStation'],
      destinationStation: map['DestinationStation'],
      arrivalTime: map['ArrivalTime'],
      departureTime: map['DepartureTime'],
    );
  }

  static List<Trains> fromList(List<Map<String, dynamic>> trianListMap) {
    List<Trains> trainsList = [];
    for (var train in trianListMap) {
      trainsList.add(Trains.fromMap(train));
    }
    return trainsList;
  }


  factory Trains.fromJson(String source) => Trains.fromMap(json.decode(source));
}
