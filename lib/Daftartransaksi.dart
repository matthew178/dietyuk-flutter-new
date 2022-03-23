import 'package:dietyukapp/AwalPaketKonsultan.dart';
import 'package:dietyukapp/ClassBeliPaket.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'session.dart' as session;
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'ClassPaket.dart';

class Daftartransaksi extends StatefulWidget {
  @override
  DaftartransaksiState createState() => DaftartransaksiState();
}

class DaftartransaksiState extends State<Daftartransaksi> {
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
                      child: new ListView.builder(
                          itemCount: onproses.length == 0 ? 0 : onproses.length,
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
                                                    id: onproses[index].id,
                                                    paket: onproses[index]
                                                        .idpaket)));
                                  },
                                  child: Card(
                                      child: Row(
                                    children: [
                                      Container(
                                          padding: EdgeInsets.fromLTRB(
                                              10, 10, 0, 10),
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
                                              onproses[index].namapaket,
                                              style: TextStyle(
                                                fontSize: 20,
                                              ),
                                            )),
                                            Container(
                                                child: Text(onproses[index]
                                                    .namakonsultan))
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
                                              ),
                                            )),
                                            Container(
                                                child: Text(onproses[index]
                                                    .tanggalselesai))
                                          ],
                                        ),
                                      ),
                                    ],
                                  )));
                            }
                          }),
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
