import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

import './screens/home.dart';
import './screens/login.dart';
import './screens/laporan.dart';
import './models/Transaksi.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.

  Transaksi transaksi = new Transaksi();

  @override
  Widget build(BuildContext context) {
    transaksi.username = 'Admin';
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Sistem Jual Beli (Sijubel)',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: Login(),
    );
  }
}
