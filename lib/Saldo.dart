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

class Saldo extends StatefulWidget {
  @override
  SaldoState createState() => SaldoState();
}

class SaldoState extends State<Saldo> {
  String foto = session.ipnumber + "/gambar/wanita.png";
  ClassUser userprofile = new ClassUser(
      "", "", "", "", "", "", "", "", "", "", "", "0", "0", "", "", "", "");
  NumberFormat frmt = new NumberFormat(",000");
  List<ClassHistoryTransaksi> arrHistory = new List();

  void initState() {
    super.initState();
    print("userlogin" + session.userlogin.toString());
    getProfile();
    getHistory();
  }

  Future<List<ClassHistoryTransaksi>> getHistory() async {
    List<ClassHistoryTransaksi> arrTemp = new List();
    Map paramData = {'iduser': session.userlogin};
    var parameter = json.encode(paramData);
    http
        .post(Uri.parse(session.ipnumber + "/getHistoryTopup"),
            headers: {"Content-Type": "application/json"}, body: parameter)
        .then((res) {
      print(res.body);
      var data = json.decode(res.body);
      var withdraw = data[0]['withdraw'];
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
      setState(() => this.arrHistory = arrTemp);
      print(arrHistory.length.toString() + " data");
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
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: double.infinity,
        child: Stack(
          children: [
            Container(
              margin: EdgeInsets.symmetric(horizontal: 32, vertical: 32),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      int.parse(userprofile.saldo.toString()) > 1000
                          ? Text(
                              'Rp. ' +
                                  frmt.format(
                                      int.parse(userprofile.saldo.toString())),
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 36,
                                  fontWeight: FontWeight.w700),
                            )
                          : Text(
                              'Rp. ' + userprofile.saldo.toString(),
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 36,
                                  fontWeight: FontWeight.w700),
                            ),
                      Container(
                        child: Row(
                          children: [
                            SizedBox(width: 20),
                            CircleAvatar(
                              radius: 25,
                              backgroundColor: Colors.white,
                              child: ClipOval(
                                child: Image.network(
                                  session.ipnumber + "/gambar/wanita.png",
                                  fit: BoxFit.contain,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  Text(
                    "Saldo",
                    style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 16,
                        color: Colors.blue[100]),
                  ),
                  SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                          child: Column(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                                color: Color.fromRGBO(243, 245, 248, 1),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(18))),
                            child: IconButton(
                                onPressed: () {
                                  Navigator.pushNamed(context, "/topup");
                                },
                                icon: Icon(
                                  Icons.trending_down,
                                  color: Colors.blue[900],
                                  size: 30,
                                )),
                            padding: EdgeInsets.all(12),
                          ),
                          SizedBox(height: 4),
                          Text(
                            "Tambah Saldo",
                            style: TextStyle(
                                fontWeight: FontWeight.w700,
                                fontSize: 14,
                                color: Colors.blue[100]),
                          )
                        ],
                      )),
                      Expanded(
                          child: Column(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                                color: Color.fromRGBO(243, 245, 248, 1),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(18))),
                            child: IconButton(
                              onPressed: () {
                                Navigator.pushNamed(context, "/withdraw");
                              },
                              icon: Icon(
                                Icons.attach_money,
                                color: Colors.blue[900],
                                size: 30,
                              ),
                            ),
                            padding: EdgeInsets.all(12),
                          ),
                          SizedBox(height: 4),
                          Text(
                            "Tarik Saldo",
                            style: TextStyle(
                                fontWeight: FontWeight.w700,
                                fontSize: 14,
                                color: Colors.blue[100]),
                          )
                        ],
                      )),
                    ],
                  )
                ],
              ),
            ),
            DraggableScrollableSheet(builder: (context, scrollController) {
              return Container(
                decoration: BoxDecoration(
                    color: Color.fromRGBO(243, 245, 248, 1),
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(40),
                        topRight: Radius.circular(40))),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 24),
                      Container(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "History Transaksi",
                              style: TextStyle(
                                  fontWeight: FontWeight.w900,
                                  fontSize: 24,
                                  color: Colors.black),
                            ),
                            // Text(
                            //   "Lihat Semua",
                            //   style: TextStyle(
                            //       fontWeight: FontWeight.w700,
                            //       fontSize: 15,
                            //       color: Colors.grey[800]),
                            // )
                          ],
                        ),
                        padding: EdgeInsets.symmetric(horizontal: 32),
                      ),
                      SizedBox(height: 24),
                      Container(
                          height: 250,
                          child: ListView.builder(
                              itemCount: arrHistory.length == 0
                                  ? 1
                                  : arrHistory.length,
                              itemBuilder: (context, index) {
                                if (arrHistory.length == 0) {
                                  return Card(
                                      child: Text("Tidak Ada Transaksi Saldo"));
                                } else {
                                  return SizedBox(
                                      height: 75,
                                      child: Card(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.end,
                                          children: [
                                            Row(
                                              children: [
                                                arrHistory[index].ket ==
                                                        "Penarikan Saldo"
                                                    ? Container(
                                                        width: MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width /
                                                                2 -
                                                            10,
                                                        padding:
                                                            EdgeInsets.fromLTRB(
                                                                10, 0, 10, 0),
                                                        child: Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            Text(
                                                                arrHistory[
                                                                        index]
                                                                    .ket,
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        17,
                                                                    color: Colors
                                                                        .red))
                                                          ],
                                                        ))
                                                    : Container(
                                                        width: MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width /
                                                                2 -
                                                            10,
                                                        padding:
                                                            EdgeInsets.fromLTRB(
                                                                10, 0, 10, 0),
                                                        child: Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            Text(
                                                                arrHistory[
                                                                        index]
                                                                    .ket,
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        17,
                                                                    color: Colors
                                                                        .green))
                                                          ],
                                                        )),
                                                Container(
                                                    width:
                                                        MediaQuery.of(context)
                                                                    .size
                                                                    .width /
                                                                2 -
                                                            10,
                                                    padding:
                                                        EdgeInsets.fromLTRB(
                                                            0, 0, 0, 0),
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .end,
                                                      children: [
                                                        Text(
                                                            arrHistory[index]
                                                                .waktu
                                                                .substring(
                                                                    0, 10),
                                                            style: TextStyle(
                                                                fontSize: 17))
                                                      ],
                                                    )),
                                              ],
                                            ),
                                            Row(
                                              children: [
                                                Container(
                                                    margin: EdgeInsets.fromLTRB(
                                                        10, 10, 10, 0),
                                                    width:
                                                        MediaQuery.of(context)
                                                                    .size
                                                                    .width /
                                                                2 -
                                                            20,
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Text(
                                                          arrHistory[index]
                                                              .status,
                                                          style: TextStyle(
                                                              fontSize: 17),
                                                        )
                                                      ],
                                                    )),
                                                arrHistory[index].ket ==
                                                        "Penarikan Saldo"
                                                    ? Container(
                                                        margin:
                                                            EdgeInsets.fromLTRB(
                                                                0, 0, 0, 0),
                                                        width: MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width /
                                                                2 -
                                                            15,
                                                        child: Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .end,
                                                          children: [
                                                            Text(
                                                                "- Rp. " +
                                                                    frmt.format(int.parse(arrHistory[
                                                                            index]
                                                                        .saldo
                                                                        .toString())),
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        17,
                                                                    color: Colors
                                                                        .red))
                                                          ],
                                                        ))
                                                    : Container(
                                                        margin:
                                                            EdgeInsets.fromLTRB(
                                                                0, 0, 0, 0),
                                                        width: MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width /
                                                                2 -
                                                            15,
                                                        child: Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .end,
                                                          children: [
                                                            Text(
                                                                "+ Rp. " +
                                                                    frmt.format(int.parse(arrHistory[
                                                                            index]
                                                                        .saldo
                                                                        .toString())),
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        17,
                                                                    color: Colors
                                                                        .green))
                                                          ],
                                                        )),
                                              ],
                                            )
                                          ],
                                        ),
                                      ));
                                }
                              }))
                    ],
                  ),
                ),
              );
            })
          ],
        ),
      ),
    );
  }
}
