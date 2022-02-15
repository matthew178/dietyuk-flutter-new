import 'dart:io';
import 'package:dietyukapp/DaftarProduk.dart';
import 'package:flutter/foundation.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'session.dart' as session;
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'ClassProduk.dart';
import 'ClassKategoriProduk.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';

class DetailProdukKonsultan extends StatefulWidget {
  final String id;

  DetailProdukKonsultan({Key key, @required this.id}) : super(key: key);

  @override
  DetailProdukKonsultanState createState() =>
      DetailProdukKonsultanState(this.id);
}

class DetailProdukKonsultanState extends State<DetailProdukKonsultan> {
  String id;
  XFile _image;
  TextEditingController kemasan = new TextEditingController();
  TextEditingController berat = new TextEditingController();
  TextEditingController harga = new TextEditingController();
  TextEditingController nama = new TextEditingController();
  TextEditingController deskripsi = new TextEditingController();
  TextEditingController varian = new TextEditingController();
  List<ClassKategoriProduk> listKategori = new List();
  ClassKategoriProduk kategori = null;
  ClassProduk produkini = new ClassProduk(
      "kodeproduk",
      "konsultan",
      "namaproduk",
      "kodekategori",
      "kemasan",
      "harga",
      "foto",
      "deskripsi",
      "status",
      "varian",
      "fotokonsultan",
      "idkonsultan",
      "berat");
  final ImagePicker _picker = ImagePicker();
  DetailProdukKonsultanState(this.id);

  @override
  void initState() {
    super.initState();
    getProduk();
  }

  // Future getImageFromGallery() async {
  //   var image = await ImagePicker.pickImage(source: ImageSource.gallery);
  //   setState(() {
  //     _image = image;
  //   });

  //   String namaFile = image.path;
  //   String basenamegallery = basename(namaFile);
  // }

  Future getImageFromGallery() async {
    var image = await _picker.pickImage(source: ImageSource.gallery);
    setState(() {
      _image = image;
    });
    String namaFile = image.path;
    String basenamegallery = basename(namaFile);
  }

  Future<String> editProduk() async {
    String base64Image = "";
    String namaFile = "";

    if (_image != null) {
      base64Image = base64Encode(File(_image.path).readAsBytesSync());
      namaFile = _image.path.split("/").last + ".png";
      print("not null");
    } else {
      print("image is null");
    }
    Map paramData = {
      'nama': nama.text,
      'idproduk': this.id,
      'kategori': kategori.kodekategori,
      'kemasan': kemasan.text,
      'berat': berat.text,
      'harga': harga.text,
      'desc': deskripsi.text,
      'varian': varian.text,
      'm_filename': namaFile,
      'm_image': base64Image
    };
    var parameter = json.encode(paramData);
    if (nama.text == "" ||
        kategori.kodekategori == "" ||
        kemasan.text == "" ||
        berat.text == "" ||
        harga.text == "" ||
        deskripsi.text == "" ||
        varian.text == "") {
      Fluttertoast.showToast(msg: "Inputan tidak boleh kosong");
    } else {
      http
          .post(Uri.parse(session.ipnumber + "/editProduk"),
              headers: {"Content-Type": "application/json"}, body: parameter)
          .then((res) {
        Fluttertoast.showToast(msg: "Berhasil edit produk");
        Navigator.pushNamed(this.context, "/konsultan");
      }).catchError((err) {
        print(err);
      });
    }

    return "";
  }

  Future<List<ClassKategoriProduk>> getKategori() async {
    List<ClassKategoriProduk> tempKategori = new List();
    Map paramData = {};
    var parameter = json.encode(paramData);
    ClassKategoriProduk databaru =
        new ClassKategoriProduk("id", "id_paket", "gambar", "icon");
    http
        .post(Uri.parse(session.ipnumber + "/getkategori"),
            headers: {"Content-Type": "application/json"}, body: parameter)
        .then((res) {
      var data = json.decode(res.body);
      data = data[0]['kategori'];
      for (int i = 0; i < data.length; i++) {
        if (i > 0) {
          databaru = ClassKategoriProduk(
              data[i]['kodekategori'].toString(),
              data[i]['namakategori'].toString(),
              data[i]['gambar'].toString(),
              data[i]['icon'].toString());
          if (data[i]['kodekategori'].toString() ==
              produkini.kodekategori.toString()) {
            setState(() => kategori = databaru);
          }
          tempKategori.add(databaru);
        }
      }
      setState(() => this.listKategori = tempKategori);
      return tempKategori;
    }).catchError((err) {
      print(err);
    });
  }

