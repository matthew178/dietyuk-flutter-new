import 'package:dietyukapp/DetailTerimaProduk.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';

import 'ClassTransaksiProdukJoin.dart';
import 'DetailBeliProduk.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'session.dart' as session;
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'ClassDetailBeliProduk.dart';

class daftarpesananmember extends StatefulWidget {
  @override
  daftarpesananmemberState createState() => daftarpesananmemberState();
}

class daftarpesananmemberState extends State<daftarpesananmember> {
  List<TransaksiProdukJoin> packing = new List();
  List<TransaksiProdukJoin> kirim = new List();
  List<TransaksiProdukJoin> selesai = new List();
  List<ClassDetailBeliProduk> detailpacking = new List();
  List<ClassDetailBeliProduk> detailkirim = new List();
  List<ClassDetailBeliProduk> detailselesai = new List();
  NumberFormat frmt = new NumberFormat(',000');

  void initState() {
    super.initState();
    getTransaksiPacking();
    getTransaksiKirim();
    getTransaksiSelesai();
  }

  Future<List<TransaksiProdukJoin>> getTransaksiPacking() async {
    List<TransaksiProdukJoin> arrTemp = new List();
    List<ClassDetailBeliProduk> arrTempDetail = new List();
    Map paramData = {'pemesan': session.userlogin};
    var parameter = json.encode(paramData);
    TransaksiProdukJoin databaru = new TransaksiProdukJoin(
        "id",
        "pemesan",
        "konsultan",
        "alamat",
        "waktubeli",
        "total",
        "status",
        "nomorresi",
        "kurir",
        "service",
        "keterangan",
        "",
        "",
        "",
        "",
        "",
        "",
        "",
        "",
        "0",
        "0");
    ClassDetailBeliProduk detailbaru = new ClassDetailBeliProduk(
        "id",
        "idbeli",
        "idproduk",
        "jumlah",
        "harga",
        "subtotal",
        "namaproduk",
        "varian",
        "foto");
    http
        .post(Uri.parse(session.ipnumber + "/getTransaksiPackingMember"),
            headers: {"Content-Type": "application/json"}, body: parameter)
        .then((res) {
      print(res.body);
      var data = json.decode(res.body);
      var datadetail = data[0]['detail'];
      var hitung = data[0]['hitung'];
      data = data[0]['transaksi'];
      for (int i = 0; i < data.length; i++) {
        databaru = TransaksiProdukJoin(
            data[i]['id'].toString(),
            data[i]['pemesan'].toString(),
            data[i]['konsultan'].toString(),
            data[i]['alamat'].toString(),
            data[i]['waktubeli'].toString(),
            data[i]['total'].toString(),
            data[i]['status'].toString(),
            data[i]['nomorresi'].toString(),
            data[i]['kurir'].toString(),
            data[i]['service'].toString(),
            data[i]['keterangan'].toString(),
            data[i]['nama'].toString(),
            data[i]['penerima'].toString(),
            data[i]['nomortelepon'].toString(),
            data[i]['nama_kota'].toString(),
            data[i]['provinsi'].toString(),
            data[i]['alamat_detail'].toString(),
            data[i]['nopesanan'].toString(),
            hitung[i].toString(),
            data[i]['totalharga'].toString(),
            data[i]['ongkir'].toString());
        arrTemp.add(databaru);
      }
      setState(() => this.packing = arrTemp);
      for (int j = 0; j < datadetail.length; j++) {
        detailbaru = ClassDetailBeliProduk(
            datadetail[j]["id"].toString(),
            datadetail[j]["idbeli"].toString(),
            datadetail[j]["idproduk"].toString(),
            datadetail[j]["jumlah"].toString(),
            datadetail[j]["harga"].toString(),
            datadetail[j]["subtotal"].toString(),
            datadetail[j]["namaproduk"].toString(),
            datadetail[j]["varian"].toString(),
            datadetail[j]["foto"].toString());
        arrTempDetail.add(detailbaru);
      }
      setState(() => this.detailpacking = arrTempDetail);
      return arrTemp;
    }).catchError((err) {
      print(err);
    });
  }

