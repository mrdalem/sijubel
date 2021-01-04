import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/Transaksi.dart';
import '../screens/home.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  Transaksi transaksi = new Transaksi();
  TextEditingController user = new TextEditingController();
  TextEditingController pass = new TextEditingController();
  bool _invalidUsername = false;
  bool _invalidPassword = false;
  bool _usernameEmpty = false;
  bool _passwordEmpty = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Card(
          elevation: 4,
          child: Container(
            alignment: Alignment.center,
            padding: EdgeInsets.all(20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Login",
                  style: TextStyle(fontSize: 20),
                ),
                TextField(
                  controller: user,
                  decoration: InputDecoration(
                      labelText: "Username",
                      errorText: _usernameEmpty ? "Masukkan username!" : null),
                ),
                TextField(
                  controller: pass,
                  decoration: InputDecoration(
                      labelText: "Password",
                      errorText: _passwordEmpty ? "Masukkan password!" : null),
                ),
                SizedBox(
                  height: 20,
                ),
                RaisedButton(
                  child: Text('Login'),
                  onPressed: () async {
                    if (user.text.isEmpty) {
                      setState(() {
                        _usernameEmpty = true;
                      });
                    } else if (pass.text.isEmpty) {
                      setState(() {
                        _passwordEmpty = true;
                      });
                    } else {
                      await FirebaseFirestore.instance
                          .collection('users')
                          .where('username', isEqualTo: user.text)
                          .get()
                          .then((value) {
                        if (value.size > 0) {
                          value.docs.forEach((element) {
                            if (element.data()['password'] == pass.text) {
                              transaksi.username = user.text;
                              Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => Home(
                                            transaksi,
                                          )));
                            } else {
                              showDialog(
                                  context: context,
                                  builder: (_) => new AlertDialog(
                                        content: new Text("Password salah!"),
                                        actions: <Widget>[
                                          FlatButton(
                                            child: Text('Ok'),
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            },
                                          )
                                        ],
                                      ));
                            }
                            ;
                          });
                        } else {
                          showDialog(
                              context: context,
                              builder: (_) => new AlertDialog(
                                    content:
                                        new Text("Username tidak ditemukan!"),
                                    actions: <Widget>[
                                      FlatButton(
                                        child: Text('Ok'),
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                      )
                                    ],
                                  ));
                        }
                      });
                    }
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
