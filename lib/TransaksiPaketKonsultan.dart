import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'session.dart' as session;
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'ClassBeliPaket.dart';
import 'AwalPaketKonsultan.dart';

class TransaksiPaketKonsultan extends StatefulWidget {
  @override
  TransaksiPaketKonsultanState createState() => TransaksiPaketKonsultanState();
}

class TransaksiPaketKonsultanState extends State<TransaksiPaketKonsultan> {
  List<Transaksibelipaket> onproses = new List();
  List<Transaksibelipaket> selesai = new List();

  @override
  void initState() {
    super.initState();
    onProses();
    getTransaksiSelesai();
  }

  Future<List<Transaksibelipaket>> onProses() async {
    List<Transaksibelipaket> arrTrans = new List();
    Map paramData = {'user': session.userlogin};
    var parameter = json.encode(paramData);
    http
        .post(Uri.parse(session.ipnumber + "/getPaketBeliKonsultan"),
            headers: {"Content-Type": "application/json"}, body: parameter)
        .then((res) {
      var data = json.decode(res.body);
      var hitung = data[0]['hitung'];
      data = data[0]['transaksi'];
      for (int i = 0; i < data.length; i++) {
        Transaksibelipaket databaru = Transaksibelipaket(
            data[i]['id'].toString(),
            data[i]['idpaket'].toString(),
            data[i]['iduser'].toString(),
            data[i]['tanggalbeli'].toString(),
            data[i]['tanggalaktifasi'].toString(),
            data[i]['tanggalselesai'].toString(),
            data[i]['keterangan'].toString(),
            data[i]['durasi'].toString(),
            data[i]['totalharga'].toString(),
            data[i]['status'].toString(),
            data[i]['nama_paket'].toString(),
            data[i]['nama'].toString(),
            data[i]['statuskonsultan'].toString());
        databaru.perhatian = hitung[i].toString();
        arrTrans.add(databaru);
        print("ini perhatian : " + arrTrans[i].perhatian);
      }
      setState(() => this.onproses = arrTrans);
      return arrTrans;
    }).catchError((err) {
      print(err);
    });
  }

