import 'ClassUser.dart';
import 'DetailProdukKonsultan.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'session.dart' as session;
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'ClassProduk.dart';

class DaftarProduk extends StatefulWidget {
  @override
  DaftarProdukState createState() => DaftarProdukState();
}

class DaftarProdukState extends State<DaftarProduk> {
  List<ClassProduk> arrProduk = new List();
  String search = "";
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
      "saldo",
      "rating",
      "status",
      "foto",
      "provinsi",
      "kota");
  @override
  void initState() {
    super.initState();
    getProduk();
    getProfile();
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
          data[0]["provinsi"].toString(),
          data[0]["kota"].toString());
      setState(() => this.userprofile = userlog);

      return userlog;
    }).catchError((err) {
      print(err);
    });
  }

  Future<List<ClassProduk>> getProduk() async {
    List<ClassProduk> tempProduk = new List();
    Map paramData = {'id': session.userlogin};
    var parameter = json.encode(paramData);
    http
        .post(Uri.parse(session.ipnumber + "/getprodukbykonsultan"),
            headers: {"Content-Type": "application/json"}, body: parameter)
        .then((res) {
      var data = json.decode(res.body);
      data = data[0]['produk'];
      for (int i = 0; i < data.length; i++) {
        ClassProduk databaru = ClassProduk(
            data[i]['kodeproduk'].toString(),
            data[i]['konsultan'].toString(),
            data[i]['namaproduk'].toString(),
            data[i]['kodekategori'].toString(),
            data[i]['kemasan'].toString(),
            data[i]['harga'].toString(),
            data[i]['foto'].toString(),
            data[i]['deskripsi'].toString(),
            data[i]['status'].toString(),
            data[i]['varian'].toString(),
            data[i]['fotokonsultan'].toString(),
            data[i]['konsultan'].toString(),
            data[i]['berat'].toString());
        tempProduk.add(databaru);
      }
      setState(() => this.arrProduk = tempProduk);
      return tempProduk;
    }).catchError((err) {
      print(err);
    });
  }

  Future<List<ClassProduk>> searchProduk(String cari) async {
    List<ClassProduk> tempProduk = new List();
    Map paramData = {'cari': cari, 'konsultan': session.userlogin};
    var parameter = json.encode(paramData);
    http
        .post(Uri.parse(session.ipnumber + "/searchProdukKonsultan"),
            headers: {"Content-Type": "application/json"}, body: parameter)
        .then((res) {
      var data = json.decode(res.body);
      data = data[0]['produk'];
      for (int i = 0; i < data.length; i++) {
        ClassProduk databaru = ClassProduk(
            data[i]['kodeproduk'].toString(),
            data[i]['konsultan'].toString(),
            data[i]['namaproduk'].toString(),
            data[i]['kodekategori'].toString(),
            data[i]['kemasan'].toString(),
            data[i]['harga'].toString(),
            data[i]['foto'].toString(),
            data[i]['deskripsi'].toString(),
            data[i]['status'].toString(),
            data[i]['varian'].toString(),
            data[i]['fotokonsultan'].toString(),
            data[i]['konsultan'].toString(),
            data[i]['berat'].toString());
        tempProduk.add(databaru);
      }
      setState(() => this.arrProduk = tempProduk);
      return tempProduk;
    }).catchError((err) {
      print(err);
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      // backgroundColor: session.warna,
      // appBar: AppBar(
      //   title: Text("Daftar Produk Page"),
      //   backgroundColor: session.warna,
      // ),
      body: Column(
        children: [
          SizedBox(
              height: size.height / 6.84,
              child: Padding(
                padding: EdgeInsets.only(left: 25, right: 25, top: 50),
                child: TextField(
                  onSubmitted: (String str) {
                    setState(() {
                      search = str;
                    });
                    searchProduk(search);
                  },
                  decoration: InputDecoration(
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: Colors.grey[300]),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: Colors.grey[200]),
                      ),
                      contentPadding: EdgeInsets.all(15),
                      fillColor: Colors.grey[200],
                      filled: true,
                      hintText: 'Cari Produk',
                      hintStyle: TextStyle(
                          // fontFamily: "Roboto",
                          fontWeight: FontWeight.w600,
                          color: Colors.grey,
                          fontSize: 18),
                      prefixIcon:
                          Icon(Icons.search, size: 30, color: Colors.black)),
                ),
              )),
          SizedBox(
            height: MediaQuery.of(context).size.height - 156,
            child: new ListView.builder(
                itemCount: arrProduk.length == 0 ? 1 : arrProduk.length,
                itemBuilder: (context, index) {
                  if (arrProduk.length == 0) {
                    return Image.asset("assets/images/noresult.png");
                  } else {
                    return GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => DetailProdukKonsultan(
                                      id: arrProduk[index].kodeproduk)));
                        },
                        child: Card(
                            child: Row(
                          children: [
                            Expanded(
                              flex: 3,
                              child: Image.network(
                                  session.ipnumber +
                                      "/gambar/produk/" +
                                      arrProduk[index].foto,
                                  fit: BoxFit.cover),
                            ),
                            Expanded(
                              flex: 5,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    child: Text(
                                      "Nama Produk :",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  Container(
                                    child: Text(arrProduk[index].namaproduk),
                                  ),
                                  Container(
                                    child: Text(
                                      "Harga Produk :",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  Container(
                                    child: Text("Rp " + arrProduk[index].harga),
                                  ),
                                  Container(
                                    child: Text(
                                      "Varian Produk :",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  Container(
                                    child: Text(arrProduk[index].varian),
                                  ),
                                  Container(
                                    child: Text(
                                      "Kemasan Produk :",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  Container(
                                    child: Text(arrProduk[index].kemasan),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        )));
                  }
                }),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (userprofile.provinsi == "0" && userprofile.kota == "0") {
            Fluttertoast.showToast(
                msg: "Harap masukkan kota asal di halaman Profile");
          } else {
            Navigator.pushNamed(context, "/tambahproduk");
          }
        },
        child: const Icon(Icons.add),
        backgroundColor: Colors.blue.shade200,
      ),
    );
  }
}
