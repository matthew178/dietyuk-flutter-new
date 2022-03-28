import 'package:dietyukapp/LaporanPerkembangan.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'shoppingcart.dart';
import 'package:hexcolor/hexcolor.dart';
import 'ClassPaket.dart';
import 'ClassAlamat.dart';
import 'kota.dart';
import 'provinsi.dart';

String ipnumber = "https://dietyukyuk.com/public";
int userlogin = 0;
String role = "";
int berat = 0;
int saldo = 0;
String status = "";
String qry = "";
List<shoppingcart> Cart = new List();
List<ClassPaket> paketSemua = new List();
ClassAlamat alamat = new ClassAlamat("0", "", "", "", "", "", "", "", "");
Kota kota = new Kota("", "", "", "", "", "");
Provinsi prov = new Provinsi("", "");
List<classLaporanPerkembangan> arrLaporan;

const TextStyle kBodyText = TextStyle(fontSize: 18, color: Colors.white);
const TextStyle kecil = TextStyle(fontSize: 15, color: Colors.white);
const TextStyle kradioButton = TextStyle(fontSize: 20, color: Colors.white);
const TextStyle cardStyle =
    TextStyle(fontSize: 14, fontWeight: FontWeight.bold);
const Color kWhite = Colors.white;
const Color kBlue = Colors.cyan;
Color warna = HexColor("#81c3d7");
