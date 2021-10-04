import "package:flutter/material.dart";
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:reservation_tracking/logic/bloc/authBloc/auth_bloc.dart';
import 'package:reservation_tracking/screens/addReservation.dart';
import 'package:reservation_tracking/screens/addTrain.dart';
import 'package:reservation_tracking/screens/loginScreen.dart';

class MainDrawer extends StatefulWidget {
  MainDrawer({Key? key, this.color}) : super(key: key);
  final Color? color;

  @override
  _MainDrawerState createState() => _MainDrawerState();
}

class _MainDrawerState extends State<MainDrawer> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var assetsImage = new AssetImage('assets/logo.jpg');
    return Drawer(
        child: SingleChildScrollView(
      child: ConstrainedBox(
        constraints: BoxConstraints(),
        child: Column(
          children: <Widget>[
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(20),
              color: widget.color != null
                  ? widget.color
                  : Theme.of(context).primaryColor,
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    SizedBox(
                      height: 40,
                    ),
                    Container(
                      height: 120,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          CircleAvatar(
                            radius: 30,
                            backgroundColor: Colors.blue,
                            backgroundImage: assetsImage,
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                              top: 26,
                              bottom: 20.0,
                              right: 30,
                            ),
                            child: Text(
                              "Reservation Track",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                      /* Padding(
                      padding: const EdgeInsets.only(top: 35.0),
                      child: Text(
                        globals.isSalesOrder
                            ? "${globals.urLedgerName}"
                            : "${globals.serial}",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 19,
                        ),
                      ),
                    ) */
                    )
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            ListTile(
              leading: Icon(Icons.train),
              title: Text(
                "Add a Train",
                style: TextStyle(
                  fontSize: 18,
                ),
              ),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => AddNewTrain()));
              },
            ),
            SizedBox(
              height: 5,
            ),
            ListTile(
              leading: Icon(Icons.bookmark_add_outlined),
              title: Text(
                "Add New Reservation",
                style: TextStyle(
                  fontSize: 18,
                ),
              ),
              onTap: () {
                Navigator.pop(context);

                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => AddNewReservation()));
              },
            ),
            SizedBox(
              height: 5,
            ),
            ListTile(
              leading: Icon(Icons.logout),
              title: Text(
                "Logout",
                style: TextStyle(
                  fontSize: 18,
                ),
              ),
              onTap: () {
                context.read<AuthBloc>().add(SignOutRequested());
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => LoginScreen()));
              },
            ),
          ],
        ),
      ),
    ));
  }
}
