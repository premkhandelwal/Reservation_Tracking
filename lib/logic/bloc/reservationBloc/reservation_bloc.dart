import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:reservation_tracking/logic/data/enums.dart';
import 'package:reservation_tracking/logic/data/reservation.dart';
import 'package:reservation_tracking/logic/data/trains.dart';

import 'package:reservation_tracking/logic/repository/dataRepository.dart';

part 'reservation_event.dart';
part 'reservation_state.dart';

class ReservationBloc extends Bloc<ReservationEvent, ReservationState> {
  final DataRepository dataRepository;
  ReservationBloc({required this.dataRepository})
      : super(ReservationInitial()) {
    on<ReservationEvent>((event, emit) async {
      if (event is AddReservationEvent) {
        emit(BookingReservation());
        await dataRepository.addNewReservation(event.rows);
        emit(ReservationBooked());
      } else if (event is FetchReservation) {
        emit(FetchingReservation());
        List<Reservation> _reservationList =
            await dataRepository.fetchReservation();
        emit(FetchedReservation(reservationList: _reservationList));
      } else if (event is AddTrainEvent) {
        emit(AddingTrain());
        String result = await dataRepository.addNewTrain(event.rows);
        if (result == "Train Already Exists") {
          emit(TrainAlreadyExists());
        } else if (result == "Failure") {
          emit(FailedAddingTrain());
        } else {
          emit(AddedTrain());
        }
      } else if (event is FetchTrain) {
        emit(FetchingTrains());
        List<Trains> _trainsList = await dataRepository.fetchAllTrains();
        emit(FetchedTrains(trainsList: _trainsList));
      } else if (event is SearchEvent) {
        List<Reservation> _reservationList = dataRepository.applyFilters(
            event.reservationList, event.searchBy, event.query);
        emit(SearchState(reservationList: _reservationList));
      }
    });
  }
}
