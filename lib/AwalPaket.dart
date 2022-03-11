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

class AwalPaket extends StatefulWidget {
  final String id;
  final String paket;
  final String status;

  AwalPaket(
      {Key key, @required this.id, @required this.paket, @required this.status})
      : super(key: key);

  @override
  AwalPaketState createState() =>
      AwalPaketState(this.id, this.paket, this.status);
}

class AwalPaketState extends State<AwalPaket> {
  String week = "1";
  ClassPaket paketsekarang = new ClassPaket("id", "estimasi", "0", "durasi",
      "status", "", "konsultan", "namapaket1", "deskripsi", "default.jpg");
  String id, paket, status;
  // List<DetailBeli> detail = new List();
  // List<DetailBeli> tempDetail = new List();
  // List<ClassPerkembangan> arrLaporan = new List();
  List<ClassAwalPaket> arrTemp = [];
  List<ClassAwalPaket> arrAwal = [];
  TextEditingController timbang = new TextEditingController();
  int durasi = 5;
  int tmp = 1;
  String foto = "assets/images/awalpage.png";

  AwalPaketState(this.id, this.paket, this.status);

  @override
  void initState() {
    super.initState();
    getPaket();
    getDetail();
    var listImagesnotFound = [
      "assets/images/awalpage.png",
      "assets/images/awalpage2.png",
      "assets/images/awalpage3.png",
      "assets/images/awalpage4.png",
      "assets/images/awalpage5.png"
    ];
    var _random = Random();
    var hasil = _random.nextInt(listImagesnotFound.length);
    foto = listImagesnotFound[hasil];
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
    // ClassAwalPaket databaru =
    //     new ClassAwalPaket("id", "id_paket", "hari", "waktu", "");
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

  void tambahPerkembangan(String id, brt, stts, idbeli, harike) async {
    Map paramData = {
      'id': id,
      'berat': brt,
      'status': stts,
      'user': session.userlogin,
      'idbeli': idbeli,
      'harike': harike
    };
    var parameter = json.encode(paramData);
    if (id != "" || brt != "" || stts != "" || idbeli != "" || harike != "") {
      http
          .post(Uri.parse(session.ipnumber + "/tambahPerkembangan"),
              headers: {"Content-Type": "application/json"}, body: parameter)
          .then((res) {
        getDetail();
      }).catchError((err) {
        print(err);
      });
    } else {
      Fluttertoast.showToast(msg: "Inputan ada yang kosong!");
    }
  }

  void cetakdialog(String idsaatini, statussaatini, idbel, hrike) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return StatefulBuilder(builder: (context, setState) {
            return Dialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0)), //this right here
              child: Container(
                // color: Colors.red,
                height: 200,
                child: Padding(
                  padding: const EdgeInsets.all(0.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
                        child: Text(
                          "Berat Badan Saat Ini ? ",
                          style: TextStyle(fontSize: 15),
                        ),
                      ),
                      Container(
                          padding: EdgeInsets.fromLTRB(10, 10, 0, 0),
                          child: Row(
                            children: [
                              Container(
                                width: 150,
                                child: TextField(
                                    controller: timbang,
                                    keyboardType: TextInputType.number),
                              ),
                              SizedBox(width: 25),
                              Container(
                                child: Text(
                                  "kg",
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              )
                            ],
                          )),
                      SizedBox(height: 10),
                      Container(
                        padding: EdgeInsets.fromLTRB(10, 10, 0, 0),
                        child: new RaisedButton(
                          onPressed: () {
                            if (timbang.text != "") {
                              tambahPerkembangan(idsaatini, timbang.text,
                                  statussaatini, idbel, hrike);

                              Fluttertoast.showToast(
                                  msg: "Berhasil tambah perkembangan");
                              Navigator.of(context, rootNavigator: true)
                                  .pop(true);
                            } else {
                              Fluttertoast.showToast(
                                  msg: "Input tidak boleh kosong!");
                            }
                          },
                          padding: new EdgeInsets.all(16.0),
                          color: Colors.green,
                          child: new Text(
                            'Submit',
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
              ),
            );
          });
        });
  }

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
              flex: 1,
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
              flex: 3,
              child: Image.asset(
                this.foto,
                fit: BoxFit.cover,
              ),
            ),
            Expanded(
                flex: 5,
                child: GridView.count(
                    crossAxisCount: 3,
                    crossAxisSpacing: 10.0,
                    mainAxisSpacing: 10.0,
                    children: List.generate(arrTemp.length, (index) {
                      return GestureDetector(
                          onTap: () {
                            arrTemp[index].tipe == "hari"
                                ? this.status == "1"
                                    ? Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => JadwalHarian(
                                                week: week,
                                                idbeli: id,
                                                hari: arrTemp[index].hari,
                                                tipe: 1)))
                                    : Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => JadwalHarian(
                                                week: week,
                                                idbeli: id,
                                                hari: arrTemp[index].hari,
                                                tipe: 2)))
                                : cetakdialog(
                                    arrTemp[index].id,
                                    arrTemp[index].keterangan,
                                    arrTemp[index].idbeli,
                                    arrTemp[index].hari);
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
                                                flex: 2,
                                                child: Text(
                                                  "Laporan\nHari Ke-" +
                                                      arrTemp[index].hari,
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontFamily: 'Biryani'),
                                                )),
                                            // Expanded(
                                            //     flex: 1,
                                            //     child: Text(
                                            //       arrTemp[index].tanggal,
                                            //       style: TextStyle(
                                            //           color: Colors.white,
                                            //           fontWeight:
                                            //               FontWeight.bold,
                                            //           fontFamily: 'Biryani'),
                                            //     )),
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
                                                    flex: 2,
                                                    child: Text(
                                                      "Laporan\nHari Ke-" +
                                                          arrTemp[index].hari,
                                                      style: TextStyle(
                                                          color: Colors.white,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontFamily:
                                                              'Biryani'),
                                                    )),
                                                // Expanded(
                                                //     flex: 1,
                                                //     child: Text(
                                                //       arrTemp[index].tanggal,
                                                //       style: TextStyle(
                                                //           color: Colors.white,
                                                //           fontWeight:
                                                //               FontWeight.bold,
                                                //           fontFamily:
                                                //               'Biryani'),
                                                //     )),
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
                                                        flex: 2,
                                                        child: Text(
                                                          "Laporan\nHari Ke-" +
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
                                                    // Expanded(
                                                    //     flex: 1,
                                                    //     child: Text(
                                                    //       arrTemp[index]
                                                    //           .tanggal,
                                                    //       style: TextStyle(
                                                    //           color:
                                                    //               Colors.white,
                                                    //           fontWeight:
                                                    //               FontWeight
                                                    //                   .bold,
                                                    //           fontFamily:
                                                    //               'Biryani'),
                                                    //     )),
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
                                                        flex: 2,
                                                        child: Text(
                                                          "Laporan\nHari Ke-" +
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
                                                    // Expanded(
                                                    //     flex: 1,
                                                    //     child: Text(
                                                    //       arrTemp[index]
                                                    //           .tanggal,
                                                    //       style: TextStyle(
                                                    //           color:
                                                    //               Colors.white,
                                                    //           fontWeight:
                                                    //               FontWeight
                                                    //                   .bold,
                                                    //           fontFamily:
                                                    //               'Biryani'),
                                                    //     )),
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
