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

class LaporanSaldo extends StatefulWidget {
  @override
  LaporanSaldoState createState() => LaporanSaldoState();
}

class LaporanSaldoState extends State<LaporanSaldo> {
  String foto = session.ipnumber + "/gambar/wanita.png";
  ClassUser userprofile = new ClassUser(
      "", "", "", "", "", "", "", "", "", "", "", "0", "0", "", "", "", "");
  NumberFormat frmt = new NumberFormat(",000");
  List<ClassHistoryTransaksi> arrHistory = new List();
  List<ClassHistoryTransaksi> arrTemp = new List();
  List<String> jenis = [
    "Semua Transaksi",
    "Pembelian Paket",
    "Pembelian Produk",
    "Penarikan Saldo",
    "TopUp Saldo"
  ];
  String jenistrans = "Semua Transaksi";

  void initState() {
    super.initState();
    print("userlogin" + session.userlogin.toString());
    getProfile();
    getHistory();
  }

  Future<List<ClassHistoryTransaksi>> getHistory() async {
    print(jenistrans);
    List<ClassHistoryTransaksi> arrTemp = new List();
    Map paramData = {'iduser': session.userlogin, 'jenis': jenistrans};
    var parameter = json.encode(paramData);
    http
        .post(Uri.parse(session.ipnumber + "/getHistoryTopupLaporan"),
            headers: {"Content-Type": "application/json"}, body: parameter)
        .then((res) {
      print(res.body);
      var data = json.decode(res.body);
      var withdraw = data[0]['withdraw'];
      var transpaket = data[0]['paket'];
      var transproduk = data[0]['produk'];
      data = data[0]['topup'];
      String keterangan = "";
      for (var i = 0; i < withdraw.length; i++) {
        if (withdraw[i]['status'].toString() == "0")
          keterangan = "Proses Verifikasi";
        else
          keterangan = "Berhasil";
        ClassHistoryTransaksi databaru = new ClassHistoryTransaksi(
            withdraw[i]['saldo'].toString(),
            keterangan,
            withdraw[i]['waktu'].toString(),
            "Penarikan Saldo");
        arrTemp.add(databaru);
      }
      for (var i = 0; i < transpaket.length; i++) {
        keterangan = "Berhasil";
        ClassHistoryTransaksi databaru = new ClassHistoryTransaksi(
            transpaket[i]['totalharga'].toString(),
            keterangan,
            transpaket[i]['tanggalbeli'].toString(),
            "Pembelian Paket " +
                transpaket[i]['nama_paket'].toString() +
                " by " +
                transpaket[i]['username'].toString());
        arrTemp.add(databaru);
      }
      for (var i = 0; i < transproduk.length; i++) {
        keterangan = "Berhasil";
        ClassHistoryTransaksi databaru = new ClassHistoryTransaksi(
            transproduk[i]['total'].toString(),
            keterangan,
            transproduk[i]['waktubeli'].toString(),
            "Pembelian Produk");
        arrTemp.add(databaru);
      }
      for (var i = 0; i < data.length; i++) {
        if (data[i]['status'].toString() == "0")
          keterangan = "Proses Verifikasi";
        else
          keterangan = "Berhasil";
        ClassHistoryTransaksi databaru = new ClassHistoryTransaksi(
            data[i]['saldo'].toString(),
            keterangan,
            data[i]['waktu'].toString(),
            "Penambahan Saldo");
        arrTemp.add(databaru);
      }
      arrTemp.sort((a, b) => a.waktu.compareTo(b.waktu));
      setState(() {
        this.arrTemp = arrTemp;
        this.arrHistory = this.arrTemp;
      });
      print(this.arrTemp.length.toString() + " data");
      return arrTemp;
    }).catchError((err) {
      print(err);
    });
  }

