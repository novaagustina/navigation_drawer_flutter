import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'PageHome.dart';
import 'EditKategori.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'dart:math';
import 'package:downloads_path_provider/downloads_path_provider.dart';
import 'package:flutter/foundation.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter_downloader/flutter_downloader.dart';

class Detailkategori extends StatefulWidget {
  List list;
  int index;
  Detailkategori({this.index, this.list});
  @override
  _DetailkategoriState createState() => new _DetailkategoriState();
}

class _DetailkategoriState extends State<Detailkategori> {
  String imageData;
  bool dataLoaded = false;

  void deleteData() {
    var url = "https://flutterprojectcrud.000webhostapp.com/deletenews.php";
    http.post(url, body: {'idnews': widget.list[widget.index]['id']});
    Fluttertoast.showToast(
        msg: "Kategori " +
            widget.list[widget.index]['name_catalog'] +
            " Berhasil Dihapus!",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM);
  }

  void download() async {
    var url = "https://flutterprojectcrud.000webhostapp.com/image/" +
        widget.list[widget.index]['icon'];
    var downloadDirectory = await DownloadsPathProvider.downloadsDirectory;
    var filePathAndName =
        downloadDirectory.path + "/" + widget.list[widget.index]['icon'];
    // var storagePerm = await Permission.storage.status;
    // if (storagePerm.isUndetermined) {
    //   await Permission.storage.request().isGranted;
    //   // We didn't ask for permission yet.
    // }
    var status = await Permission.storage.status;
    if (!status.isGranted) {
      await Permission.storage.request();
    }

    var response = await http.get(url);
    File file = new File(filePathAndName);
    // ignore: await_only_futures
    await file.writeAsBytesSync(response.bodyBytes);
    setState(() {
      imageData = filePathAndName;
      dataLoaded = true;
    });
    Fluttertoast.showToast(
        msg: "Gambar Berhasil didownload!" + filePathAndName,
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM);
  }

  void download2() async {
    var storagePerm = await Permission.storage.status;
    // debugPrint(storagePerm);
    if (storagePerm.isUndetermined) {
      await Permission.storage.request().isGranted;
      // We didn't ask for permission yet.
    }

    //comment out the next two lines to prevent the device from getting
    // the image from the web in order to prove that the picture is
    // coming from the device instead of the web.{
    var url = "https://flutterprojectcrud.000webhostapp.com/image/" +
        widget.list[widget.index]['icon']; // <-- 1
    var response = await http.get(url); // <--2
    // var documentDirectory = await getApplicationDocumentsDirectory();
    var documentDirectory = await DownloadsPathProvider.downloadsDirectory;
    var firstPath = documentDirectory.path;

    var filePathAndName =
        documentDirectory.path + "/" + widget.list[widget.index]['icon'];

    var filePathAndName2 = filePathAndName;
    debugPrint("DOWNLOAD TO " + filePathAndName2);
    //comment out the next three lines to prevent the image from being saved
    //to the device to show that it's coming from the internet
    await Directory(firstPath).create(recursive: true); // <-- 1
    File file2 = new File(filePathAndName); // <-- 2
    file2.writeAsBytesSync(response.bodyBytes); // <-- 3
    setState(() {
      imageData = filePathAndName;
      dataLoaded = true;
    });
    Fluttertoast.showToast(
        msg: "Gambar Berhasil didownload!" + filePathAndName,
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM);
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
          title: new Text("${widget.list[widget.index]['name_catalog']}")),
      body: new Container(
        height: 270.0,
        padding: const EdgeInsets.all(20.0),
        child: new Card(
          child: new Center(
            child: new Column(
              children: <Widget>[
                new Padding(
                  padding: const EdgeInsets.only(top: 30.0),
                ),
                new Text(
                  widget.list[widget.index]['name_catalog'],
                  style: new TextStyle(fontSize: 20.0),
                ),
                new Row(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    new RaisedButton(
                        child: new Text("EDIT"),
                        color: Colors.green,
                        onPressed: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => EditKategori(
                                      list: widget.list, index: widget.index)),
                            )),
                    new RaisedButton(
                      child: new Text("DELETE"),
                      color: Colors.red,
                      onPressed: () => confirm(),
                    ),
                    new RaisedButton(
                      child: new Text("Download"),
                      color: Colors.yellow,
                      onPressed: () => download(),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  void confirm() {
    AlertDialog alertDialog = new AlertDialog(
      content: new Text(
          "Anda yakin menghapus kategori ini? Nama Kategori : '${widget.list[widget.index]['name_catalog']}'"),
      actions: <Widget>[
        new RaisedButton(
          child: new Text(
            "OK DELETE!",
            style: new TextStyle(color: Colors.black),
          ),
          color: Colors.red,
          onPressed: () {
            deleteData();
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => new PageHome()),
            );
          },
        ),
        new RaisedButton(
          child: new Text("CANCEL", style: new TextStyle(color: Colors.black)),
          color: Colors.green,
          onPressed: () => Navigator.pop(context),
        ),
      ],
    );

    showDialog(context: context, child: alertDialog);
  }
}
