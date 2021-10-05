import 'package:email_validator/email_validator.dart';
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
  TextEditingController customerName = new TextEditingController();
  TextEditingController password = new TextEditingController();
  bool _obscure = true;
  @override
  void initState() {
    tabController = TabController(length: 2, vsync: this);
    super.initState();
  }

  var _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: DefaultTabController(
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
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    height: 380,
                    decoration:
                        BoxDecoration(border: Border.all(color: Colors.grey)),
                    child: Column(
                      children: [
                        Container(
                          height: 50,
                          decoration: BoxDecoration(
                            color: Colors.grey[300],
                          ),
                          child: TabBar(
                            indicator: BoxDecoration(
                              color: Colors.white,
                            ),
                            labelColor: Colors.white,
                            unselectedLabelColor: Colors.black,
                            tabs: [
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
                                loginSignUpField(false),
                                loginSignUpField(true)
                                // second tab bar view widget
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
      ),
    );
  }

  Widget loginSignUpField(bool isSignUp) {
    return SingleChildScrollView(
      child: Column(
        children: [
          SizedBox(
            height: 30,
          ),
          isSignUp
              ? Column(
                  children: [
                    TextFormFieldWidget(hintText: "Enter your Name", controller: customerName,validator: (val) {
                      if (val == null || val == "") {
                        return "Name cannot be empty";
                      }
                      return null;
                    }),
                    SizedBox(
                      height: 20,
                    )
                  ],
                )
              : Container(),
          TextFormFieldWidget(
            hintText:   isSignUp ? "Enter New Email" : "Registered Email",controller:  emailid,
            validator:   (val) {
            if (val == null || val == "") {
              return "Email address cannot be empty";
            } else if (!EmailValidator.validate(val))
              return 'Enter a valid email address';
            else
              return null;
          }),
          SizedBox(
            height: 20,
          ),
          TextFormFieldWidget(
             hintText:  isSignUp ? "Enter New Password" : "Registered Password",controller:  password,
             validator:  (val) {
            if (val == null || val == "") {
              return "Password cannot be empty";
            } else if (val.length < 6) {
              return "Please enter a strong password";
            }
            return null;
          },obscure:  _obscure),
          SizedBox(
            height: isSignUp ? 30 : 60,
          ),
          Align(
            alignment: isSignUp ? Alignment.center : Alignment.centerRight,
            child: BlocConsumer<AuthBloc, AuthState>(
              listener: (context, state) {
                if (state is UserLoggedIn) {
                  Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                        builder: (context) => HomePage(),
                      ),
                      (route) => false);
                } else if (state is UserSignedUp) {
                  showDialog(
                    context: context,
                    builder: (ctx) => AlertDialog(
                      title: Text("Message"),
                      content: Text(
                        "Signed Up Successfully!",
                      ),
                      actions: [
                        ElevatedButton(
                            onPressed: () {
                              Navigator.pushAndRemoveUntil(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => LoginScreen(),
                                  ),
                                  (route) => false);
                            },
                            child: Text("Ok"))
                      ],
                    ),
                  );
                } else if (state is UserLogInFailure) {
                  showDialog(
                    context: context,
                    builder: (ctx) => AlertDialog(
                      title: Text("Message"),
                      content: Text(
                        "Invalid Credentials!",
                      ),
                      actions: [
                        ElevatedButton(
                            onPressed: () {
                              Navigator.pop(ctx);
                            },
                            child: Text("Ok"))
                      ],
                    ),
                  );
                } else if (state is UserSignUpFailure) {
                  showDialog(
                    context: context,
                    builder: (ctx) => AlertDialog(
                      title: Text("Message"),
                      content: Text(
                        "Failed to sign up",
                      ),
                      actions: [
                        ElevatedButton(
                            onPressed: () {
                              Navigator.pop(ctx);
                            },
                            child: Text("Ok"))
                      ],
                    ),
                  );
                }else if(state is UserAlreadyExists){
                  showDialog(
                    context: context,
                    builder: (ctx) => AlertDialog(
                      title: Text("Message"),
                      content: Text(
                        "User with the entered credentials already exists. Please sign up using different account",
                      ),
                      actions: [
                        ElevatedButton(
                            onPressed: () {
                              Navigator.pop(ctx);
                            },
                            child: Text("Ok"))
                      ],
                    ),
                  );
                }
              },
              builder: (context, state) {
                if (state is OperationInProgress) {
                  return CircularProgressIndicator();
                }
                return ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        if (isSignUp) {
                          context.read<AuthBloc>().add(SignUpRequested(
                              name: customerName.text,
                              emailId: emailid.text,
                              password: password.text));
                        } else {
                          context.read<AuthBloc>().add(SignInRequested(
                              emailId: emailid.text, password: password.text));
                        }
                      }
                    },
                    child: Text(
                      isSignUp ? "Sign Up" : "Sign In",
                    ),
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(Colors.green),
                    ));
              },
            ),
          )
        ],
      ),
    );
  }
}

class TextFormFieldWidget extends StatefulWidget {
  final String hintText;
  final TextEditingController controller;
  final String? Function(String?)? validator;
  final bool? obscure;
  const TextFormFieldWidget({
    Key? key,
    required this.hintText,
    required this.controller,
    this.validator,
    this.obscure,
  }) : super(key: key);

  @override
  _TextFormFieldWidgetState createState() => _TextFormFieldWidgetState();
}

class _TextFormFieldWidgetState extends State<TextFormFieldWidget> {
  bool flag = true;
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      validator: widget.validator,
      controller: widget.controller,
      decoration: InputDecoration(
          suffixIcon: widget.obscure == true
            ? GestureDetector(
                onTap: () {
                  setState(() {
                    flag = !flag;
                    
                  });
                },
                child: flag
                    ? Icon(
                        Icons.visibility_off,
                        color: Colors.grey,
                        size: 25,
                      )
                    : Icon(
                        Icons.visibility,
                        color: Colors.grey,
                        size: 25,
                      ))
            : null,

          filled: true,
          fillColor: Colors.grey[200],
          enabledBorder: InputBorder.none,
          errorBorder: InputBorder.none,
          focusedBorder: InputBorder.none,
          hintStyle: TextStyle(color: Colors.black),
          hintText: widget.hintText,
          border:
              OutlineInputBorder(borderSide: BorderSide(color: Colors.grey))),
      style: TextStyle(
        color: Colors.black,
        fontSize: 15,
        fontWeight: FontWeight.w600,
      ),
      obscureText: widget.obscure == true
          ? flag
              ? true
              : false
          : false,
    );
  }
}
