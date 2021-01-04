import 'package:flutter/material.dart';
import 'package:sijubel/screens/transaksi/input_jumlah.dart';
import '../../models/Transaksi.dart';
import './input_jumlah.dart';

class InputBerat extends StatefulWidget {
  InputBerat(this.transaksi);

  Transaksi transaksi;
  TextEditingController _fieldBerat = new TextEditingController();

  @override
  _InputBeratState createState() => _InputBeratState();
}

class _InputBeratState extends State<InputBerat> {
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
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(20),
              child: Text(
                "Berapa Kg?",
                style: TextStyle(fontSize: 20),
              ),
            ),
            TextField(
              style: TextStyle(fontSize: 30),
              autofocus: true,
              textInputAction: TextInputAction.go,
              onSubmitted: (value) {
                if (widget._fieldBerat.text.isEmpty) {
                  setState(() {
                    _empty = true;
                  });
                } else {
                  widget.transaksi.berat =
                      double.parse(widget._fieldBerat.text);
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => InputJumlah(
                                widget.transaksi,
                              )));
                }
              },
              textAlign: TextAlign.center,
              controller: widget._fieldBerat,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                  contentPadding: EdgeInsets.symmetric(horizontal: 20),
                  errorText: _empty ? "Berat tidak boleh kosong!" : null),
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  RaisedButton(
                    child: Text("Kembali"),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                  RaisedButton(
                    child: Row(children: [
                      Text("Lanjut"),
                      SizedBox(
                        width: 5,
                      ),
                      Icon(
                        Icons.arrow_forward_ios,
                        size: 12,
                      )
                    ]),
                    onPressed: () {
                      if (widget._fieldBerat.text.isEmpty) {
                        setState(() {
                          _empty = true;
                        });
                      } else {
                        widget.transaksi.berat =
                            double.parse(widget._fieldBerat.text);
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => InputJumlah(
                                      widget.transaksi,
                                    )));
                      }
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
