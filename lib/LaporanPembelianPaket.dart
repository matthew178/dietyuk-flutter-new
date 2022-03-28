import 'package:dietyukapp/ClassBeliPaket.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/painting.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'ClassUser.dart';
import 'session.dart' as session;
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'package:intl/intl.dart';
import 'showHTMLPage.dart';
import 'ClassHistoryTransaksi.dart';

class LaporanPembelianPaket extends StatefulWidget {
  @override
  LaporanPembelianPaketState createState() => LaporanPembelianPaketState();
}

class LaporanPembelianPaketState extends State<LaporanPembelianPaket> {
  List<Transaksibelipaket> arrTransaksi = new List();
  List<Transaksibelipaket> onProses = new List();
  List<Transaksibelipaket> selesai = new List();
  List<Transaksibelipaket> batal = new List();
  String foto = session.ipnumber + "/gambar/wanita.png";
  ClassUser userprofile = new ClassUser(
      "", "", "", "", "", "", "", "", "", "", "", "0", "0", "", "", "", "");
  NumberFormat frmt = new NumberFormat(",000");
  List<Transaksibelipaket> arrHistory = new List();
  List<Transaksibelipaket> arrTemp = new List();
  List<String> jenis = [
    "Semua Transaksi",
    "Belum Aktivasi",
    "Sedang Berjalan",
    "Selesai",
    "Cancel"
  ];
  String jenistrans = "Semua Transaksi";

  @override
  void initState() {
    super.initState();
    getTransaksiBelumSelesai();
    getTransaksiSelesai();
    getTransaksiBatal();
    transaksiOnProses();
    onChangedDrop();
  }

  void sesuaikanTransaksi() {
    arrTemp.clear();
    setState(() {
      for (int i = 0; i < arrTransaksi.length; i++) {
        arrTemp.add(arrTransaksi[i]);
      }
      for (int i = 0; i < onProses.length; i++) {
        arrTemp.add(onProses[i]);
      }
      for (int i = 0; i < selesai.length; i++) {
        arrTemp.add(selesai[i]);
      }
      for (int i = 0; i < batal.length; i++) {
        arrTemp.add(batal[i]);
      }

      arrTemp.sort((a, b) => a.tanggalbeli.compareTo(b.tanggalbeli));
    });
    print(arrTemp.length.toString() + " data");
  }

  void onChangedDrop() {
    setState(() {
      if (jenistrans == "Semua Transaksi") {
        this.arrHistory = arrTemp;
      } else if (jenistrans == "Belum Aktivasi") {
        this.arrHistory = arrTransaksi;
      } else if (jenistrans == "Sedang Berjalan") {
        this.arrHistory = onProses;
      } else if (jenistrans == "Selesai") {
        this.arrHistory = selesai;
      } else if (jenistrans == "Cancel") {
        this.arrHistory = batal;
      }
    });
  }

