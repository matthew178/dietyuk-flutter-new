import 'dart:io';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'session.dart' as session;
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'ClassUser.dart';
import 'ClassBank.dart';
import 'package:intl/intl.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';

class Topup2 extends StatefulWidget {
  final ClassBank bank;
  final String nominal;

  Topup2({Key key, @required this.bank, @required this.nominal})
      : super(key: key);

  @override
  Topup2State createState() => Topup2State(this.bank, this.nominal);
}

class Topup2State extends State<Topup2> {
  // TextEditingController saldo = new TextEditingController();
  NumberFormat frmt = new NumberFormat(",000");
  ClassBank bank;
  String nominal;
  ClassUser userprofile = new ClassUser(
      "", "", "", "", "", "", "", "", "", "", "", "", "0", "", "", "", "");
  XFile _image;
  String namaFile = "";
  String basenamegallery = "";
  bool upload = false;

  Topup2State(this.bank, this.nominal);

  void initState() {
    super.initState();
    getProfile();
    print(nominal);
  }

  final ImagePicker _picker = ImagePicker();
  Future getImageFromGallery() async {
    var image = await _picker.pickImage(source: ImageSource.gallery);
    setState(() {
      _image = image;
    });

    String namaFile = image.path;
    String basenamegallery = basename(namaFile);
  }

  Future<String> evtConfirm() async {
    String base64Image = "";
    String namaFile = "";

    if (_image != null) {
      base64Image = base64Encode(File(_image.path).readAsBytesSync());
      namaFile = _image.path.split("/").last + ".png"; //mfile
      upload = true;
      print("not null");
    } else {
      upload = false;
      print("image is null");
    }
    if (upload) {
      Map paramData = {
        'saldo': nominal,
        'id_user': session.userlogin.toString(),
        'bank': bank.nama,
        'm_filename': namaFile,
        'm_image': base64Image
      };
      var parameter = json.encode(paramData);

      http
          .post(Uri.parse(session.ipnumber + "/topup"),
              headers: {"Content-Type": "application/json"}, body: parameter)
          .then((res) {
        print(res.body);
      }).catchError((err) {
        print(err);
      });
    }
    return "";
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
          data[0]['foto'].toString(),
          "",
          "");
      setState(() => this.userprofile = userlog);
      return userlog;
    }).catchError((err) {
      print(err);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("TOP UP SALDO"),
        backgroundColor: session.warna,
      ),
      body: ListView(
        children: [
          Column(
            children: [
              SizedBox(height: 30),
              Container(
                child: Container(
                  padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                  child: Row(
                    children: [
                      Expanded(
                        flex: 2,
                        child: Icon(
                          AntDesign.wallet,
                          color: Colors.blue[900],
                          size: 50,
                        ),
                      ),
                      Expanded(
                        flex: 6,
                        child: Text(
                          "Disarankan untuk menghindari top up antara pukul 21.00 s/d 03.00 dikarenakan adanya cut off mutasi internet banking sehingga proses validasi pembayaran memerlukan waktu yang lama.",
                          style: TextStyle(fontSize: 15),
                          textAlign: TextAlign.justify,
                        ),
                      )
                    ],
                  ),
                ),
              ),
              SizedBox(height: 30),
              Container(
                height: 350,
                width: 375,
                padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                decoration: BoxDecoration(
                    color: Colors.yellow[100],
                    border: Border.all(color: Colors.grey)),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SizedBox(height: 15),
                    Container(
                        child: Text(
                      "> Silahkan Transfer dengan detail berikut :",
                      style: TextStyle(fontSize: 16, color: Colors.grey[700]),
                    )),
                    SizedBox(height: 5),
                    Container(
                      child: Text("Bank " + bank.nama + " : " + bank.norek,
                          style:
                              TextStyle(fontSize: 14, color: Colors.grey[700])),
                    ),
                    Container(
                      child: Text(
                          "Nominal : Rp. " +
                              frmt.format(int.parse(nominal.toString())),
                          style:
                              TextStyle(fontSize: 14, color: Colors.grey[700])),
                    ),
                    Container(
                      child: Text("Atas Nama " + bank.atasnama,
                          style:
                              TextStyle(fontSize: 14, color: Colors.grey[700])),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Container(
                      child: Text(
                          "> Saldo anda akan masuk maksimal dalam waktu 30 menit",
                          style:
                              TextStyle(fontSize: 16, color: Colors.grey[700])),
                    ),
                    SizedBox(height: 30),
                    Container(
                      margin: EdgeInsets.only(right: 0),
                      // padding: EdgeInsets.fromLTRB(0, 0, 20, 0),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          color: HexColor("#1e96fc")),
                      child: FlatButton(
                        onPressed: () {
                          getImageFromGallery();
                        },
                        child: Text(
                          'Upload Bukti Transfer',
                          style: session.kBodyText
                              .copyWith(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.fromLTRB(20, 10, 10, 0),
                      child: Center(
                        child: _image == null
                            ? Text('No File Selected.')
                            : Text(basenamegallery.toString()),
                      ),
                    ),
                    SizedBox(height: 50),
                    Container(
                      margin: EdgeInsets.only(right: 0),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          color: HexColor("#168aad")),
                      child: FlatButton(
                        onPressed: () {
                          if (_image == null) {
                            Fluttertoast.showToast(
                                msg: "Silahkan upload bukti transfer anda");
                          } else {
                            evtConfirm();
                            Fluttertoast.showToast(
                                msg:
                                    "Saldo sementara di proses. Saldo akan masuk maksimal dalam waktu 30 menit",
                                toastLength: Toast.LENGTH_LONG);
                            Navigator.pushNamed(context, "/member");
                          }
                        },
                        child: Text(
                          'Submit',
                          style: session.kBodyText
                              .copyWith(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}
