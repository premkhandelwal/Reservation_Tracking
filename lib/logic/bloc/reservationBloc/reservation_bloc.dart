import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:reservation_tracking/logic/data/reservation.dart';

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
      }
    });
  }
}
