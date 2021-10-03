import 'package:flutter/material.dart';
import 'package:reservation_tracking/logic/bloc/authBloc/auth_bloc.dart';
import 'package:reservation_tracking/logic/bloc/reservationBloc/reservation_bloc.dart';
import 'package:reservation_tracking/logic/data/reservation.dart';
import 'package:reservation_tracking/screens/addReservation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:reservation_tracking/screens/loginScreen.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    context.read<ReservationBloc>().add(FetchReservation());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Divider(indent: width * 0.05),
            Text("Reservation System"),
            IconButton(
              icon: Icon(Icons.logout),
              onPressed: () {
                context.read<AuthBloc>().add(SignOutRequested());
                Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                      builder: (context) => LoginScreen(),
                    ),
                    (route) => false);
              },
            )
          ],
        ),
        centerTitle: true,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (ctx) => AddNewReservation()));
        },
        child: Icon(Icons.add),
      ),
      body: SafeArea(
        child: BlocBuilder<ReservationBloc, ReservationState>(
            builder: (context, state) {
          if (state is FetchedReservation) {
            return Padding(
              padding: const EdgeInsets.all(20.0),
              child: buildGridView(state.reservationList),
            );
          }
          return Text("No Users Found");
        }),
      ),
    );
  }

  Widget buildGridView(List<Reservation> reservationList) {
    return GridView.builder(
        shrinkWrap: true,
        itemCount: reservationList.length,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 1, childAspectRatio: 1.4),
        itemBuilder: (context, index) {
          return Column(
            children: [
              InkWell(
                child: Container(
                    width: MediaQuery.of(context).size.width,
                    padding: EdgeInsets.only(left: 10, bottom: 20),
                    decoration: BoxDecoration(
                      // color: Colors.white,
                      borderRadius: BorderRadius.circular(15.0),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.3),
                          blurRadius: 5.0,
                          spreadRadius: 3.0,
                        )
                      ],
                    ),
                    child: buildContent(reservationList, index)),
              ),
              SizedBox(
                height: 20,
              )
            ],
          );
        });
  }

  Widget buildContent(List<Reservation?> reservationList, int index) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 20),
        buildRichText("Train Name: ", "${reservationList[index]?.trainName}"),
        SizedBox(height: 20),
        buildRichText(
            "Source Station: ", "${reservationList[index]?.sourceStation}"),
        SizedBox(height: 20),
        buildRichText("Destination Station: ",
            "${reservationList[index]?.destinationStation}"),
        SizedBox(height: 20),
        buildRichText(
            "Age of Passenger: ", "${reservationList[index]?.ageofPassenger}"),
        SizedBox(height: 20),
        buildRichText(
            "Date of Travel: ", "${reservationList[index]?.dateofTravel}")
      ],
    );
  }

  RichText buildRichText(String? key, String? value) {
    return RichText(
      textAlign: TextAlign.left,
      text: TextSpan(
        text: "$key",
        style: TextStyle(
          // color: Colors.white,
          fontSize: 16,
          fontWeight: FontWeight.normal,
        ),
        children: [
          TextSpan(
            text: "$value",
            style: TextStyle(
                color: Colors.white,

                // color: Colors.black,
                fontSize: 18,
                fontWeight: FontWeight.bold),
          )
        ],
      ),
    );
  }
}
