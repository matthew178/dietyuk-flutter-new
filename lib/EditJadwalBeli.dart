import 'package:fluttertoast/fluttertoast.dart';
import 'session.dart' as session;
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'ClassPaket.dart';
import 'ClassJadwal.dart';
import 'ClassProduk.dart';

class EditJadwalBeli extends StatefulWidget {
  final String id;
  final String paket;

  EditJadwalBeli({Key key, @required this.id, @required this.paket})
      : super(key: key);

  @override
  EditJadwalBeliState createState() => EditJadwalBeliState(this.id, this.paket);
}

class EditJadwalBeliState extends State<EditJadwalBeli> {
  TextEditingController nama = new TextEditingController();
  TextEditingController deskripsi = new TextEditingController();
  TextEditingController estimasi = new TextEditingController();
  TextEditingController harga = new TextEditingController();
  TextEditingController durasi = new TextEditingController();
  TextEditingController takaran = new TextEditingController();

  String waktu = "pagi";
  List<ClassJadwal> arrJadwal = new List();
  List<ClassJadwal> allJadwal = new List();
  List<ClassProduk> arrProduk = new List();
  ClassProduk produkyangdipilih = null;
  int hari = 1;
  int mode = 0;
  ClassPaket paketsaatini =
      new ClassPaket("", "", "", "", "", "", "", "", "", "");

  String id, tanggal, paket;
  List<ClassPaket> arrPaket = new List();

  EditJadwalBeliState(this.id, this.paket);

  void initState() {
    super.initState();
    getPaket();
    getJadwal();
    getProduk();
  }

  void handleradiogroup(String value) {
    setState(() => this.waktu = value);
    sesuaikanJadwal(waktu, hari);
  }

  Future<void> evtSebelum() async {
    if (hari <= 1) {
      setState(() {
        hari = int.parse(paketsaatini.durasi);
      });
    } else {
      setState(() {
        hari = hari - 1;
      });
    }
    sesuaikanJadwal(waktu, hari);
  }

  void hapusJadwal(String idjadwal) async {
    Map paramData = {'id': idjadwal};
    var parameter = json.encode(paramData);
    http
        .post(Uri.parse(session.ipnumber + "/kurangSpek"),
            headers: {"Content-Type": "application/json"}, body: parameter)
        .then((res) {
      if (res.body.contains("sukses")) {
        Fluttertoast.showToast(msg: "Berhasil hapus jadwal");
        getJadwal();
        sesuaikanJadwal(waktu, hari);
      }
    }).catchError((err) {
      print(err);
    });
  }

  Future<void> evtSesudah() async {
    if (hari >= int.parse(paketsaatini.durasi)) {
      setState(() {
        hari = 1;
      });
    } else {
      setState(() {
        hari = hari + 1;
      });
    }
    sesuaikanJadwal(waktu, hari);
  }

