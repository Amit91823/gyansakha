import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gyansakha/screens/LoginScreen.dart';

class SigninScreen extends StatefulWidget {
  const SigninScreen({Key? key}) : super(key: key);

  @override
  _SigninScreenState createState() => _SigninScreenState();
}

class _SigninScreenState extends State<SigninScreen> {
  final _formkey = GlobalKey<FormState>();
  Map<String, String> _formdata = {};
  String _accountcontroller = "teacher";

  final _auth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: Colors.teal,
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
            height: 475,
            child: Card(
                elevation: 8,
                shadowColor: Colors.teal,
                color: Colors.white70,
                child: myform(context))));
  }

  Form myform(BuildContext context) {
    return Form(
      key: _formkey,
      child: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: 30,
            ),
            Container(
              margin: EdgeInsets.all(10),
              child: Text(
                "Create Account",
                style: TextStyle(
                    color: Colors.teal,
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold),
              ),
            ),
            Container(
              margin: EdgeInsets.all(10),
              child: TextFormField(
                decoration: InputDecoration(labelText: "Name"),
                validator: (String? data) {
                  if (data!.isEmpty) {
                    return "Enter a valid Name";
                  }
                  return null;
                },
                onSaved: (String? data) {
                  _formdata["name"] = data!;
                },
              ),
            ),
            Container(
              margin: EdgeInsets.all(15),
              child: TextFormField(
                decoration: InputDecoration(labelText: "Email"),
                validator: (String? data) {
                  if (data!.isEmpty) {
                    return "Enter a valid email";
                  }
                  return null;
                },
                onSaved: (String? data) {
                  _formdata["email"] = data!;
                },
              ),
            ),
            Container(
              margin: EdgeInsets.all(10),
              child: TextFormField(
                decoration: InputDecoration(labelText: "Password"),
                validator: (String? data) {
                  if (data!.isEmpty) {
                    return "Enter a valid password";
                  }
                  return null;
                },
                onSaved: (String? data) {
                  _formdata["password"] = data!;
                },
              ),
            ),
            Container(
              margin: EdgeInsets.all(10),
              child: DropdownButtonFormField<String>(
                value: _accountcontroller,
                items: ["Teacher", "Student"]
                    .map((label) => DropdownMenuItem(
                          child: Text(label),
                          value: label.toLowerCase(),
                        ))
                    .toList(),
                decoration: InputDecoration(labelText: "Select Account"),
                onChanged: (String? data) {
                  setState(() {
                    _accountcontroller = data!;
                  });
                },
                validator: (String? data) {
                  if (data!.isEmpty) {
                    return "Select an Account";
                  }
                  return null;
                },
                onSaved: (String? data) {
                  _formdata["acc_type"] = data!;
                },
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  margin: EdgeInsets.all(10),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(primary: Colors.teal),
                    onPressed: _signin,
                    child: Text("Register"),
                  ),
                ),
                SizedBox(
                  width: 30,
                ),
                ElevatedButton(
                    style: ElevatedButton.styleFrom(primary: Colors.teal),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text("Login"))
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _signin() async {
    if (_formkey.currentState!.validate()) {
      _formkey.currentState!.save();

      try {
        UserCredential _authuser = await _auth.createUserWithEmailAndPassword(
            email: _formdata["email"]!, password: _formdata["password"]!);

        FirebaseFirestore.instance
            .collection("users")
            .doc(_authuser.user?.uid)
            .set({
          "name": _formdata['name'],
          "account_type": _formdata['acc_type'],
          "created_at": DateTime.now().microsecondsSinceEpoch
        });
        if (_authuser.user != null) {
          _auth.signOut();

          Navigator.of(context).popUntil((route) => route.isFirst);
          Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (_) => LoginScreen()));
        } else {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text("Login UnSucessfull!"),
            duration: Duration(seconds: 3),
            action: SnackBarAction(
              label: "Nahi  Huaa Hai!",
              onPressed: () {},
            ),
          ));
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text("unsucessfull nahi huaa!"),
          duration: Duration(seconds: 2),
          action: SnackBarAction(
            label: "fir se karo!",
            onPressed: () {},
          ),
        ));
      }
    }
  }
}
