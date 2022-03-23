import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'session.dart' as session;
import 'package:http/http.dart' as http;
import 'dart:convert';

class Chat extends StatefulWidget {
  final String username1;
  final String username2;
  final String namalawan;
  Chat(
      {Key key,
      @required this.username1,
      @required this.username2,
      @required this.namalawan})
      : super(key: key);
  @override
  _ChatState createState() =>
      new _ChatState(this.username1, this.username2, this.namalawan);
}

class _ChatState extends State<Chat> {
  String username1, username2, namalawan;
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  TextEditingController teksChat = new TextEditingController();
  String channel;

  _ChatState(this.username1, this.username2, this.namalawan) {
    if (this.username1.compareTo(this.username2) < 0) {
      channel = this.username1 + "_" + this.username2;
    } else {
      channel = this.username2 + "_" + this.username1;
    }
  }

  @override
  void initState() {
    super.initState();
    cekPesan();
  }

  void cekPesan() async {
    Map paramData = {'username1': username1, 'username2': username2};
    var parameter = json.encode(paramData);
    if (username1 != "" && username2 != "") {
      http
          .post(Uri.parse(session.ipnumber + "/cekPesan"),
              headers: {"Content-Type": "application/json"}, body: parameter)
          .then((res) {
        print(res.body);
      }).catchError((err) {
        print(err);
      });
    }
  }

  void sendmessage() async {
    var teks = teksChat.text;
    if (teksChat.text != "") {
      teksChat.text = "";
      DocumentReference ref = await _firestore.collection(channel).add({
        'user1': username1,
        'user2': username2,
        'teks': teks,
        'tanggal': DateTime.now().toString(),
        'foto': ""
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
        appBar: AppBar(title: Text(this.namalawan)),
        body: Container(
          child: Column(
            children: <Widget>[
              Expanded(
                child: _buildBody(context),
              ),
              Container(
                color: Colors.white,
                child: Align(
                  alignment: Alignment.bottomLeft,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: <Widget>[
                        Expanded(flex: 1, child: SizedBox()),
                        Expanded(
                          flex: 7,
                          child: TextFormField(
                              controller: teksChat,
                              keyboardType: TextInputType.text,
                              style: TextStyle(color: Colors.blue),
                              decoration: InputDecoration(
                                hintText: "Chat",
                                hintStyle: TextStyle(color: Colors.grey),
                                border: InputBorder.none,
                                // icon: Icon(
                                //   Icons.email,
                                //   color: Colors.grey,
                                // )),
                              )),
                        ),
                        Expanded(
                          flex: 1,
                          child: GestureDetector(
                            onTap: sendmessage,
                            child: Icon(
                              Icons.send,
                              color: Colors.grey,
                            ),
                          ),
                          // child: FlatButton(
                          //   child: new Text("Send"),
                          //   onPressed: sendmessage,
                          // )
                        )
                      ],
                    ),
                  ),
                ),
              )
            ],
          ),
        ));
  }

  Widget _buildBody(BuildContext context) {
    FirebaseFirestore.instance
        .collection(channel)
        .get()
        .then((QuerySnapshot snapshot) {
      snapshot.docs.forEach((f) => print('${f.data}}'));
    });

    var data = FirebaseFirestore.instance
        .collection(channel)
        .orderBy('tanggal')
        .snapshots();
    return StreamBuilder<QuerySnapshot>(
      stream: data,
      builder: (context, snapshot) {
        if (!snapshot.hasData) return LinearProgressIndicator();
        return _buildList(context, snapshot.data.docs);
      },
    );
  }

  Widget _buildList(BuildContext context, List<DocumentSnapshot> snapshot) {
    return ListView(
      padding: const EdgeInsets.only(top: 20.0),
      children: snapshot.map((data) => _buildListItem(context, data)).toList(),
    );
  }

  Widget _buildListItem(BuildContext context, DocumentSnapshot data) {
    Size size = MediaQuery.of(context).size;
    final record = Record.fromSnapshot(data);
    print("cek = " + record.user1 + "-" + "Hansen");
    if (record.user1 == username1) {
      // rata kanan
      return Padding(
        key: ValueKey(record.tanggal),
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: <Widget>[
            record.foto == ""
                ? Container(
                    padding: const EdgeInsets.symmetric(
                      vertical: 8.0,
                      horizontal: 16.0,
                    ),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10.0)),
                    child: Text(record.teks,
                        style: TextStyle(
                          fontSize: 20.0,
                        )),
                  )
                : Container(
                    padding: const EdgeInsets.symmetric(
                      vertical: 8.0,
                      horizontal: 16.0,
                    ),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10.0)),
                    child: Image.network(
                      session.ipnumber + "/gambar/produk/" + record.foto,
                      height: size.height / (size.height / 150),
                      width: size.width / (size.width / 150),
                    ),
                  ),
            Padding(padding: const EdgeInsets.only(top: 5.0)),
            Text(record.tanggal.substring(0, 16) + "",
                style: TextStyle(fontSize: 10.0, color: Colors.black)),
            Padding(padding: const EdgeInsets.only(top: 10.0)),
          ],
        ),
      );
    } else {
      return Padding(
        key: ValueKey(record.tanggal),
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            record.foto == ""
                ? Container(
                    padding: const EdgeInsets.symmetric(
                      vertical: 8.0,
                      horizontal: 16.0,
                    ),
                    decoration: BoxDecoration(
                        color: Colors.blue[100],
                        borderRadius: BorderRadius.circular(10.0)),
                    child: Text(record.teks,
                        style: TextStyle(
                          fontSize: 20.0,
                        )),
                  )
                : Container(
                    padding: const EdgeInsets.symmetric(
                      vertical: 8.0,
                      horizontal: 16.0,
                    ),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10.0)),
                    child: Image.network(
                      session.ipnumber + "/gambar/produk/" + record.foto,
                      height: size.height / (size.height / 150),
                      width: size.width / (size.width / 150),
                    ),
                  ),
            Padding(padding: const EdgeInsets.only(top: 5.0)),
            Text(record.tanggal.substring(0, 16) + "",
                style: TextStyle(fontSize: 10.0, color: Colors.black)),
            Padding(padding: const EdgeInsets.only(top: 10.0)),
          ],
        ),
      );
    }
  }
}

class Record {
  final String user1;
  final String user2;
  final String teks;
  final String tanggal;
  final DocumentReference reference;
  final String foto;

  Record.fromMap(Map<String, dynamic> map, {this.reference})
      : assert(map['user1'] != null),
        assert(map['user2'] != null),
        assert(map['teks'] != null),
        assert(map['tanggal'] != null),
        assert(map['foto'] != null),
        user1 = map['user1'],
        user2 = map['user2'],
        teks = map['teks'],
        tanggal = map['tanggal'],
        foto = map['foto'];

  Record.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(snapshot.data(), reference: snapshot.reference);

  @override
  String toString() => "Record<$user1:$user2:$teks:$tanggal:$foto>";
}
