import 'package:flutter/material.dart';
import '../../models/Transaksi.dart';
import './input_tipe_harga.dart';

class InputJumlah extends StatefulWidget {
  InputJumlah(this.transaksi);

  Transaksi transaksi;
  TextEditingController _fieldJumlah = new TextEditingController();

  @override
  _InputJumlahState createState() => _InputJumlahState();
}

class _InputJumlahState extends State<InputJumlah> {
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
                "Jumlah berapa ekor?",
                style: TextStyle(fontSize: 20),
              ),
            ),
            TextField(
              style: TextStyle(fontSize: 30),
              autofocus: true,
              textInputAction: TextInputAction.go,
              onSubmitted: (value) {
                if (widget._fieldJumlah.text.isEmpty) {
                  setState(() {
                    _empty = true;
                  });
                } else {
                  widget.transaksi.jumlah = int.parse(widget._fieldJumlah.text);
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => InputTipeHarga(
                                widget.transaksi,
                              )));
                }
              },
              textAlign: TextAlign.center,
              controller: widget._fieldJumlah,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                contentPadding: EdgeInsets.symmetric(horizontal: 20),
                errorText: _empty ? "Jumlah tidak boleh kosong!" : null,
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
                      if (widget._fieldJumlah.text.isEmpty) {
                        setState(() {
                          _empty = true;
                        });
                      } else {
                        widget.transaksi.jumlah =
                            int.parse(widget._fieldJumlah.text);
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => InputTipeHarga(
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
