import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tradingkafundaadmin/bloc/bloc/addcompany_bloc.dart';
import 'package:tradingkafundaadmin/bloc/bloc/managemarket_bloc.dart';
import 'package:tradingkafundaadmin/main.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String email, password;
  bool obscureText = true;
  final formKey = new GlobalKey<FormState>();

  checkFields() {
    final form = formKey.currentState;
    if (form.validate()) {
      return true;
    } else {
      return false;
    }
  }

  String validateEmail(String value) {
    Pattern pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = new RegExp(pattern);
    if (!regex.hasMatch(value))
      return 'Enter Valid Email';
    else
      return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          height: 400.0,
          width: 300.0,
          child: Column(
            children: <Widget>[
              Form(
                key: formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 15),
                      child: Container(
                        child: Image.asset("images/tradingkafundalogo.jpg"),
                      ),
                    ),
                    Padding(
                        padding: EdgeInsets.only(
                            left: 25.0, right: 25.0, top: 20.0, bottom: 5.0),
                        child: Container(
                          height: 50.0,
                          child: TextFormField(
                            decoration: InputDecoration(hintText: 'Email'),
                            validator: (value) => value.isEmpty
                                ? 'Email is required'
                                : validateEmail(value.trim()),
                            onChanged: (value) {
                              this.email = value;
                            },
                          ),
                        )),
                    Padding(
                        padding: EdgeInsets.only(
                            left: 25.0, right: 25.0, top: 20.0, bottom: 5.0),
                        child: Container(
                          height: 50.0,
                          child: TextFormField(
                            obscureText: obscureText,
                            decoration: InputDecoration(
                                hintText: 'Password',
                                suffixIcon: IconButton(
                                  icon: Icon(Icons.remove_red_eye),
                                  onPressed: () {
                                    obscureText = !obscureText;
                                    setState(() {});
                                  },
                                )),
                            validator: (value) =>
                                value.isEmpty ? 'Password is required' : null,
                            onChanged: (value) {
                              this.password = value;
                            },
                          ),
                        )),
                    Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: SizedBox(
                        width: 150,
                        height: 34,
                        child: RaisedButton(
                          onPressed: () {
                            if (checkFields()) {
                              print("Email: $email Password $password");
                              if (email == "talktotradingkafunda@gmail.com" &&
                                  password == "Hello@Market") {
                                Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                        builder: (_) => MultiBlocProvider(
                                                providers: [
                                                  BlocProvider(
                                                      create: (context) =>
                                                          ManagemarketBloc()),
                                                  BlocProvider(
                                                      create: (context) =>
                                                          AddcompanyBloc())
                                                ],
                                                child: MyHomePage(
                                                    title:
                                                        "Trading ka Funda Admin"))));
                              }
                            }
                          },
                          color: Colors.blue,
                          child: Text(
                            "Login",
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
