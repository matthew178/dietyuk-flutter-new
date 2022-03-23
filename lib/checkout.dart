import 'ClassAlamat.dart';
import 'ClassKurir.dart';
import 'ClassUser.dart';
import 'package:flutter/material.dart';
import 'ClassProduk.dart';
import 'shoppingcart.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'produkdetail.dart';
import 'session.dart' as session;
import 'package:fluttertoast/fluttertoast.dart';

class Checkout extends StatefulWidget {
  @override
  CheckoutState createState() => CheckoutState();
}

class CheckoutState extends State<Checkout> {
  NumberFormat frmt = new NumberFormat(",000");
  // List<ClassProduk> arrProduk = new List();
  List<shoppingcart> cartshop = [];
  List<ClassKurir> arrKurir = [];
  int jumlah = 0;
  int total = 0;
  int berat = 0;
  int grandtotal = 0;
  ClassAlamat kirim = new ClassAlamat("id", "username", "provinsi", "kota",
      "detail", "namaprovinsi", "namakota", "penerima", "nomortelepon");
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
      "rating",
      "status",
      "foto",
      "provinsi",
      "kota");
  ClassProduk produk = new ClassProduk(
      "kodeproduk",
      "konsultan",
      "namaproduk",
      "kodekategori",
      "kemasan",
      "0",
      "defaultproduct.png",
      "deskripsi",
      "status",
      "varian",
      "pria.jpg",
      "0",
      "");
  ClassKurir kurir = null;

  Future<List<ClassKurir>> getOngkir() async {
    kurir = null;
    setState(() => grandtotal = total);
    List<ClassKurir> arrTemp = [];
    ClassKurir kurirBaru = new ClassKurir(
        "kurir", 'service', "deskripsi", 0, "assets/images/jne.png");
    Map paramData = {
      'asal': session.Cart[0].konsultan,
      'tujuan': session.alamat.kota,
      'berat': berat.toString()
    };
    var parameter = json.encode(paramData);
    if (session.Cart[0].konsultan != "" &&
        session.alamat.kota != "" &&
        berat.toString() != "") {
      http
          .post(Uri.parse(session.ipnumber + "/hitungOngkir"),
              headers: {"Content-Type": "application/json"}, body: parameter)
          .then((res) {
        var data = json.decode(res.body);
        var datajne = json.decode(data['jne']);
        int biaya = 0;
        if (datajne['rajaongkir']['results'][0]['costs'].length > 0) {
          biaya = (berat / 1000).ceil() *
              datajne['rajaongkir']['results'][0]['costs'][0]['cost'][0]
                  ['value'];
          kurirBaru = ClassKurir(
              "JNE",
              datajne['rajaongkir']['results'][0]['costs'][0]['service']
                  .toString(),
              datajne['rajaongkir']['results'][0]['costs'][0]['cost'][0]['etd']
                      .toString() +
                  " hari",
              biaya,
              "assets/images/jne.png");
          arrTemp.add(kurirBaru);
          print("JNE masuk");
        } else {
          print("JNE tidak ada layanan");
        }
        var datapos = json.decode(data['pos']);
        if (datapos['rajaongkir']['results'][0]['costs'].length > 0) {
          biaya = (berat / 1000).ceil() *
              datapos['rajaongkir']['results'][0]['costs'][0]['cost'][0]
                  ['value'];
          kurirBaru = ClassKurir(
              "Pos Indonesia",
              datapos['rajaongkir']['results'][0]['costs'][0]['service']
                  .toString(),
              datapos['rajaongkir']['results'][0]['costs'][0]['cost'][0]['etd']
                      .toString() +
                  " hari",
              biaya,
              "assets/images/pos.png");
          arrTemp.add(kurirBaru);
          print("POS juga masuk");
        } else {
          print("POS tidak ada layanan");
        }
        var datatiki = json.decode(data['tiki']);
        if (datatiki['rajaongkir']['results'][0]['costs'].length > 0) {
          biaya = (berat / 1000).ceil() *
              datatiki['rajaongkir']['results'][0]['costs'][0]['cost'][0]
                  ['value'];
          kurirBaru = ClassKurir(
              "TIKI",
              datatiki['rajaongkir']['results'][0]['costs'][0]['service']
                  .toString(),
              datatiki['rajaongkir']['results'][0]['costs'][0]['cost'][0]['etd']
                      .toString() +
                  " hari",
              biaya,
              "assets/images/tiki.png");
          arrTemp.add(kurirBaru);
          print("TIKI juga masuk");
        } else {
          print("TIKI tidak ada layanan");
        }
        setState(() => kirim = session.alamat);
        setState(() => this.arrKurir = arrTemp);
        print(arrKurir.length.toString() + " kurir");
        print((berat / 1000).ceil().toString() + " kg");
      }).catchError((err) {
        print(err);
      });
    }
    return arrTemp;
  }

  void refreshAlamat() {
    setState(() => kirim = session.alamat);
  }

  void initState() {
    super.initState();
    getProfile();
    if (session.Cart.length == 0) {
      print("kosong");
    } else {
      getArrProduk();
      for (int i = 0; i < session.Cart.length; i++) {
        if (session.Cart.length != 0 &&
            int.parse(session.Cart[i].username) == session.userlogin) {
          jumlah++;
          cartshop.add(session.Cart[i]);
        }
      }
      // if (session.alamat.id != "0" && session.Cart.length > 0) {
      //   getOngkir();
      // }
    }
  }

  void showAlert(int index) {
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
                  child: new Text("Hapus produk ini dari Keranjang ?")),
              flex: 2,
            ),
            new Expanded(
              child: Row(
                children: [
                  SizedBox(width: 30),
                  Container(
                    child: new RaisedButton(
                      onPressed: () {
                        setState(() {
                          session.Cart.removeAt(index);
                          cartshop.removeAt(index);
                          hitungTotal();
                          // arrProduk.removeAt(index);
                        });
                        Fluttertoast.showToast(
                            msg: "Berhasil hapus produk dari Keranjang!");
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

  Future<List<ClassProduk>> getArrProduk() async {
    List<ClassProduk> tempProduk = [];
    Map paramData = {'id': 'all'};
    var parameter = json.encode(paramData);
    http
        .post(Uri.parse(session.ipnumber + "/getProdukKategori"),
            headers: {"Content-Type": "application/json"}, body: parameter)
        .then((res) {
      // print(res.body);
      var data = json.decode(res.body);
      data = data[0]['produk'];
      for (int i = 0; i < data.length; i++) {
        for (int j = 0; j < session.Cart.length; j++) {
          if (session.Cart[j].kodeproduk == data[i]['kodeproduk'] &&
              int.parse(session.Cart[j].username) == session.userlogin) {
            ClassProduk databaru = ClassProduk(
                data[i]['kodeproduk'].toString(),
                data[i]['nama'].toString(),
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
            session.Cart[j].produkini = databaru;
            tempProduk.add(databaru);
            berat = berat +
                int.parse(data[i]['berat'].toString()) *
                    int.parse(session.Cart[j].jumlah);
            print("berat " + berat.toString() + " gram");
          }
        }
      }
      // setState(() => this.arrProduk = tempProduk);
      hitungTotal();
    }).catchError((err) {
      print(err);
    });
    return tempProduk;
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
    }).catchError((err) {
      print(err);
    });
    return userlog;
  }

  void checkOut() async {
    String data = jsonEncode(session.Cart);
    Map paramData = {
      'data': data,
      'alamat': session.alamat.id,
      'total': grandtotal,
      'kurir': kurir.kurir,
      'service': kurir.service,
      'totalharga': total.toString(),
      'ongkir': kurir.ongkir.toString()
    };
    var parameter = json.encode(paramData);
    http
        .post(Uri.parse(session.ipnumber + "/checkout"),
            headers: {"Content-Type": "application/json"}, body: parameter)
        .then((res) {
      print(res.body);
      hapusCart();
      session.alamat = new ClassAlamat("id", "username", "provinsi", "kota",
          "detail", "namaprovinsi", "namakota", "penerima", "nomortelepon");
      Navigator.pushNamed(context, '/member');
      Fluttertoast.showToast(msg: "Berhasil membeli produk");
    }).catchError((err) {
      print(err);
    });
  }

  void hapusCart() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    session.Cart.clear();
    String data = jsonEncode(session.Cart);
    pref.setString(("cart" + session.userlogin.toString()), data);
  }

  void hitungTotal() {
    total = 0;
    jumlah = 0;
    // getOngkir();
    if (session.Cart.length > 0) {
      for (int i = 0; i < session.Cart.length; i++) {
        if (int.parse(session.Cart[i].username) == session.userlogin) {
          setState(() {
            jumlah++;
            total = total +
                int.parse(session.Cart[i].jumlah) *
                    int.parse(session.Cart[i].produkini.harga);
            grandtotal = total;
          });
          if (kurir != null) {
            setState(() {
              grandtotal = total + kurir.ongkir;
            });
          }
        }
      }
    } else {
      setState(() {
        total = 0;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          foregroundColor: session.warna,
          title: Center(
            child: Column(
              children: [
                Text(
                  "Your Cart",
                  style: TextStyle(color: Colors.black),
                ),
                Text(
                  jumlah.toString() + " items",
                  style: Theme.of(context).textTheme.caption,
                )
              ],
            ),
          ),
        ),
        body: ListView(
          children: [
            SizedBox(height: 15),
            Container(
              padding: EdgeInsets.fromLTRB(20, 0, 0, 0),
              child: Text(
                "Alamat Pengiriman",
                style: TextStyle(fontSize: 20),
              ),
            ),
            SizedBox(
              height: size.height / (size.height / 100),
              child: Container(
                padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                margin: EdgeInsets.fromLTRB(10, 0, 10, 0),
                decoration: BoxDecoration(
                    color: session.kBlue,
                    border: Border.all(color: Colors.black),
                    borderRadius: BorderRadius.all(Radius.circular(20))),
                child: FlatButton(
                    onPressed: () {
                      if (session.Cart.length > 0 && session.alamat.id != "0") {
                        Navigator.pushNamed(context, "/pilihAlamat")
                            .then((value) => getOngkir());
                      } else {
                        Navigator.pushNamed(context, "/pilihAlamat");
                      }
                    },
                    child: session.alamat.id == "0"
                        ? Text(
                            "--- Pilih Alamat ---",
                            style: session.kBodyText
                                .copyWith(fontWeight: FontWeight.bold),
                          )
                        : Column(
                            children: [
                              SizedBox(height: 10),
                              Text(session.alamat.penerima,
                                  style: TextStyle(color: Colors.white)),
                              Text(session.alamat.nomortelepon,
                                  style: TextStyle(color: Colors.white)),
                              Text(session.alamat.detail,
                                  style: TextStyle(color: Colors.white)),
                              Text(
                                  session.alamat.namakota +
                                      ", " +
                                      session.alamat.namaprovinsi,
                                  style: TextStyle(color: Colors.white))
                            ],
                          )),
              ),
            ),
            SizedBox(height: 15),
            Container(
                padding: EdgeInsets.fromLTRB(25, 0, 0, 0),
                child: Text(
                  "Daftar Produk",
                  style: TextStyle(fontSize: 20),
                )),
            SizedBox(
              height: size.height / (size.height / 350),
              child: new ListView.builder(
                  itemCount: cartshop.length == 0 ? 1 : cartshop.length,
                  itemBuilder: (context, index) {
                    if (cartshop.length == 0) {
                      return Card(
                          child: Center(
                              child: Text(
                        "Tidak ada data",
                        style: TextStyle(fontSize: 15),
                      )));
                    } else {
                      return GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => ProdukDetail(
                                        id: session.Cart[index].kodeproduk)));
                          },
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                      child: SizedBox(
                                    width: (88 / 375) * size.width,
                                    child: AspectRatio(
                                      aspectRatio: 0.88,
                                      child: Container(
                                        padding: EdgeInsets.all(10),
                                        decoration: BoxDecoration(
                                          color: Color(0xFFF5F6F9),
                                          borderRadius:
                                              BorderRadius.circular(15),
                                        ),
                                        child: Image(
                                          image: NetworkImage(session.ipnumber +
                                              "/gambar/produk/" +
                                              session
                                                  .Cart[index].produkini.foto),
                                        ),
                                      ),
                                    ),
                                  )),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        session.Cart[index].produkini.varian ==
                                                "-"
                                            ? Text(
                                                session.Cart[index].produkini
                                                    .namaproduk,
                                                style: TextStyle(
                                                    fontSize: 16,
                                                    color: Colors.black),
                                                maxLines: 2,
                                              )
                                            : Text(
                                                session.Cart[index].produkini
                                                        .namaproduk +
                                                    " " +
                                                    session.Cart[index]
                                                        .produkini.varian,
                                                style: TextStyle(
                                                    fontSize: 16,
                                                    color: Colors.black),
                                                maxLines: 2,
                                              ),
                                        SizedBox(height: 10),
                                        int.parse(session.Cart[index].produkini
                                                    .harga) >
                                                1000
                                            ? Text.rich(TextSpan(
                                                text: "Rp " +
                                                    frmt.format(int.parse(
                                                        session.Cart[index]
                                                            .produkini.harga)),
                                                style: TextStyle(
                                                    fontWeight: FontWeight.w600,
                                                    color: Colors.orange),
                                              ))
                                            : Text.rich(TextSpan(
                                                text: "Rp " +
                                                    session.Cart[index]
                                                        .produkini.harga,
                                                style: TextStyle(
                                                    // fontWeight: FontWeight.w600,
                                                    color: Colors.orange),
                                              ))
                                      ],
                                    ),
                                  ),
                                  Expanded(
                                    child: SizedBox(
                                      child: Row(
                                        children: [
                                          RawMaterialButton(
                                            constraints:
                                                BoxConstraints(minWidth: 0),
                                            onPressed: () {
                                              setState(() {
                                                if (int.parse(cartshop[index]
                                                        .jumlah) <=
                                                    1) {
                                                  // cartshop[index].jumlah = "0";
                                                  showAlert(index);
                                                } else {
                                                  cartshop[index].jumlah =
                                                      (int.parse(cartshop[index]
                                                                  .jumlah) -
                                                              1)
                                                          .toString();
                                                  setState(() => berat = berat -
                                                      int.parse(cartshop[index]
                                                          .produkini
                                                          .berat));
                                                }
                                                hitungTotal();
                                                if (session.alamat.id != "0" &&
                                                    session.Cart.length > 0) {
                                                  getOngkir();
                                                }
                                              });
                                            },
                                            elevation: 0,
                                            child: Icon(
                                              Icons.remove,
                                              color: Colors.black,
                                              size: 20,
                                            ),
                                            fillColor: Colors.grey[200],
                                            padding: EdgeInsets.all(5.0),
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(10)),
                                          ),
                                          SizedBox(
                                            width: 10.0,
                                          ),
                                          Text(
                                            cartshop[index].jumlah.toString(),
                                            style: TextStyle(
                                                fontSize: 18,
                                                color: Colors.black,
                                                fontWeight: FontWeight.w700),
                                          ),
                                          SizedBox(
                                            width: 10.0,
                                          ),
                                          RawMaterialButton(
                                            constraints:
                                                BoxConstraints(minWidth: 0),
                                            elevation: 0,
                                            onPressed: () {
                                              setState(() {
                                                cartshop[index].jumlah =
                                                    (int.parse(cartshop[index]
                                                                .jumlah) +
                                                            1)
                                                        .toString();
                                                berat = berat +
                                                    int.parse(cartshop[index]
                                                        .produkini
                                                        .berat);
                                                hitungTotal();
                                                if (session.alamat.id != "0" &&
                                                    session.Cart.length > 0) {
                                                  getOngkir();
                                                }
                                              });
                                            },
                                            child: Icon(
                                              Icons.add,
                                              color: Colors.black,
                                              size: 20,
                                            ),
                                            fillColor: Colors.grey[200],
                                            padding: EdgeInsets.all(5.0),
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(10)),
                                          ),
                                        ],
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ],
                          ));
                    }
                  }),
            ),
            SizedBox(height: 15),
            Container(
                child: Text("Jasa Pengiriman", style: TextStyle(fontSize: 20))),
            SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  flex: 3,
                  child: SizedBox(
                    height: size.height / 13.5,
                    width: size.width / 2,
                    child: DropdownButton<ClassKurir>(
                      // style: Theme.of(context).textTheme.title,
                      hint: Text("Pilih Kurir"),
                      value: kurir,
                      onChanged: (ClassKurir value) {
                        setState(() {
                          kurir = value;
                          hitungTotal();
                        });
                      },
                      items: arrKurir.map((ClassKurir kurir) {
                        return DropdownMenuItem<ClassKurir>(
                          value: kurir,
                          child: Row(
                            children: <Widget>[
                              SizedBox(
                                width: 5,
                              ),
                              kurir.foto != ""
                                  ? SizedBox(
                                      height: 50,
                                      width: 50,
                                      child: Image.asset(
                                        kurir.foto,
                                        fit: BoxFit.contain,
                                      ))
                                  : SizedBox(
                                      height: 50,
                                      width: 50,
                                    ),
                              SizedBox(
                                width: 10,
                              ),
                              new Row(
                                children: [
                                  new Text(kurir.kurir),
                                  SizedBox(width: 50),
                                  new Text("Rp. " + frmt.format(kurir.ongkir))
                                  // Container(
                                  //   child: Expanded(
                                  //       flex: 1, child: Text(kurir.kurir)),
                                  // ),
                                  // Container(
                                  //   child: Expanded(
                                  //       flex: 1, child: Text(kurir.service)),
                                  // )
                                ],
                              )
                            ],
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                )
              ],
            ),
            SizedBox(height: 50),
            Row(
              children: [
                SizedBox(width: 25),
                Expanded(
                    flex: 2,
                    child: total > 0
                        ? Text(
                            "Rp. " + frmt.format(grandtotal) + " ",
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          )
                        : Text(
                            "Rp. 0",
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          )),
                Expanded(
                    flex: 2,
                    child: Center(
                      child: Container(
                        height: size.height * 0.08,
                        width: size.width * 0.8,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16),
                            color: session.kBlue),
                        child: FlatButton(
                          onPressed: () {
                            if (cartshop.length > 0 &&
                                kurir != null &&
                                int.parse(userprofile.saldo.toString()) >
                                    grandtotal) {
                              checkOut();
                            } else if (cartshop.length == 0) {
                              Fluttertoast.showToast(
                                  msg: "Tidak ada produk untuk dibeli");
                            } else if (kurir == null) {
                              Fluttertoast.showToast(
                                  msg: "Silahkan pilih jasa pengiriman");
                            } else if (session.alamat == null) {
                              Fluttertoast.showToast(
                                  msg: "Alamat pengiriman belum dikirim");
                            } else if (int.parse(userprofile.saldo) <
                                grandtotal) {
                              Fluttertoast.showToast(
                                  msg:
                                      "Saldo tidak cukup. Silahkan topup dulu");
                            }
                          },
                          child: Text(
                            'Checkout',
                            style: session.kBodyText
                                .copyWith(fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    )),
                SizedBox(width: 5)
              ],
            ),
            SizedBox(height: 10)
          ],
        ));
  }
}
