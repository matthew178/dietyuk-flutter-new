import 'ClassDetailBeliProduk.dart';
import 'ClassTransaksiProdukJoin.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'session.dart' as session;
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'package:intl/intl.dart';

class DetailTerimaProduk extends StatefulWidget {
  final String idbeli;

  DetailTerimaProduk({Key key, @required this.idbeli}) : super(key: key);

  @override
  DetailTerimaProdukState createState() => DetailTerimaProdukState(this.idbeli);
}

class DetailTerimaProdukState extends State<DetailTerimaProduk> {
  String idbeli;
  TextEditingController edt = new TextEditingController();
  List<ClassDetailBeliProduk> arrDetail = new List();
  NumberFormat frmt = new NumberFormat(",000");
  TransaksiProdukJoin header = new TransaksiProdukJoin(
      "id",
      "pemesan",
      "konsultan",
      "alamat",
      "waktubeli",
      "0",
      "status",
      "nomorresi",
      "kurir",
      "service",
      "keterangan",
      "nama",
      "penerima",
      "nomortelepon",
      "namakota",
      "provinsi",
      "alamat_detail",
      "nopesanan",
      "jumlahproduk",
      "0",
      "0");
  bool lihat = false;
  DetailTerimaProdukState(this.idbeli);

  void updateResi() async {
    Map paramData = {'idbeli': this.idbeli, 'resi': edt.text};
    var parameter = json.encode(paramData);
    http
        .post(Uri.parse(session.ipnumber + "/updateResi"),
            headers: {"Content-Type": "application/json"}, body: parameter)
        .then((res) {
      Navigator.pop(context);
      Fluttertoast.showToast(msg: "Berhasil Input Resi");
    }).catchError((err) {
      print(err);
    });
  }

  void selesaikanPesanan() async {
    Map paramData = {'idbeli': this.idbeli};
    var parameter = json.encode(paramData);
    http
        .post(Uri.parse(session.ipnumber + "/selesaikanPesananMember"),
            headers: {"Content-Type": "application/json"}, body: parameter)
        .then((res) {
      Navigator.pop(context);
      Fluttertoast.showToast(msg: "Berhasil Input Resi");
    }).catchError((err) {
      print(err);
    });
  }

