import 'package:flutter/material.dart';
import '../../models/Transaksi.dart';

import './input_tujuan.dart';

class InputNominal extends StatefulWidget {
  InputNominal(this.transaksi);

  Transaksi transaksi;
  TextEditingController _fieldNominal = new TextEditingController();

  @override
  _InputNominalState createState() => _InputNominalState();
}

class _InputNominalState extends State<InputNominal> {
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
                widget.transaksi.tipetransaksi == "perkilo"
                    ? "Harga Per Kilo?"
                    : "Harga Total?",
                style: TextStyle(fontSize: 20),
              ),
            ),
            TextField(
              style: TextStyle(fontSize: 30),
              autofocus: true,
              textInputAction: TextInputAction.go,
              onSubmitted: (value) {
                if (widget._fieldNominal.text.isEmpty) {
                  setState(() {
                    _empty = true;
                  });
                } else {
                  if (widget.transaksi.tipetransaksi == "perkilo") {
                    widget.transaksi.hargaperkilo =
                        double.parse(widget._fieldNominal.text);
                    widget.transaksi.totalharga =
                        widget.transaksi.hargaperkilo * widget.transaksi.berat;
                  } else {
                    widget.transaksi.totalharga =
                        double.parse(widget._fieldNominal.text);
                    widget.transaksi.hargaperkilo =
                        widget.transaksi.totalharga / widget.transaksi.berat;
                  }

                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => InputTujuan(
                                widget.transaksi,
                              )));
                }
              },
              textAlign: TextAlign.center,
              controller: widget._fieldNominal,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                contentPadding: EdgeInsets.symmetric(horizontal: 20),
                errorText: _empty ? "Nominal tidak boleh kosong!" : null,
              ),
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
                      if (widget._fieldNominal.text.isEmpty) {
                        setState(() {
                          _empty = true;
                        });
                      } else {
                        if (widget.transaksi.tipetransaksi == "perkilo") {
                          widget.transaksi.hargaperkilo =
                              double.parse(widget._fieldNominal.text);
                          widget.transaksi.totalharga =
                              widget.transaksi.hargaperkilo *
                                  widget.transaksi.berat;
                        } else {
                          widget.transaksi.totalharga =
                              double.parse(widget._fieldNominal.text);
                          widget.transaksi.hargaperkilo =
                              widget.transaksi.totalharga /
                                  widget.transaksi.berat;
                        }

                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => InputTujuan(
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
