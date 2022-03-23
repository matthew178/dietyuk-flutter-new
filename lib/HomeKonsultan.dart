import 'package:dietyukapp/DaftarPaketKonsultan.dart';
import 'package:dietyukapp/DaftarProduk.dart';
import 'package:dietyukapp/PilihOrder.dart';
import 'package:dietyukapp/Pilih_Laporan_Konsultan.dart';
import 'package:dietyukapp/tdeecalculator.dart';

import 'DaftarPaket.dart';
import 'DaftarProdukMember.dart';
import 'DaftarTransaksiMember.dart';
import 'pilihproduk.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hexcolor/hexcolor.dart';
import 'session.dart' as session;
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'ClassUser.dart';
import 'package:intl/intl.dart';

class Homekonsultan extends StatefulWidget {
  @override
  HomekonsultanState createState() => HomekonsultanState();
}

class HomekonsultanState extends State<Homekonsultan> {
  NumberFormat frmt = new NumberFormat(',000');

  String foto = session.ipnumber + "/gambar/wanita.png";
  ClassUser userprofile = new ClassUser(
      "1",
      "coba1",
      "coba1",
      "123",
      "Matthew",
      "pria",
      "08219",
      "tanggallahir",
      "berat",
      "tinggi",
      "role",
      "0",
      "rating",
      "status",
      "foto",
      "",
      "");

  void initState() {
    super.initState();
    getProfile();
  }

