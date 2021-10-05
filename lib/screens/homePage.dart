import 'package:flutter/material.dart';
import 'package:reservation_tracking/logic/bloc/reservationBloc/reservation_bloc.dart';
import 'package:reservation_tracking/logic/data/enums.dart';
import 'package:reservation_tracking/logic/data/reservation.dart';
import 'package:reservation_tracking/logic/data/user.dart';
import 'package:reservation_tracking/services/sessionConstants.dart';
import 'package:reservation_tracking/services/sharedObjects.dart';
import 'package:reservation_tracking/screens/addReservation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:reservation_tracking/screens/drawer.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

ScrollController scrollController = ScrollController();

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    SessionConstants.sessionUser = User(
      emailId: SharedObjects.prefs?.getString(SessionConstants.sessionEmail),
      userName: SharedObjects.prefs?.getString(SessionConstants.sessionName),
      userId: SharedObjects.prefs?.getString(SessionConstants.sessionUid),
    );
    context.read<ReservationBloc>().add(FetchReservation());
    super.initState();
  }

  bool _isSearching = false;
  TextEditingController _searchQueryController = TextEditingController();
  String searchQuery = "Search query";
  List<Reservation> reservationList = [];
  List<Reservation> backUpreservationList = [];
  SearchBy? _val = SearchBy.TrainName;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: _isSearching ? _buildSearchField() : Text("Reservation System"),
        centerTitle: true,
        actions: _buildActions(),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (ctx) => AddNewReservation()));
        },
        child: Icon(Icons.add),
      ),
      drawer: MainDrawer(),
      body: RefreshIndicator(
        onRefresh: () async {
          // if the internet connection is available or not etc..
          await Future.delayed(
            Duration(seconds: 2),
          );
          _searchQueryController.clear();
          context.read<ReservationBloc>().add(FetchReservation());
        },
        child: SafeArea(
          child: BlocBuilder<ReservationBloc, ReservationState>(
              builder: (context, state) {
            if (state is FetchedReservation &&
                state.reservationList.isNotEmpty) {
              reservationList = state.reservationList;
              return Padding(
                padding: const EdgeInsets.all(20.0),
                child: buildGridView(),
              );
            } else if (state is FetchingReservation) {
              return CircularProgressIndicator();
            } else if (state is SearchState) {
              if (backUpreservationList.isEmpty) {
                backUpreservationList = List.from(reservationList);
              }
              reservationList = state.reservationList;
              return Padding(
                padding: const EdgeInsets.all(20.0),
                child: ListView(
                  children: [
                    _isSearching ? radioTiles() : Container(),
                    buildGridView(),
                  ],
                ),
              );
            }
            return Center(
                child: Text(
              "No Reservations Found",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ));
          }),
        ),
      ),
    );
  }

  Widget _buildSearchField() {
    return TextField(
      controller: _searchQueryController,
      autofocus: true,
      decoration: InputDecoration(
        hintText: "Search Data...",
        border: InputBorder.none,
        hintStyle: TextStyle(color: Colors.white30),
      ),
      style: TextStyle(color: Colors.white, fontSize: 16.0),
      onChanged: (query) => updateSearchQuery(query),
    );
  }

  List<Widget> _buildActions() {
    if (_isSearching) {
      return <Widget>[
        IconButton(
          icon: const Icon(Icons.clear),
          onPressed: () {
            _stopSearching();
            return;
          },
        ),
      ];
    }

    return <Widget>[
      IconButton(
        icon: const Icon(Icons.search),
        onPressed: _startSearch,
      ),
    ];
  }

  void _startSearch() {
    setState(() {
      _isSearching = true;
    });
  }

  void updateSearchQuery(String newQuery) {
    context.read<ReservationBloc>().add(SearchEvent(
        reservationList: backUpreservationList,
        searchBy: _val != null ? _val! : SearchBy.TrainName,
        query: newQuery));
  }

  void _stopSearching() {
    _clearSearchQuery();

    setState(() {
      _isSearching = false;
    });
    context.read<ReservationBloc>().add(FetchReservation());
  }

  void _clearSearchQuery() {
    setState(() {
      _searchQueryController.clear();
      // updateSearchQuery("");
    });
  }

  Widget radioTiles() {
    return Column(
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Expanded(
              child: Row(
                children: [
                  Radio<SearchBy?>(
                      toggleable: true,
                      value: SearchBy.TrainName,
                      groupValue: _val,
                      onChanged: (val) {
                        setState(() {
                          _val = val;
                        });
                        updateSearchQuery(_searchQueryController.text);
                      }),
                  Expanded(
                    child: Text('Train Name'),
                  )
                ],
              ),
              flex: 1,
            ),
            Expanded(
              child: Row(
                children: [
                  Radio<SearchBy?>(
                      toggleable: true,
                      value: SearchBy.SourceStation,
                      groupValue: _val,
                      onChanged: (val) {
                        setState(() {
                          _val = val;
                        });
                        updateSearchQuery(_searchQueryController.text);
                      }),
                  Expanded(child: Text('Source'))
                ],
              ),
              flex: 1,
            ),
          ],
        ),
        Row(
          children: [
            Expanded(
              child: Row(
                children: [
                  Radio<SearchBy?>(
                      toggleable: true,
                      value: SearchBy.DestinationStation,
                      groupValue: _val,
                      onChanged: (val) {
                        setState(() {
                          _val = val;
                        });
                        updateSearchQuery(_searchQueryController.text);
                      }),
                  Expanded(child: Text('Destination'))
                ],
              ),
              flex: 1,
            ),
            Expanded(
              child: Row(
                children: [
                  Radio<SearchBy?>(
                      toggleable: true,
                      value: SearchBy.DateofTravel,
                      groupValue: _val,
                      onChanged: (val) {
                        setState(() {
                          _val = val;
                        });
                        updateSearchQuery(_searchQueryController.text);
                      }),
                  Expanded(child: Text('Date of Travel'))
                ],
              ),
              flex: 1,
            ),
          ],
        ),
      ],
    );
  }

  Widget buildGridView() {
    return GridView.builder(
        controller: scrollController,
        shrinkWrap: true,
        itemCount: reservationList.length,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 1, childAspectRatio: 1.4),
        itemBuilder: (context, index) {
          return SingleChildScrollView(
            child: Column(
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
            ),
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
