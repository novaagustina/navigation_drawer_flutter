import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:fluttertoast/fluttertoast.dart';

class AddData extends StatefulWidget {
  @override
  _AddDataState createState() => new _AddDataState();
}

class _AddDataState extends State<AddData> {
  TextEditingController controllerKategori = new TextEditingController();

  void addData() {
    var url = "https://flutterprojectcrud.000webhostapp.com/addnews.php";

    http.post(url, body: {"newscatalog": controllerKategori.text});
    Fluttertoast.showToast(
        msg: "Data Berhasil Ditambahkan Silahkan Cek di Menu Kategori",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM);
  }

  @override
  Widget build(BuildContext context) {
    return new Column(
      children: <Widget>[
        Padding(
            padding: EdgeInsets.all(10.30),
            child: TextField(
              controller: controllerKategori,
              decoration: new InputDecoration(
                  hintText: "Isi Kategori disini...", labelText: "Kategori"),
            )),
        Padding(
            padding: EdgeInsets.all(20.20),
            child: RaisedButton(
              child: new Text("Tambah Kategori"),
              color: Colors.purpleAccent,
              onPressed: () {
                addData();
              },
            )),
      ],
    );
  }
}
