import 'package:flutter/material.dart';
import '../../models/Transaksi.dart';
import './detail_transaksi.dart';

class InputTujuan extends StatefulWidget {
  InputTujuan(this.transaksi);

  Transaksi transaksi;
  TextEditingController _fieldTujuan = new TextEditingController();

  @override
  _InputTujuanState createState() => _InputTujuanState();
}

class _InputTujuanState extends State<InputTujuan> {
  bool _empty = false;

  @override
  Widget build(BuildContext context) {
    if (widget.transaksi.jenis == 'jual') {
      if (widget.transaksi.tujuan != null) {
        widget._fieldTujuan.text = widget.transaksi.tujuan;
      }
    } else {
      if (widget.transaksi.asal != null) {
        widget._fieldTujuan.text = widget.transaksi.asal;
      }
    }

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
                widget.transaksi.jenis == 'jual'
                    ? "Pembeli/Tujuan pengiriman?"
                    : "Diperoleh dari?",
                style: TextStyle(fontSize: 20),
              ),
            ),
            TextField(
              textCapitalization: TextCapitalization.sentences,
              style: TextStyle(fontSize: 30),
              textInputAction: TextInputAction.go,
              onSubmitted: (value) {
                if (widget._fieldTujuan.text.isEmpty) {
                  setState(() {
                    _empty = true;
                  });
                } else {
                  widget.transaksi.setTime();
                  widget.transaksi.jenis == 'jual'
                      ? widget.transaksi.tujuan = widget._fieldTujuan.text
                      : widget.transaksi.asal = widget._fieldTujuan.text;
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => DetailTransaksi(
                                widget.transaksi,
                              )));
                }
              },
              autofocus: true,
              textAlign: TextAlign.center,
              controller: widget._fieldTujuan,
              keyboardType: TextInputType.text,
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
                      if (widget._fieldTujuan.text.isEmpty) {
                        setState(() {
                          _empty = true;
                        });
                      } else {
                        widget.transaksi.setTime();
                        widget.transaksi.jenis == 'jual'
                            ? widget.transaksi.tujuan = widget._fieldTujuan.text
                            : widget.transaksi.asal = widget._fieldTujuan.text;
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => DetailTransaksi(
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
