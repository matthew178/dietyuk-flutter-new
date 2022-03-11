import 'package:dietyukapp/ClassBeliPaket.dart';

import 'AwalPaket.dart';
import 'package:fluttertoast/fluttertoast.dart';
// import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'rating.dart';
import 'session.dart' as session;
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'ClassPaket.dart';

class Daftartransaksimember extends StatefulWidget {
  @override
  DaftartransaksimemberState createState() => DaftartransaksimemberState();
}

class DaftartransaksimemberState extends State<Daftartransaksimember> {
  List<Transaksibelipaket> arrTransaksi = new List();
  List<Transaksibelipaket> onProses = new List();
  List<Transaksibelipaket> selesai = new List();
  List<Transaksibelipaket> batal = new List();
  TextEditingController reviewkonsultan = new TextEditingController();
  TextEditingController reviewpaket = new TextEditingController();
  TextEditingController keteranganlaporan = new TextEditingController();
  DateTime tglnow = new DateTime(
      DateTime.now().year, DateTime.now().month, DateTime.now().day);
  int ratingpaket, ratingkonsultan;

  @override
  void initState() {
    super.initState();
    getTransaksiBelumSelesai();
    transaksiOnProses();
    getTransaksiSelesai();
    getTransaksiBatal();
  }

  void confirmBatal(String id) {
    AlertDialog dialog = new AlertDialog(
      content: new Container(
        width: 600.0,
        height: 300.0,
        decoration: new BoxDecoration(
          shape: BoxShape.rectangle,
          color: const Color(0xFFFFFF),
          borderRadius: new BorderRadius.all(new Radius.circular(32.0)),
        ),
        child: new Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            new Expanded(
              child: new Container(
                  child: new Text("Ingin membatalkan pembelian paket ?")),
              flex: 2,
            ),
            new Expanded(
              child: Row(
                children: [
                  SizedBox(width: 30),
                  Container(
                    child: new RaisedButton(
                      onPressed: () {
                        batalBeliPaket(id);
                        Navigator.of(context, rootNavigator: true).pop(true);
                      },
                      padding: new EdgeInsets.all(16.0),
                      color: Colors.green,
                      child: new Text(
                        'Ya',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18.0,
                          fontFamily: 'helvetica_neue_light',
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                  SizedBox(width: 15),
                  Container(
                    child: new RaisedButton(
                      onPressed: () {
                        Navigator.of(context, rootNavigator: true).pop(true);
                      },
                      padding: new EdgeInsets.all(16.0),
                      color: Colors.red,
                      child: new Text(
                        'Tidak',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18.0,
                          fontFamily: 'helvetica_neue_light',
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return dialog;
        });
  }

  void submitRatingReview(String idbeli, paket, ratingpaket, ratingkonsul,
      revpaket, revkonsul) async {
    Map paramData = {
      'idbeli': idbeli,
      'paket': paket,
      'ratingpaket': ratingpaket,
      'ratingkonsultan': ratingkonsul,
      'reviewpaket': revpaket,
      'reviewkonsultan': revkonsul
    };
    var parameter = json.encode(paramData);
    http
        .post(Uri.parse(session.ipnumber + '/kirimRating'),
            headers: {"Content-Type": "application/json"}, body: parameter)
        .then((res) {
      Fluttertoast.showToast(msg: "Berhasil kirim rating");
      getTransaksiSelesai();
    }).catchError((err) {
      print(err);
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
      return arrTrans;
    }).catchError((err) {
      print(err);
    });
  }

  // void kirimRating(String paket) async {
  //   Map paramData = {
  //     'user': session.userlogin,
  //     'paket': paket,
  //     'ratingkonsultan': ratingkonsultan,
  //     'ratingpaket': ratingpaket,
  //     'reviewpaket': reviewpaket.text,
  //     'reviewkonsultan': reviewkonsultan.text
  //   };
  //   var parameter = json.encode(paramData);
  //   http
  //       .post(Uri.parse(session.ipnumber + "/kirimRating"),
  //           headers: {"Content-Type": "application/json"}, body: parameter)
  //       .then((res) {
  //     var data = json.decode(res.body);
  //     data = data[0]['transaksi'];
  //   }).catchError((err) {
  //     print(err);
  //   });
  // }

  // void ratingReview(String paket) {
  //   AlertDialog dialog = new AlertDialog(
  //     content: new Container(
  //       width: MediaQuery.of(context).size.width,
  //       height: 475.0,
  //       decoration: new BoxDecoration(
  //         shape: BoxShape.rectangle,
  //         color: const Color(0xFFFFFF),
  //         borderRadius: new BorderRadius.all(new Radius.circular(32.0)),
  //       ),
  //       child: new ListView(
  //         // crossAxisAlignment: CrossAxisAlignment.stretch,
  //         children: <Widget>[
  //           Container(
  //             decoration: BoxDecoration(
  //                 color: Colors.blue[100],
  //                 border: Border.all(color: Colors.black),
  //                 borderRadius: BorderRadius.all(Radius.circular(20))),
  //             child: Column(
  //               children: [
  //                 SizedBox(height: 10),
  //                 Container(
  //                     child: Center(child: Text("Rating untuk Konsultan"))),
  //                 SizedBox(height: 5),
  //                 Container(
  //                   child: Column(
  //                     mainAxisAlignment: MainAxisAlignment.center,
  //                     children: [
  //                       Rating((rating) {
  //                         setState(() {
  //                           ratingkonsultan = rating;
  //                         });
  //                       }, 5),
  //                     ],
  //                   ),
  //                 ),
  //                 SizedBox(height: 15),
  //                 Container(
  //                     child: Center(child: Text("Review untuk Konsultan"))),
  //                 Container(
  //                   width: 250,
  //                   child: TextField(
  //                     controller: reviewkonsultan,
  //                     autofocus: false,
  //                     keyboardType: TextInputType.multiline,
  //                     maxLines: null,
  //                   ),
  //                 ),
  //                 SizedBox(height: 10)
  //               ],
  //             ),
  //           ),
  //           SizedBox(height: 25),
  //           Container(
  //             decoration: BoxDecoration(
  //                 color: Colors.yellow[100],
  //                 border: Border.all(color: Colors.black),
  //                 borderRadius: BorderRadius.all(Radius.circular(20))),
  //             child: Column(
  //               children: [
  //                 SizedBox(height: 10),
  //                 Container(
  //                     child: Center(child: Text("Rating untuk Paket Diet"))),
  //                 SizedBox(height: 5),
  //                 Container(
  //                   child: Column(
  //                     mainAxisAlignment: MainAxisAlignment.center,
  //                     children: [
  //                       Rating((rating) {
  //                         setState(() {
  //                           ratingpaket = rating;
  //                         });
  //                       }, 5),
  //                     ],
  //                   ),
  //                 ),
  //                 SizedBox(height: 15),
  //                 Container(
  //                     child: Center(child: Text("Review untuk Konsultan"))),
  //                 Container(
  //                   width: 250,
  //                   child: TextField(
  //                     controller: reviewpaket,
  //                     autofocus: false,
  //                     keyboardType: TextInputType.multiline,
  //                     maxLines: null,
  //                   ),
  //                 ),
  //                 SizedBox(height: 10)
  //               ],
  //             ),
  //           ),
  //           SizedBox(height: 20),
  //           Container(
  //             child: new RaisedButton(
  //               onPressed: () {
  //                 Navigator.of(context, rootNavigator: true).pop(true);
  //               },
  //               padding: new EdgeInsets.all(16.0),
  //               color: Colors.green,
  //               child: new Text(
  //                 'Submit Rating & Review',
  //                 style: TextStyle(
  //                   color: Colors.white,
  //                   fontSize: 18.0,
  //                   fontFamily: 'helvetica_neue_light',
  //                 ),
  //                 textAlign: TextAlign.center,
  //               ),
  //             ),
  //           ),
  //           SizedBox(height: 5),
  //           Container(
  //             child: new RaisedButton(
  //               onPressed: () {
  //                 Navigator.of(context, rootNavigator: true).pop(true);
  //               },
  //               padding: new EdgeInsets.all(16.0),
  //               color: Colors.red,
  //               child: new Text(
  //                 'Lapor Konsultan',
  //                 style: TextStyle(
  //                   color: Colors.white,
  //                   fontSize: 18.0,
  //                   fontFamily: 'helvetica_neue_light',
  //                 ),
  //                 textAlign: TextAlign.center,
  //               ),
  //             ),
  //           ),
  //         ],
  //       ),
  //     ),
  //   );
  //   showDialog(
  //       context: context,
  //       builder: (BuildContext context) {
  //         return dialog;
  //       });
  // }

  void ratingReview(String paket, idbeli) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return Dialog(
              backgroundColor: Colors.transparent,
              insetPadding: EdgeInsets.all(10),
              child: Stack(
                overflow: Overflow.visible,
                alignment: Alignment.center,
                children: <Widget>[
                  ListView(
                    children: <Widget>[
                      SizedBox(height: MediaQuery.of(context).size.height / 8),
                      Container(
                        decoration: BoxDecoration(
                            color: Colors.blue[100],
                            border: Border.all(color: Colors.black),
                            borderRadius:
                                BorderRadius.all(Radius.circular(20))),
                        child: Column(
                          children: [
                            SizedBox(height: 10),
                            Container(
                                child: Center(
                                    child: Text(
                              "Rating untuk Konsultan",
                              style: TextStyle(
                                  fontSize: 17, fontWeight: FontWeight.bold),
                            ))),
                            SizedBox(height: 5),
                            Container(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Rating((rating) {
                                    setState(() {
                                      ratingkonsultan = rating;
                                    });
                                  }, 5),
                                ],
                              ),
                            ),
                            SizedBox(height: 15),
                            Container(
                                child: Center(
                                    child: Text("Review untuk Konsultan",
                                        style: TextStyle(
                                            fontSize: 17,
                                            fontWeight: FontWeight.bold)))),
                            Container(
                              width: 250,
                              child: TextField(
                                controller: reviewkonsultan,
                                autofocus: false,
                                keyboardType: TextInputType.multiline,
                                maxLines: null,
                              ),
                            ),
                            SizedBox(height: 10)
                          ],
                        ),
                      ),
                      SizedBox(height: 25),
                      Container(
                        decoration: BoxDecoration(
                            color: Colors.yellow[100],
                            border: Border.all(color: Colors.black),
                            borderRadius:
                                BorderRadius.all(Radius.circular(20))),
                        child: Column(
                          children: [
                            SizedBox(height: 10),
                            Container(
                                child: Center(
                                    child: Text("Rating untuk Paket Diet",
                                        style: TextStyle(
                                            fontSize: 17,
                                            fontWeight: FontWeight.bold)))),
                            SizedBox(height: 5),
                            Container(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Rating((rating) {
                                    setState(() {
                                      ratingpaket = rating;
                                    });
                                  }, 5),
                                ],
                              ),
                            ),
                            SizedBox(height: 15),
                            Container(
                                child: Center(
                                    child: Text("Review untuk Paket Diet",
                                        style: TextStyle(
                                            fontSize: 17,
                                            fontWeight: FontWeight.bold)))),
                            Container(
                              width: 250,
                              child: TextField(
                                controller: reviewpaket,
                                autofocus: false,
                                keyboardType: TextInputType.multiline,
                                maxLines: null,
                              ),
                            ),
                            SizedBox(height: 10)
                          ],
                        ),
                      ),
                      SizedBox(height: 20),
                      Container(
                        child: new RaisedButton(
                          onPressed: () {
                            // kirimRating(paket);
                            Navigator.of(context, rootNavigator: true)
                                .pop(true);
                            setState(() {
                              submitRatingReview(
                                  idbeli,
                                  paket,
                                  ratingpaket,
                                  ratingkonsultan,
                                  reviewpaket.text,
                                  reviewkonsultan.text);
                              getTransaksiSelesai();
                              ratingpaket = 0;
                              ratingkonsultan = 0;
                              reviewpaket.text = "";
                              reviewkonsultan.text = "";
                            });
                          },
                          padding: new EdgeInsets.all(16.0),
                          color: Colors.green,
                          child: new Text(
                            'Submit Rating & Review',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18.0,
                              fontFamily: 'helvetica_neue_light',
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                      SizedBox(height: 5),
                      // Container(
                      //   child: new RaisedButton(
                      //     onPressed: () {
                      //       laporKonsultan();
                      //     },
                      //     padding: new EdgeInsets.all(16.0),
                      //     color: Colors.red,
                      //     child: new Text(
                      //       'Lapor Konsultan',
                      //       style: TextStyle(
                      //         color: Colors.white,
                      //         fontSize: 18.0,
                      //         fontFamily: 'helvetica_neue_light',
                      //       ),
                      //       textAlign: TextAlign.center,
                      //     ),
                      //   ),
                      // ),
                    ],
                  ),
                ],
              ));
        });
  }

  void laporKonsultan() {
    AlertDialog dialog = new AlertDialog(
      content: new Container(
        width: 260.0,
        height: 230.0,
        decoration: new BoxDecoration(
          shape: BoxShape.rectangle,
          color: const Color(0xFFFFFF),
          borderRadius: new BorderRadius.all(new Radius.circular(32.0)),
        ),
        child: new Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Container(
              child: Column(
                children: [
                  SizedBox(height: 10),
                  Container(
                      child: Center(
                          child: Text("Alasan Pelaporan",
                              style: TextStyle(
                                  fontSize: 17, fontWeight: FontWeight.bold)))),
                  Container(
                    width: 250,
                    child: TextField(
                      controller: keteranganlaporan,
                      autofocus: false,
                      keyboardType: TextInputType.multiline,
                      maxLines: null,
                    ),
                  ),
                  SizedBox(height: 10)
                ],
              ),
            ),
            new Expanded(
              child: Row(
                children: [
                  SizedBox(width: 50),
                  Container(
                    child: new RaisedButton(
                      onPressed: () {
                        Navigator.of(context, rootNavigator: true).pop(true);
                      },
                      padding: new EdgeInsets.all(16.0),
                      color: Colors.blue,
                      child: new Text(
                        'Kirim Laporan',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18.0,
                          fontFamily: 'helvetica_neue_light',
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return dialog;
        });
  }

  void showAlert(String di, String packet, String sttskonsultan) {
    AlertDialog dialog = new AlertDialog(
      content: new Container(
        width: 260.0,
        height: 230.0,
        decoration: new BoxDecoration(
          shape: BoxShape.rectangle,
          color: const Color(0xFFFFFF),
          borderRadius: new BorderRadius.all(new Radius.circular(32.0)),
        ),
        child: new Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            new Expanded(
              child: new Container(
                  child: new Text(
                      "Program akan dimulai besok, aktivasi paket sekarang ?")),
              flex: 2,
            ),
            new Expanded(
              child: Row(
                children: [
                  SizedBox(width: 30),
                  Container(
                    child: new RaisedButton(
                      onPressed: () {
                        aktivasiPaket(di, packet, sttskonsultan);
                        Navigator.of(context, rootNavigator: true).pop(true);
                      },
                      padding: new EdgeInsets.all(16.0),
                      color: Colors.green,
                      child: new Text(
                        'Ya',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18.0,
                          fontFamily: 'helvetica_neue_light',
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                  SizedBox(width: 15),
                  Container(
                    child: new RaisedButton(
                      onPressed: () {
                        Navigator.of(context, rootNavigator: true).pop(true);
                      },
                      padding: new EdgeInsets.all(16.0),
                      color: Colors.red,
                      child: new Text(
                        'Tidak',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18.0,
                          fontFamily: 'helvetica_neue_light',
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return dialog;
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
      return arrTrans;
    }).catchError((err) {
      print(err);
    });
  }

  Future<String> aktivasiPaket(
      String id, String paket, String sttskonsultan) async {
    if (sttskonsultan == "Aktif") {
      Map paramData = {
        'id': id,
        'paket': paket,
        'username': session.userlogin,
        'berat': session.berat
      };
      var parameter = json.encode(paramData);
      http
          .post(Uri.parse(session.ipnumber + "/aktivasiPaket"),
              headers: {"Content-Type": "application/json"}, body: parameter)
          .then((res) {
        var data = json.decode(res.body);
        data = data[0]['transaksi'];
        getTransaksiBelumSelesai();
        transaksiOnProses();
        getTransaksiSelesai();
        getTransaksiBatal();
        return "selesai";
      }).catchError((err) {
        print(err);
      });
    } else {
      Fluttertoast.showToast(
          msg:
              "Konsultan diblokir, paket yang telah dibeli akan otomatis dibatalkan. Uang anda akan dikembalikan");
      Map paramData = {'id': id, 'username': session.userlogin, 'mode': 1};
      var parameter = json.encode(paramData);
      http
          .post(Uri.parse(session.ipnumber + "/refundPaket"),
              headers: {"Content-Type": "application/json"}, body: parameter)
          .then((res) {
        var data = json.decode(res.body);
        data = data[0]['transaksi'];
        print("transaksi = " + data.toString());
        getTransaksiBelumSelesai();
        transaksiOnProses();
        getTransaksiSelesai();
        getTransaksiBatal();
        return "selesai";
      }).catchError((err) {
        print(err);
      });
    }
  }

  void batalBeliPaket(String id) async {
    Map paramData = {'id': id, 'username': session.userlogin, 'mode': 2};
    var parameter = json.encode(paramData);
    http
        .post(Uri.parse(session.ipnumber + "/refundPaket"),
            headers: {"Content-Type": "application/json"}, body: parameter)
        .then((res) {
      getTransaksiBelumSelesai();
      transaksiOnProses();
      getTransaksiSelesai();
      getTransaksiBatal();
    }).catchError((err) {
      print(err);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Daftar Transaksi Page"),
        backgroundColor: session.warna,
      ),
      body: DefaultTabController(
        length: 4,
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
                        text: "MyPaket",
                      ),
                      Tab(
                        text: "Proses",
                      ),
                      Tab(
                        text: "Selesai",
                      ),
                      Tab(
                        text: "Batal",
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
                          itemCount: arrTransaksi.length == 0
                              ? 1
                              : arrTransaksi.length,
                          itemBuilder: (context, index) {
                            if (arrTransaksi.length == 0) {
                              return Image.asset("assets/images/nodata.png");
                            } else {
                              return GestureDetector(
                                  onTap: () {},
                                  child: Card(
                                      child: Column(
                                    children: [
                                      Container(
                                        padding:
                                            EdgeInsets.fromLTRB(0, 10, 0, 0),
                                        child: Text(
                                          arrTransaksi[index].namapaket,
                                          style: TextStyle(
                                            fontSize: 20,
                                          ),
                                        ),
                                      ),
                                      DateTime.parse(arrTransaksi[index]
                                                      .tanggalbeli)
                                                  .add(new Duration(days: 3))
                                                  .compareTo(tglnow) >
                                              0
                                          ? Container(
                                              child: Row(
                                                children: [
                                                  Container(
                                                    padding:
                                                        EdgeInsets.fromLTRB(
                                                            10, 10, 0, 10),
                                                    child: Image.asset(
                                                        'assets/images/waiting.png'),
                                                  ),
                                                  SizedBox(width: 30),
                                                  Container(
                                                    child: RaisedButton(
                                                      shape:
                                                          RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(2),
                                                      ),
                                                      onPressed: () {
                                                        showAlert(
                                                            arrTransaksi[index]
                                                                .id,
                                                            arrTransaksi[index]
                                                                .idpaket,
                                                            arrTransaksi[index]
                                                                .statuskonsultan);
                                                      },
                                                      color: Colors
                                                          .lightBlueAccent,
                                                      child: Text(
                                                        'Aktivasi Paket',
                                                        style: TextStyle(
                                                            fontSize: 15.0,
                                                            color: Colors.black,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      ),
                                                    ),
                                                  ),
                                                  SizedBox(width: 15),
                                                  Container(
                                                    child: RaisedButton(
                                                      shape:
                                                          RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(2),
                                                      ),
                                                      onPressed: () {
                                                        confirmBatal(
                                                            arrTransaksi[index]
                                                                .id);
                                                      },
                                                      color: Colors
                                                          .lightBlueAccent,
                                                      child: Text(
                                                        'Batal Beli Paket',
                                                        style: TextStyle(
                                                            fontSize: 15.0,
                                                            color: Colors.black,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            )
                                          : Container(
                                              child: Row(
                                                children: [
                                                  Container(
                                                    padding:
                                                        EdgeInsets.fromLTRB(
                                                            10, 10, 0, 10),
                                                    child: Image.asset(
                                                        'assets/images/waiting.png'),
                                                  ),
                                                  SizedBox(width: 90),
                                                  Container(
                                                    child: RaisedButton(
                                                      shape:
                                                          RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(2),
                                                      ),
                                                      onPressed: () {
                                                        showAlert(
                                                            arrTransaksi[index]
                                                                .id,
                                                            arrTransaksi[index]
                                                                .idpaket,
                                                            arrTransaksi[index]
                                                                .statuskonsultan);
                                                      },
                                                      color: Colors
                                                          .lightBlueAccent,
                                                      child: Text(
                                                        'Aktivasi Paket',
                                                        style: TextStyle(
                                                            fontSize: 15.0,
                                                            color: Colors.black,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            )
                                    ],
                                  )));
                            }
                          }),
                    ),
                    Container(
                      child: new ListView.builder(
                          itemCount: onProses.length == 0 ? 1 : onProses.length,
                          itemBuilder: (context, index) {
                            if (onProses.length == 0) {
                              return Image.asset("assets/images/nodata.png");
                            } else {
                              return GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => AwalPaket(
                                                  id: onProses[index].id,
                                                  paket:
                                                      onProses[index].idpaket,
                                                  status:
                                                      onProses[index].status,
                                                )));
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
                                              onProses[index].namapaket,
                                              style: TextStyle(
                                                fontSize: 20,
                                              ),
                                            )),
                                            Container(
                                                child: Text(onProses[index]
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
                                                child: Text(onProses[index]
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
                          itemCount: selesai.length == 0 ? 1 : selesai.length,
                          itemBuilder: (context, index) {
                            if (selesai.length == 0) {
                              return Image.asset("assets/images/noresult.png");
                            } else {
                              return GestureDetector(
                                  onTap: () {
                                    selesai[index].status == "2"
                                        ? Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) => AwalPaket(
                                                      id: selesai[index].id,
                                                      paket: selesai[index]
                                                          .idpaket,
                                                      status:
                                                          selesai[index].status,
                                                    )))
                                        : ratingReview(selesai[index].idpaket,
                                            selesai[index].id);
                                  },
                                  child: selesai[index].status == "2"
                                      // ? Card(
                                      //     child: Row(
                                      //     children: [
                                      //       Container(
                                      //           padding: EdgeInsets.fromLTRB(
                                      //               10, 10, 0, 10),
                                      //           child: Image.asset(
                                      //               'assets/images/done.png')),
                                      //       SizedBox(
                                      //         width: 30,
                                      //       ),
                                      //       Container(
                                      //         child: Column(
                                      //           children: [
                                      //             Container(
                                      //                 child: Text(
                                      //               selesai[index].namapaket,
                                      //               style: TextStyle(
                                      //                 fontSize: 20,
                                      //               ),
                                      //             )),
                                      //             Container(
                                      //                 child: Text(selesai[index]
                                      //                     .namakonsultan))
                                      //           ],
                                      //         ),
                                      //       ),
                                      //     ],
                                      //   ))
                                      ? Card(
                                          child: Row(
                                          children: [
                                            Column(
                                              children: [
                                                Container(
                                                    padding:
                                                        EdgeInsets.fromLTRB(
                                                            10, 10, 0, 10),
                                                    child: Image.asset(
                                                        'assets/images/done.png')),
                                                Container(
                                                    padding:
                                                        EdgeInsets.fromLTRB(
                                                            10, 10, 0, 10),
                                                    child: Text(
                                                      "      Selesai     ",
                                                    )),
                                              ],
                                            ),
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
                                        ))
                                      : Card(
                                          child: Row(
                                          children: [
                                            Column(
                                              children: [
                                                Container(
                                                    padding:
                                                        EdgeInsets.fromLTRB(
                                                            10, 10, 0, 10),
                                                    child: Icon(Icons.help,
                                                        size: 50,
                                                        color: Colors
                                                            .yellow[700])),
                                                Container(
                                                    padding:
                                                        EdgeInsets.fromLTRB(
                                                            10, 10, 0, 10),
                                                    child:
                                                        Text("Berikan Ulasan")),
                                              ],
                                            ),
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
                    Container(
                      child: new ListView.builder(
                          itemCount: batal.length == 0 ? 1 : batal.length,
                          itemBuilder: (context, index) {
                            if (batal.length == 0) {
                              return Image.asset("assets/images/nodata.png");
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
                                              'assets/images/cancel.png')),
                                      SizedBox(
                                        width: 30,
                                      ),
                                      Expanded(
                                        flex: 2,
                                        child: Column(
                                          children: [
                                            Container(
                                                child: Text(
                                              batal[index].namapaket,
                                              style: TextStyle(
                                                fontSize: 20,
                                              ),
                                            )),
                                            Container(
                                                child: Text(
                                                    batal[index].namakonsultan))
                                          ],
                                        ),
                                      ),
                                      // Expanded(
                                      //   child: SizedBox(),
                                      // ),
                                      Expanded(
                                          child: batal[index].status == "3"
                                              ? Text("Batal Beli Paket")
                                              : Text("Konsultan Diblokir"))
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