  Future<List<ClassProduk>> getProduk() async {
    List<ClassProduk> allproduk = new List();
    ClassProduk produk =
        new ClassProduk("", "", "", "", "", "", "", "", "", "", "", "", "");
    Map paramData = {'id': session.userlogin};
    var parameter = json.encode(paramData);
    http
        .post(Uri.parse(session.ipnumber + "/getprodukbykonsultan"),
            headers: {"Content-Type": "application/json"}, body: parameter)
        .then((res) {
      var data = json.decode(res.body);
      data = data[0]['produk'];
      for (int i = 0; i < data.length; i++) {
        produk = ClassProduk(
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
        allproduk.add(produk);
      }
      setState(() => this.arrProduk = allproduk);
      return allproduk;
    }).catchError((err) {
      print(err);
    });
  }

  Future<List<ClassPaket>> getPaket() async {
    ClassPaket tempPaket =
        new ClassPaket("", "", "", "", "", "", "", "", "", "");
    Map paramData = {'id': paket};
    var parameter = json.encode(paramData);
    http
        .post(Uri.parse(session.ipnumber + "/getpaketbyid"),
            headers: {"Content-Type": "application/json"}, body: parameter)
        .then((res) {
      var data = json.decode(res.body);
      data = data[0]['paket'];
      for (int i = 0; i < data.length; i++) {
        tempPaket = ClassPaket(
            data[i]['id_paket'].toString(),
            data[i]['estimasiturun'].toString(),
            data[i]['harga'].toString(),
            data[i]['durasi'].toString(),
            data[i]['status'].toString(),
            data[i]['rating'].toString(),
            data[i]['konsultan'].toString(),
            data[i]['nama_paket'].toString(),
            data[i]['deskripsi'].toString(),
            data[i]['gambar'].toString());
      }
      setState(() => this.paketsaatini = tempPaket);
      //   nama.text = paket.nama;
      //   deskripsi.text = paket.deskripsi;
      //   estimasi.text = paket.estimasi;
      //   harga.text = paket.harga;
      //   durasi.text = paket.durasi;
      getJadwal();
      return paket;
    }).catchError((err) {
      print(err);
    });
  }

  Future<List<ClassJadwal>> sesuaikanJadwal(String waktu, int harike) async {
    List<ClassJadwal> tempJadwal = new List();
    ClassJadwal databaru =
        new ClassJadwal("id", "id_paket", "hari", "waktu", "keterangan", "");
    for (int i = 0; i < allJadwal.length; i++) {
      if (allJadwal[i].waktu == waktu &&
          allJadwal[i].hari == harike.toString()) {
        databaru = ClassJadwal(
            allJadwal[i].id,
            allJadwal[i].id_paket,
            allJadwal[i].hari,
            allJadwal[i].waktu,
            allJadwal[i].keterangan,
            allJadwal[i].takaran);
        tempJadwal.add(databaru);
        setState(() {});
      }
    }
    setState(() => this.arrJadwal = tempJadwal);
    print(arrJadwal.length.toString() + " data");
    return tempJadwal;
  }

  Future<List<ClassJadwal>> getJadwal() async {
    List<ClassJadwal> tempJadwal = new List();
    Map paramData = {'id': id};
    var parameter = json.encode(paramData);
    ClassJadwal databaru =
        new ClassJadwal("id", "id_paket", "hari", "waktu", "keterangan", "");
    http
        .post(Uri.parse(session.ipnumber + "/getdetailbyid"),
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
      print("ini id : " + id);
      sesuaikanJadwal(waktu, hari);
      return tempJadwal;
    }).catchError((err) {
      print(err);
    });
  }

