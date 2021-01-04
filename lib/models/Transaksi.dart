import 'dart:core';
import 'package:cloud_firestore/cloud_firestore.dart';

class Transaksi {
  String username;

  String id;
  DateTime input;
  double berat;
  int jumlah;
  double hargaperkilo;
  String tujuan;
  String asal;
  double totalharga;
  String jenis;
  String tipetransaksi;
  String status;

  void clearData() {
    id = null;
    input = null;
    berat = null;
    jumlah = null;
    hargaperkilo = null;
    totalharga = null;
    tujuan = null;
    asal = null;
    status = null;
  }

  void setTime() {
    input = DateTime.now();
  }

  void setJenisJual() {
    jenis = "jual";
  }

  void setJenisBeli() {
    jenis = "beli";
  }

  void addToFirebase() {
    if (jenis == 'jual') {
      FirebaseFirestore.instance.collection('transaksi').add({
        'user': username,
        'jenis': jenis,
        'berat': berat,
        'jumlah': jumlah,
        'hargaperkilo': hargaperkilo,
        'totalharga': totalharga,
        'tujuan': tujuan,
        'input': input,
        'status': status,
        'pernahhutang': status == 'hutang' ? true : false,
        'deleterequest': false
      }).then((value) => print(value.id));
    } else {
      FirebaseFirestore.instance.collection('transaksi').add({
        'user': username,
        'jenis': jenis,
        'berat': berat,
        'jumlah': jumlah,
        'hargaperkilo': hargaperkilo,
        'totalharga': totalharga,
        'asal': asal,
        'input': input,
        'status': status,
        'pernahhutang': status == 'hutang' ? true : false,
        'deleterequest': false
      }).then((value) => print(value.id));
    }
  }
}