  Future<List<Transaksibelipaket>> getTransaksiSelesai() async {
    List<Transaksibelipaket> arrTrans = new List();
    Map paramData = {'user': session.userlogin};
    var parameter = json.encode(paramData);
    http
        .post(Uri.parse(session.ipnumber + "/getPaketSelesaiKonsultan"),
            headers: {"Content-Type": "application/json"}, body: parameter)
        .then((res) {
      var data = json.decode(res.body);
      data = data[0]['transaksi'];
      for (int i = 0; i < data.length; i++) {
        Transaksibelipaket databaru = Transaksibelipaket(
            data[i]['id'].toString(),
            data[i]['idpaket'].toString(),
            data[i]['iduser'].toString(),
            data[i]['tanggalbeli'].toString(),
            data[i]['tanggalaktifasi'].toString(),
            data[i]['tanggalselesai'].toString(),
            data[i]['keterangan'].toString(),
            data[i]['durasi'].toString(),
            data[i]['totalharga'].toString(),
            data[i]['status'].toString(),
            data[i]['nama_paket'].toString(),
            data[i]['nama'].toString(),
            data[i]['statuskonsultan'].toString());
        arrTrans.add(databaru);
      }
      setState(() => this.selesai = arrTrans);
      return arrTrans;
    }).catchError((err) {
      print(err);
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text("Daftar Transaksi Page"),
        backgroundColor: session.warna,
      ),
      body: DefaultTabController(
        length: 2,
        child: Scaffold(
          body: Column(
            children: <Widget>[
              SizedBox(
                height: 50,
                child: AppBar(
                  backgroundColor: session.warna,
                  bottom: TabBar(
                    tabs: [
                      Tab(
                        text: "On Proses",
                      ),
                      Tab(
                        text: "Selesai",
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: TabBarView(
                  children: [
                    Container(
                      child: Column(
                        children: [
                          Container(
                              padding: EdgeInsets.fromLTRB(20, 20, 0, 0),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("Keterangan :",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold)),
                                  Row(
                                    children: [
                                      Container(
                                          height: 10,
                                          width: 10,
                                          color: Colors.green),
                                      Container(
                                        child: Text("Tingkat Keaktifan > 60%",
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold)),
                                      ),
                                      SizedBox(width: 5),
                                      Container(
                                          height: 10,
                                          width: 10,
                                          color: Colors.yellow),
                                      Container(
                                        child: Text("Tingkat Keaktifan 30%-60%",
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold)),
                                      )
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Container(
                                          height: 10,
                                          width: 10,
                                          color: Colors.red),
                                      Container(
                                        child: Text("Tingkat Keaktifan < 30%",
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold)),
                                      )
                                    ],
                                  ),
                                ],
                              )),
                          SizedBox(height: 10),
                          SizedBox(
                              height: size.height - 210,
                              child: new ListView.builder(
                                  itemCount: onproses.length == 0
                                      ? 0
                                      : onproses.length,
                                  itemBuilder: (context, index) {
                                    if (onproses.length == 0) {
                                      return Card(
                                        child: Text("Data empty"),
                                      );
                                    } else {
                                      return GestureDetector(
                                          onTap: () {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        AwalPaketKonsultan(
                                                            id: onproses[index]
                                                                .id,
                                                            paket:
                                                                onproses[index]
                                                                    .idpaket)));
                                          },
                                          child: double.parse(onproses[index]
                                                      .perhatian) <
                                                  0.3
                                              ? Card(
                                                  color: Colors.red,
                                                  child: Row(
                                                    children: [
                                                      Container(
                                                          padding: EdgeInsets
                                                              .fromLTRB(10, 10,
                                                                  0, 10),
                                                          child: Image.asset(
                                                              'assets/images/progress.png')),
                                                      SizedBox(
                                                        width: 30,
                                                      ),
                                                      Container(
                                                        child: Column(
                                                          children: [
                                                            Container(
                                                                child: Text(
                                                              onproses[index]
                                                                  .namapaket,
                                                              style: TextStyle(
                                                                color: Colors
                                                                    .white,
                                                                fontSize: 20,
                                                              ),
                                                            )),
                                                            Container(
                                                                child: Text(
                                                              onproses[index]
                                                                  .namakonsultan,
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .white),
                                                            ))
                                                          ],
                                                        ),
                                                      ),
                                                      SizedBox(width: 50),
                                                      Container(
                                                        child: Column(
                                                          children: [
                                                            Container(
                                                                child: Text(
                                                              "Tanggal Selesai",
                                                              style: TextStyle(
                                                                  fontSize: 10,
                                                                  color: Colors
                                                                      .white),
                                                            )),
                                                            Container(
                                                                child: Text(
                                                                    onproses[
                                                                            index]
                                                                        .tanggalselesai,
                                                                    style: TextStyle(
                                                                        color: Colors
                                                                            .white)))
                                                          ],
                                                        ),
                                                      ),
                                                      SizedBox(width: 35),
                                                      SizedBox(
                                                          height: 50,
                                                          width: 50,
                                                          child: Image.asset(
                                                              'assets/images/warning.png')),
                                                    ],
                                                  ))
                                              : double.parse(onproses[index]
                                                              .perhatian) >
                                                          0.3 &&
                                                      double.parse(
                                                              onproses[index]
                                                                  .perhatian) <
                                                          0.6
                                                  ? Card(
                                                      color: Colors.yellow,
                                                      child: Row(
                                                        children: [
                                                          Container(
                                                              padding:
                                                                  EdgeInsets
                                                                      .fromLTRB(
                                                                          10,
                                                                          10,
                                                                          0,
                                                                          10),
                                                              child: Image.asset(
                                                                  'assets/images/progress.png')),
                                                          SizedBox(
                                                            width: 30,
                                                          ),
                                                          Container(
                                                            child: Column(
                                                              children: [
                                                                Container(
                                                                    child: Text(
                                                                  onproses[
                                                                          index]
                                                                      .namapaket,
                                                                  style:
                                                                      TextStyle(
                                                                    color: Colors
                                                                        .black,
                                                                    fontSize:
                                                                        20,
                                                                  ),
                                                                )),
                                                                Container(
                                                                    child: Text(
                                                                  onproses[
                                                                          index]
                                                                      .namakonsultan,
                                                                  style: TextStyle(
                                                                      color: Colors
                                                                          .black),
                                                                ))
                                                              ],
                                                            ),
                                                          ),
                                                          SizedBox(width: 50),
                                                          Container(
                                                            child: Column(
                                                              children: [
                                                                Container(
                                                                    child: Text(
                                                                  "Tanggal Selesai",
                                                                  style:
                                                                      TextStyle(
                                                                    fontSize:
                                                                        10,
                                                                  ),
                                                                )),
                                                                Container(
                                                                    child: Text(
                                                                        onproses[index]
                                                                            .tanggalselesai))
                                                              ],
                                                            ),
                                                          ),
                                                          SizedBox(width: 35),
                                                          SizedBox(
                                                              height: 50,
                                                              width: 50,
                                                              child: Image.asset(
                                                                  'assets/images/warningkuning.png')),
                                                        ],
                                                      ))
                                                  : Card(
                                                      color: Colors.green,
                                                      child: Row(
                                                        children: [
                                                          Container(
                                                              padding:
                                                                  EdgeInsets
                                                                      .fromLTRB(
                                                                          10,
                                                                          10,
                                                                          0,
                                                                          10),
                                                              child: Image.asset(
                                                                  'assets/images/progress.png')),
                                                          SizedBox(
                                                            width: 30,
                                                          ),
                                                          Container(
                                                            child: Column(
                                                              children: [
                                                                Container(
                                                                    child: Text(
                                                                  onproses[
                                                                          index]
                                                                      .namapaket,
                                                                  style:
                                                                      TextStyle(
                                                                    color: Colors
                                                                        .white,
                                                                    fontSize:
                                                                        20,
                                                                  ),
                                                                )),
                                                                Container(
                                                                    child: Text(
                                                                  onproses[
                                                                          index]
                                                                      .namakonsultan,
                                                                  style: TextStyle(
                                                                      color: Colors
                                                                          .white),
                                                                ))
                                                              ],
                                                            ),
                                                          ),
                                                          SizedBox(width: 50),
                                                          Container(
                                                            child: Column(
                                                              children: [
                                                                Container(
                                                                    child: Text(
                                                                  "Tanggal Selesai",
                                                                  style: TextStyle(
                                                                      fontSize:
                                                                          10,
                                                                      color: Colors
                                                                          .white),
                                                                )),
                                                                Container(
                                                                    child: Text(
                                                                  onproses[
                                                                          index]
                                                                      .tanggalselesai,
                                                                  style: TextStyle(
                                                                      color: Colors
                                                                          .white),
                                                                ))
                                                              ],
                                                            ),
                                                          ),
                                                          SizedBox(width: 35),
                                                          SizedBox(
                                                              height: 50,
                                                              width: 50,
                                                              child: Image.asset(
                                                                  'assets/images/good.png')),
                                                        ],
                                                      )));
                                    }
                                  }))
                        ],
                      ),
                    ),
                    Container(
                      child: new ListView.builder(
                          itemCount: selesai.length == 0 ? 0 : selesai.length,
                          itemBuilder: (context, index) {
                            if (selesai.length == 0) {
                              return Card(
                                child: Text("Data empty"),
                              );
                            } else {
                              return GestureDetector(
                                  onTap: () {},
                                  child: Card(
                                      child: Row(
                                    children: [
                                      Container(
                                          padding: EdgeInsets.fromLTRB(
                                              10, 10, 0, 10),
                                          child: Image.asset(
                                              'assets/images/done.png')),
                                      SizedBox(
                                        width: 30,
                                      ),
                                      Container(
                                        child: Column(
                                          children: [
                                            Container(
                                                child: Text(
                                              selesai[index].namapaket,
                                              style: TextStyle(
                                                fontSize: 20,
                                              ),
                                            )),
                                            Container(
                                                child: Text(selesai[index]
                                                    .namakonsultan))
                                          ],
                                        ),
                                      ),
                                    ],
                                  )));
                            }
                          }),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