  Future<ClassUser> getProfile() async {
    ClassUser userlog = new ClassUser(
        "", "", "", "", "", "", "", "", "", "", "", "0", "0", "", "", "", "");
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
          "",
          "");
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
        backgroundColor: Color.fromRGBO(38, 81, 158, 1),
        body: Column(
          children: [
            Container(
                padding: EdgeInsets.fromLTRB(20, 20, 20, 20),
                child: Row(
                  children: [
                    Text("Jenis Transaksi : ",
                        style: TextStyle(color: Colors.white, fontSize: 20)),
                    Container(
                      color: Colors.white,
                      margin: EdgeInsets.fromLTRB(30, 10, 10, 0),
                      child: DropdownButton<String>(
                        hint: Text("--Jenis Transaksi--"),
                        value: jenistrans,
                        onChanged: (String Value) {
                          setState(() {
                            jenistrans = Value;
                            getHistory();
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
                height: size.height - 108,
                child: ListView.builder(
                    itemCount: arrHistory.length == 0 ? 1 : arrHistory.length,
                    itemBuilder: (context, index) {
                      if (arrHistory.length == 0) {
                        return Card(child: Text("Tidak Ada Transaksi Saldo"));
                      } else {
                        return SizedBox(
                            height: 80,
                            child: Card(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Row(
                                    children: [
                                      arrHistory[index].ket == "Penarikan Saldo"
                                          ? Container(
                                              width: MediaQuery.of(context)
                                                          .size
                                                          .width /
                                                      2 -
                                                  10,
                                              padding: EdgeInsets.fromLTRB(
                                                  10, 0, 10, 0),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(arrHistory[index].ket,
                                                      style: TextStyle(
                                                          fontSize: 17,
                                                          color: Colors.red))
                                                ],
                                              ))
                                          : arrHistory[index].ket ==
                                                  "Penambahan Saldo"
                                              ? Container(
                                                  width: MediaQuery.of(context)
                                                              .size
                                                              .width /
                                                          2 -
                                                      10,
                                                  padding: EdgeInsets.fromLTRB(
                                                      10, 0, 10, 0),
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                          arrHistory[index].ket,
                                                          style: TextStyle(
                                                              fontSize: 17,
                                                              color:
                                                                  Colors.green))
                                                    ],
                                                  ))
                                              : Container(
                                                  width: MediaQuery.of(context)
                                                              .size
                                                              .width /
                                                          2 -
                                                      10,
                                                  padding: EdgeInsets.fromLTRB(
                                                      10, 0, 10, 0),
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                          arrHistory[index].ket,
                                                          style: TextStyle(
                                                              fontSize: 17,
                                                              color:
                                                                  Colors.red))
                                                    ],
                                                  )),
                                      Container(
                                          width: MediaQuery.of(context)
                                                      .size
                                                      .width /
                                                  2 -
                                              10,
                                          padding:
                                              EdgeInsets.fromLTRB(0, 0, 0, 0),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.end,
                                            children: [
                                              Text(
                                                  arrHistory[index]
                                                      .waktu
                                                      .substring(0, 10),
                                                  style:
                                                      TextStyle(fontSize: 17))
                                            ],
                                          )),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Container(
                                          margin: EdgeInsets.fromLTRB(
                                              10, 10, 10, 0),
                                          width: MediaQuery.of(context)
                                                      .size
                                                      .width /
                                                  2 -
                                              20,
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                arrHistory[index].status,
                                                style: TextStyle(fontSize: 17),
                                              )
                                            ],
                                          )),
                                      arrHistory[index].ket == "Penarikan Saldo"
                                          ? Container(
                                              margin: EdgeInsets.fromLTRB(
                                                  0, 0, 0, 0),
                                              width: MediaQuery.of(context)
                                                          .size
                                                          .width /
                                                      2 -
                                                  15,
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.end,
                                                children: [
                                                  Text(
                                                      "- Rp. " +
                                                          frmt.format(int.parse(
                                                              arrHistory[index]
                                                                  .saldo
                                                                  .toString())),
                                                      style: TextStyle(
                                                          fontSize: 17,
                                                          color: Colors.red))
                                                ],
                                              ))
                                          : arrHistory[index].ket ==
                                                  "Penambahan Saldo"
                                              ? Container(
                                                  margin: EdgeInsets.fromLTRB(
                                                      0, 0, 0, 0),
                                                  width: MediaQuery.of(context)
                                                              .size
                                                              .width /
                                                          2 -
                                                      15,
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment.end,
                                                    children: [
                                                      Text(
                                                          "+ Rp. " +
                                                              frmt.format(int.parse(
                                                                  arrHistory[
                                                                          index]
                                                                      .saldo
                                                                      .toString())),
                                                          style: TextStyle(
                                                              fontSize: 17,
                                                              color:
                                                                  Colors.green))
                                                    ],
                                                  ))
                                              : Container(
                                                  margin: EdgeInsets.fromLTRB(
                                                      0, 0, 0, 0),
                                                  width: MediaQuery.of(context)
                                                              .size
                                                              .width /
                                                          2 -
                                                      15,
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment.end,
                                                    children: [
                                                      Text(
                                                          "- Rp. " +
                                                              frmt.format(int.parse(
                                                                  arrHistory[
                                                                          index]
                                                                      .saldo
                                                                      .toString())),
                                                          style: TextStyle(
                                                              fontSize: 17,
                                                              color:
                                                                  Colors.red))
                                                    ],
                                                  )),
                                    ],
                                  )
                                ],
                              ),
                            ));
                      }
                    })),
            SizedBox(height: 10)
          ],
        ));
  }
}
