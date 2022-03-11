import 'dart:convert';
import 'pesananprodukkonsultan.dart';
import 'TransaksiPaketKonsultan.dart';
import 'session.dart' as session;
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'package:badges/badges.dart';
import 'ClassBeliPaket.dart';
import 'ClassBeliProduk.dart';

class PilihOrder extends StatefulWidget {
  @override
  PilihOrderState createState() => PilihOrderState();
}

class PilihOrderState extends State<PilihOrder> {
  List<TransaksiBeliProduk> arrTransProduk = new List();
  List<Transaksibelipaket> arrTransPaket = new List();

  void initState() {
    super.initState();
    getTransPaket();
    getTransProduk();
  }

  Future<List<TransaksiBeliProduk>> getTransProduk() async {
    List<TransaksiBeliProduk> arrTemp = new List();
    Map paramData = {'konsultan': session.userlogin};
    var parameter = json.encode(paramData);
    TransaksiBeliProduk databaru = new TransaksiBeliProduk(
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
        "0",
        "0");
    http
        .post(Uri.parse(session.ipnumber + "/getTransaksiProdukKonsultan"),
            headers: {"Content-Type": "application/json"}, body: parameter)
        .then((res) {
      print(res.body);
      var data = json.decode(res.body);
      data = data[0]['transaksi'];
      for (int i = 0; i < data.length; i++) {
        databaru = TransaksiBeliProduk(
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
            data[i]['totalharga'].toString(),
            data[i]['ongkir'].toString());
        arrTemp.add(databaru);
      }
      setState(() => this.arrTransProduk = arrTemp);
      print("selesai");
      return arrTemp;
    }).catchError((err) {
      print(err);
    });
  }

