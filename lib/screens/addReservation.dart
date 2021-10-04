import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:reservation_tracking/logic/bloc/reservationBloc/reservation_bloc.dart';
import 'package:reservation_tracking/logic/data/reservation.dart';
import 'package:reservation_tracking/logic/data/trains.dart';
import 'package:reservation_tracking/screens/addTrain.dart';
import 'package:reservation_tracking/services/sessionConstants.dart';
import 'package:reservation_tracking/screens/homePage.dart';
import 'package:reservation_tracking/services/sharedObjects.dart';

class AddNewReservation extends StatefulWidget {
  const AddNewReservation({Key? key}) : super(key: key);

  @override
  _AddNewReservationState createState() => _AddNewReservationState();
}

class _AddNewReservationState extends State<AddNewReservation> {
  @override
  void initState() {
    super.initState();
    context.read<ReservationBloc>().add(FetchTrain());
  }

  Trains? selectedTrain;
  List<Trains> trains = [];
  TextEditingController age = new TextEditingController();
  TextEditingController sourceController = new TextEditingController();
  TextEditingController destinationController = new TextEditingController();
  TextEditingController dateofTravelController = new TextEditingController();
  DateTime? dateofTravel;
  var _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ReservationBloc, ReservationState>(
      listener: (context, state) {
        if (state is FetchedTrains && state.trainsList.isEmpty) {
          showDialog(
            context: context,
            builder: (ctx) => AlertDialog(
              title: Text("Message"),
              content: Text(
                  "You don't have any trains added. Please add at least one train to continue"),
              actions: [
                ElevatedButton(
                    onPressed: () {
                      Navigator.pop(ctx);
                    },
                    child: Text("Ok"))
              ],
            ),
          );
        } else if (state is FetchedTrains) {
          trains = state.trainsList;
        }
      },
      builder: (context, state) {
        if (state is FetchingTrains) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
        return Form(
          key: _formKey,
          child: Scaffold(
            appBar: AppBar(
              title: Text("New Reservation"),
              centerTitle: true,
            ),
            body: Padding(
              padding: const EdgeInsets.all(15.0),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    DropdownButtonFormField<Trains>(
                      validator: (val) {
                        if (val == null) {
                          return "This is a required field";
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          suffixIcon: IconButton(
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (ctx) => AddNewTrain(),
                                    ));
                              },
                              icon: Icon(Icons.add))),
                      hint: selectedTrain == null
                          ? Text('Select Train')
                          : Text(
                              selectedTrain!.trainName!,
                              style: TextStyle(fontSize: 20),
                            ),
                      isExpanded: true,
                      iconSize: 30.0,
                      style: TextStyle(
                        fontSize: 20,
                      ),
                      value: selectedTrain,
                      items: trains.map(
                        (val) {
                          return DropdownMenuItem<Trains>(
                            value: val,
                            child: Text(
                              val.trainName!,
                            ),
                          );
                        },
                      ).toList(),
                      onChanged: (Trains? val) {
                        setState(
                          () {
                            selectedTrain = val;
                          },
                        );
                      },
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    TextFormField(
                      validator: (val) {
                        if (val == "") {
                          return "This is a required field";
                        }
                        return null;
                      },
                      style: TextStyle(
                        fontSize: 20,
                      ),
                      controller: sourceController,
                      decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: "Enter Boarding Station",
                          labelStyle: TextStyle(
                            fontSize: 20,
                          )),
                    ),
                    SizedBox(height: 30),
                    TextFormField(
                      validator: (val) {
                        if (val == "") {
                          return "This is a required field";
                        }
                        return null;
                      },
                      style: TextStyle(
                        fontSize: 20,
                      ),
                      controller: destinationController,
                      decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: "Enter Destination Station",
                          labelStyle: TextStyle(
                            fontSize: 20,
                          )),
                    ),
                    SizedBox(height: 30),
                    TextFormField(
                      validator: (val) {
                        if (val == "") {
                          return "This is a required field";
                        }
                        return null;
                      },
                      style: TextStyle(
                        fontSize: 20,
                      ),
                      controller: age,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: "Age of Passenger",
                          labelStyle: TextStyle(
                            fontSize: 20,
                          )),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    DateTimeField(
                      validator: (val) {
                        print(val);
                        if (val == null) {
                          return "This is a required field";
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: "Date of Travel",
                        labelStyle: TextStyle(
                          fontSize: 20,
                        ),
                      ),
                      controller: dateofTravelController,
                      style: TextStyle(fontSize: 20),
                      format: DateFormat(),
                      onChanged: (selectedDate) {
                        dateofTravel = selectedDate;
                        dateofTravelController.text =
                            DateFormat("dd/MM/yyyy").format(selectedDate!);
                      },
                      initialValue: dateofTravel,
                      onShowPicker: (context, currentValue) async {
                        final time = showDatePicker(
                          firstDate: DateTime(1500),
                          lastDate: DateTime(3000),
                          initialDate: DateTime.now(),
                          helpText: "Select Date",
                          fieldLabelText: "Select Date",
                          context: context,
                        );

                        return time;
                      },
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    BlocConsumer<ReservationBloc, ReservationState>(
                      listener: (context, state) {
                        if (state is ReservationBooked) {
                          showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: Text("Message"),
                              content: Text("Added Successfully!!"),
                              actions: [
                                ElevatedButton(
                                    onPressed: () {
                                      Navigator.pushAndRemoveUntil(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => HomePage(),
                                          ),
                                          (route) => false);
                                    },
                                    child: Text("Ok"))
                              ],
                            ),
                          );
                        }
                      },
                      builder: (context, state) {
                        if (state is BookingReservation) {
                          return CircularProgressIndicator();
                        }
                        return ElevatedButton(
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              context.read<ReservationBloc>().add(
                                  AddReservationEvent(
                                      rows: Reservation.toMap(Reservation(
                                          customerID: SharedObjects.prefs?.getString(SessionConstants.sessionUid),
                                          trainName: selectedTrain!.trainName,
                                          trainCode: "T1",
                                          sourceStation: sourceController.text,
                                          destinationStation:
                                              destinationController.text,
                                          ageofPassenger: num.parse(age.text),
                                          dateofTravel:
                                              dateofTravelController.text))));
                            }
                          },
                          child: Text("Submit"),
                        );
                      },
                    )
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
