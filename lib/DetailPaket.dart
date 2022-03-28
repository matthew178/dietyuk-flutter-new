import 'package:dietyukapp/ClassReview.dart';
import 'package:dietyukapp/ClassTestimoni.dart';
import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hexcolor/hexcolor.dart';

import 'session.dart' as session;
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'ClassPaket.dart';
import 'ClassJadwal.dart';
import 'package:intl/intl.dart';
import 'ClassUser.dart';

class DetailPaket extends StatefulWidget {
  final String id;
  final String konsultan;

  DetailPaket({Key key, @required this.id, @required this.konsultan})
      : super(key: key);

  @override
  DetailPaketState createState() => DetailPaketState(this.id, this.konsultan);
}

class DetailPaketState extends State<DetailPaket> {
  String id, konsultan;
  ClassPaket paketsekarang = new ClassPaket("id", "estimasi", "0", "durasi",
      "status", "0.00", "konsultan", "namapaket1", "deskripsi", "default.jpg");
  List<ClassJadwal> arrJadwal = [];
  List<ClassReview> arrReview = [];
  List<ClassJadwal> allJadwal = [];
  List<classTestimoni> arrTesti = [];
  NumberFormat frmt = new NumberFormat(',000');
  int hari = 1;
  int mode = 0;
  ClassUser userprofile = new ClassUser(
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
      "0",
      "0.00",
      "status",
      "foto",
      "",
      "");

  List<ClassPaket> arrPaket = new List();

  DetailPaketState(this.id, this.konsultan);

  @override
  void initState() {
    super.initState();
    getPaket();
    getJadwal();
    getProfile();
    getReview();
    getTesti();
  }

  Widget cetakbintang(x, y) {
    if (x <= y) {
      return Image.asset("assets/images/bfull.png",
          width: 15, height: 15, fit: BoxFit.cover);
    } else if (x > y && x < y + 1) {
      return Image.asset("assets/images/bstengah.png",
          width: 15, height: 15, fit: BoxFit.cover);
    } else {
      return Image.asset("assets/images/bkosong.png",
          width: 15, height: 15, fit: BoxFit.cover);
    }
  }

