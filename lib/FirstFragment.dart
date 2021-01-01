import 'package:flutter/material.dart';

class FirstFragment extends StatefulWidget {
  final String title;
  FirstFragment({Key key, this.title}) : super(key: key);
  @override
  _FirstFragmentState createState() => _FirstFragmentState();
}

class _FirstFragmentState extends State<FirstFragment> {
  TextEditingController editingController = TextEditingController();

  final duplicateItems = List<String>.generate(1000, (i) => "Item $i");
  var items = List<String>();

  @override
  void initState() {
    items.addAll(duplicateItems);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        margin: EdgeInsets.only(left: 10.0, right: 10.0, top: 10.0),
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                onChanged: (value) {
                  filterSearchResult(value);
                },
                controller: editingController,
                decoration: InputDecoration(
                    labelText: "Search",
                    hintText: "Search",
                    prefixIcon: Icon(Icons.search),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(25.0)))),
              ),
            ),
            Expanded(
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: items.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text('${items[index]}'),
                    onTap: () {
                      //Go to the next screen with Navigator.push
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void filterSearchResult(String query) {
    List<String> dummySearchList = List<String>();
    dummySearchList.addAll(duplicateItems);

    if (query.isNotEmpty) {
      List<String> dummyListData = List<String>();
      dummySearchList.forEach((item) {
        if (item.contains(query)) {
          dummyListData.add(item);
        }
      });

      setState(() {
        items.clear();
        items.addAll(dummyListData);
      });
      return;
    } else {
      setState(() {
        items.clear();
        items.addAll(duplicateItems);
      });
    }
  }
}