  Future<List<ClassJadwal>> evtTambahJadwal() async {
    Map paramData = {
      'idbeli': this.id,
      'hari': hari,
      'waktu': waktu,
      'ket': deskripsi.text,
      'takaran': takaran.text
    };
    var parameter = json.encode(paramData);
    if (this.id == "" || deskripsi.text == "" || takaran.text == "") {
      Fluttertoast.showToast(msg: "Inputan tidak boleh kosong");
    } else {
      http
          .post(Uri.parse(session.ipnumber + "/tambahSpek"),
              headers: {"Content-Type": "application/json"}, body: parameter)
          .then((res) {
        print(res.body);
        getJadwal();
        sesuaikanJadwal(waktu, hari);
        deskripsi.text = "";
        takaran.text = "";
        Fluttertoast.showToast(msg: "Berhasil tambah jadwal!");
      }).catchError((err) {
        print(err);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: Text("Jadwal Paket  " + id),
      //   backgroundColor: session.warna,
      // ),
      body: Center(
        child: ListView(children: <Widget>[
          SizedBox(height: 15),
          Container(
              padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
              child: Text(
                paketsaatini.nama,
                style: TextStyle(
                  fontSize: 20,
                ),
              )),
          Container(
              padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
              child: Text(
                "Durasi : " + paketsaatini.durasi + " Hari",
                style: TextStyle(fontSize: 10, color: Colors.red),
              )),
          Container(
            padding: EdgeInsets.fromLTRB(20, 10, 10, 0),
            child: Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                      flex: 2,
                      child: Text(
                        "Hari " + hari.toString(),
                        style: TextStyle(fontSize: 20),
                      )),
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
          Container(
            padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
            child: Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    flex: 1,
                    child: Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Container(
                            padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                            child: Center(
                              child: Radio(
                                value: "pagi",
                                groupValue: waktu,
                                onChanged: handleradiogroup,
                              ),
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                            child: Center(
                              child: Text("Pagi",
                                  style: TextStyle(
                                    fontSize: 10,
                                  )),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Container(
                            padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                            child: Center(
                              child: Radio(
                                value: "siang",
                                groupValue: waktu,
                                onChanged: handleradiogroup,
                              ),
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                            child: Center(
                              child: Text("Siang",
                                  style: TextStyle(
                                    fontSize: 10,
                                  )),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Container(
                            padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                            child: Center(
                              child: Radio(
                                value: "malam",
                                groupValue: waktu,
                                onChanged: handleradiogroup,
                              ),
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                            child: Center(
                              child: Text("Malam",
                                  style: TextStyle(
                                    fontSize: 10,
                                  )),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Container(
                            padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                            child: Center(
                              child: Radio(
                                value: "olahraga",
                                groupValue: waktu,
                                onChanged: handleradiogroup,
                              ),
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                            child: Center(
                              child: Text("Olahraga",
                                  style: TextStyle(
                                    fontSize: 10,
                                  )),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.fromLTRB(20, 0, 10, 0),
            child: Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    flex: 4,
                    child: mode == 0
                        ? TextFormField(
                            controller: deskripsi,
                            keyboardType: TextInputType.text,
                            autofocus: false,
                            decoration:
                                InputDecoration(labelText: "Deskripsi Jadwal"),
                            validator: (value) => value.isEmpty
                                ? "Deskripsi Jadwal tidak boleh kosong"
                                : null,
                          )
                        : DropdownButton<ClassProduk>(
                            // style: Theme.of(context).textTheme.title,
                            hint: Text("Daftar Produk"),
                            value: produkyangdipilih,
                            onChanged: (ClassProduk Value) {
                              setState(() {
                                produkyangdipilih = Value;
                                deskripsi.text = Value.namaproduk;
                              });
                            },
                            items: arrProduk.map((ClassProduk produk) {
                              return DropdownMenuItem<ClassProduk>(
                                value: produk,
                                child: Row(
                                  children: <Widget>[
                                    SizedBox(
                                      width: 10,
                                    ),
                                    produk.varian != "-"
                                        ? Text(
                                            produk.namaproduk +
                                                " " +
                                                produk.varian,
                                            style:
                                                TextStyle(color: Colors.black),
                                          )
                                        : Text(
                                            produk.namaproduk,
                                            style:
                                                TextStyle(color: Colors.black),
                                          )
                                  ],
                                ),
                              );
                            }).toList(),
                          ),
                  ),
                  Expanded(
                    flex: 1,
                    child: RaisedButton(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(100),
                      ),
                      onPressed: () {
                        evtTambahJadwal();
                      },
                      color: Colors.lightBlueAccent,
                      child: Text(
                        '+',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: IconButton(
                      onPressed: () {
                        // print("masuk mode pilih" + mode.toString());
                        // print("jumlah produk = " + arrProduk.length.toString());
                        if (mode == 0) {
                          setState(() {
                            mode = 1;
                          });
                        } else {
                          setState(() {
                            mode = 0;
                          });
                        }
                      },
                      icon: Icon(Icons.toggle_off),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.fromLTRB(20, 10, 20, 0),
            child: TextFormField(
              controller: takaran,
              keyboardType: TextInputType.text,
              autofocus: false,
              decoration: InputDecoration(labelText: "Takaran"),
              validator: (value) =>
                  value.isEmpty ? "Takaran tidak boleh kosong" : null,
            ),
          ),
          Container(
              padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
              child: SizedBox(
                height: 200,
                child: new ListView.builder(
                    itemCount: arrJadwal.length == 0 ? 0 : arrJadwal.length,
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
                                child: Text(arrJadwal[index].takaran +
                                    " " +
                                    arrJadwal[index].keterangan)),
                            Expanded(
                              flex: 1,
                              child: RaisedButton(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(2),
                                ),
                                onPressed: () {
                                  hapusJadwal(arrJadwal[index].id);
                                },
                                color: Colors.red,
                                child: Text(
                                  'X',
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            ),
                          ],
                        ));
                      }
                    }),
              )),
        ]),
      ),
    );
  }
}
