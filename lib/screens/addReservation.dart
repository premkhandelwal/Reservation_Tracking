import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:reservation_tracking/logic/bloc/reservationBloc/reservation_bloc.dart';
import 'package:reservation_tracking/logic/data/reservation.dart';
import 'package:reservation_tracking/screens/homePage.dart';

class AddNewReservation extends StatefulWidget {
  const AddNewReservation({Key? key}) : super(key: key);

  @override
  _AddNewReservationState createState() => _AddNewReservationState();
}

class _AddNewReservationState extends State<AddNewReservation> {
  String? selectedTrain = "Select Train";
  List<String> trains = [
    "Select Train",
    "Duronto Express",
    "Rajdhani Express",
    "Shatabdi Express",
    "Pune-Lonavala Local"
  ];
  TextEditingController age = new TextEditingController();
  TextEditingController sourceController =
      new TextEditingController();
  TextEditingController destinationController =
      new TextEditingController();
  TextEditingController dateofTravelController =
      new TextEditingController();
  DateTime? dateofTravel = DateTime.now();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("New Reservation"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              DropdownButtonFormField<String>(
                validator: (val) {
                  if (val == null) {
                    return "This is a required field";
                  }
                  return null;
                },
                decoration: InputDecoration(border: OutlineInputBorder()),
                hint: selectedTrain == null
                    ? Text('Dropdown')
                    : Text(
                        selectedTrain!,
                        style: TextStyle(fontSize: 20),
                      ),
                isExpanded: true,
                iconSize: 30.0,
                style: TextStyle(fontSize: 20),
                value: selectedTrain,
                items: trains.map(
                  (val) {
                    return DropdownMenuItem<String>(
                      value: val,
                      child: Text(
                        val,
                      ),
                    );
                  },
                ).toList(),
                onChanged: (String? val) {
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
                    Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                          builder: (context) => HomePage(),
                        ),
                        (route) => false);
                  }
                },
                builder: (context, state) {
                  if (state is BookingReservation) {
                    return Text("Yoo");
                  }
                  return ElevatedButton(
                    onPressed: () {
                      context.read<ReservationBloc>().add(AddReservationEvent(
                          rows: Reservation.toMap(Reservation(
                              trainName: selectedTrain,
                              trainCode: "T1",
                              sourceStation: sourceController.text,
                              destinationStation: destinationController.text,
                              ageofPassenger: num.parse(age.text),
                              dateofTravel: dateofTravelController.text))));
                    },
                    child: Text("Submit"),
                  );
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
