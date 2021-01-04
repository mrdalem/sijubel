import 'package:flutter/material.dart';
import 'package:flutter_money_formatter/flutter_money_formatter.dart';
import 'package:sijubel/screens/home.dart';
import '../../models/Transaksi.dart';

class DetailTransaksi extends StatefulWidget {
  DetailTransaksi(this.transaksi);

  Transaksi transaksi;
  TextEditingController _fieldBerat = new TextEditingController();
  TextEditingController _fieldJumlah = new TextEditingController();
  TextEditingController _fieldHarga = new TextEditingController();
  TextEditingController _fieldTujuan = new TextEditingController();

  @override
  _DetailTransaksiState createState() => _DetailTransaksiState();
}

class _DetailTransaksiState extends State<DetailTransaksi> {
  @override
  void initState() {
    widget._fieldBerat.text = widget.transaksi.berat.round().toString();
    widget._fieldJumlah.text = widget.transaksi.jumlah.toString();
    widget._fieldHarga.text = widget.transaksi.hargaperkilo.round().toString();
    widget.transaksi.jenis == 'jual'
        ? widget._fieldTujuan.text = widget.transaksi.tujuan
        : widget._fieldTujuan.text = widget.transaksi.asal;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: widget.transaksi.jenis == 'jual'
            ? Colors.green[800]
            : Colors.red[800],
        title: Text(widget.transaksi.jenis == 'jual'
            ? "Detail Penjualan"
            : "Detail Pembelian"),
        centerTitle: true,
      ),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        child: Card(
          elevation: 3,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            CircleAvatar(
                                child:
                                    Image.asset('assets/images/user_pic.png')),
                            SizedBox(
                              width: 10,
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Operator"),
                                Text(widget.transaksi.username),
                              ],
                            )
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(getHari(widget.transaksi.input.weekday) +
                                ", " +
                                widget.transaksi.input.day.toString() +
                                "-" +
                                widget.transaksi.input.month.toString() +
                                "-" +
                                widget.transaksi.input.year.toString()),
                            Text(
                              ((DateTime.fromMillisecondsSinceEpoch(widget
                                                  .transaksi
                                                  .input
                                                  .millisecondsSinceEpoch *
                                              1)
                                          .hour))
                                      .toString() +
                                  ":" +
                                  ((DateTime.fromMillisecondsSinceEpoch(widget
                                                  .transaksi
                                                  .input
                                                  .millisecondsSinceEpoch *
                                              1)
                                          .minute))
                                      .toString()
                                      .padLeft(2, '0') +
                                  " WITA",
                              style: TextStyle(fontSize: 12),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Expanded(flex: 3, child: Text("Berat")),
                            Expanded(
                              flex: 8,
                              child: TextField(
                                enabled: false,
                                style: TextStyle(fontSize: 16),
                                textAlign: TextAlign.left,
                                controller: widget._fieldBerat,
                                keyboardType: TextInputType.text,
                                decoration: InputDecoration(
                                  isDense: true,
                                  border: OutlineInputBorder(),
                                  contentPadding: EdgeInsets.symmetric(
                                      vertical: 5, horizontal: 5),
                                ),
                              ),
                            ),
                            Expanded(
                                flex: 1,
                                child: Text(
                                  "Kg",
                                  textAlign: TextAlign.right,
                                )),
                          ],
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Row(
                          children: [
                            Expanded(flex: 3, child: Text("Jumlah")),
                            Expanded(
                              flex: 7,
                              child: TextField(
                                enabled: false,
                                style: TextStyle(fontSize: 16),
                                textAlign: TextAlign.left,
                                controller: widget._fieldJumlah,
                                keyboardType: TextInputType.text,
                                decoration: InputDecoration(
                                  isDense: true,
                                  border: OutlineInputBorder(),
                                  contentPadding: EdgeInsets.symmetric(
                                      vertical: 5, horizontal: 5),
                                ),
                              ),
                            ),
                            Expanded(
                                flex: 2,
                                child: Text(
                                  "Ekor",
                                  textAlign: TextAlign.right,
                                )),
                          ],
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Row(
                          children: [
                            Expanded(flex: 3, child: Text("Harga")),
                            Expanded(
                              flex: 7,
                              child: TextField(
                                enabled: false,
                                style: TextStyle(fontSize: 16),
                                textAlign: TextAlign.left,
                                controller: widget._fieldHarga,
                                keyboardType: TextInputType.text,
                                decoration: InputDecoration(
                                  isDense: true,
                                  border: OutlineInputBorder(),
                                  contentPadding: EdgeInsets.symmetric(
                                      vertical: 5, horizontal: 5),
                                ),
                              ),
                            ),
                            Expanded(
                                flex: 2,
                                child: Text(
                                  "per Kg",
                                  textAlign: TextAlign.right,
                                )),
                          ],
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Row(
                          children: [
                            Expanded(
                                flex: 3,
                                child: Text(widget.transaksi.jenis == 'jual'
                                    ? "Tujuan"
                                    : "Asal")),
                            Expanded(
                              flex: 9,
                              child: TextField(
                                enabled: false,
                                style: TextStyle(fontSize: 16),
                                textAlign: TextAlign.left,
                                controller: widget._fieldTujuan,
                                keyboardType: TextInputType.text,
                                decoration: InputDecoration(
                                  isDense: true,
                                  border: OutlineInputBorder(),
                                  contentPadding: EdgeInsets.symmetric(
                                      vertical: 5, horizontal: 5),
                                ),
                              ),
                            ),
                          ],
                        ),
                        Divider(
                          height: 40,
                          color: Colors.grey[500],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("Total Harga"),
                            Text("Rp " +
                                FlutterMoneyFormatter(
                                        amount: widget.transaksi.totalharga)
                                    .output
                                    .withoutFractionDigits),
                          ],
                        )
                      ],
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Opsi Pembayaran"),
                    SizedBox(
                      height: 10,
                    ),
                    RaisedButton(
                      color: Colors.yellow.shade200,
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text("Hutang"),
                            SizedBox(
                              width: 5,
                            ),
                            // Icon(
                            //   Icons.arrow_forward_ios,
                            //   size: 12,
                            // )
                          ]),
                      onPressed: () async {
                        widget.transaksi.status = "hutang";

                        await widget.transaksi.addToFirebase();

                        widget.transaksi.clearData();

                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => Home(
                                      widget.transaksi,
                                    )));
                      },
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    RaisedButton(
                      color: Colors.green.shade200,
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text("Lunas"),
                            SizedBox(
                              width: 5,
                            ),
                            // Icon(
                            //   Icons.done,
                            //   size: 12,
                            // )
                          ]),
                      onPressed: () async {
                        widget.transaksi.status = "lunas";
                        await widget.transaksi.addToFirebase();

                        widget.transaksi.clearData();

                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => Home(
                                      widget.transaksi,
                                    )));
                      },
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

getHari(int weekday) {
  switch (weekday) {
    case 1:
      {
        return "Senin";
      }

      break;

    case 2:
      {
        return "Selasa";
      }

      break;

    case 3:
      {
        return "Rabu";
      }

      break;

    case 4:
      {
        return "Kamis";
      }

      break;

    case 5:
      {
        return "Jumat";
      }

      break;

    case 6:
      {
        return "Sabtu";
      }

      break;

    case 7:
      {
        return "Minggu";
      }

      break;
    default:
  }
}
