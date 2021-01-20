import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'PageHome.dart';
import 'EditKategori.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'dart:io';
import 'package:permission_handler/permission_handler.dart';
import 'package:ext_storage/ext_storage.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/foundation.dart';

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
    // var downloadDirectory = await DownloadsPathProvider.downloadsDirectory;
    var test_path = await getExternalStorageDirectory();
    debugPrint(test_path.path);
    var downloadDirectory = await ExtStorage.getExternalStoragePublicDirectory(ExtStorage.DIRECTORY_DOWNLOADS);
    debugPrint(downloadDirectory);
    var filePathAndName =
        downloadDirectory + "/" + widget.list[widget.index]['icon'];
    debugPrint(filePathAndName);
    
    var status = await Permission.storage.status;
    if (!status.isGranted) {
      await Permission.storage.request();
    }
    //get file
    var response = await http.get(url);
    File file = new File(filePathAndName);
    // ignore: await_only_futures
    await file.writeAsBytesSync(response.bodyBytes);
    setState(() {
      imageData = filePathAndName; //set path file imageData
      dataLoaded = true; //Load ke path
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
