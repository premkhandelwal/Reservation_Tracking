import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:reservation_tracking/logic/bloc/reservationBloc/reservation_bloc.dart';
import 'package:reservation_tracking/logic/data/trains.dart';

class AddNewTrain extends StatefulWidget {
  final bool? fromReservationScreen;
  const AddNewTrain({Key? key, this.fromReservationScreen}) : super(key: key);

  @override
  _AddNewTrainState createState() => _AddNewTrainState();
}

class _AddNewTrainState extends State<AddNewTrain> {
  TextEditingController trainName = new TextEditingController();
  TextEditingController trainNoController = new TextEditingController();
  TextEditingController sourceController = new TextEditingController();
  TextEditingController destinationController = new TextEditingController();
  TextEditingController departureTimeController = new TextEditingController();
  TextEditingController arrivalTimeController = new TextEditingController();
  var _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Scaffold(
        appBar: AppBar(
          title: Text("Add New Train"),
          centerTitle: true,
        ),
        body: Padding(
          padding: const EdgeInsets.all(15.0),
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(
                  height: 10,
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
                  controller: trainName,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: "Enter Train Name",
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
                  controller: sourceController,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: "Enter Source Station",
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
                  controller: departureTimeController, // add this line.
                  decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: "Select Departure Time",
                      labelStyle: TextStyle(
                        fontSize: 20,
                      )),
                  onTap: () async {
                    TimeOfDay time = TimeOfDay.now();
                    FocusScope.of(context).requestFocus(new FocusNode());

                    TimeOfDay? picked = await showTimePicker(
                        context: context, initialTime: time);
                    if (picked != null) {
                      setState(() {
                        departureTimeController.text =
                            "${picked.hour.toString()}:${picked.minute.toString()}"; // add this line.
                        time = picked;
                      });
                    }
                  },
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
                  controller: arrivalTimeController, // add this line.
                  decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: "Select Arrival Time",
                      labelStyle: TextStyle(
                        fontSize: 20,
                      )),
                  onTap: () async {
                    TimeOfDay time = TimeOfDay.now();

                    TimeOfDay? picked = await showTimePicker(
                      context: context,
                      initialTime: time,
                      builder: (BuildContext context, Widget? child) {
                        return MediaQuery(
                          data: MediaQuery.of(context)
                              .copyWith(alwaysUse24HourFormat: true),
                          child: child!,
                        );
                      },
                    );
                    if (picked != null) {
                      setState(() {
                        arrivalTimeController.text =
                            "${picked.hour.toString()}:${picked.minute.toString()}"; // add this line.
                        time = picked;
                      });
                    }
                  },
                ),
                SizedBox(
                  height: 30,
                ),
                BlocConsumer<ReservationBloc, ReservationState>(
                  listener: (context, state) {
                    if (state is AddedTrain) {
                      showDialog(
                        context: context,
                        builder: (ctx) => AlertDialog(
                          title: Text("Message"),
                          content: Text("Added Successfully!!"),
                          actions: [
                            ElevatedButton(
                                onPressed: () {
                                  if (widget.fromReservationScreen != null &&
                                      widget.fromReservationScreen!) {
                                    context
                                        .read<ReservationBloc>()
                                        .add(FromTraintoReservationEvent());

                                  }
                                  Navigator.pop(ctx);
                                  Navigator.pop(context);
                                },
                                child: Text("Ok"))
                          ],
                        ),
                      );
                    } else if (state is TrainAlreadyExists) {
                      showDialog(
                        context: context,
                        builder: (ctx) => AlertDialog(
                          title: Text("Message"),
                          content: Text("Train Already Exists!!"),
                          actions: [
                            ElevatedButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: Text("Ok"))
                          ],
                        ),
                      );
                    }
                  },
                  builder: (context, state) {
                    if (state is AddingTrain) {
                      return CircularProgressIndicator();
                    }
                    return ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          context.read<ReservationBloc>().add(AddTrainEvent(
                              rows: Trains.toMap(Trains(
                                  trainName: trainName.text,
                                  sourceStation: sourceController.text,
                                  destinationStation:
                                      destinationController.text,
                                  arrivalTime: arrivalTimeController.text,
                                  departureTime:
                                      departureTimeController.text))));
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
  }
}
