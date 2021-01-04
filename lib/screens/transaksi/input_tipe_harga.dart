import 'package:flutter/material.dart';
import 'package:sijubel/screens/transaksi/input_nominal.dart';
import '../../models/Transaksi.dart';

class InputTipeHarga extends StatefulWidget {
  InputTipeHarga(this.transaksi);

  Transaksi transaksi;

  @override
  _InputTipeHargaState createState() => _InputTipeHargaState();
}

class _InputTipeHargaState extends State<InputTipeHarga> {
  bool _empty = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: widget.transaksi.jenis == 'jual'
            ? Colors.green[800]
            : Colors.red[800],
        title: Text(widget.transaksi.jenis == 'jual'
            ? "Penjualan Baru"
            : "Pembelian Baru"),
        centerTitle: true,
      ),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(20),
              child: Text(
                "Harga",
                style: TextStyle(fontSize: 20),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  RaisedButton(
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Per Kilo",
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 20),
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          Icon(
                            Icons.arrow_forward_ios,
                            size: 12,
                          )
                        ]),
                    onPressed: () {
                      widget.transaksi.tipetransaksi = "perkilo";
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => InputNominal(
                                    widget.transaksi,
                                  )));
                    },
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  RaisedButton(
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Total Harga",
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 20),
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          Icon(
                            Icons.arrow_forward_ios,
                            size: 12,
                          )
                        ]),
                    onPressed: () {
                      widget.transaksi.tipetransaksi = "totalharga";
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => InputNominal(
                                    widget.transaksi,
                                  )));
                    },
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
