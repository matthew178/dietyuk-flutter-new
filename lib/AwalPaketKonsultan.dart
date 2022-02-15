import 'package:flutter/cupertino.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';

import 'ClassUser.dart';
import 'EditJadwalBeli.dart';
import 'JadwalHarian.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'ClassAwalPaket.dart';
import 'session.dart' as session;
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'ClassPaket.dart';
import 'dart:async';
import 'dart:convert';
import 'dart:math';

class AwalPaketKonsultan extends StatefulWidget {
  final String id;
  final String paket;

  AwalPaketKonsultan({Key key, @required this.id, @required this.paket})
      : super(key: key);

  @override
  AwalPaketKonsultanState createState() =>
      AwalPaketKonsultanState(this.id, this.paket);
}

class AwalPaketKonsultanState extends State<AwalPaketKonsultan> {
  String week = "1";
  ClassPaket paketsekarang = new ClassPaket("id", "estimasi", "0", "durasi",
      "status", "", "konsultan", "namapaket1", "deskripsi", "default.jpg");
  String id, paket;
  // List<DetailBeli> detail = new List();
  // List<DetailBeli> tempDetail = new List();
  // List<ClassPerkembangan> arrLaporan = new List();
  List<ClassAwalPaket> arrTemp = [];
  List<ClassAwalPaket> arrAwal = [];
  TextEditingController timbang = new TextEditingController();
  ClassUser usertemp = new ClassUser(
      "id",
      "username",
      "email",
      "password",
      "nama",
      "jeniskelamin",
      "nomorhp",
      "tanggallahir",
      "berat",
      "tinggi",
      "role",
      "saldo",
      "rating",
      "status",
      "foto",
      "provinsi",
      "kota");
  int durasi = 5;
  int tmp = 1;
  DateTime now = DateTime.now();
  DateTime ultah;
  int tahun = 0, bulan = 0, hari = 0;
  double bmr = 0.0;

  AwalPaketKonsultanState(this.id, this.paket);

  @override
  void initState() {
    super.initState();
    getPaket();
    getDetail();
    getDataCustomer();
  }

