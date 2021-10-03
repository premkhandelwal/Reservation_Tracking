import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:reservation_tracking/logic/bloc/authBloc/auth_bloc.dart';
import 'package:reservation_tracking/logic/bloc/reservationBloc/reservation_bloc.dart';
import 'package:reservation_tracking/logic/repository/authRepository.dart';
import 'package:reservation_tracking/logic/repository/dataRepository.dart';
import 'package:reservation_tracking/logic/services/sessionConstants.dart';
import 'package:reservation_tracking/logic/services/sharedObjects.dart';
import 'package:reservation_tracking/screens/homePage.dart';
import 'package:reservation_tracking/screens/loginScreen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  SharedObjects.prefs = await CachedSharedPreference.getInstance();
  runApp(MyApp(
    dataRepository: DataRepository(),
    authRepository: AuthRepository(),
  ));
}

class MyApp extends StatelessWidget {
  final DataRepository dataRepository;
  final AuthRepository authRepository;
  const MyApp({
    Key? key,
    required this.dataRepository,
    required this.authRepository,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<ReservationBloc>(
          create: (context) => ReservationBloc(dataRepository: dataRepository),
        ),
        BlocProvider<AuthBloc>(
          create: (context) => AuthBloc(authRepository: authRepository),
        )
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          brightness: Brightness.light,
          /* light theme settings */
        ),
        darkTheme: ThemeData(
          brightness: Brightness.dark,

          /* dark theme settings */
        ),
        themeMode: ThemeMode.dark,
        /* ThemeMode.system to follow system theme, 
             ThemeMode.light for light theme, 
             ThemeMode.dark for dark theme
          */
        // debugShowCheckedModeBanner: false,

        home:
            SharedObjects.prefs?.getString(SessionConstants.sessionUid) != null
                ? HomePage()
                : LoginScreen(),
      ),
    );
  }
}