  Future<List<TransaksiProdukJoin>> getTransaksiKirim() async {
    List<TransaksiProdukJoin> arrTemp = new List();
    List<ClassDetailBeliProduk> arrTempDetail = new List();
    Map paramData = {'pemesan': session.userlogin};
    var parameter = json.encode(paramData);
    TransaksiProdukJoin databaru = new TransaksiProdukJoin(
        "id",
        "pemesan",
        "konsultan",
        "alamat",
        "waktubeli",
        "total",
        "status",
        "nomorresi",
        "kurir",
        "service",
        "keterangan",
        "",
        "",
        "",
        "",
        "",
        "",
        "",
        "",
        "0",
        "0");
    ClassDetailBeliProduk detailbaru = new ClassDetailBeliProduk(
        "id",
        "idbeli",
        "idproduk",
        "jumlah",
        "harga",
        "subtotal",
        "namaproduk",
        "varian",
        "foto");
    http
        .post(Uri.parse(session.ipnumber + "/getTransaksiKirimMember"),
            headers: {"Content-Type": "application/json"}, body: parameter)
        .then((res) {
      print(res.body);
      var data = json.decode(res.body);
      var datadetail = data[0]['detail'];
      var hitung = data[0]['hitung'];
      data = data[0]['transaksi'];
      for (int i = 0; i < data.length; i++) {
        databaru = TransaksiProdukJoin(
            data[i]['id'].toString(),
            data[i]['pemesan'].toString(),
            data[i]['konsultan'].toString(),
            data[i]['alamat'].toString(),
            data[i]['waktubeli'].toString(),
            data[i]['total'].toString(),
            data[i]['status'].toString(),
            data[i]['nomorresi'].toString(),
            data[i]['kurir'].toString(),
            data[i]['service'].toString(),
            data[i]['keterangan'].toString(),
            data[i]['nama'].toString(),
            data[i]['penerima'].toString(),
            data[i]['nomortelepon'].toString(),
            data[i]['nama_kota'].toString(),
            data[i]['provinsi'].toString(),
            data[i]['alamat_detail'].toString(),
            data[i]['nopesanan'].toString(),
            hitung[i].toString(),
            data[i]['totalharga'].toString(),
            data[i]['ongkir'].toString());
        arrTemp.add(databaru);
      }
      setState(() => this.kirim = arrTemp);
      for (int j = 0; j < datadetail.length; j++) {
        detailbaru = ClassDetailBeliProduk(
            datadetail[j]["id"].toString(),
            datadetail[j]["idbeli"].toString(),
            datadetail[j]["idproduk"].toString(),
            datadetail[j]["jumlah"].toString(),
            datadetail[j]["harga"].toString(),
            datadetail[j]["subtotal"].toString(),
            datadetail[j]["namaproduk"].toString(),
            datadetail[j]["varian"].toString(),
            datadetail[j]["foto"].toString());
        arrTempDetail.add(detailbaru);
      }
      setState(() => this.detailkirim = arrTempDetail);
      return arrTemp;
    }).catchError((err) {
      print(err);
    });
  }

