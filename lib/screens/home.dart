import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sijubel/screens/transaksi/input_berat.dart';
import 'package:flutter_money_formatter/flutter_money_formatter.dart';

import '../models/Transaksi.dart';
import '../screens/login.dart';
import './transaksi/input_berat.dart';
import './users.dart';
import 'laporan.dart';

class Home extends StatefulWidget {
  Home(this.transaksi);

  Transaksi transaksi;

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    // if (widget.transaksi.username == null) {
    //   Navigator.pushReplacement(
    //       context, MaterialPageRoute(builder: (context) => Login()));
    // }

    int tgl = DateTime.now().day;
    int bln = DateTime.now().month;
    int thn = DateTime.now().year;

    print(DateTime.parse("${thn}-${bln}-${tgl}"));

    return Scaffold(
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
              selected: true,
              selectedTileColor: Colors.grey.shade200,
              title: Text(
                'Transaksi',
              ),
              leading: Icon(Icons.attach_money),
              onTap: () {
                // Update the state of the app
                // ...
                // Then close the drawer
                Navigator.pop(context);
              },
            ),
            widget.transaksi.username == 'admin'
                ? ListTile(
                    title: Text('Laporan'),
                    leading: Icon(Icons.bar_chart),
                    onTap: () async {
                      await Navigator.pop(context);
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => Laporan(widget.transaksi)));
                    },
                  )
                : SizedBox(),
            widget.transaksi.username == 'admin'
                ? ListTile(
                    title: Text('Pengguna'),
                    leading: Icon(Icons.people),
                    onTap: () async {
                      // Update the state of the app
                      // ...
                      // Then close the drawer
                      await Navigator.pop(context);
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => Users(widget.transaksi)));
                    },
                  )
                : SizedBox(),
          ],
        ),
      ),
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.grey),
        elevation: 0,
        backgroundColor: Colors.grey.shade100,
        title: Text(
          "Transaksi",
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: true,
      ),
      body: FutureBuilder(
          future: FirebaseFirestore.instance
              .collection('transaksi')
              .orderBy('input', descending: true)
              .get(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              List data = [];

              double totalmasuk = 0;
              double totalkeluar = 0;
              double stok = 0;
              for (var i = 0; i < snapshot.data.size; i++) {
                if (snapshot.data.docs[i]['jenis'] == 'jual') {
                  totalmasuk = totalmasuk + snapshot.data.docs[i]['totalharga'];
                  stok = stok - snapshot.data.docs[i]['berat'];
                } else {
                  totalkeluar =
                      totalkeluar + snapshot.data.docs[i]['totalharga'];
                  stok = stok + snapshot.data.docs[i]['berat'];
                }
              }

              for (var i = 0; i < snapshot.data.size; i++) {
                data.add(snapshot.data.docs[i]);
              }

              return Column(
                children: [
                  Container(
                    padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
                    margin: EdgeInsets.fromLTRB(10, 0, 10, 10),
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Container(width: 70, child: Text("Masuk")),
                                Text(
                                  "Rp " +
                                      FlutterMoneyFormatter(amount: totalmasuk)
                                          .output
                                          .withoutFractionDigits,
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                            SizedBox(height: 5),
                            Row(
                              children: [
                                Container(width: 70, child: Text("Keluar")),
                                Text(
                                  "Rp " +
                                      FlutterMoneyFormatter(amount: totalkeluar)
                                          .output
                                          .withoutFractionDigits,
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ],
                            )
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.only(right: 0),
                          child: Column(
                            children: [
                              Text("Stok (kg)"),
                              Text(
                                stok.round().toString(),
                                style: TextStyle(fontSize: 25),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                  Expanded(
                    child: RefreshIndicator(
                      onRefresh: () async {
                        // FirebaseFirestore.instance
                        //     .collection('transaksi')
                        //     .orderBy('input', descending: true)
                        //     .get()
                        //     .then((value) => print(value.docs.length));

                        setState(() {});
                      },
                      child: ListView.builder(
                        itemCount: 7,
                        itemBuilder: (context, index) {
                          List<Widget> itemTransaksi = [];

                          for (var i = 0; i < data.length; i++) {
                            if (data[i]['input'].microsecondsSinceEpoch >
                                    DateTime.parse("${thn}-${bln}-${tgl}")
                                        .subtract(Duration(days: index))
                                        .microsecondsSinceEpoch &&
                                data[i]['input'].microsecondsSinceEpoch <
                                    DateTime.parse("${thn}-${bln}-${tgl}")
                                        .subtract(Duration(days: index))
                                        .add(Duration(days: 1))
                                        .microsecondsSinceEpoch) {
                              itemTransaksi.add(GestureDetector(
                                onTap: () async {
                                  if (widget.transaksi.username == 'admin') {
                                    showDialog(
                                        context: context,
                                        builder: (_) => new AlertDialog(
                                              content: Text(data[i]
                                                      ['deleterequest']
                                                  ? "Transaksi ini diminta untuk dihapus. Lanjutkan?"
                                                  : "Hapus transaksi?"),
                                              actions: <Widget>[
                                                FlatButton(
                                                  child: Text('Kembali'),
                                                  onPressed: () async {
                                                    Navigator.of(context).pop();
                                                  },
                                                ),
                                                data[i]['deleterequest']
                                                    ? FlatButton(
                                                        child: Text('Biarkan'),
                                                        onPressed: () async {
                                                          await FirebaseFirestore
                                                              .instance
                                                              .collection(
                                                                  'transaksi')
                                                              .doc(data[i].id)
                                                              .update({
                                                            'deleterequest':
                                                                false
                                                          }).then((value) => print(
                                                                  "Permintaan hapus terkirim"));
                                                          await setState(() {});
                                                          Navigator.of(context)
                                                              .pop();
                                                        },
                                                      )
                                                    : SizedBox(),
                                                FlatButton(
                                                  child: Text('Hapus'),
                                                  onPressed: () async {
                                                    await FirebaseFirestore
                                                        .instance
                                                        .collection('transaksi')
                                                        .doc(data[i].id)
                                                        .delete()
                                                        .then((value) => print(
                                                            "Transaksi terhapus"));
                                                    await setState(() {});
                                                    Navigator.of(context).pop();
                                                  },
                                                ),
                                              ],
                                            ));
                                  } else {
                                    showDialog(
                                        context: context,
                                        builder: (_) => new AlertDialog(
                                              content: Text(
                                                  "Minta admin untuk hapus transaksi ini?"),
                                              actions: <Widget>[
                                                // FlatButton(
                                                //   child: Text('Kembali'),
                                                //   onPressed: () async {
                                                //     Navigator.of(context).pop();
                                                //   },
                                                // ),
                                                FlatButton(
                                                  child: Text('Tidak'),
                                                  onPressed: () async {
                                                    await FirebaseFirestore
                                                        .instance
                                                        .collection('transaksi')
                                                        .doc(data[i].id)
                                                        .update({
                                                      'deleterequest': false
                                                    }).then((value) => print(
                                                            "Permintaan hapus terkirim"));
                                                    await setState(() {});
                                                    Navigator.of(context).pop();
                                                  },
                                                ),
                                                FlatButton(
                                                  child: Text('Ya'),
                                                  onPressed: () async {
                                                    await FirebaseFirestore
                                                        .instance
                                                        .collection('transaksi')
                                                        .doc(data[i].id)
                                                        .update({
                                                      'deleterequest': true
                                                    }).then((value) => print(
                                                            "Permintaan hapus terkirim"));
                                                    await setState(() {});
                                                    Navigator.of(context).pop();
                                                  },
                                                )
                                              ],
                                            ));
                                  }
                                },
                                child: Container(
                                  margin: EdgeInsets.fromLTRB(10, 3, 10, 0),
                                  height: 70,
                                  child: Card(
                                    color: data[i]['deleterequest']
                                        ? Colors.red.shade100
                                        : Colors.white,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10.0),
                                    ),
                                    child: Row(
                                      children: [
                                        Expanded(
                                          flex: 2,
                                          child: Container(
                                            decoration: BoxDecoration(
                                                color:
                                                    data[i]['jenis'] == 'jual'
                                                        ? Colors.green[400]
                                                        : Colors.red[400],
                                                borderRadius: BorderRadius.only(
                                                    topLeft:
                                                        Radius.circular(10),
                                                    bottomLeft:
                                                        Radius.circular(10))),
                                            height: double.infinity,
                                            child: Center(
                                                child: Text(
                                              data[i]['jenis'].toUpperCase(),
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.w500),
                                            )),
                                          ),
                                        ),
                                        Expanded(
                                          flex: 10,
                                          child: Container(
                                            margin: EdgeInsets.symmetric(
                                                horizontal: 10),
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceEvenly,
                                              children: [
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Row(
                                                      children: [
                                                        Text(
                                                            data[i]['berat']
                                                                    .round()
                                                                    .toString() +
                                                                " Kg |",
                                                            style: TextStyle(
                                                                fontSize: 16,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold)),
                                                        SizedBox(
                                                          width: 5,
                                                        ),
                                                        Text(
                                                            data[i]['jumlah']
                                                                    .round()
                                                                    .toString() +
                                                                " ekor",
                                                            style: TextStyle(
                                                                fontSize: 16,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold)),
                                                      ],
                                                    ),
                                                    Text(
                                                        "Rp " +
                                                            FlutterMoneyFormatter(
                                                                    amount: data[
                                                                            i][
                                                                        'totalharga'])
                                                                .output
                                                                .withoutFractionDigits,
                                                        style: TextStyle(
                                                            fontSize: 16,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold))
                                                  ],
                                                ),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Row(children: [
                                                      Container(
                                                        margin: EdgeInsets.only(
                                                            right: 5),
                                                        padding: EdgeInsets
                                                            .symmetric(
                                                                horizontal: 7,
                                                                vertical: 2),
                                                        child: Text(
                                                          data[i]['status'],
                                                          style: TextStyle(
                                                              fontSize: 12,
                                                              color:
                                                                  Colors.white),
                                                        ),
                                                        decoration: BoxDecoration(
                                                            color: data[i][
                                                                        'status'] ==
                                                                    'lunas'
                                                                ? Colors.green
                                                                : Colors.grey,
                                                            borderRadius:
                                                                BorderRadius
                                                                    .all(Radius
                                                                        .circular(
                                                                            7))),
                                                      ),
                                                      Text(
                                                        ((DateTime.fromMillisecondsSinceEpoch(
                                                                        data[i]['input'].seconds *
                                                                            1000)
                                                                    .hour))
                                                                .toString() +
                                                            ":" +
                                                            ((DateTime.fromMillisecondsSinceEpoch(
                                                                        data[i]['input'].seconds *
                                                                            1000)
                                                                    .minute))
                                                                .toString()
                                                                .padLeft(
                                                                    2, '0') +
                                                            " WITA - ${data[i]['user']}",
                                                        style: TextStyle(
                                                            fontSize: 12),
                                                      ),
                                                    ]),
                                                    Container(
                                                      alignment:
                                                          Alignment.centerRight,
                                                      width: 95,
                                                      child: Text(
                                                          data[i]['jenis'] ==
                                                                  'jual'
                                                              ? 'ke ' +
                                                                  data[i]
                                                                      ['tujuan']
                                                              : 'dari ' +
                                                                  data[i]
                                                                      ['asal'],
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                          style: TextStyle(
                                                              fontSize: 12)),
                                                    )
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ));
                            }
                          }
                          if (itemTransaksi.isEmpty) {
                            return SizedBox();
                          } else {
                            return Column(
                              children: [
                                Container(
                                  width: double.infinity,
                                  alignment: Alignment.center,
                                  padding: EdgeInsets.symmetric(vertical: 2),
                                  margin: EdgeInsets.fromLTRB(0, 20, 0, 5),
                                  decoration: BoxDecoration(
                                      color: Colors.grey.shade300,
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(2))),
                                  child: Text(
                                      DateTime.parse("${thn}-${bln}-${tgl}")
                                              .subtract(Duration(days: index))
                                              .day
                                              .toString() +
                                          "-${bln}-${thn}",
                                      style: TextStyle(
                                          color: Colors.black, fontSize: 12)),
                                ),
                                Container(
                                  child: Column(
                                    children: itemTransaksi,
                                  ),
                                ),
                              ],
                            );
                          }
                        },
                      ),
                    ),
                  )
                ],
              );
            }

            return Center(child: CircularProgressIndicator());
          }),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
        child: Row(
          children: [
            Expanded(
                child: RaisedButton(
              onPressed: () {
                widget.transaksi.setJenisJual();
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => InputBerat(
                              widget.transaksi,
                            )));
              },
              child: Text("JUAL"),
              color: Colors.green[200],
            )),
            SizedBox(
              width: 20,
            ),
            Expanded(
                child: RaisedButton(
              onPressed: () {
                widget.transaksi.setJenisBeli();
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => InputBerat(
                              widget.transaksi,
                            )));
              },
              child: Text("BELI"),
              color: Colors.red[200],
            ))
          ],
        ),
      ),
    );
  }
}
