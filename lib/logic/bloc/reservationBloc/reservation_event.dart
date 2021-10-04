part of 'reservation_bloc.dart';

@immutable
abstract class ReservationEvent {}

class AddReservationEvent extends ReservationEvent {
  final Map<String, dynamic> rows;
  AddReservationEvent({
    required this.rows,
  });
}

class FetchReservation extends ReservationEvent {}

class AddTrainEvent extends ReservationEvent {
  final Map<String, dynamic> rows;
  AddTrainEvent({
    required this.rows,
  });
}

class FetchTrain extends ReservationEvent {}

class SearchEvent extends ReservationEvent {
  List<Reservation> reservationList;
  SearchBy searchBy;
  String query;
  SearchEvent({
    required this.reservationList,
    required this.searchBy,
    required this.query,
  });
}
