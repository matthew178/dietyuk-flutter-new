import 'package:dietyukapp/LaporanPenjualanPaket.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'ClassKategoriProduk.dart';
import 'DaftarProdukMember.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'session.dart' as session;
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

class PilihLaporanKonsultan extends StatefulWidget {
  @override
  PilihLaporanKonsultanState createState() => PilihLaporanKonsultanState();
}

class PilihLaporanKonsultanState extends State<PilihLaporanKonsultan> {
  List<ClassKategoriProduk> arrKategori = new List();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
        backgroundColor: session.warna,
        body: Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: EdgeInsets.only(top: 50),
                child: Text(
                  "Laporan",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 35,
                      fontWeight: FontWeight.bold),
                ),
              ),
              GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => LaporanPaket()));
                  },
                  child: Container(
                    margin: EdgeInsets.all(20),
                    height: 200,
                    child: Stack(
                      children: [
                        Positioned.fill(
                            child: ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: Image.asset(
                            "assets/images/Laporan_Paket.png",
                            fit: BoxFit.cover,
                          ),
                        )),
                        Positioned(
                            bottom: 0,
                            left: 0,
                            right: 0,
                            child: Container(
                              height: 170,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.only(
                                      bottomLeft: Radius.circular(20),
                                      bottomRight: Radius.circular(20)),
                                  gradient: LinearGradient(
                                      begin: Alignment.bottomCenter,
                                      end: Alignment.topCenter,
                                      colors: [
                                        Colors.black.withOpacity(0.3),
                                        Colors.transparent
                                      ])),
                            )),
                      ],
                    ),
                  )),
              GestureDetector(
                  onTap: () {},
                  child: Container(
                    margin: EdgeInsets.all(20),
                    height: 200,
                    child: Stack(
                      children: [
                        Positioned.fill(
                            child: ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: Image.asset(
                            "assets/images/Laporan_Produk.png",
                            fit: BoxFit.fill,
                          ),
                        )),
                        Positioned(
                            bottom: 0,
                            left: 0,
                            right: 0,
                            child: Container(
                              height: 170,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.only(
                                      bottomLeft: Radius.circular(20),
                                      bottomRight: Radius.circular(20)),
                                  gradient: LinearGradient(
                                      begin: Alignment.bottomCenter,
                                      end: Alignment.topCenter,
                                      colors: [
                                        Colors.black.withOpacity(0.3),
                                        Colors.transparent
                                      ])),
                            )),
                      ],
                    ),
                  ))
            ],
          ),
        ));
  }
}