  Future<List<ClassReview>> getReview() async {
    List<ClassReview> arrTemp = [];
    Map paramData = {'id': this.id};
    var parameter = json.encode(paramData);
    http
        .post(Uri.parse(session.ipnumber + "/getreviewpaket"),
            headers: {"Content-Type": "application/json"}, body: parameter)
        .then((res) {
      var data = json.decode(res.body);
      data = data[0]['review'];

      for (int i = 0; i < data.length; i++) {
        ClassReview review = new ClassReview(
            data[i]['id'].toString(),
            data[i]['idbeli'].toString(),
            data[i]['konsultan'].toString(),
            data[i]['paket'].toString(),
            data[i]['ratingkonsultan'].toString(),
            data[i]['ratingpaket'].toString(),
            data[i]['review_konsultan'].toString(),
            data[i]['review_paket'].toString());
        review.namauser = data[i]['username'].toString();
        arrTemp.add(review);
      }
      setState(() {
        arrReview = arrTemp;
      });
    }).catchError((err) {
      print(err);
    });

    return arrTemp;
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
      return userlog;
    }).catchError((err) {
      print(err);
    });
  }

  Future<List<classTestimoni>> getTesti() async {
    List<classTestimoni> tempTes = [];
    Map paramData = {'paket': id};
    var parameter = json.encode(paramData);
    print("sini");
    http
        .post(Uri.parse(session.ipnumber + "/getTestiPaket"),
            headers: {"Content-Type": "application/json"}, body: parameter)
        .then((res) {
      var data = json.decode(res.body);
      data = data[0]['testi'];
      for (int i = 0; i < data.length; i++) {
        setState(() {
          tempTes.add(new classTestimoni(
              data[i]['id'].toString(),
              data[i]['username'].toString(),
              data[i]['review_paket'].toString(),
              double.parse(data[i]['ratingpaket'].toString()),
              data[i]['testimoni'].toString()));
        });
      }
      setState(() {
        this.arrTesti = tempTes;
      });
      print(arrTesti.length.toString() + " data");
      return data;
    }).catchError((err) {
      print(err);
    });
  }

  Future<String> beliPaket() async {
    Map paramData = {
      'id': id,
      'user': session.userlogin,
      'durasi': paketsekarang.durasi,
      'total': paketsekarang.harga
    };
    var parameter = json.encode(paramData);
    http
        .post(Uri.parse(session.ipnumber + "/belipaket"),
            headers: {"Content-Type": "application/json"}, body: parameter)
        .then((res) {
      var data = json.decode(res.body);
      data = data[0]['status'];
      if (data == "berhasil") {
        Fluttertoast.showToast(msg: "Berhasil Beli Paket");
        Navigator.pushNamed(this.context, "/member");
      }
      return data;
    }).catchError((err) {
      print(err);
    });
  }

  void showAlert() {
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
                  child: Text(
                "Rincian Pembelian",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              )),
            ),
            new Expanded(
              child: new Container(
                  child: Column(
                children: [
                  int.parse(userprofile.saldo.toString()) > 1000
                      ? Container(
                          child: Row(
                            children: [
                              Expanded(
                                child: Text("Saldo : "),
                                flex: 1,
                              ),
                              Expanded(
                                child: Text("Rp. " +
                                    frmt.format(int.parse(userprofile.saldo))),
                                flex: 1,
                              )
                            ],
                          ),
                        )
                      : Container(
                          child: Row(
                            children: [
                              Expanded(
                                child: Text("Saldo : "),
                                flex: 1,
                              ),
                              Expanded(
                                child: Text("Rp. " + userprofile.saldo),
                                flex: 1,
                              )
                            ],
                          ),
                        ),
                  int.parse(paketsekarang.harga.toString()) > 999
                      ? Container(
                          child: Row(
                            children: [
                              Expanded(
                                child: Text("Harga Paket : "),
                                flex: 1,
                              ),
                              Expanded(
                                child: Text("Rp. " +
                                    frmt.format(
                                        int.parse(paketsekarang.harga))),
                                flex: 1,
                              )
                            ],
                          ),
                        )
                      : Container(
                          child: Row(
                            children: [
                              Expanded(
                                child: Text("Harga Paket : "),
                                flex: 1,
                              ),
                              Expanded(
                                child: Text("Rp. " + paketsekarang.harga),
                                flex: 1,
                              )
                            ],
                          ),
                        ),
                  Container(
                      // child: Text("-----------------------------"),
                      child: Divider(
                    color: Colors.black,
                  ))
                ],
              )),
            ),
            new Expanded(
                child: Container(
              child: Row(
                children: [
                  Expanded(child: Text("Saldo Akhir : ")),
                  Expanded(
                      child: int.parse(userprofile.saldo) -
                                  int.parse(paketsekarang.harga) >=
                              0
                          ? Text("Rp. " +
                              frmt.format(int.parse(userprofile.saldo) -
                                  int.parse(paketsekarang.harga)))
                          : Text(
                              "Rp. " +
                                  frmt.format(int.parse(userprofile.saldo) -
                                      int.parse(paketsekarang.harga)),
                              style: TextStyle(color: Colors.red),
                            ))
                ],
              ),
            )),
            new Expanded(
              child: Row(
                children: [
                  SizedBox(width: 30),
                  Container(
                    child: new RaisedButton(
                      onPressed: () {
                        int.parse(userprofile.saldo) >
                                int.parse(paketsekarang.harga)
                            ? beliPaket()
                            : Fluttertoast.showToast(
                                msg: "Saldo Anda Tidak Cukup");
                        Navigator.of(context, rootNavigator: true).pop(true);
                      },
                      padding: new EdgeInsets.all(16.0),
                      color: Colors.green,
                      child: new Text(
                        'Beli',
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
                        'Batal',
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

  // Future<List<ClassJadwal>> sesuaikanJadwal(int harike) async {
  //   List<ClassJadwal> tempJadwal = new List();
  //   ClassJadwal databaru =
  //       new ClassJadwal("id", "id_paket", "hari", "waktu", "keterangan", "");
  //   for (int i = 0; i < allJadwal.length; i++) {
  //     if (allJadwal[i].hari == harike.toString()) {
  //       databaru = ClassJadwal(
  //           allJadwal[i].id,
  //           allJadwal[i].id_paket,
  //           allJadwal[i].hari,
  //           allJadwal[i].waktu,
  //           allJadwal[i].keterangan,
  //           allJadwal[i].takaran);
  //       tempJadwal.add(databaru);
  //     }
  //   }
  //   setState(() => this.arrJadwal = tempJadwal);
  //   print(arrJadwal.length.toString() + " data");
  //   return tempJadwal;
  // }

  Future<List<ClassJadwal>> getJadwal() async {
    List<ClassJadwal> tempJadwal = new List();
    Map paramData = {'id': id};
    var parameter = json.encode(paramData);
    ClassJadwal databaru =
        new ClassJadwal("id", "id_paket", "hari", "waktu", "keterangan", "");
    http
        .post(Uri.parse(session.ipnumber + "/getjadwalbyid"),
            headers: {"Content-Type": "application/json"}, body: parameter)
        .then((res) {
      var data = json.decode(res.body);
      data = data[0]['jadwal'];
      for (int i = 0; i < data.length; i++) {
        databaru = ClassJadwal(
            data[i]['id'].toString(),
            data[i]['id_paket'].toString(),
            data[i]['hari'].toString(),
            data[i]['waktu'].toString(),
            data[i]['keterangan'].toString(),
            data[i]['takaran'].toString());
        tempJadwal.add(databaru);
      }
      setState(() => this.arrJadwal = tempJadwal);
      setState(() => this.allJadwal = tempJadwal);
      // sesuaikanJadwal(hari);
      return tempJadwal;
    }).catchError((err) {
      print(err);
    });
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
    Map paramData = {'id': id};
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
          data[0]['background'].toString());
      setState(() => this.paketsekarang = arrPaket);
      return arrPaket;
    }).catchError((err) {
      print(err);
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text("Detail Paket " + id),
        backgroundColor: session.warna,
      ),
      body: DefaultTabController(
        length: 4,
        child: Scaffold(
          body: Column(
            children: <Widget>[
              SizedBox(
                child: Center(
                  child: Stack(children: <Widget>[
                    new Image.network(session.ipnumber +
                        "/gambar/jenis_paket/" +
                        paketsekarang.gambar),
                    Positioned.fill(
                        top: 35,
                        child: Align(
                            alignment: Alignment.topRight,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Text(
                                  paketsekarang.nama + " ",
                                  style: TextStyle(
                                      fontSize: 25,
                                      fontWeight: FontWeight.w300,
                                      fontFamily: "PoiretOne"),
                                ),
                                Text(paketsekarang.rating.substring(0, 3)),
                                SizedBox(width: 5),
                                Container(
                                  height: 20,
                                  width: 20,
                                  child: Image.asset("assets/images/bfull.png"),
                                ),
                              ],
                            ))),
                    Positioned.fill(
                        top: 65,
                        child: Align(
                          alignment: Alignment.topRight,
                          child: Text(
                            "By : " + konsultan,
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                        )),
                    Positioned.fill(
                        top: 95,
                        child: Align(
                          alignment: Alignment.topRight,
                          child: Text(
                            paketsekarang.durasi + " hari",
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                        )),
                    Positioned.fill(
                        top: 125,
                        child: Align(
                          alignment: Alignment.topRight,
                          child: Text(
                            "Rp " + frmt.format(int.parse(paketsekarang.harga)),
                            style: TextStyle(
                                fontSize: 25,
                                fontWeight: FontWeight.w300,
                                fontFamily: 'Biryani'),
                          ),
                        )),
                    // Positioned.fill(
                    //   top: 155,
                    //   child: Align(
                    //       alignment: Alignment.topRight,
                    //       child: Row(
                    //         children: [
                    //           Container(
                    //             height: 20,
                    //             width: 20,
                    //             child: Image.asset("assets/images/bfull.png"),
                    //           ),
                    //           SizedBox(width: 5),
                    //           Text(paketsekarang.rating.substring(0, 3))
                    //         ],
                    //       )),
                    // )
                  ]),
                ),
              ),
              SizedBox(
                height: 50,
                child: AppBar(
                  backgroundColor: session.warna,
                  bottom: TabBar(
                    tabs: [
                      Tab(text: "Deskripsi Paket"),
                      Tab(text: "Jadwal"),
                      Tab(text: "Review"),
                      Tab(text: "Testimoni")
                    ],
                  ),
                ),
              ),
              Expanded(
                child: TabBarView(
                  children: [
                    // first tab bar view widget
                    Container(
                      child: ListView(
                        children: [
                          Container(
                            padding: EdgeInsets.fromLTRB(10, 15, 0, 10),
                            child: Text(
                              "Deskripsi Paket : ",
                              // paketsekarang.deskripsi,
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 17,
                                  fontFamily: "Biryani"),
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.fromLTRB(10, 15, 0, 10),
                            child: Text(
                              // "Deskripsi : " + paketsekarang.deskripsi,
                              paketsekarang.deskripsi,
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 17,
                                  fontFamily: "Biryani"),
                            ),
                          ),
                        ],
                      ),
                    ),

                    // second tab bar viiew widget
                    Container(
                      child: ListView(
                        children: [
                          // Container(
                          //   padding: EdgeInsets.fromLTRB(20, 10, 10, 0),
                          //   child: Center(
                          //     child: Row(
                          //       mainAxisAlignment: MainAxisAlignment.center,
                          //       children: [
                          //         Expanded(
                          //             flex: 2,
                          //             child: Text(
                          //               "Hari " + hari.toString(),
                          //               style: TextStyle(fontSize: 20),
                          //             )),
                          //         Expanded(
                          //           flex: 1,
                          //           child: RaisedButton(
                          //             shape: RoundedRectangleBorder(
                          //               borderRadius: BorderRadius.circular(2),
                          //             ),
                          //             onPressed: () {
                          //               evtSebelum();
                          //             },
                          //             color: Colors.lightBlueAccent,
                          //             child: Text(
                          //               '<',
                          //               style: TextStyle(color: Colors.white),
                          //             ),
                          //           ),
                          //         ),
                          //         Expanded(
                          //           flex: 1,
                          //           child: RaisedButton(
                          //             shape: RoundedRectangleBorder(
                          //               borderRadius: BorderRadius.circular(2),
                          //             ),
                          //             onPressed: () {
                          //               evtSesudah();
                          //             },
                          //             color: Colors.lightBlueAccent,
                          //             child: Text(
                          //               '>',
                          //               style: TextStyle(color: Colors.white),
                          //             ),
                          //           ),
                          //         )
                          //       ],
                          //     ),
                          //   ),
                          // ),
                          SizedBox(height: 15),
                          Container(
                              padding: EdgeInsets.fromLTRB(10, 10, 0, 10),
                              child: SizedBox(
                                height: 190,
                                child: new ListView.builder(
                                    itemCount: arrJadwal.length == 0
                                        ? 0
                                        : arrJadwal.length,
                                    itemBuilder: (context, index) {
                                      if (arrJadwal.length == 0) {
                                        return Card(
                                          child: Text("Data empty"),
                                        );
                                      } else {
                                        return Card(
                                            child: Row(
                                          children: [
                                            Expanded(
                                                flex: 3,
                                                child: Text(
                                                    // arrJadwal[index].takaran +
                                                    " " +
                                                        arrJadwal[index]
                                                            .keterangan)),
                                          ],
                                        ));
                                      }
                                    }),
                              )),
                        ],
                      ),
                    ),
                    Container(
                      child: ListView(
                        children: [
                          Container(
                              padding: EdgeInsets.fromLTRB(10, 15, 10, 10),
                              child: SizedBox(
                                  height: 200,
                                  width: 150,
                                  child: new ListView.builder(
                                      itemCount: arrReview.length == 0
                                          ? 1
                                          : arrReview.length,
                                      itemBuilder: (context, index) {
                                        if (arrReview.length == 0) {
                                          return Image.asset(
                                              "assets/images/nodata.png");
                                        } else {
                                          return Card(
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Container(
                                                    padding:
                                                        EdgeInsets.fromLTRB(
                                                            10, 10, 10, 10),
                                                    child: Image.asset(
                                                      "assets/images/avatar.png",
                                                      height: 75,
                                                      width: 75,
                                                    )),
                                                Container(
                                                  child: Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Container(
                                                          padding: EdgeInsets
                                                              .fromLTRB(20, 10,
                                                                  10, 0),
                                                          child: Text(
                                                            arrReview[index]
                                                                .namauser,
                                                            style: TextStyle(
                                                                fontSize: 16,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold),
                                                          )),
                                                      Container(
                                                        padding:
                                                            EdgeInsets.fromLTRB(
                                                                20, 10, 10, 0),
                                                        child: Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .start,
                                                          children: [
                                                            cetakbintang(
                                                                1,
                                                                double.parse(
                                                                    arrReview[
                                                                            index]
                                                                        .rtpaket)),
                                                            cetakbintang(
                                                                2,
                                                                double.parse(
                                                                    arrReview[
                                                                            index]
                                                                        .rtpaket)),
                                                            cetakbintang(
                                                                3,
                                                                double.parse(
                                                                    arrReview[
                                                                            index]
                                                                        .rtpaket)),
                                                            cetakbintang(
                                                                4,
                                                                double.parse(
                                                                    arrReview[
                                                                            index]
                                                                        .rtpaket)),
                                                            cetakbintang(
                                                                5,
                                                                double.parse(
                                                                    arrReview[
                                                                            index]
                                                                        .rtpaket)),
                                                          ],
                                                        ),
                                                      ),
                                                      Container(
                                                          width:
                                                              size.width / 1.5,
                                                          padding: EdgeInsets
                                                              .fromLTRB(20, 10,
                                                                  10, 10),
                                                          child: Row(
                                                            children: [
                                                              Expanded(
                                                                child: Text(
                                                                    '"' +
                                                                        arrReview[index]
                                                                            .rvpaket +
                                                                        '"',
                                                                    style: TextStyle(
                                                                        fontSize:
                                                                            15,
                                                                        fontWeight:
                                                                            FontWeight.bold)),
                                                              )
                                                            ],
                                                          ))
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          );
                                        }
                                      }))),
                        ],
                      ),
                    ),
                    Container(
                      child: ListView(
                        children: [
                          Container(
                              padding: EdgeInsets.fromLTRB(10, 15, 10, 10),
                              child: SizedBox(
                                  height: 200,
                                  width: 150,
                                  child: new ListView.builder(
                                      itemCount: arrTesti.length == 0
                                          ? 1
                                          : arrTesti.length,
                                      itemBuilder: (context, index) {
                                        if (arrTesti.length == 0) {
                                          return Container(
                                              child: Text(
                                                  "Belum Ada Data Testimoni",
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold)));
                                        } else {
                                          return Card(
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Container(
                                                    padding:
                                                        EdgeInsets.fromLTRB(
                                                            10, 10, 10, 10),
                                                    child: Image.asset(
                                                      "assets/images/avatar.png",
                                                      height: 75,
                                                      width: 75,
                                                    )),
                                                Container(
                                                  child: Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Container(
                                                          padding: EdgeInsets
                                                              .fromLTRB(20, 10,
                                                                  10, 0),
                                                          child: Text(
                                                            arrTesti[index]
                                                                .username,
                                                            style: TextStyle(
                                                                fontSize: 16,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold),
                                                          )),
                                                      Container(
                                                        padding:
                                                            EdgeInsets.fromLTRB(
                                                                20, 10, 10, 0),
                                                        child: Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .start,
                                                          children: [
                                                            cetakbintang(
                                                                1,
                                                                arrTesti[index]
                                                                    .rating),
                                                            cetakbintang(
                                                                2,
                                                                arrTesti[index]
                                                                    .rating),
                                                            cetakbintang(
                                                                3,
                                                                arrTesti[index]
                                                                    .rating),
                                                            cetakbintang(
                                                                4,
                                                                arrTesti[index]
                                                                    .rating),
                                                            cetakbintang(
                                                                5,
                                                                arrTesti[index]
                                                                    .rating),
                                                          ],
                                                        ),
                                                      ),
                                                      Container(
                                                          width:
                                                              size.width / 1.5,
                                                          padding: EdgeInsets
                                                              .fromLTRB(20, 10,
                                                                  10, 10),
                                                          child: Row(
                                                            children: [
                                                              Expanded(
                                                                child: Text(
                                                                    '"' +
                                                                        arrTesti[index]
                                                                            .review +
                                                                        '"',
                                                                    style: TextStyle(
                                                                        fontSize:
                                                                            15,
                                                                        fontWeight:
                                                                            FontWeight.bold)),
                                                              )
                                                            ],
                                                          ))
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          );
                                        }
                                      }))),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                child: RaisedButton(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(2),
                  ),
                  onPressed: () {
                    showAlert();
                  },
                  color: Colors.lightBlueAccent,
                  child: Text(
                    'Beli Paket',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
