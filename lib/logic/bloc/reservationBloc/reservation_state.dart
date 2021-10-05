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
class AddingTrain extends ReservationState{}

class AddedTrain extends ReservationState {}

class FailedAddingTrain extends ReservationState {}

class TrainAlreadyExists extends ReservationState{}

class FetchingTrains extends ReservationState{}

class FetchedTrains extends ReservationState {
  final List<Trains> trainsList;
  FetchedTrains({
    required this.trainsList,
  });
}

class SearchState extends ReservationState{
  final List<Reservation> reservationList;
  SearchState({
    required this.reservationList,
  });
}

class FromTraintoReservationState extends ReservationState{}