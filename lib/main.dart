import 'package:dietyukapp/LaporanPenjualanPaket.dart';
import 'package:dietyukapp/Withdrawsaldo.dart';
import 'Dashkonsultan.dart';
import 'Dashmember.dart';
import 'ForgotPassword.dart';
import 'PilihAlamat.dart';
import 'Register.dart';
import 'checkout.dart';
import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';
import 'dart:async';
import 'Login.dart';
import 'Tambahpaket.dart';
import 'EditProfile.dart';
import 'Saldo.dart';
import 'Topup.dart';
import 'TambahAlamat.dart';
import 'TambahProduk.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'dietYuk App',
      // theme: ThemeData(
      //     textTheme:
      //         // GoogleFonts.josefinSansTextTheme(Theme.of(context).textTheme),
      //         GoogleFonts.aBeeZeeTextTheme(Theme.of(context).textTheme),
      //     primarySwatch: Colors.blue,
      //     visualDensity: VisualDensity.adaptivePlatformDensity),
      initialRoute: '/',
      routes: {
        '/': (context) => Login(),
        '/register': (context) => Register(),
        '/konsultan': (context) => Dashkonsultan(),
        '/member': (context) => Dashmember(),
        '/tambahpaket': (context) => Tambahpaket(),
        '/editprofile': (context) => Editprofile(),
        '/saldo': (context) => Saldo(),
        '/topup': (context) => Topup(),
        '/withdraw': (context) => Withdrawsaldo(),
        '/tambahproduk': (context) => TambahProduk(),
        '/halamancart': (context) => Checkout(),
        '/lupapassword': (context) => ForgotPassword(),
        '/pilihAlamat': (context) => PilihAlamat(),
        '/tambahAlamat': (context) => TambahAlamat()
      },
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key key, @required this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
  }
}
