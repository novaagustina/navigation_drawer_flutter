import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:fluttertoast/fluttertoast.dart';
import 'dart:io';
import 'dart:convert';
import 'package:image_picker/image_picker.dart';

class AddNews extends StatefulWidget {
  AddNews() : super();
  final String title = "Upload Image";
  @override
  _AddNewsState createState() => _AddNewsState();
}

class _AddNewsState extends State<AddNews> {
  TextEditingController title;
  TextEditingController detailnews;
  String _mySelection;

  final String url =
      "https://flutterprojectcrud.000webhostapp.com/listnews.php";

  List data = List(); //edited line
  Future<String> getSWData() async {
    var res = await http
        .get(Uri.encodeFull(url), headers: {"Accept": "application/json"});
    var resBody = json.decode(res.body);
    setState(() {
      data = resBody;
    });
    print(resBody);
    return "Sucess";
  }

  @override
  void initState() {
    super.initState();
    this.getSWData();
  }

  @override
  Widget build(BuildContext context) {
    return new Column(
      children: <Widget>[
        new TextField(
          controller: title,
          decoration:
              new InputDecoration(hintText: "Kategori", labelText: "Kategori"),
        ),
        new TextField(
          controller: detailnews,
          decoration: new InputDecoration(
              hintText: "Detail Berita", labelText: "DetailBerita"),
        ),
        Padding(
          padding: EdgeInsets.all(20.30),
          child: Container(
            width: 400.0,
            padding: EdgeInsets.symmetric(horizontal: 10.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15.0),
              border: Border.all(
                  color: Colors.blue, style: BorderStyle.solid, width: 0.80),
            ),

            //panggil data di news_catalog ke dropdown
            child: new DropdownButton(
              hint: new Text('Pilih Kategori Berita'),
              items: data.map((item) {
                return new DropdownMenuItem(
                  child: new Text(
                      item['name_catalog']), //keluarkan value name_catalog
                  value: item['id']
                      .toString(), //setiap user memilik catalog, value yang akan dikirim oleh flutter ke php adalah id dari catalog
                );
              }).toList(),
              onChanged: (newVal) {
                setState(() {
                  _mySelection = newVal;
                });
              },
              value: _mySelection,
            ), //end dropdown
          ),
        ),
      ],
    );
  }
}