  Future<ClassProduk> getProduk() async {
    ClassProduk produkskrg = new ClassProduk(
        "kodeproduk",
        "konsultan",
        "namaproduk",
        "kodekategori",
        "kemasan",
        "0",
        "foto",
        "deskripsi",
        "status",
        "varian",
        "pria.jpg",
        "0",
        "");
    Map paramData = {'kodeproduk': this.id};
    var parameter = json.encode(paramData);
    http
        .post(Uri.parse(session.ipnumber + "/getProdukDetail"),
            headers: {"Content-Type": "application/json"}, body: parameter)
        .then((res) {
      print(res.body);
      var data = json.decode(res.body);
      data = data[0]['produk'];
      produkskrg = new ClassProduk(
          data['kodeproduk'].toString(),
          data['namakonsultan'].toString(),
          data['namaproduk'].toString(),
          data['kodekategori'].toString(),
          data['kemasan'].toString(),
          data['harga'].toString(),
          data['foto'].toString(),
          data['deskripsi'].toString(),
          data['status'].toString(),
          data['varian'].toString(),
          data['fotokonsultan'].toString(),
          data['konsultan'].toString(),
          data['berat'].toString());
      setState(() => this.produkini = produkskrg);
      kemasan.text = produkini.kemasan;
      berat.text = produkini.berat;
      harga.text = produkini.harga;
      nama.text = produkini.namaproduk;
      deskripsi.text = produkini.deskripsi;
      varian.text = produkini.varian;
      getKategori();
      return produkskrg;
    }).catchError((err) {
      print(err);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Detail Produk"),
      ),
      body: Center(
        child: ListView(
          children: [
            Container(
              padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
              child: TextFormField(
                controller: nama,
                keyboardType: TextInputType.text,
                autofocus: true,
                decoration: InputDecoration(labelText: "Nama Produk"),
                validator: (value) =>
                    value.isEmpty ? "Nama tidak boleh kosong" : null,
              ),
            ),
            DropdownButton<ClassKategoriProduk>(
              // style: Theme.of(context).textTheme.title,
              hint: Text("Kategori Produk"),
              value: kategori,
              onChanged: (ClassKategoriProduk value) {
                setState(() => {this.kategori = value});
              },
              items: listKategori.map((ClassKategoriProduk kategori) {
                return DropdownMenuItem<ClassKategoriProduk>(
                  value: kategori,
                  child: Row(
                    children: <Widget>[
                      SizedBox(
                        width: 10,
                      ),
                      Text(
                        kategori.namakategori,
                        style: TextStyle(color: Colors.black),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
            Container(
              padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
              child: TextFormField(
                controller: kemasan,
                keyboardType: TextInputType.text,
                autofocus: true,
                decoration: InputDecoration(labelText: "Kemasan"),
                validator: (value) =>
                    value.isEmpty ? "Detail Kemasan tidak boleh kosong" : null,
              ),
            ),
            Container(
              padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
              child: TextFormField(
                controller: berat,
                keyboardType: TextInputType.number,
                autofocus: true,
                decoration: InputDecoration(labelText: "Berat (gram)"),
                validator: (value) =>
                    value.isEmpty ? "Detail Kemasan tidak boleh kosong" : null,
              ),
            ),
            Container(
              padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
              child: TextFormField(
                controller: harga,
                keyboardType: TextInputType.number,
                autofocus: true,
                decoration: InputDecoration(labelText: "Harga (Rp)"),
                validator: (value) =>
                    value.isEmpty ? "Detail Kemasan tidak boleh kosong" : null,
              ),
            ),
            Container(
              padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
              child: TextFormField(
                controller: deskripsi,
                keyboardType: TextInputType.text,
                autofocus: true,
                maxLines: 5,
                decoration: InputDecoration(labelText: "Deskripsi Produk"),
                validator: (value) => value.isEmpty
                    ? "Deskripsi Produk tidak boleh kosong"
                    : null,
              ),
            ),
            Container(
              padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
              child: TextFormField(
                controller: varian,
                keyboardType: TextInputType.text,
                autofocus: true,
                decoration: InputDecoration(
                    labelText: "Varian Produk",
                    hintText: 'Jika tidak ada isi dengan "-"'),
                validator: (value) =>
                    value.isEmpty ? "Varian Produk tidak boleh kosong" : null,
              ),
            ),
            Container(
              padding: EdgeInsets.fromLTRB(20, 30, 10, 0),
              child: SizedBox(
                width: double.infinity,
                height: 50,
                child: RaisedButton(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(2),
                  ),
                  onPressed: () {
                    getImageFromGallery();
                  },
                  color: Colors.lightBlueAccent,
                  child: Text(
                    'Tambah Gambar Produk',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.fromLTRB(20, 10, 10, 25),
              width: MediaQuery.of(context).size.width,
              height: 200.0,
              child: Center(
                child: _image == null
                    ? Text('No Image Selected.')
                    : Image.file(File(_image.path)),
              ),
            ),
            Container(
              padding: EdgeInsets.fromLTRB(20, 30, 10, 10),
              child: SizedBox(
                width: double.infinity,
                height: 60,
                child: RaisedButton(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(2),
                  ),
                  onPressed: () {
                    editProduk();
                  },
                  color: Colors.lightBlueAccent,
                  child: Text(
                    'Edit',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
