part of 'reservation_bloc.dart';

@immutable
abstract class ReservationState {}

class ReservationInitial extends ReservationState {}

class BookingReservation extends ReservationState{}

class ReservationBooked extends ReservationState {}

class FetchingReservation extends ReservationState{}

class FetchedReservation extends ReservationState {
  final List<Reservation> reservationList;
  FetchedReservation({
    required this.reservationList,
  });
}
