part of 'reservation_bloc.dart';

@immutable
abstract class ReservationEvent {}

class AddReservationEvent extends ReservationEvent {
  final Map<String, dynamic> rows;
  AddReservationEvent({
    required this.rows,
  });
}

class FetchReservation extends ReservationEvent{}
