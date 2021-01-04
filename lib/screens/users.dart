import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../models/Transaksi.dart';
import './login.dart';
import 'home.dart';
import 'laporan.dart';

class Users extends StatefulWidget {
  Users(this.transaksi);

  Transaksi transaksi;
  TextEditingController _fieldTujuan = new TextEditingController();

  @override
  _UsersState createState() => _UsersState();
}

class _UsersState extends State<Users> {
  bool _validateUser = false;
  bool _validatePass = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Kelola Pengguna"),
        centerTitle: true,
      ),
      drawer: Drawer(
        child: ListView(
          // Important: Remove any padding from the ListView.
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Container(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CircleAvatar(
                              child: Image.asset('assets/images/user_pic.png'),
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Text(widget.transaksi.username,
                                style: TextStyle(
                                    fontSize: 18, color: Colors.white)),
                            Text(
                              "Operator",
                              style:
                                  TextStyle(fontSize: 12, color: Colors.white),
                            ),
                            SizedBox(
                              height: 3,
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                  RaisedButton(
                    onPressed: () {
                      Navigator.pushReplacement(context,
                          MaterialPageRoute(builder: (context) => Login()));
                    },
                    child: Text('Ganti Akun'),
                  )
                ],
              ),
              decoration: BoxDecoration(
                color: Colors.blue[800],
              ),
            ),
            ListTile(
              selected: false,
              selectedTileColor: Colors.grey.shade200,
              title: Text(
                'Transaksi',
              ),
              leading: Icon(Icons.attach_money),
              onTap: () async {
                await Navigator.pop(context);
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => Home(widget.transaksi)));
              },
            ),
            ListTile(
              title: Text('Laporan'),
              leading: Icon(Icons.bar_chart),
              onTap: () async {
                await Navigator.pop(context);
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => Laporan(widget.transaksi)));
              },
            ),
            ListTile(
              title: Text('Pengguna'),
              selected: true,
              selectedTileColor: Colors.grey.shade200,
              leading: Icon(Icons.people),
              onTap: () async {
                // Update the state of the app
                // ...
                // Then close the drawer
                await Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
      body: Container(
        padding: EdgeInsets.all(20),
        child: FutureBuilder(
            future: FirebaseFirestore.instance.collection('users').get(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                List<Widget> item = [];

                for (var i = 0; i < snapshot.data.size; i++) {
                  item.add(Card(
                    elevation: 3,
                    child: Container(
                      padding: EdgeInsets.all(10),
                      height: 50,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Container(
                                  width: 80,
                                  child:
                                      Text(snapshot.data.docs[i]['username'])),
                              SizedBox(
                                width: 20,
                              ),
                              Text(snapshot.data.docs[i]['password'])
                            ],
                          ),
                          RaisedButton(
                            child: Text('Hapus'),
                            onPressed: () async {
                              await FirebaseFirestore.instance
                                  .collection('users')
                                  .doc(snapshot.data.docs[i].id)
                                  .delete();

                              setState(() {});
                            },
                          )
                        ],
                      ),
                    ),
                  ));
                }

                return ListView(
                  children: item,
                );
              }

              return Center(child: CircularProgressIndicator());
            }),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          TextEditingController username = new TextEditingController();
          TextEditingController password = new TextEditingController();
          showDialog(
              context: context,
              builder: (_) => new AlertDialog(
                    title: Text("Tambah Pengguna"),
                    content: Container(
                      height: 200,
                      child: ListView(
                        children: [
                          TextField(
                            controller: username,
                            decoration: InputDecoration(
                                labelText: "Username",
                                errorText: _validateUser
                                    ? "Tidak boleh kosong"
                                    : null),
                          ),
                          TextField(
                            controller: password,
                            decoration: InputDecoration(
                                labelText: "Password",
                                errorText: _validatePass
                                    ? "Tidak boleh kosong"
                                    : null),
                          ),
                        ],
                      ),
                    ),
                    actions: <Widget>[
                      FlatButton(
                        child: Text('Batal'),
                        onPressed: () async {
                          Navigator.of(context).pop();
                        },
                      ),
                      FlatButton(
                        child: Text('Simpan'),
                        onPressed: () async {
                          if (username.text == null || username.text.isEmpty) {
                            setState(() {
                              _validateUser = true;
                            });
                          } else if (password.text == null ||
                              password.text.isEmpty) {
                            setState(() {
                              _validatePass = true;
                            });
                          } else {
                            await FirebaseFirestore.instance
                                .collection('users')
                                .add({
                              'username': username.text,
                              'password': password.text,
                            }).then((value) => value.id);

                            await setState(() {});
                            Navigator.of(context).pop();
                          }
                        },
                      )
                    ],
                  ));
        },
      ),
    );
  }
}

class AddUser extends StatefulWidget {
  @override
  _AddUserState createState() => _AddUserState();
}

class _AddUserState extends State<AddUser> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