  Future<ClassUser> getProfile() async {
    ClassUser userlog = new ClassUser(
        "", "", "", "", "", "", "", "", "", "", "", "", "0", "", "", "", "");
    Map paramData = {'id': session.userlogin};
    var parameter = json.encode(paramData);
    http
        .post(Uri.parse(session.ipnumber + "/getprofile"),
            headers: {"Content-Type": "application/json"}, body: parameter)
        .then((res) {
      print(res.body);
      var data = json.decode(res.body);
      data = data[0]['profile'];
      userlog = ClassUser(
          data[0]["id"].toString(),
          data[0]["username"].toString(),
          data[0]["email"].toString(),
          data[0]["password"].toString(),
          data[0]["nama"].toString(),
          data[0]["jeniskelamin"].toString(),
          data[0]["nomorhp"].toString(),
          data[0]["tanggallahir"].toString(),
          data[0]["berat"].toString(),
          data[0]["tinggi"].toString(),
          data[0]["role"].toString(),
          data[0]["saldo"].toString(),
          data[0]["rating"].toString(),
          data[0]["status"].toString(),
          data[0]["foto"].toString(),
          data[0]["provinsi"].toString(),
          data[0]["kota"].toString());
      setState(() => this.userprofile = userlog);
      print("foto : " + userprofile.foto);
      if (userprofile.jeniskelamin == "pria" && userprofile.foto == "pria.png")
        foto = session.ipnumber + "/gambar/pria.jpg";
      else if (userprofile.jeniskelamin == "wanita" &&
          userprofile.foto == "wanita.png")
        foto = session.ipnumber + "/gambar/wanita.png";
      else
        foto = session.ipnumber + "/gambar/" + userprofile.foto;
      return userlog;
    }).catchError((err) {
      print(err);
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
        body: Stack(
      children: <Widget>[
        Container(
          decoration: BoxDecoration(
              image: DecorationImage(
                  alignment: Alignment.topCenter,
                  image: AssetImage('assets/images/header.png'))),
        ),
        session.status == "Aktif"
            ? SafeArea(
                child: Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Column(
                      children: <Widget>[
                        Container(
                          height: 64,
                          margin: EdgeInsets.only(bottom: 30),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              CircleAvatar(
                                radius: 32,
                                backgroundImage: NetworkImage(this.foto),
                              ),
                              SizedBox(width: 16),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                    userprofile.nama,
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    userprofile.username,
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold),
                                  )
                                ],
                              )
                            ],
                          ),
                        ),
                        Row(
                          children: <Widget>[
                            Padding(
                              padding: EdgeInsets.symmetric(vertical: 5.0),
                              child: Container(
                                  height: size.height * 0.1,
                                  width: size.width * 0.9,
                                  decoration: BoxDecoration(
                                      color: HexColor("#81c3d7"),
                                      borderRadius: BorderRadius.circular(16)),
                                  child: Center(
                                    child: Row(
                                      children: [
                                        Expanded(
                                            // margin: EdgeInsets.only(left: 10),
                                            child: int.parse(
                                                        userprofile.saldo) >
                                                    1000
                                                ? Text(
                                                    " Rp. " +
                                                        frmt.format(int.parse(
                                                            userprofile.saldo)),
                                                    style: TextStyle(
                                                        fontSize: 20,
                                                        color: Colors.white),
                                                  )
                                                : Container(
                                                    padding:
                                                        EdgeInsets.fromLTRB(
                                                            0, 0, 50, 0),
                                                    child: Text(
                                                      " Rp. " +
                                                          userprofile.saldo,
                                                      style: TextStyle(
                                                          fontSize: 20,
                                                          color: Colors.white),
                                                    ),
                                                  )),
                                        SizedBox(width: 100),
                                        Expanded(
                                            child: Container(
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(16),
                                              color: HexColor("#1e96fc")),
                                          child: FlatButton(
                                            onPressed: () {
                                              Navigator.pushNamed(
                                                      context, "/saldo")
                                                  .then(
                                                      (value) => getProfile());
                                            },
                                            child: Text(
                                              'Tarik Saldo',
                                              style: session.kBodyText.copyWith(
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                        )),
                                        SizedBox(width: 5)
                                      ],
                                    ),
                                  )),
                            ),
                          ],
                        ),
                        SizedBox(height: 50),
                        Expanded(
                          child: GridView.count(
                            crossAxisCount: 2,
                            mainAxisSpacing: 10,
                            crossAxisSpacing: 10,
                            primary: false,
                            children: <Widget>[
                              GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    Daftarpaketkonsultan()))
                                        .then((value) => getProfile());
                                  },
                                  child: Card(
                                    elevation: 4,
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(50)),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: <Widget>[
                                        Image.asset(
                                          "assets/images/listpaket.png",
                                          height: 128,
                                        ),
                                        SizedBox(height: 3),
                                        Text(
                                          "Daftar Paket",
                                          style: session.cardStyle,
                                        )
                                      ],
                                    ),
                                  )),
                              GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  DaftarProduk()))
                                      .then((value) => getProfile());
                                },
                                child: Card(
                                  elevation: 4,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(50)),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      Image.asset(
                                        "assets/images/listproduk.png",
                                        height: 128,
                                      ),
                                      SizedBox(height: 3),
                                      Text(
                                        "Daftar Produk",
                                        style: session.cardStyle,
                                      )
                                    ],
                                  ),
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  PilihOrder()))
                                      .then((value) => getProfile());
                                },
                                child: Card(
                                  elevation: 4,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(50)),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      Image.asset(
                                        "assets/images/mypaket.png",
                                        height: 128,
                                      ),
                                      SizedBox(height: 3),
                                      Text(
                                        "Pesanan Saya",
                                        style: session.cardStyle,
                                      )
                                    ],
                                  ),
                                ),
                              ),
                              GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    PilihLaporanKonsultan()))
                                        .then((value) => getProfile());
                                  },
                                  child: Card(
                                    elevation: 4,
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(50)),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: <Widget>[
                                        Image.asset(
                                          "assets/images/report.png",
                                          height: 128,
                                        ),
                                        SizedBox(height: 3),
                                        Text(
                                          "Laporan",
                                          style: session.cardStyle,
                                        )
                                      ],
                                    ),
                                  )),
                              GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    tdeecalculator()))
                                        .then((value) => getProfile());
                                  },
                                  child: Card(
                                    elevation: 4,
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(50)),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: <Widget>[
                                        Image.asset(
                                          "assets/images/kalkulator.png",
                                          height: 128,
                                        ),
                                        SizedBox(height: 3),
                                        Text(
                                          "TDEE Kalkulator",
                                          style: session.cardStyle,
                                        )
                                      ],
                                    ),
                                  ))
                            ],
                          ),
                        )
                      ],
                    )),
              )
            : SafeArea(
                child: Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Column(
                      children: <Widget>[
                        Container(
                          height: 64,
                          margin: EdgeInsets.only(bottom: 30),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              CircleAvatar(
                                radius: 32,
                                backgroundImage: NetworkImage(this.foto),
                              ),
                              SizedBox(width: 16),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                    userprofile.nama,
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    userprofile.username,
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold),
                                  )
                                ],
                              )
                            ],
                          ),
                        ),
                        Row(
                          children: <Widget>[
                            Padding(
                              padding: EdgeInsets.symmetric(vertical: 5.0),
                              child: Container(
                                  height: size.height * 0.1,
                                  width: size.width * 0.9,
                                  decoration: BoxDecoration(
                                      color: HexColor("#81c3d7"),
                                      borderRadius: BorderRadius.circular(16)),
                                  child: Center(
                                    child: Row(
                                      children: [
                                        Expanded(
                                            // margin: EdgeInsets.only(left: 10),
                                            child: int.parse(
                                                        userprofile.saldo) >
                                                    1000
                                                ? Text(
                                                    " Rp. " +
                                                        frmt.format(int.parse(
                                                            userprofile.saldo)),
                                                    style: TextStyle(
                                                        fontSize: 20,
                                                        color: Colors.white),
                                                  )
                                                : Container(
                                                    padding:
                                                        EdgeInsets.fromLTRB(
                                                            0, 0, 50, 0),
                                                    child: Text(
                                                      " Rp. " +
                                                          userprofile.saldo,
                                                      style: TextStyle(
                                                          fontSize: 20,
                                                          color: Colors.white),
                                                    ),
                                                  )),
                                        SizedBox(width: 100)
                                      ],
                                    ),
                                  )),
                            ),
                          ],
                        ),
                        SizedBox(height: 50),
                        Expanded(
                          child: GridView.count(
                            crossAxisCount: 2,
                            mainAxisSpacing: 10,
                            crossAxisSpacing: 10,
                            primary: false,
                            children: <Widget>[
                              GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  PilihOrder()))
                                      .then((value) => getProfile());
                                },
                                child: Card(
                                  elevation: 4,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(50)),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      Image.asset(
                                        "assets/images/mypaket.png",
                                        height: 128,
                                      ),
                                      SizedBox(height: 3),
                                      Text(
                                        "Pesanan Saya",
                                        style: session.cardStyle,
                                      )
                                    ],
                                  ),
                                ),
                              ),
                              GestureDetector(
                                  onTap: () {
                                    Fluttertoast.showToast(msg: "Laporan");
                                  },
                                  child: Card(
                                    elevation: 4,
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(50)),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: <Widget>[
                                        Image.asset(
                                          "assets/images/report.png",
                                          height: 128,
                                        ),
                                        SizedBox(height: 3),
                                        Text(
                                          "Laporan",
                                          style: session.cardStyle,
                                        )
                                      ],
                                    ),
                                  )),
                              GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    tdeecalculator()))
                                        .then((value) => getProfile());
                                  },
                                  child: Card(
                                    elevation: 4,
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(50)),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: <Widget>[
                                        Image.asset(
                                          "assets/images/kalkulator.png",
                                          height: 128,
                                        ),
                                        SizedBox(height: 3),
                                        Text(
                                          "TDEE Kalkulator",
                                          style: session.cardStyle,
                                        )
                                      ],
                                    ),
                                  ))
                            ],
                          ),
                        )
                      ],
                    )),
              )
      ],
    ));
  }
}
