import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:reservation_tracking/logic/bloc/authBloc/auth_bloc.dart';
import 'package:reservation_tracking/screens/homePage.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with TickerProviderStateMixin {
  late TabController tabController;
  TextEditingController emailid = new TextEditingController();
  TextEditingController password = new TextEditingController();

  @override
  void initState() {
    tabController = TabController(length: 2, vsync: this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        body: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: 180,
              ),
              Text(
                "Reservation Track",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 30,
                    color: Colors.green),
              ),
              SizedBox(
                height: 50,
              ),
              // give the tab bar a height [can change hheight to preferred height]
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  height: 320,
                  decoration:
                      BoxDecoration(border: Border.all(color: Colors.grey)),
                  child: Column(
                    children: [
                      Container(
                        height: 45,
                        decoration: BoxDecoration(
                          color: Colors.grey[300],
                        ),
                        child: TabBar(
                          // give the indicator a decoration (color and border radius)
                          indicator: BoxDecoration(
                            color: Colors.white,
                          ),
                          labelColor: Colors.white,
                          unselectedLabelColor: Colors.black,
                          tabs: [
                            // first tab [you can add an icon using the icon property]
                            Tab(
                              child: Text(
                                'Login',
                                style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),

                            // second tab [you can add an icon using the icon property]
                            Tab(
                              child: Text(
                                'Sign Up',
                                style: TextStyle(color: Colors.black),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(18.0),
                          child: TabBarView(
                            children: [
                              // first tab bar view widget
                              Column(
                                children: [
                                  SizedBox(
                                    height: 30,
                                  ),
                                  TextFormField(
                                    controller: emailid,
                                    decoration: InputDecoration(
                                        filled: true,
                                        fillColor: Colors.grey[200],
                                        enabledBorder: InputBorder.none,
                                        errorBorder: InputBorder.none,
                                        focusedBorder: InputBorder.none,
                                        hintStyle:
                                            TextStyle(color: Colors.black),
                                        hintText: "Registered Email",
                                        border: OutlineInputBorder(
                                            borderSide: BorderSide(
                                                color: Colors.grey))),
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 15,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  SizedBox(
                                    height: 20,
                                  ),
                                  TextFormField(
                                    controller: password,
                                    decoration: InputDecoration(
                                        filled: true,
                                        fillColor: Colors.grey[200],
                                        enabledBorder: InputBorder.none,
                                        errorBorder: InputBorder.none,
                                        focusedBorder: InputBorder.none,
                                        hintStyle:
                                            TextStyle(color: Colors.black),
                                        hintText: "Registered Password",
                                        border: OutlineInputBorder(
                                            borderSide: BorderSide(
                                                color: Colors.grey))),
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 15,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  SizedBox(
                                    height: 30,
                                  ),
                                  Align(
                                    alignment: Alignment.centerRight,
                                    child: BlocConsumer<AuthBloc, AuthState>(
                                      listener: (context, state) {
                                        if (state is UserLoggedIn) {
                                          Navigator.pushAndRemoveUntil(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    HomePage(),
                                              ),
                                              (route) => false);
                                        }
                                      },
                                      builder: (context, state) {
                                        return ElevatedButton(
                                            onPressed: () {
                                              context.read<AuthBloc>().add(
                                                  SignInRequested(
                                                      emailId: emailid.text,
                                                      password: password.text));
                                            },
                                            child: Text(
                                              "Sign In",
                                            ),
                                            style: ButtonStyle(
                                              backgroundColor:
                                                  MaterialStateProperty.all(
                                                      Colors.green),
                                            ));
                                      },
                                    ),
                                  )
                                ],
                              ),

                              // second tab bar view widget
                              Column(
                                children: [
                                  SizedBox(
                                    height: 30,
                                  ),
                                  TextFormField(
                                    controller: emailid,
                                    decoration: InputDecoration(
                                        filled: true,
                                        fillColor: Colors.grey[200],
                                        enabledBorder: InputBorder.none,
                                        errorBorder: InputBorder.none,
                                        focusedBorder: InputBorder.none,
                                        hintStyle:
                                            TextStyle(color: Colors.black),
                                        hintText: "Enter New Email",
                                        border: OutlineInputBorder(
                                            borderSide: BorderSide(
                                                color: Colors.grey))),
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 15,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  SizedBox(
                                    height: 20,
                                  ),
                                  TextFormField(
                                    controller: password,
                                    decoration: InputDecoration(
                                        filled: true,
                                        fillColor: Colors.grey[200],
                                        enabledBorder: InputBorder.none,
                                        errorBorder: InputBorder.none,
                                        focusedBorder: InputBorder.none,
                                        hintStyle:
                                            TextStyle(color: Colors.black),
                                        hintText: "Enter New Password",
                                        border: OutlineInputBorder(
                                            borderSide: BorderSide(
                                                color: Colors.grey))),
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 15,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  SizedBox(
                                    height: 30,
                                  ),
                                  Align(
                                    alignment: Alignment.centerRight,
                                    child: BlocConsumer<AuthBloc, AuthState>(
                                      listener: (context, state) {
                                        if (state is UserSignedUp) {
                                          Navigator.pushAndRemoveUntil(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    LoginScreen(),
                                              ),
                                              (route) => false);
                                        }
                                      },
                                      builder: (context, state) {
                                        return ElevatedButton(
                                            onPressed: () {
                                              context.read<AuthBloc>().add(
                                                  SignUpRequested(
                                                      emailId: emailid.text,
                                                      password: password.text));
                                              /* final signUpState = context.watch<FirebaseauthBloc>().state;
                                                                              if(signUpState is UserSignedUp){
                                    
                                                                              context.read<FirebaseauthBloc>().add(EmailVerificationRequested(user:signUpState.currentUser));
                                                                              } */
                                            },
                                            child: Text(
                                              "Sign Up",
                                            ),
                                            style: ButtonStyle(
                                              backgroundColor:
                                                  MaterialStateProperty.all(
                                                      Colors.green),
                                            ));
                                      },
                                    ),
                                  )
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // tab bar view here
            ],
          ),
        ),
      ),
    );
  }
}