  void showAlert() {
    AlertDialog dialog = new AlertDialog(
      content: new Container(
        width: 260.0,
        height: 175,
        decoration: new BoxDecoration(
          shape: BoxShape.rectangle,
          color: const Color(0xFFFFFF),
          borderRadius: new BorderRadius.all(new Radius.circular(32.0)),
        ),
        child: new Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            new Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 5),
                  Text("Nomor Resi :"),
                  Container(
                    decoration: BoxDecoration(
                        border: Border.all(),
                        borderRadius: BorderRadius.circular(8)),
                    child: TextField(
                      controller: edt,
                      keyboardType: TextInputType.multiline,
                      maxLines: null,
                    ),
                  ),
                  SizedBox(height: 10),
                  Center(
                    child: Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          color: Colors.red),
                      child: FlatButton(
                        onPressed: () {
                          if (edt.text.isEmpty || edt.text == "") {
                            Fluttertoast.showToast(
                                msg: "Nomor Resi tidak boleh kosong!",
                                backgroundColor: Colors.red);
                          } else {
                            updateResi();
                            Navigator.pop(context);
                            Navigator.of(context, rootNavigator: true)
                                .pop(true);
                          }
                        },
                        child: Text(
                          'Kirim',
                          style: session.kBodyText
                              .copyWith(fontWeight: FontWeight.bold),
                        ),
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

  void showAlertLain() {
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
                      "Pesanan akan diselesaikan, dan uang akan masuk ke konsultan. Anda yakin ?")),
              flex: 2,
            ),
            new Expanded(
              child: Row(
                children: [
                  SizedBox(width: 30),
                  Container(
                    child: new RaisedButton(
                      onPressed: () {
                        selesaikanPesanan();
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

  Future<List<ClassDetailBeliProduk>> getDetail() async {
    List<ClassDetailBeliProduk> arrTemp = new List();
    Map paramData = {'idbeli': this.idbeli};
    var parameter = json.encode(paramData);
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
        .post(Uri.parse(session.ipnumber + "/getDetailTransProduk"),
            headers: {"Content-Type": "application/json"}, body: parameter)
        .then((res) {
      var data = json.decode(res.body);
      var header = data[0]['alamat'];
      data = data[0]['transaksi'];
      for (int j = 0; j < data.length; j++) {
        detailbaru = ClassDetailBeliProduk(
            data[j]["id"].toString(),
            data[j]["idbeli"].toString(),
            data[j]["idproduk"].toString(),
            data[j]["jumlah"].toString(),
            data[j]["harga"].toString(),
            data[j]["subtotal"].toString(),
            data[j]["namaproduk"].toString(),
            data[j]["varian"].toString(),
            data[j]["foto"].toString());
        arrTemp.add(detailbaru);
      }
      TransaksiProdukJoin temp = TransaksiProdukJoin(
          header[0]['id'].toString(),
          header[0]['pemesan'].toString(),
          header[0]['konsultan'].toString(),
          header[0]['alamat'].toString(),
          header[0]['waktubeli'].toString(),
          header[0]['total'].toString(),
          header[0]['status'].toString(),
          header[0]['nomorresi'].toString(),
          header[0]['kurir'].toString(),
          header[0]['service'].toString(),
          header[0]['keterangan'].toString(),
          header[0]['nama'].toString(),
          header[0]['penerima'].toString(),
          header[0]['nomortelepon'].toString(),
          header[0]['nama_kota'].toString(),
          header[0]['provinsi'].toString(),
          header[0]['alamat_detail'].toString(),
          header[0]['nopesanan'].toString(),
          "0",
          header[0]['totalhargaproduk'].toString(),
          header[0]['ongkir'].toString());
      setState(() => this.header = temp);
      print(this.header.nomorresi + " nomoreesi");
      setState(() => this.arrDetail = arrTemp);
      return arrTemp;
    }).catchError((err) {
      print(err);
    });
  }

  void initState() {
    super.initState();
    getDetail();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text("Rincian Pesanan"),
        backgroundColor: session.warna,
      ),
      body: ListView(
        children: [
          SizedBox(height: 15),
          Container(
            padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
            margin: EdgeInsets.fromLTRB(15, 0, 15, 0),
            decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(5),
                border: Border.all(color: Colors.black)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(children: [
                  Icon(Icons.local_shipping),
                  SizedBox(width: 10),
                  Text(
                    "Informasi Pengiriman",
                    style: TextStyle(fontSize: 17),
                  )
                ]),
                SizedBox(height: 10),
                Text(
                  "Kurir  : " + header.kurir,
                  style: TextStyle(fontSize: 15),
                ),
                Text(
                  "Jenis Service : " + header.service,
                  style: TextStyle(fontSize: 15),
                ),
                Text(
                  header.nomorresi == ""
                      ? "Nomor Resi : -"
                      : "Nomor Resi : " + header.nomorresi,
                  style: TextStyle(fontSize: 15),
                ),
                Divider(color: Colors.black),
                Row(children: [
                  Icon(Icons.location_on),
                  SizedBox(width: 10),
                  Text(
                    "Alamat Pengiriman",
                    style: TextStyle(fontSize: 17),
                  )
                ]),
                SizedBox(height: 10),
                Text(header.penerima, style: TextStyle(fontSize: 15)),
                Text(header.nomortelepon, style: TextStyle(fontSize: 15)),
                SizedBox(height: 5),
                Text(
                    header.alamat_detail +
                        ", " +
                        header.namakota +
                        ", " +
                        header.provinsi,
                    style: TextStyle(fontSize: 15)),
                SizedBox(height: 10)
              ],
            ),
          ),
          SizedBox(height: 20),
          SizedBox(
            height: 325,
            child: Container(
                margin: EdgeInsets.fromLTRB(10, 0, 15, 0),
                // decoration: BoxDecoration(color: Colors.yellow[50]),
                child: new ListView.builder(
                    itemCount: arrDetail.length == 0 ? 1 : arrDetail.length,
                    itemBuilder: (context, index) {
                      if (arrDetail.length == 0) {
                        return Image.asset("assets/images/nodata.png");
                      } else {
                        return Card(
                            child: Row(
                          children: [
                            SizedBox(
                              height: 100,
                              width: 100,
                              child: Image.network(session.ipnumber +
                                  "/gambar/produk/" +
                                  arrDetail[index].foto),
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                    padding: EdgeInsets.fromLTRB(10, 10, 0, 10),
                                    // color: Colors.green,
                                    child: Text(
                                      arrDetail[index].namaproduk +
                                          " " +
                                          arrDetail[index].varian,
                                      style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold),
                                    )),
                                Container(
                                  // color: Colors.red,
                                  width: 250,
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Text(
                                        "x" + arrDetail[index].jumlah,
                                        style: TextStyle(
                                            fontSize: 13,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      SizedBox(height: 10),
                                      Text("Rp. " +
                                          frmt.format(int.parse(
                                              arrDetail[index].subtotal)))
                                    ],
                                  ),
                                ),
                                SizedBox(height: 10)
                              ],
                            ),
                          ],
                        ));
                      }
                    })),
          ),
          // Divider(color: Colors.black),
          SizedBox(height: 25),
          GestureDetector(
            onTap: () {
              setState(() {
                lihat = !lihat;
              });
            },
            child: Container(
              margin: EdgeInsets.fromLTRB(10, 0, 10, 0),
              height: 50,
              width: size.width,
              color: Colors.yellow[100],
              child: Row(
                children: [
                  Container(
                      padding: EdgeInsets.fromLTRB(10, 10, 0, 0),
                      width: size.width / 3,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Total Pesanan",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 18),
                          )
                        ],
                      )),
                  Container(width: 25),
                  Container(
                      width: size.width / 2 - 10,
                      padding: EdgeInsets.fromLTRB(10, 10, 0, 0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            "Rp. " +
                                frmt.format(int.parse(header.total.toString())),
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 18),
                          )
                        ],
                      )),
                  SizedBox(width: 5),
                  Container(
                      width: 10,
                      padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          lihat == false
                              ? Icon(Icons.keyboard_arrow_down,
                                  color: Colors.grey)
                              : Icon(Icons.keyboard_arrow_up,
                                  color: Colors.grey)
                        ],
                      )),
                ],
              ),
            ),
          ),
          Visibility(
              visible: lihat,
              child: Container(
                margin: EdgeInsets.fromLTRB(10, 0, 10, 0),
                color: Colors.yellow[100],
                height: 75,
                child: Column(
                  children: [
                    Row(
                      children: [
                        Container(
                            width: size.width / 2 - 40,
                            height: 25,
                            margin: EdgeInsets.fromLTRB(10, 0, 10, 0),
                            child: Text(
                              "Subtotal Produk",
                              style: TextStyle(fontSize: 17),
                            )),
                        Container(
                            margin: EdgeInsets.fromLTRB(0, 0, 10, 0),
                            width: size.width / 2 - 10,
                            height: 25,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  "Rp. " +
                                      frmt.format(int.parse(
                                          header.totalharga.toString())),
                                  style: TextStyle(fontSize: 17),
                                )
                              ],
                            )),
                      ],
                    ),
                    SizedBox(height: 15),
                    Row(
                      children: [
                        Container(
                            width: size.width / 2 - 40,
                            height: 25,
                            margin: EdgeInsets.fromLTRB(10, 0, 10, 0),
                            child: Text(
                              "Subtotal Pengiriman",
                              style: TextStyle(fontSize: 17),
                            )),
                        Container(
                            margin: EdgeInsets.fromLTRB(0, 0, 10, 0),
                            width: size.width / 2 - 10,
                            height: 25,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  "Rp. " +
                                      frmt.format(
                                          int.parse(header.ongkir.toString())),
                                  style: TextStyle(fontSize: 17),
                                )
                              ],
                            )),
                      ],
                    )
                  ],
                ),
              )),
          SizedBox(height: 10),
          session.role == "konsultan"
              ? header.nomorresi == ""
                  ? Row(
                      children: [
                        SizedBox(width: 10),
                        Expanded(
                            child: Center(
                          child: Container(
                            height: size.height * 0.08,
                            width: size.width * 0.8,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(16),
                                color: Colors.green),
                            child: FlatButton(
                              onPressed: () {
                                showAlert();
                              },
                              child: Text(
                                'Input Resi',
                                style: session.kBodyText
                                    .copyWith(fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                        )),
                      ],
                    )
                  : SizedBox()
              : Row(
                  children: [
                    SizedBox(width: 10),
                    Expanded(
                        child: Center(
                      child: Container(
                        height: size.height * 0.08,
                        width: size.width * 0.8,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16),
                            color: Colors.red),
                        child: FlatButton(
                          onPressed: () {
                            showAlertLain();
                          },
                          child: Text(
                            'Selesaikan Pesanan',
                            style: session.kBodyText
                                .copyWith(fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    )),
                  ],
                ),
          SizedBox(height: 50)
        ],
      ),
    );
  }
}