  Future<List<Transaksibelipaket>> getTransaksiBelumSelesai() async {
    List<Transaksibelipaket> arrTrans = new List();
    Map paramData = {'user': session.userlogin};
    var parameter = json.encode(paramData);
    http
        .post(Uri.parse(session.ipnumber + "/getPaketBelumSelesai"),
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
      setState(() => this.arrTransaksi = arrTrans);
      print("arrTrans : " + arrTransaksi.length.toString());
      sesuaikanTransaksi();
      return arrTrans;
    }).catchError((err) {
      print(err);
    });
  }

  Future<List<Transaksibelipaket>> transaksiOnProses() async {
    List<Transaksibelipaket> arrTrans = new List();
    Map paramData = {'user': session.userlogin};
    var parameter = json.encode(paramData);
    http
        .post(Uri.parse(session.ipnumber + "/paketOnProses"),
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
      setState(() => this.onProses = arrTrans);
      print("onProses : " + onProses.length.toString());

      sesuaikanTransaksi();

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
        .post(Uri.parse(session.ipnumber + "/getTransaksiSelesai"),
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
      print("selesai : " + selesai.length.toString());

      sesuaikanTransaksi();

      return arrTrans;
    }).catchError((err) {
      print(err);
    });
  }

  Future<List<Transaksibelipaket>> getTransaksiBatal() async {
    List<Transaksibelipaket> arrTrans = new List();
    Map paramData = {'user': session.userlogin};
    var parameter = json.encode(paramData);
    http
        .post(Uri.parse(session.ipnumber + "/getTransaksiBatal"),
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
      setState(() => this.batal = arrTrans);
      print("batal : " + batal.length.toString());

      sesuaikanTransaksi();

      return arrTrans;
    }).catchError((err) {
      print(err);
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
        backgroundColor: Color.fromRGBO(38, 81, 158, 1),
        body: ListView(
          children: [
            Container(
                padding: EdgeInsets.fromLTRB(20, 20, 20, 20),
                child: Row(
                  children: [
                    Text("Status Paket : ",
                        style: TextStyle(color: Colors.white, fontSize: 20)),
                    Container(
                      color: Colors.white,
                      margin: EdgeInsets.fromLTRB(30, 10, 10, 0),
                      child: DropdownButton<String>(
                        hint: Text("--Status Paket--"),
                        value: jenistrans,
                        onChanged: (String Value) {
                          setState(() {
                            jenistrans = Value;
                            onChangedDrop();
                            print("arrhistory = " +
                                arrHistory.length.toString() +
                                " data");
                          });
                        },
                        items: jenis.map((String namajenis) {
                          return DropdownMenuItem<String>(
                            value: namajenis,
                            child: Row(
                              children: <Widget>[
                                Text(
                                  namajenis,
                                  style: TextStyle(color: Colors.black),
                                ),
                              ],
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  ],
                )),
            Container(
                height: size.height,
                child: ListView.builder(
                    itemCount: arrHistory.length == 0 ? 1 : arrHistory.length,
                    itemBuilder: (context, index) {
                      if (arrHistory.length == 0) {
                        return Container(
                            padding: EdgeInsets.all(20),
                            color: Colors.white,
                            child: Text("Tidak Ada Transaksi Pembelian Paket",
                                style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold)));
                      } else {
                        return SizedBox(
                            height: 125,
                            child: Card(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Container(
                                          padding: EdgeInsets.only(left: 10),
                                          child: Text(
                                              "Tanggal Beli : " +
                                                  arrHistory[index].tanggalbeli,
                                              style:
                                                  TextStyle(letterSpacing: 1))),
                                    ],
                                  ),
                                  Divider(height: 5, color: Colors.black),
                                  Container(
                                      padding: EdgeInsets.only(left: 10),
                                      child: Text(
                                          arrHistory[index].namapaket +
                                              " by " +
                                              arrHistory[index].namakonsultan,
                                          style: TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.bold))),
                                  SizedBox(height: 15),
                                  Row(
                                    children: [
                                      Container(
                                        padding: EdgeInsets.only(left: 10),
                                        width: size.width / 2,
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            arrHistory[index].status == "2" ||
                                                    arrHistory[index].status ==
                                                        "5" ||
                                                    arrHistory[index].status ==
                                                        "1"
                                                ? Container(
                                                    child: Text(
                                                        "Tanggal Aktivasi : " +
                                                            arrHistory[index]
                                                                .tanggalaktivasi))
                                                : Container(
                                                    child: Text(
                                                        "Tanggal Aktivasi : -")),
                                            arrHistory[index].status == "2" ||
                                                    arrHistory[index].status ==
                                                        "5" ||
                                                    arrHistory[index].status ==
                                                        "1"
                                                ? Container(
                                                    child: Text(
                                                        "Tanggal Selesai : " +
                                                            arrHistory[index]
                                                                .tanggalselesai))
                                                : Container(
                                                    child: Text(
                                                        "Tanggal Selesai : -"))
                                          ],
                                        ),
                                      ),
                                      Container(
                                        padding: EdgeInsets.only(right: 10),
                                        width: size.width / 2.1,
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.end,
                                          children: [
                                            Text(
                                              "Rp. " +
                                                  frmt.format(int.parse(
                                                      arrHistory[index]
                                                          .totalharga)),
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold),
                                            )
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                  Divider(height: 5, color: Colors.black),
                                  Container(
                                      padding: EdgeInsets.only(left: 10),
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text("Status : "),
                                          arrHistory[index].status == "0"
                                              ? Text(
                                                  "Belum Aktif",
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors.grey[700]),
                                                )
                                              : arrHistory[index].status == "1"
                                                  ? Text(
                                                      "Sedang Berjalan",
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          color: Colors.blue),
                                                    )
                                                  : arrHistory[index].status ==
                                                              "2" ||
                                                          arrHistory[index]
                                                                  .status ==
                                                              "5"
                                                      ? Text(
                                                          "Selesai",
                                                          style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              color:
                                                                  Colors.green),
                                                        )
                                                      : Text(
                                                          "Cancel",
                                                          style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              color:
                                                                  Colors.red),
                                                        )
                                        ],
                                      ))
                                ],
                              ),
                            ));
                      }
                    }))
          ],
        ));
  }
}