  Future<List<Transaksibelipaket>> getTransPaket() async {
    List<Transaksibelipaket> arrTemp = new List();
    Map paramData = {'konsultan': session.userlogin};
    var parameter = json.encode(paramData);
    Transaksibelipaket databaru = new Transaksibelipaket(
        "id",
        "idpaket",
        "iduser",
        "tanggalbeli",
        "tanggalaktivasi",
        "tanggalselesai",
        "keterangan",
        "durasi",
        "totalharga",
        "status",
        "namapaket",
        "namakonsultan",
        "statuskonsultan");
    http
        .post(Uri.parse(session.ipnumber + "/getTransaksiPaketKonsultan"),
            headers: {"Content-Type": "application/json"}, body: parameter)
        .then((res) {
      print(res.body);
      var data = json.decode(res.body);
      data = data[0]['transaksi'];
      for (int i = 0; i < data.length; i++) {
        databaru = Transaksibelipaket(
            data[i]["id"].toString(),
            data[i]["idpaket"].toString(),
            data[i]["iduser"].toString(),
            data[i]["tanggalbeli"].toString(),
            data[i]["tanggalaktivasi"].toString(),
            data[i]["tanggalselesai"].toString(),
            data[i]["keterangan"].toString(),
            data[i]["durasi"].toString(),
            data[i]["totalharga"].toString(),
            data[i]["status"].toString(),
            data[i]["namapaket"].toString(),
            data[i]["namakonsultan"].toString(),
            data[i]["statuskonsultan"].toString());
        arrTemp.add(databaru);
      }
      setState(() => this.arrTransPaket = arrTemp);
      print("selesai" + session.userlogin.toString());
      return arrTemp;
    }).catchError((err) {
      print(err);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: session.warna,
        // drawer: Drawer(),
        // appBar: AppBar(),
        body: Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: EdgeInsets.only(top: 50),
                child: Text(
                  "Order",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 35,
                      fontWeight: FontWeight.bold),
                ),
              ),
              SizedBox(height: 100),
              Expanded(
                child: GridView.count(
                  crossAxisCount: 2,
                  mainAxisSpacing: 10,
                  crossAxisSpacing: 10,
                  primary: false,
                  children: <Widget>[
                    Badge(
                        position: BadgePosition.topEnd(top: 0, end: 30),
                        animationDuration: Duration(milliseconds: 300),
                        animationType: BadgeAnimationType.slide,
                        badgeContent: Text(
                          arrTransPaket.length.toString(),
                          style: TextStyle(color: Colors.white),
                        ),
                        child: GestureDetector(
                          onTap: () {
                            Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            TransaksiPaketKonsultan()))
                                .then((value) => getTransPaket());
                          },
                          child: Card(
                            elevation: 4,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8)),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Image.asset(
                                  "assets/images/paket.jpg",
                                  height: 128,
                                ),
                                SizedBox(height: 10),
                                Text(
                                  "Paket",
                                  style: session.cardStyle,
                                )
                              ],
                            ),
                          ),
                        )),
                    session.status == "Aktif"
                        ? Badge(
                            position: BadgePosition.topEnd(top: 0, end: 30),
                            animationDuration: Duration(milliseconds: 300),
                            animationType: BadgeAnimationType.slide,
                            badgeContent: Text(
                              arrTransProduk.length.toString(),
                              style: TextStyle(color: Colors.white),
                            ),
                            child: GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  PesananProdukKonsultan()))
                                      .then((value) => getTransProduk());
                                },
                                child: Card(
                                  elevation: 4,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8)),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      Image.asset(
                                        "assets/images/produk.png",
                                        height: 128,
                                      ),
                                      SizedBox(height: 10),
                                      Text(
                                        "Produk",
                                        style: session.cardStyle,
                                      )
                                    ],
                                  ),
                                )))
                        : SizedBox()
                  ],
                ),
              )
              // Expanded(
              //     child: ListView.builder(
              //   itemCount: arrKategori.length,
              //   itemBuilder: (BuildContext ctx, int index) {
              //     return GestureDetector(
              //         onTap: () {
              //           Navigator.push(
              //               context,
              //               MaterialPageRoute(
              //                   builder: (context) => Daftarprodukmember(
              //                       kategori:
              //                           arrKategori[index].kodekategori)));
              //         },
              //         child: Container(
              //           margin: EdgeInsets.all(20),
              //           height: 200,
              //           child: Stack(
              //             children: [
              //               Positioned.fill(
              //                   child: ClipRRect(
              //                 borderRadius: BorderRadius.circular(20),
              //                 child: Image.network(
              //                   session.ipnumber +
              //                       "/gambar/" +
              //                       arrKategori[index].gambar,
              //                   fit: BoxFit.cover,
              //                 ),
              //               )),
              //               Positioned(
              //                   bottom: 0,
              //                   left: 0,
              //                   right: 0,
              //                   child: Container(
              //                     height: 170,
              //                     decoration: BoxDecoration(
              //                         borderRadius: BorderRadius.only(
              //                             bottomLeft: Radius.circular(20),
              //                             bottomRight: Radius.circular(20)),
              //                         gradient: LinearGradient(
              //                             begin: Alignment.bottomCenter,
              //                             end: Alignment.topCenter,
              //                             colors: [
              //                               Colors.black.withOpacity(0.7),
              //                               Colors.transparent
              //                             ])),
              //                   )),
              //               Positioned(
              //                 bottom: 0,
              //                 child: Padding(
              //                     padding: EdgeInsets.all(8),
              //                     child: Row(children: [
              //                       ClipOval(
              //                         child: Container(
              //                           child: Image.network(
              //                             session.ipnumber +
              //                                 "/gambar/" +
              //                                 arrKategori[index].icon,
              //                             height: 75,
              //                             width: 75,
              //                           ),
              //                           padding: EdgeInsets.all(10),
              //                         ),
              //                       ),
              //                       SizedBox(width: 10),
              //                       Text(
              //                         arrKategori[index].namakategori,
              //                         style: TextStyle(
              //                             color: Colors.white, fontSize: 25),
              //                       )
              //                     ])),
              //               )
              //             ],
              //           ),
              //         ));
              //   },
              // ))
            ],
          ),
        ));
  }
}