  Future<List<TransaksiProdukJoin>> getTransaksiSelesai() async {
    List<TransaksiProdukJoin> arrTemp = new List();
    List<ClassDetailBeliProduk> arrTempDetail = new List();
    Map paramData = {'pemesan': session.userlogin};
    var parameter = json.encode(paramData);
    TransaksiProdukJoin databaru = new TransaksiProdukJoin(
        "id",
        "pemesan",
        "konsultan",
        "alamat",
        "waktubeli",
        "total",
        "status",
        "nomorresi",
        "kurir",
        "service",
        "keterangan",
        "",
        "",
        "",
        "",
        "",
        "",
        "",
        "",
        "0",
        "0");
    ClassDetailBeliProduk detailbaru = new ClassDetailBeliProduk(
        "id",
        "idbeli",
        "idproduk",
        "jumlah",
        "harga",
        "subtotal",
        "namaproduk",
        "varian",
        "foto");
    http
        .post(Uri.parse(session.ipnumber + "/getTransaksiSelesaiMember"),
            headers: {"Content-Type": "application/json"}, body: parameter)
        .then((res) {
      print(res.body);
      var data = json.decode(res.body);
      var datadetail = data[0]['detail'];
      var hitung = data[0]['hitung'];
      data = data[0]['transaksi'];
      for (int i = 0; i < data.length; i++) {
        databaru = TransaksiProdukJoin(
            data[i]['id'].toString(),
            data[i]['pemesan'].toString(),
            data[i]['konsultan'].toString(),
            data[i]['alamat'].toString(),
            data[i]['waktubeli'].toString(),
            data[i]['total'].toString(),
            data[i]['status'].toString(),
            data[i]['nomorresi'].toString(),
            data[i]['kurir'].toString(),
            data[i]['service'].toString(),
            data[i]['keterangan'].toString(),
            data[i]['nama'].toString(),
            data[i]['penerima'].toString(),
            data[i]['nomortelepon'].toString(),
            data[i]['nama_kota'].toString(),
            data[i]['provinsi'].toString(),
            data[i]['alamat_detail'].toString(),
            data[i]['nopesanan'].toString(),
            hitung[i].toString(),
            data[i]['totalharga'].toString(),
            data[i]['ongkir'].toString());
        arrTemp.add(databaru);
      }
      setState(() => this.selesai = arrTemp);
      for (int j = 0; j < datadetail.length; j++) {
        detailbaru = ClassDetailBeliProduk(
            datadetail[j]["id"].toString(),
            datadetail[j]["idbeli"].toString(),
            datadetail[j]["idproduk"].toString(),
            datadetail[j]["jumlah"].toString(),
            datadetail[j]["harga"].toString(),
            datadetail[j]["subtotal"].toString(),
            datadetail[j]["namaproduk"].toString(),
            datadetail[j]["varian"].toString(),
            datadetail[j]["foto"].toString());
        arrTempDetail.add(detailbaru);
      }
      setState(() => this.detailselesai = arrTempDetail);
      return arrTemp;
    }).catchError((err) {
      print(err);
    });
  }

