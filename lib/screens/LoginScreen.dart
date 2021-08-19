import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gyansakha/screens/RegistationScreen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formkey = GlobalKey<FormState>();

  Map<String, String> _formdata = {};
  final _auth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.teal,
          centerTitle: true,
          title: Text(
            "GyanSakha",
            style: TextStyle(
                color: Colors.white,
                fontSize: 20.0,
                fontWeight: FontWeight.bold),
          ),
        ),
        body: Container(
            margin: EdgeInsets.only(top: 20, right: 8, left: 15),
            width: MediaQuery.of(context).size.width,
            height: 400,
            child: Card(
                elevation: 8,
                shadowColor: Colors.teal,
                color: Colors.white70,
                child: myform(context))));
  }

  Form myform(BuildContext context) {
    return Form(
        key: _formkey,
        child: Column(children: [
          SizedBox(
            height: 50,
          ),
          Container(
            child: Text(
              "Login Into App",
              style: TextStyle(
                  color: Colors.teal,
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold),
            ),
          ),
          Container(
            child: Container(
              margin: EdgeInsets.all(15),
              child: TextFormField(
                decoration: InputDecoration(
                  labelText: "Email",
                ),
                validator: (String? data) {
                  if (data!.isEmpty) {
                    return "Enter A Valid Email";
                  }
                  return null;
                },
                onSaved: (String? data) {
                  _formdata["email"] = data!;
                },
              ),
            ),
          ),
          Container(
            child: Container(
              margin: EdgeInsets.all(15),
              child: TextFormField(
                decoration: InputDecoration(
                  labelText: "Password",
                ),
                validator: (String? data) {
                  if (data!.isEmpty) {
                    return "Enter a Valid Password";
                  }
                  return null;
                },
                onSaved: (String? data) {
                  _formdata["password"] = data!;
                },
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                  style: ElevatedButton.styleFrom(primary: Colors.teal),
                  onPressed: _login,
                  child: Container(
                    padding: EdgeInsets.all(5),
                    child: Text("Login"),
                  )),
              SizedBox(
                height: 30,
                width: 30,
              ),
              ElevatedButton(
                  style: ElevatedButton.styleFrom(primary: Colors.teal),
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (_) => SigninScreen()));
                  },
                  child: Text("Registation"))
            ],
          )
        ]));
  }

  void _login() async {
    if (_formkey.currentState!.validate()) {
      _formkey.currentState!.save();

      try {
        UserCredential _authuser = await _auth.signInWithEmailAndPassword(
            email: _formdata["email"]!, password: _formdata["password"]!);
        if (_authuser.user != null) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text("Login Sucessfull!"),
            duration: Duration(seconds: 3),
            action: SnackBarAction(
              label: "Sucessfull",
              onPressed: () {},
            ),
          ));
        } else {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text("Login failed!"),
            duration: Duration(seconds: 3),
            action: SnackBarAction(
              label: "failed",
              onPressed: () {},
            ),
          ));
        }
      } catch (e) {
        print(e);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text("unsucessfull!"),
          duration: Duration(seconds: 2),
          action: SnackBarAction(
            label: "Try Again!",
            onPressed: () {},
          ),
        ));
      }
    }
  }
}
