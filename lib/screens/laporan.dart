import 'package:fl_chart/fl_chart.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter_money_formatter/flutter_money_formatter.dart';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sijubel/models/Transaksi.dart';
import 'package:sijubel/screens/users.dart';

import 'home.dart';

class Laporan extends StatefulWidget {
  Laporan(this.transaksi);

  Transaksi transaksi;
  @override
  State<StatefulWidget> createState() => LaporanState();
}

class LaporanState extends State<Laporan> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: Text("Laporan"),
          centerTitle: true,
          bottom: TabBar(
            tabs: [
              Tab(
                text: "Harian",
              ),
              Tab(
                text: "Bulanan",
              ),
              Tab(
                text: "Hutang",
              ),
            ],
          ),
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
                                child:
                                    Image.asset('assets/images/user_pic.png'),
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Text(widget.transaksi.username,
                                  style: TextStyle(
                                      fontSize: 18, color: Colors.white)),
                              Text(
                                "Operator",
                                style: TextStyle(
                                    fontSize: 12, color: Colors.white),
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
                        // Navigator.pushReplacement(context,
                        //     MaterialPageRoute(builder: (context) => Login()));
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
                selected: true,
                selectedTileColor: Colors.grey.shade200,
                title: Text('Laporan'),
                leading: Icon(Icons.bar_chart),
                onTap: () {
                  // Update the state of the app
                  // ...
                  // Then close the drawer
                  Navigator.pop(context);
                },
              ),
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
        body: StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection('transaksi')
                .orderBy('input', descending: true)
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }

              if (!snapshot.hasData) {
                return Center(
                  child: Text("Kosong"),
                );
              }

              List data = [];

              for (var i = 0; i < snapshot.data.size; i++) {
                data.add(snapshot.data.docs[i]);
              }

              int day = data.last['input'].toDate().day;
              int month = data.last['input'].toDate().month;
              int year = data.last['input'].toDate().year;

              DateTime oldest = DateTime.parse("${year}-" +
                  month.toString().padLeft(2, "0") +
                  "-" +
                  day.toString().padLeft(2, "0"));

              day = DateTime.now().day;
              month = DateTime.now().month;
              year = DateTime.now().year;

              DateTime today = DateTime.parse("${year}-" +
                  month.toString().padLeft(2, "0") +
                  "-" +
                  day.toString().padLeft(2, "0"));

              int range = DateTime.now().difference(oldest).inDays;

              List dataharian = [];
              List databulanan = [];

              for (var i = 0; i <= range; i++) {
                double pemasukan = 0;
                double pengeluaran = 0;
                double stokmasuk = 0;
                double stokkeluar = 0;

                data.forEach((e) {
                  if (e['input'].toDate().millisecondsSinceEpoch >
                          today
                              .subtract(Duration(days: i))
                              .millisecondsSinceEpoch &&
                      e['input'].toDate().millisecondsSinceEpoch <
                          today
                              .subtract(Duration(days: i))
                              .add(Duration(days: 1))
                              .millisecondsSinceEpoch) {
                    if (e['jenis'] == 'jual') {
                      pemasukan = pemasukan + e['totalharga'];
                      stokkeluar = stokkeluar + e['berat'];
                    } else {
                      pengeluaran = pengeluaran + e['totalharga'];
                      stokmasuk = stokmasuk + e['berat'];
                    }
                  }
                });

                dataharian.add({
                  'date': today.subtract(Duration(days: i)),
                  'pemasukan': pemasukan.round(),
                  'pengeluaran': pengeluaran.round(),
                  'stokmasuk': stokmasuk.round(),
                  'stokkeluar': stokkeluar.round()
                });
              }

              int montholdest = data.last['input'].toDate().month;
              int yearoldest = data.last['input'].toDate().year;

              int rangemonth =
                  (month - montholdest) + ((year - yearoldest) * 12);

              // print(rangemonth);

              int m = DateTime.now().month;
              int y = DateTime.now().year;

              for (var i = 0; i <= rangemonth; i++) {
                double pemasukan = 0;
                double pengeluaran = 0;
                double stokmasuk = 0;
                double stokkeluar = 0;

                if (m <= 0) {
                  m = m + 12;
                  y = y - 1;
                }

                int yearafter = y;
                int monthafter = m + 1;

                if (monthafter == 13) {
                  monthafter = 1;
                  yearafter++;
                }
                // print(m.toString() + "-" + y.toString());

                DateTime monthStart = DateTime.parse(
                    "${y}-" + m.toString().padLeft(2, "0") + "-01");
                DateTime monthEnd = DateTime.parse("${yearafter}-" +
                        monthafter.toString().padLeft(2, "0") +
                        "-01")
                    .subtract(Duration(days: 1));

                data.forEach((e) {
                  if (e['input'].toDate().millisecondsSinceEpoch >
                          monthStart.millisecondsSinceEpoch &&
                      e['input'].toDate().millisecondsSinceEpoch <
                          monthEnd.millisecondsSinceEpoch) {
                    if (e['jenis'] == 'jual') {
                      pemasukan = pemasukan + e['totalharga'];
                      stokkeluar = stokkeluar + e['berat'];
                    } else {
                      pengeluaran = pengeluaran + e['totalharga'];
                      stokmasuk = stokmasuk + e['berat'];
                    }
                  }
                });

                databulanan.add({
                  'date': monthStart,
                  'pemasukan': pemasukan.round(),
                  'pengeluaran': pengeluaran.round(),
                  'stokmasuk': stokmasuk.round(),
                  'stokkeluar': stokkeluar.round()
                });

                m = m - 1;
              }

              List<Widget> hutangpiutang = [];

              double jumlahhutang = 0;
              double jumlahpiutang = 0;

              data.forEach((element) {
                if (element['status'] == 'hutang' || element['pernahhutang']) {
                  hutangpiutang.add(GestureDetector(
                    onTap: () async {
                      showDialog(
                          context: context,
                          builder: (_) => new AlertDialog(
                                content: Text("Update status hutang"),
                                actions: <Widget>[
                                  FlatButton(
                                    child: Text('Hutang'),
                                    onPressed: () async {
                                      await FirebaseFirestore.instance
                                          .collection('transaksi')
                                          .doc(element.id)
                                          .update({
                                        'status': 'hutang',
                                      }).then((value) =>
                                              print("Transaksi diupdate"));
                                      await setState(() {});
                                      Navigator.of(context).pop();
                                    },
                                  ),
                                  FlatButton(
                                    child: Text('Lunas'),
                                    onPressed: () async {
                                      await FirebaseFirestore.instance
                                          .collection('transaksi')
                                          .doc(element.id)
                                          .update({
                                        'status': 'lunas',
                                      }).then((value) =>
                                              print("Transaksi diupdate"));
                                      await setState(() {});
                                      Navigator.of(context).pop();
                                    },
                                  )
                                ],
                              ));
                    },
                    child: Container(
                      margin: EdgeInsets.fromLTRB(10, 3, 10, 0),
                      height: 70,
                      child: Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              flex: 2,
                              child: Container(
                                decoration: BoxDecoration(
                                    color: element['jenis'] == 'jual'
                                        ? Colors.green[400]
                                        : Colors.red[400],
                                    borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(10),
                                        bottomLeft: Radius.circular(10))),
                                height: double.infinity,
                                child: Center(
                                    child: Text(
                                  element['jenis'].toUpperCase(),
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w500),
                                )),
                              ),
                            ),
                            Expanded(
                              flex: 10,
                              child: Container(
                                margin: EdgeInsets.symmetric(horizontal: 10),
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(
                                          children: [
                                            Text(
                                                element['berat']
                                                        .round()
                                                        .toString() +
                                                    " Kg |",
                                                style: TextStyle(
                                                    fontSize: 16,
                                                    fontWeight:
                                                        FontWeight.bold)),
                                            SizedBox(
                                              width: 5,
                                            ),
                                            Text(
                                                element['jumlah']
                                                        .round()
                                                        .toString() +
                                                    " ekor",
                                                style: TextStyle(
                                                    fontSize: 16,
                                                    fontWeight:
                                                        FontWeight.bold)),
                                          ],
                                        ),
                                        Text(
                                            "Rp " +
                                                FlutterMoneyFormatter(
                                                        amount: element[
                                                            'totalharga'])
                                                    .output
                                                    .withoutFractionDigits,
                                            style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold))
                                      ],
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(children: [
                                          Container(
                                            margin: EdgeInsets.only(right: 5),
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 7, vertical: 2),
                                            child: Text(
                                              element['status'],
                                              style: TextStyle(
                                                  fontSize: 12,
                                                  color: Colors.white),
                                            ),
                                            decoration: BoxDecoration(
                                                color:
                                                    element['status'] == 'lunas'
                                                        ? Colors.green
                                                        : Colors.grey,
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(7))),
                                          ),
                                          Text(
                                            ((DateTime.fromMillisecondsSinceEpoch(
                                                            element['input']
                                                                    .seconds *
                                                                1000)
                                                        .hour))
                                                    .toString() +
                                                ":" +
                                                ((DateTime.fromMillisecondsSinceEpoch(
                                                            element['input']
                                                                    .seconds *
                                                                1000)
                                                        .minute))
                                                    .toString()
                                                    .padLeft(2, '0') +
                                                " WITA - ${element['user']}",
                                            style: TextStyle(fontSize: 12),
                                          ),
                                        ]),
                                        Container(
                                          alignment: Alignment.centerRight,
                                          width: 95,
                                          child: Text(
                                              element['jenis'] == 'jual'
                                                  ? 'ke ' + element['tujuan']
                                                  : 'dari ' + element['asal'],
                                              overflow: TextOverflow.ellipsis,
                                              style: TextStyle(fontSize: 12)),
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

                if (element['status'] == 'hutang' &&
                    element['jenis'] == 'jual') {
                  jumlahpiutang = jumlahpiutang + element['totalharga'];
                }

                if (element['status'] == 'hutang' &&
                    element['jenis'] == 'beli') {
                  jumlahhutang = jumlahhutang + element['totalharga'];
                }
              });

              return TabBarView(
                children: [
                  Column(children: [
                    Expanded(
                      child: Scrollbar(
                        child: ListView.separated(
                          padding: EdgeInsets.symmetric(vertical: 20),
                          itemCount: dataharian.length,
                          itemBuilder: (context, index) {
                            return Card(
                                elevation: 3,
                                margin: EdgeInsets.symmetric(horizontal: 20),
                                child: Container(
                                    padding: EdgeInsets.all(0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          padding: EdgeInsets.all(5),
                                          color: index % 2 == 0
                                              ? Colors.blue.shade100
                                              : Colors.blue.shade300,
                                          height: 22,
                                          width: double.infinity,
                                          child: Text(
                                            DateFormat.d()
                                                    .format(dataharian[index]
                                                        ['date'])
                                                    .toString() +
                                                " " +
                                                DateFormat.MMMM()
                                                    .format(dataharian[index]
                                                        ['date'])
                                                    .toString()
                                                    .substring(0, 3) +
                                                "-" +
                                                DateFormat.y()
                                                    .format(dataharian[index]
                                                        ['date'])
                                                    .toString(),
                                            style: TextStyle(fontSize: 12),
                                          ),
                                        ),
                                        SizedBox(height: 10),
                                        Container(
                                          padding: EdgeInsets.fromLTRB(
                                              10, 0, 10, 10),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    children: [
                                                      Container(
                                                          width: 50,
                                                          child:
                                                              Text("Masuk:")),
                                                      Text(
                                                          "Rp " +
                                                              FlutterMoneyFormatter(
                                                                      amount: dataharian[index]
                                                                              [
                                                                              'pemasukan']
                                                                          .toDouble())
                                                                  .output
                                                                  .withoutFractionDigits,
                                                          style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold))
                                                    ],
                                                  ),
                                                  SizedBox(
                                                    height: 5,
                                                  ),
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    children: [
                                                      Container(
                                                          width: 50,
                                                          child:
                                                              Text("Keluar:")),
                                                      Text(
                                                        "Rp " +
                                                            FlutterMoneyFormatter(
                                                                    amount: dataharian[index]
                                                                            [
                                                                            'pengeluaran']
                                                                        .toDouble())
                                                                .output
                                                                .withoutFractionDigits,
                                                        style: TextStyle(
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      ),
                                                    ],
                                                  )
                                                ],
                                              ),
                                              Row(
                                                children: [
                                                  Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .center,
                                                    children: [
                                                      Text(
                                                        "Stok",
                                                        style: TextStyle(
                                                            fontSize: 12),
                                                      ),
                                                      Text("Masuk (kg)",
                                                          style: TextStyle(
                                                              fontSize: 12)),
                                                      Text(
                                                          dataharian[index]
                                                                  ['stokmasuk']
                                                              .toString(),
                                                          style: TextStyle(
                                                              fontSize: 20))
                                                    ],
                                                  ),
                                                  SizedBox(
                                                    width: 10,
                                                  ),
                                                  Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .center,
                                                    children: [
                                                      Text("Stok",
                                                          style: TextStyle(
                                                              fontSize: 12)),
                                                      Text("Keluar (kg)",
                                                          style: TextStyle(
                                                              fontSize: 12)),
                                                      Text(
                                                          dataharian[index][
                                                                      'stokkeluar']
                                                                  .toString() +
                                                              "",
                                                          style: TextStyle(
                                                              fontSize: 20))
                                                    ],
                                                  )
                                                ],
                                              )
                                            ],
                                          ),
                                        )
                                      ],
                                    )));
                          },
                          separatorBuilder: (_, __) {
                            return Divider(
                              height: 10,
                            );
                          },
                        ),
                      ),
                    )
                  ]),
                  Column(children: [
                    Expanded(
                      child: Scrollbar(
                        child: ListView.separated(
                          padding: EdgeInsets.symmetric(vertical: 20),
                          itemCount: databulanan.length,
                          itemBuilder: (context, index) {
                            return Card(
                                elevation: 3,
                                margin: EdgeInsets.symmetric(horizontal: 20),
                                child: Container(
                                    padding: EdgeInsets.all(0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          padding: EdgeInsets.all(5),
                                          color: index % 2 == 0
                                              ? Colors.green.shade100
                                              : Colors.green.shade300,
                                          height: 22,
                                          width: double.infinity,
                                          child: Text(
                                            DateFormat.MMMM()
                                                    .format(databulanan[index]
                                                        ['date'])
                                                    .toString()
                                                    .substring(0, 3) +
                                                "-" +
                                                DateFormat.y()
                                                    .format(databulanan[index]
                                                        ['date'])
                                                    .toString(),
                                            style: TextStyle(fontSize: 12),
                                          ),
                                        ),
                                        SizedBox(height: 10),
                                        Container(
                                          padding: EdgeInsets.fromLTRB(
                                              10, 0, 10, 10),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    children: [
                                                      Container(
                                                          width: 50,
                                                          child:
                                                              Text("Masuk:")),
                                                      Text(
                                                          "Rp " +
                                                              FlutterMoneyFormatter(
                                                                      amount: databulanan[index]
                                                                              [
                                                                              'pemasukan']
                                                                          .toDouble())
                                                                  .output
                                                                  .withoutFractionDigits,
                                                          style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold))
                                                    ],
                                                  ),
                                                  SizedBox(
                                                    height: 5,
                                                  ),
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    children: [
                                                      Container(
                                                          width: 50,
                                                          child:
                                                              Text("Keluar:")),
                                                      Text(
                                                        "Rp " +
                                                            FlutterMoneyFormatter(
                                                                    amount: databulanan[index]
                                                                            [
                                                                            'pengeluaran']
                                                                        .toDouble())
                                                                .output
                                                                .withoutFractionDigits,
                                                        style: TextStyle(
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      ),
                                                    ],
                                                  )
                                                ],
                                              ),
                                              Row(
                                                children: [
                                                  Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .center,
                                                    children: [
                                                      Text(
                                                        "Stok",
                                                        style: TextStyle(
                                                            fontSize: 12),
                                                      ),
                                                      Text("Masuk (kg)",
                                                          style: TextStyle(
                                                              fontSize: 12)),
                                                      Text(
                                                          databulanan[index]
                                                                  ['stokmasuk']
                                                              .toString(),
                                                          style: TextStyle(
                                                              fontSize: 20))
                                                    ],
                                                  ),
                                                  SizedBox(
                                                    width: 10,
                                                  ),
                                                  Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .center,
                                                    children: [
                                                      Text("Stok",
                                                          style: TextStyle(
                                                              fontSize: 12)),
                                                      Text("Keluar (kg)",
                                                          style: TextStyle(
                                                              fontSize: 12)),
                                                      Text(
                                                          databulanan[index][
                                                                      'stokkeluar']
                                                                  .toString() +
                                                              "",
                                                          style: TextStyle(
                                                              fontSize: 20))
                                                    ],
                                                  )
                                                ],
                                              )
                                            ],
                                          ),
                                        )
                                      ],
                                    )));
                          },
                          separatorBuilder: (_, __) {
                            return Divider(
                              height: 10,
                            );
                          },
                        ),
                      ),
                    )
                  ]),
                  Column(
                    children: [
                      Container(
                          margin: EdgeInsets.all(10),
                          child: Card(
                            elevation: 4,
                            child: Container(
                              padding: EdgeInsets.symmetric(vertical: 10),
                              width: double.infinity,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Text("Hutang"),
                                      SizedBox(
                                        height: 5,
                                      ),
                                      Text(
                                          FlutterMoneyFormatter(
                                                  amount: jumlahhutang)
                                              .output
                                              .withoutFractionDigits,
                                          style: TextStyle(fontSize: 22)),
                                    ],
                                  ),
                                  Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Text("Piutang"),
                                      SizedBox(
                                        height: 5,
                                      ),
                                      Text(
                                          FlutterMoneyFormatter(
                                                  amount: jumlahpiutang)
                                              .output
                                              .withoutFractionDigits,
                                          style: TextStyle(fontSize: 22))
                                    ],
                                  )
                                ],
                              ),
                            ),
                          )),
                      Expanded(
                          child: ListView(
                        children: hutangpiutang,
                      )),
                    ],
                  ),
                ],
              );
            }),
      ),
    );
  }
}