  void getDataUlang() async {
    getTransaksiKirim();
    getTransaksiPacking();
    getTransaksiSelesai();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: session.warna,
        title: Text("Pesanan Saya"),
      ),
      body: DefaultTabController(
        length: 3,
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
                        text: "Packing",
                      ),
                      Tab(
                        text: "Kirim",
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
                            itemCount: packing.length == 0 ? 1 : packing.length,
                            itemBuilder: (context, index) {
                              if (packing.length == 0) {
                                return Image.asset("assets/images/nodata.png");
                              } else {
                                return GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      DetailBeliProduk(
                                                          idbeli: packing[index]
                                                              .id)))
                                          .then((value) => getDataUlang());
                                    },
                                    child: Card(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            children: [
                                              Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Container(
                                                      width:
                                                          MediaQuery.of(context)
                                                                      .size
                                                                      .width /
                                                                  2 +
                                                              90,
                                                      padding:
                                                          EdgeInsets.fromLTRB(
                                                              15, 10, 0, 0),
                                                      child: Text(
                                                        "Pembeli : " +
                                                            packing[index].nama,
                                                        style: TextStyle(
                                                            fontSize: 15,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      )),
                                                ],
                                              ),
                                              Container(
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width /
                                                      4,
                                                  padding: EdgeInsets.fromLTRB(
                                                      0, 10, 0, 0),
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment.end,
                                                    children: [
                                                      Text(
                                                        "#" +
                                                            packing[index]
                                                                .nopesanan,
                                                        style: TextStyle(
                                                            fontSize: 15,
                                                            color: Colors.grey),
                                                      )
                                                    ],
                                                  )),
                                            ],
                                          ),
                                          Divider(
                                            color: Colors.black,
                                          ),
                                          Row(
                                            children: [
                                              SizedBox(width: 5),
                                              SizedBox(
                                                height: 125,
                                                width: 125,
                                                child: Image.network(session
                                                        .ipnumber +
                                                    "/gambar/produk/" +
                                                    detailpacking[index].foto),
                                              ),
                                              SizedBox(width: 5),
                                              Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Container(
                                                      width: 200,
                                                      child: Text(
                                                        detailpacking[index]
                                                                .namaproduk +
                                                            " " +
                                                            detailpacking[index]
                                                                .varian,
                                                        style: TextStyle(
                                                            fontSize: 15,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      )),
                                                  SizedBox(height: 25),
                                                  Container(
                                                    width: 250,
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .end,
                                                      children: [
                                                        Text(
                                                          "x" +
                                                              detailpacking[
                                                                      index]
                                                                  .jumlah,
                                                          style: TextStyle(
                                                              fontSize: 13,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                        ),
                                                        SizedBox(height: 10),
                                                        Text("Rp. " +
                                                            frmt.format(int.parse(
                                                                detailpacking[
                                                                        index]
                                                                    .subtotal)))
                                                      ],
                                                    ),
                                                  )
                                                ],
                                              ),
                                            ],
                                          ),
                                          Divider(color: Colors.black),
                                          Container(
                                              width: MediaQuery.of(context)
                                                  .size
                                                  .width,
                                              child: Row(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    SizedBox(width: 10),
                                                    Container(
                                                        width: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .width /
                                                            5,
                                                        child: Text(
                                                          packing[index]
                                                                  .jumlahproduk +
                                                              " item",
                                                          style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              fontSize: 15),
                                                        )),
                                                    Container(
                                                        width: MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width /
                                                                2 +
                                                            100,
                                                        child: Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .end,
                                                          children: [
                                                            Text(
                                                              "Total Pesanan : Rp. " +
                                                                  frmt.format(int
                                                                      .parse(packing[
                                                                              index]
                                                                          .total
                                                                          .toString())),
                                                              style: TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  fontSize: 15),
                                                            )
                                                          ],
                                                        ))
                                                  ])),
                                          SizedBox(height: 5)
                                        ],
                                      ),
                                    ));
                              }
                            })),
                    Container(
                        child: new ListView.builder(
                            itemCount: kirim.length == 0 ? 1 : kirim.length,
                            itemBuilder: (context, index) {
                              if (kirim.length == 0) {
                                return Image.asset("assets/images/nodata.png");
                              } else {
                                return GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      DetailTerimaProduk(
                                                          idbeli:
                                                              kirim[index].id)))
                                          .then((value) => getDataUlang());
                                    },
                                    child: Card(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            children: [
                                              Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Container(
                                                      width:
                                                          MediaQuery.of(context)
                                                                      .size
                                                                      .width /
                                                                  2 -
                                                              10,
                                                      padding:
                                                          EdgeInsets.fromLTRB(
                                                              15, 10, 0, 0),
                                                      child: Text(
                                                        "Pembeli : " +
                                                            kirim[index].nama,
                                                        style: TextStyle(
                                                            fontSize: 15,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      )),
                                                ],
                                              ),
                                              Container(
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width /
                                                      2,
                                                  padding: EdgeInsets.fromLTRB(
                                                      0, 10, 0, 0),
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment.end,
                                                    children: [
                                                      Text(
                                                        "#" +
                                                            kirim[index]
                                                                .nopesanan,
                                                        style: TextStyle(
                                                            fontSize: 15,
                                                            color: Colors.grey),
                                                      )
                                                    ],
                                                  )),
                                            ],
                                          ),
                                          Divider(
                                            color: Colors.black,
                                          ),
                                          Row(
                                            children: [
                                              SizedBox(width: 5),
                                              SizedBox(
                                                height: 125,
                                                width: 125,
                                                child: Image.network(session
                                                        .ipnumber +
                                                    "/gambar/produk/" +
                                                    detailkirim[index].foto),
                                              ),
                                              SizedBox(width: 5),
                                              Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Container(
                                                      width: 200,
                                                      child: Text(
                                                        detailkirim[index]
                                                                .namaproduk +
                                                            " " +
                                                            detailkirim[index]
                                                                .varian,
                                                        style: TextStyle(
                                                            fontSize: 15,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      )),
                                                  SizedBox(height: 25),
                                                  Container(
                                                    width: 250,
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .end,
                                                      children: [
                                                        Text(
                                                            "x" +
                                                                detailkirim[
                                                                        index]
                                                                    .jumlah,
                                                            style: TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold)),
                                                        SizedBox(height: 10),
                                                        Text(
                                                          "Rp. " +
                                                              frmt.format(int.parse(
                                                                  detailkirim[
                                                                          index]
                                                                      .subtotal)),
                                                          style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                        )
                                                      ],
                                                    ),
                                                  )
                                                ],
                                              ),
                                            ],
                                          ),
                                          Divider(color: Colors.black),
                                          Container(
                                              width: MediaQuery.of(context)
                                                  .size
                                                  .width,
                                              child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.end,
                                                  children: [
                                                    Text(
                                                      "Total Pesanan : Rp. " +
                                                          frmt.format(int.parse(
                                                              kirim[index]
                                                                  .total
                                                                  .toString())),
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 15),
                                                    ),
                                                  ])),
                                          SizedBox(height: 5)
                                        ],
                                      ),
                                    ));
                              }
                            })),
                    Container(
                        child: new ListView.builder(
                            itemCount: selesai.length == 0 ? 1 : selesai.length,
                            itemBuilder: (context, index) {
                              if (selesai.length == 0) {
                                return Image.asset("assets/images/nodata.png");
                              } else {
                                return GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      DetailBeliProduk(
                                                          idbeli: selesai[index]
                                                              .id)))
                                          .then((value) => getDataUlang());
                                    },
                                    child: Card(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            children: [
                                              Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Container(
                                                      width:
                                                          MediaQuery.of(context)
                                                                      .size
                                                                      .width /
                                                                  2 -
                                                              10,
                                                      padding:
                                                          EdgeInsets.fromLTRB(
                                                              15, 10, 0, 0),
                                                      child: Text(
                                                        "Pembeli : " +
                                                            selesai[index].nama,
                                                        style: TextStyle(
                                                            fontSize: 15,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      )),
                                                ],
                                              ),
                                              Container(
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width /
                                                      2,
                                                  padding: EdgeInsets.fromLTRB(
                                                      0, 10, 0, 0),
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment.end,
                                                    children: [
                                                      Text(
                                                        "#" +
                                                            selesai[index]
                                                                .nopesanan,
                                                        style: TextStyle(
                                                            fontSize: 15,
                                                            color: Colors.grey),
                                                      )
                                                    ],
                                                  )),
                                            ],
                                          ),
                                          Divider(
                                            color: Colors.black,
                                          ),
                                          Row(
                                            children: [
                                              SizedBox(width: 5),
                                              SizedBox(
                                                height: 125,
                                                width: 125,
                                                child: Image.network(session
                                                        .ipnumber +
                                                    "/gambar/produk/" +
                                                    detailselesai[index].foto),
                                              ),
                                              SizedBox(width: 5),
                                              Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Container(
                                                      width: 200,
                                                      child: Text(
                                                        detailselesai[index]
                                                                .namaproduk +
                                                            " " +
                                                            detailselesai[index]
                                                                .varian,
                                                        style: TextStyle(
                                                            fontSize: 15,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      )),
                                                  SizedBox(height: 25),
                                                  Container(
                                                    width: 250,
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .end,
                                                      children: [
                                                        Text(
                                                          "x" +
                                                              detailselesai[
                                                                      index]
                                                                  .jumlah,
                                                          style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                        ),
                                                        SizedBox(height: 10),
                                                        Text(
                                                          "Rp. " +
                                                              frmt.format(int.parse(
                                                                  detailselesai[
                                                                          index]
                                                                      .subtotal)),
                                                          style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                        )
                                                      ],
                                                    ),
                                                  )
                                                ],
                                              ),
                                            ],
                                          ),
                                          Divider(color: Colors.black),
                                          Container(
                                              width: MediaQuery.of(context)
                                                  .size
                                                  .width,
                                              child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.end,
                                                  children: [
                                                    Text(
                                                      "Total Pesanan : Rp. " +
                                                          frmt.format(int.parse(
                                                              selesai[index]
                                                                  .total
                                                                  .toString())),
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 15),
                                                    ),
                                                  ])),
                                          SizedBox(height: 5)
                                        ],
                                      ),
                                    ));
                              }
                            })),
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