  Future<ClassUser> getDataCustomer() async {
    ClassUser temp;
    Map paramData = {'id': id};
    var parameter = json.encode(paramData);
    http
        .post(Uri.parse(session.ipnumber + "/getDataCustomer"),
            headers: {"Content-Type": "application/json"}, body: parameter)
        .then((res) {
      print(res.body);
      var data = json.decode(res.body);
      data = data[0]['profile'];
      temp = ClassUser(
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
      setState(() => this.usertemp = temp);
      print("Nama : " + usertemp.nama);
      ultah = DateTime.parse(usertemp.tanggallahir);
      var diff = now.difference(ultah).inDays;
      tahun = diff ~/ 365;
      bulan = (diff - tahun * 365) ~/ 30;
      hari = diff - (tahun * 365) - (bulan * 30); // masih salah
      setState(() {
        if (usertemp.jeniskelamin == "pria") {
          bmr = 66.5 +
              (13.7 * double.parse(usertemp.berat)) +
              (5 * double.parse(usertemp.tinggi) - (6.8 * tahun));
        } else {
          bmr = 655 +
              (9.6 * double.parse(usertemp.berat)) +
              (1.8 * double.parse(usertemp.tinggi) - (4.7 * tahun));
        }
      });
    }).catchError((err) {
      print(err);
    });
    return temp;
  }

  Future<List<ClassAwalPaket>> getDetail() async {
    arrAwal.clear();
    Map paramData = {'id': id};
    var parameter = json.encode(paramData);
    ClassAwalPaket databaru =
        new ClassAwalPaket("id", "hari", "tanggal", "week", "status");
    int week = 0;
    http
        .post(Uri.parse(session.ipnumber + "/getdetailbeli"),
            headers: {"Content-Type": "application/json"}, body: parameter)
        .then((res) {
      var returndata = json.decode(res.body);
      var data = returndata[0]['detail'];
      for (int i = 0; i < data.length; i++) {
        week = ((int.parse(data[i]['hari'].toString()) - 1) ~/ 7).toInt() + 1;
        databaru = ClassAwalPaket("0", data[i]['hari'].toString(),
            data[i]['tanggal'].toString(), week.toString(), "hari");
        arrAwal.add(databaru);
      }
      data = returndata[0]['laporan'];
      for (int i = 0; i < data.length; i++) {
        week = ((int.parse(data[i]['harike'].toString()) - 1) ~/ 7).toInt() + 1;
        databaru = ClassAwalPaket(
            data[i]['id'].toString(),
            data[i]['harike'].toString(),
            data[i]['tanggal'].toString(),
            week.toString(),
            "laporan");
        databaru.setberat(int.parse(data[i]['berat'].toString()));
        databaru.setidbeli(data[i]['idbeli'].toString());
        databaru.setketerangan(data[i]['status'].toString());
        databaru.setidbeli(data[i]['idbeli'].toString());
        arrAwal.add(databaru);
      }
      arrAwal.sort((a, b) => int.parse(a.hari).compareTo(int.parse(b.hari)));

      sesuaikanHari(1);
    }).catchError((err) {
      print(err);
    });
    return arrAwal;
  }

  void sesuaikanHari(int week) {
    List<ClassAwalPaket> tempDetail = [];
    for (int i = 0; i < arrAwal.length; i++) {
      if (arrAwal[i].week == week.toString()) {
        tempDetail.add(arrAwal[i]);
      }
    }
    setState(() => this.arrTemp = tempDetail);
  }

  Future<ClassPaket> getPaket() async {
    ClassPaket arrPaket = new ClassPaket(
        "id",
        "estimasi",
        "harga",
        "durasi",
        "status",
        "rating",
        "konsultan",
        "namapaket",
        "deskripsi",
        "default.jpg");
    Map paramData = {'id': paket};
    var parameter = json.encode(paramData);
    http
        .post(Uri.parse(session.ipnumber + "/getpaketbyid"),
            headers: {"Content-Type": "application/json"}, body: parameter)
        .then((res) {
      var data = json.decode(res.body);
      data = data[0]['paket'];
      arrPaket = ClassPaket(
          data[0]['id_paket'].toString(),
          data[0]['estimasiturun'].toString(),
          data[0]['harga'].toString(),
          data[0]['durasi'].toString(),
          data[0]['status'].toString(),
          data[0]['rating'].toString(),
          data[0]['nama'].toString(),
          data[0]['nama_paket'].toString(),
          data[0]['deskripsi'].toString(),
          data[0]['gambar'].toString());
      if (int.parse(data[0]['durasi'].toString()) % 7 == 0) {
        durasi = int.parse(data[0]['durasi'].toString()) ~/ 7;
      } else {
        durasi = int.parse(data[0]['durasi'].toString()) ~/ 7 + 1;
      }
      setState(() => this.paketsekarang = arrPaket);
    }).catchError((err) {
      print(err);
    });
    return arrPaket;
  }

  // Future<ClassPerkembangan> tambahPerkembangan(
  //     String id, brt, stts, idbeli, harike) async {
  //   Map paramData = {
  //     'id': id,
  //     'berat': brt,
  //     'status': stts,
  //     'user': session.userlogin,
  //     'idbeli': idbeli,
  //     'harike': harike
  //   };
  //   var parameter = json.encode(paramData);
  //   http
  //       .post(Uri.parse(session.ipnumber + "/tambahPerkembangan"),
  //           headers: {"Content-Type": "application/json"}, body: parameter)
  //       .then((res) {
  //     print(res.body);
  //     getDetail();
  //   }).catchError((err) {
  //     print(err);
  //   });
  // }

  Future<void> evtSebelum() async {
    if (int.parse(week) <= 1) {
      setState(() {
        week = durasi.toString();
      });
    } else {
      setState(() {
        week = (int.parse(week) - 1).toString();
      });
    }
    sesuaikanHari(int.parse(week));
  }

  Future<void> evtSesudah() async {
    if (int.parse(week) >= durasi) {
      setState(() {
        week = "1";
      });
    } else {
      setState(() {
        week = (int.parse(week) + 1).toString();
      });
    }
    sesuaikanHari(int.parse(week));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Program Diet"),
        backgroundColor: session.warna,
      ),
      body: Center(
        child: Column(
          children: [
            Expanded(
              flex: 2,
              child: Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      flex: 1,
                      child: RaisedButton(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(2),
                        ),
                        onPressed: () {
                          evtSebelum();
                        },
                        color: Colors.lightBlueAccent,
                        child: Text(
                          '<',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                    Expanded(
                        flex: 2,
                        child: Text(
                          "Minggu " + week.toString(),
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 20, fontFamily: 'Biryani'),
                        )),
                    Expanded(
                      flex: 1,
                      child: RaisedButton(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(2),
                        ),
                        onPressed: () {
                          evtSesudah();
                        },
                        color: Colors.lightBlueAccent,
                        child: Text(
                          '>',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
            Expanded(
              flex: 4,
              child: Container(
                  padding: EdgeInsets.fromLTRB(20, 5, 0, 10),
                  margin: EdgeInsets.fromLTRB(10, 0, 10, 0),
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.black),
                      color: Colors.yellow[100],
                      borderRadius: BorderRadius.all(Radius.circular(20))),
                  child: Container(
                      child: Row(
                    children: [
                      Expanded(
                          flex: 3,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Nama : ",
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold)),
                              Text(usertemp.nama,
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15)),
                              SizedBox(height: 5),
                              Text("Usia :",
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold)),
                              Text(
                                  tahun.toString() +
                                      " tahun " +
                                      bulan.toString() +
                                      " bulan ",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15)),
                              SizedBox(height: 5),
                              Text("Jenis Kelamin : ",
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold)),
                              Text(usertemp.jeniskelamin,
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15)),
                            ],
                          )),
                      Container(
                          child: VerticalDivider(
                              color: Colors.black,
                              thickness: 1,
                              indent: 10,
                              endIndent: 0,
                              width: 20)),
                      Expanded(
                          flex: 3,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Tinggi Badan : ",
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold)),
                              Text(usertemp.tinggi + " cm",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15)),
                              SizedBox(height: 5),
                              Text("Berat Badan : ",
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold)),
                              Text(usertemp.berat + " kg",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15)),
                              SizedBox(height: 5),
                              Text("BMR : ",
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold)),
                              Text(bmr.toString() + " kkal",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15)),
                            ],
                          )),
                    ],
                  ))),
            ),
            Expanded(
                flex: 2,
                child: Row(
                  children: [
                    SizedBox(width: 50),
                    Expanded(
                      flex: 3,
                      child: RaisedButton(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(2),
                        ),
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      EditJadwalBeli(id: id, paket: paket)));
                        },
                        color: Colors.lightBlueAccent,
                        child: Text(
                          'Chat',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                    Expanded(child: SizedBox(), flex: 3),
                    Expanded(
                      flex: 3,
                      child: RaisedButton(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(2),
                        ),
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      EditJadwalBeli(id: id, paket: paket)));
                        },
                        color: Colors.lightBlueAccent,
                        child: Text(
                          'Edit Jadwal',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: SizedBox(),
                    )
                  ],
                )),
            SizedBox(height: 15),
            Expanded(
                flex: 10,
                child: GridView.count(
                    crossAxisCount: 3,
                    crossAxisSpacing: 10.0,
                    mainAxisSpacing: 10.0,
                    children: List.generate(arrTemp.length, (index) {
                      return GestureDetector(
                          onTap: () {
                            arrTemp[index].tipe == "hari"
                                ? Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => JadwalHarian(
                                            week: week,
                                            idbeli: id,
                                            hari: arrTemp[index].hari,
                                            tipe: 2)))
                                : arrTemp[index].keterangan == "3"
                                    ? Fluttertoast.showToast(
                                        msg: "Tidak ada perkembangan")
                                    : arrTemp[index].keterangan == "2"
                                        ? Fluttertoast.showToast(
                                            msg: "Berat badan naik")
                                        : arrTemp[index].keterangan == "1"
                                            ? Fluttertoast.showToast(
                                                msg: "Turun berat badan")
                                            : Fluttertoast.showToast(
                                                msg:
                                                    "Belum ada laporan perkembangan");
                          },
                          child: arrTemp[index].tipe == "hari"
                              ? Card(
                                  color: Colors.grey,
                                  elevation: 10.0,
                                  child: Center(
                                    child: Column(
                                      children: [
                                        Expanded(
                                            flex: 1,
                                            child: Text(
                                              "Hari " + arrTemp[index].hari,
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.bold,
                                                  fontFamily: 'Biryani'),
                                            )),
                                        Expanded(
                                            flex: 1,
                                            child: Text(
                                              arrTemp[index].tanggal,
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.bold,
                                                  fontFamily: 'Biryani'),
                                            ))
                                      ],
                                    ),
                                  ))
                              : arrTemp[index].keterangan == "0"
                                  ? Card(
                                      color: Colors.grey,
                                      elevation: 10.0,
                                      child: Center(
                                        child: Column(
                                          children: [
                                            Expanded(
                                                flex: 1,
                                                child: Text(
                                                  "Hari " + arrTemp[index].hari,
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontFamily: 'Biryani'),
                                                )),
                                            Expanded(
                                                flex: 1,
                                                child: Text(
                                                  arrTemp[index].tanggal,
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontFamily: 'Biryani'),
                                                )),
                                            Expanded(
                                                flex: 2,
                                                child: Text(
                                                  arrTemp[index]
                                                      .berat
                                                      .toString(),
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 30,
                                                      fontFamily: 'Biryani'),
                                                ))
                                          ],
                                        ),
                                      ))
                                  : arrTemp[index].keterangan == "1"
                                      ? Card(
                                          color: Colors.green,
                                          elevation: 10.0,
                                          child: Center(
                                            child: Column(
                                              children: [
                                                Expanded(
                                                    flex: 1,
                                                    child: Text(
                                                      "Hari " +
                                                          arrTemp[index].hari,
                                                      style: TextStyle(
                                                          color: Colors.white,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontFamily:
                                                              'Biryani'),
                                                    )),
                                                Expanded(
                                                    flex: 1,
                                                    child: Text(
                                                      arrTemp[index].tanggal,
                                                      style: TextStyle(
                                                          color: Colors.white,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontFamily:
                                                              'Biryani'),
                                                    )),
                                                Expanded(
                                                    flex: 2,
                                                    child: Text(
                                                      arrTemp[index]
                                                          .berat
                                                          .toString(),
                                                      style: TextStyle(
                                                          color: Colors.white,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 30,
                                                          fontFamily:
                                                              'Biryani'),
                                                    )),
                                                Expanded(
                                                  flex: 1,
                                                  child: Row(
                                                    children: [
                                                      Expanded(
                                                        flex: 1,
                                                        child: SizedBox(),
                                                      ),
                                                      Expanded(
                                                          child: Icon(
                                                        Icons.arrow_downward,
                                                        color: Colors.white,
                                                      ))
                                                    ],
                                                  ),
                                                ),
                                                SizedBox(height: 10)
                                              ],
                                            ),
                                          ))
                                      : arrTemp[index].keterangan == "2"
                                          ? Card(
                                              color: Colors.red,
                                              elevation: 10.0,
                                              child: Center(
                                                child: Column(
                                                  children: [
                                                    Expanded(
                                                        flex: 1,
                                                        child: Text(
                                                          "Hari " +
                                                              arrTemp[index]
                                                                  .hari,
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.white,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              fontFamily:
                                                                  'Biryani'),
                                                        )),
                                                    Expanded(
                                                        flex: 1,
                                                        child: Text(
                                                          arrTemp[index]
                                                              .tanggal,
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.white,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              fontFamily:
                                                                  'Biryani'),
                                                        )),
                                                    Expanded(
                                                        flex: 2,
                                                        child: Text(
                                                          arrTemp[index]
                                                              .berat
                                                              .toString(),
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.white,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              fontSize: 30,
                                                              fontFamily:
                                                                  'Biryani'),
                                                        )),
                                                    Expanded(
                                                      flex: 1,
                                                      child: Row(
                                                        children: [
                                                          Expanded(
                                                            flex: 1,
                                                            child: SizedBox(),
                                                          ),
                                                          Expanded(
                                                              child: Icon(
                                                            Icons.arrow_upward,
                                                            color: Colors.white,
                                                          ))
                                                        ],
                                                      ),
                                                    ),
                                                    SizedBox(height: 10)
                                                  ],
                                                ),
                                              ))
                                          : Card(
                                              color: Colors.blue,
                                              elevation: 10.0,
                                              child: Center(
                                                child: Column(
                                                  children: [
                                                    Expanded(
                                                        flex: 1,
                                                        child: Text(
                                                          "Hari " +
                                                              arrTemp[index]
                                                                  .hari,
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.white,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              fontFamily:
                                                                  'Biryani'),
                                                        )),
                                                    Expanded(
                                                        flex: 1,
                                                        child: Text(
                                                          arrTemp[index]
                                                              .tanggal,
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.white,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              fontFamily:
                                                                  'Biryani'),
                                                        )),
                                                    Expanded(
                                                        flex: 2,
                                                        child: Text(
                                                          arrTemp[index]
                                                              .berat
                                                              .toString(),
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.white,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              fontSize: 30,
                                                              fontFamily:
                                                                  'Biryani'),
                                                        )),
                                                    Expanded(
                                                      flex: 1,
                                                      child: Row(
                                                        children: [
                                                          Expanded(
                                                            flex: 1,
                                                            child: SizedBox(),
                                                          ),
                                                          Expanded(
                                                              child:
                                                                  Image.asset(
                                                            'assets/images/equals.png',
                                                            height: 50,
                                                            width: 50,
                                                          ))
                                                        ],
                                                      ),
                                                    ),
                                                    SizedBox(height: 10)
                                                  ],
                                                ),
                                              )));
                    })))
          ],
        ),
      ),
    );
  }
}
