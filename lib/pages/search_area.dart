import 'dart:async';
import 'dart:convert';
import 'package:art_sweetalert/art_sweetalert.dart';
import 'package:flutter/material.dart';
import 'package:uas_application/models/area_model.dart';
import 'package:uas_application/restapi.dart';

class SearchArea extends StatefulWidget {
  @override
  _SearchAreaState createState() => _SearchAreaState();
}

class _SearchAreaState extends State<SearchArea> {
  List<AreaModel> _area = [];
  List<AreaModel> _search = [];
  List data = [];
  DataService ds = DataService();
  var loading = false;

  Future<Null> fetchData() async {
    setState(() {
      loading = true;
    });
    _area.clear();
  }

  selectAllArea() async {
    data = jsonDecode(await ds.selectAll('63476a7599b6c11c094bd4ff',
        'site_inspector', 'area', '63b6240abc64651ccd513b91'));
    _area = data.map((e) => AreaModel.fromJson(e)).toList();
    loading = false;
    setState(() {
      _area = _area;
    });
  }

  TextEditingController controller = new TextEditingController();

  onSearch(String text) async {
    _search.clear();
    if (text.isEmpty) {
      setState(() {});
      return;
    }

    _area.forEach((f) {
      if (f.area.toString() == text) _search.add(f);
    });

    setState(() {});
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchData();
    selectAllArea();
  }

  FutureOr reloadDataArea(dynamic value) {
    setState(() {
      selectAllArea();
    });
  }

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)?.settings.arguments as List<String>;

    return Scaffold(
      backgroundColor: Color.fromARGB(255, 24, 11, 38),
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 76, 0, 111),
        title: const Center(
          child: Text('Add Movie'),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 20.0),
            child: GestureDetector(
              onTap: () async {
                ArtDialogResponse response = await ArtSweetAlert.show(
                    barrierDismissible: false,
                    context: context,
                    artDialogArgs: ArtDialogArgs(
                        denyButtonText: "Tidak..",
                        title: "Hapus data??",
                        confirmButtonText: "Ya..",
                        type: ArtSweetAlertType.warning));

                if (response == null) {
                  return;
                }

                if (response.isTapConfirmButton) {
                  try {
                    bool response = await ds.removeId(
                        '63476a7599b6c11c094bd4ff',
                        'site_inspector',
                        'area',
                        '63b6240abc64651ccd513b91',
                        _search[0].id);
                    if (response) {
                      ArtDialogResponse response = await ArtSweetAlert.show(
                          barrierDismissible: false,
                          context: context,
                          artDialogArgs: ArtDialogArgs(
                              type: ArtSweetAlertType.success,
                              title: "Data Berhasil Dihapus!",
                              confirmButtonText: "OK"));
                      if (response == null) {
                        return;
                      }

                      if (response.isTapConfirmButton) {
                        Navigator.pushNamed(context, 'area',
                            arguments: [args[0], args[1]]);
                      }
                    }
                  } catch (e) {
                    ArtDialogResponse response = await ArtSweetAlert.show(
                        barrierDismissible: false,
                        context: context,
                        artDialogArgs: ArtDialogArgs(
                            title: 'Data Gagal Dihapus!',
                            confirmButtonText: "OK",
                            type: ArtSweetAlertType.warning));
                    if (response == null) {
                      return;
                    }

                    if (response.isTapConfirmButton) {
                      setState(() {});
                    }
                  }
                }
              },
              child: const Icon(
                Icons.delete_outline,
                size: 26.0,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 20.0),
            child: GestureDetector(
              onTap: () async {
                Navigator.pushNamed(context, 'update_area', arguments: [_search[0].id, args[0], args[1]]);
              },
              child: const Icon(
                Icons.edit,
                size: 26.0,
              ),
            ),
          ),
        ],
      ),
      body: Container(
        child: Column(
          children: <Widget>[
            Container(
              padding: EdgeInsets.all(10.0),
              child: Card(
                //color: Color.fromARGB(255, 46, 40, 62),
                child: ListTile(
                  leading: Icon(Icons.search),
                  title: TextField(
                    controller: controller,
                    onChanged: onSearch,
                    decoration: InputDecoration(
                        hintText: "Search", border: InputBorder.none),
                  ),
                  trailing: IconButton(
                    onPressed: () {
                      controller.clear();
                      onSearch('');
                    },
                    icon: Icon(Icons.cancel),
                  ),
                ),
              ),
            ),
            loading
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : Expanded(
                    child: _search.length != 0 || controller.text.isNotEmpty
                        ? ListView.builder(
                            itemCount: _search.length,
                            itemBuilder: (context, i) {
                              final b = _search[i];
                              return Container(
                                  height: 200,
                                  child: GestureDetector(
                                    child: Card(
                                        color: Color.fromARGB(255, 46, 40, 62),
                                        child: Column(children: [
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              const Align(
                                                alignment: Alignment.center,
                                                child: Icon(
                                                  Icons.apartment,
                                                  color: Colors.white,
                                                  size: 130,
                                                ),
                                              ),
                                              Padding(
                                                  padding: EdgeInsets.symmetric(
                                                      horizontal: 15),
                                                  child: Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      Text(''),
                                                      // Area
                                                      Text(b.area,
                                                          textAlign:
                                                              TextAlign.left,
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.white,
                                                              fontSize: 30)),
                                                    ],
                                                  ))
                                            ],
                                          ),
                                        ])),
                                    onTap: () {
                                      Navigator.pushNamed(context, 'list',
                                          arguments: [
                                            b.area,
                                            args[0],
                                            args[1]
                                          ]).then(reloadDataArea);
                                    },
                                  ));
                            },
                          )
                        : ListView.builder(
                            itemCount: _area.length,
                            itemBuilder: (context, i) {
                              final a = _area[i];
                              return Container(
                                  height: 200,
                                  child: GestureDetector(
                                    child: Card(
                                        color: Color.fromARGB(255, 46, 40, 62),
                                        child: Column(children: [
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              const Align(
                                                alignment: Alignment.center,
                                                child: Icon(
                                                  Icons.apartment,
                                                  color: Colors.white,
                                                  size: 130,
                                                ),
                                              ),
                                              Padding(
                                                  padding: EdgeInsets.symmetric(
                                                      horizontal: 15),
                                                  child: Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      Text(''),
                                                      // Area
                                                      Text(a.area,
                                                          textAlign:
                                                              TextAlign.left,
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.white,
                                                              fontSize: 30)),
                                                    ],
                                                  ))
                                            ],
                                          ),
                                        ])),
                                    onTap: () {
                                      Navigator.pushNamed(context, 'list',
                                          arguments: [
                                            a.area,
                                            args[0],
                                            args[1]
                                          ]).then(reloadDataArea);
                                    },
                                  ));
                            },
                          ),
                  ),
          ],
        ),
      ),
    );
  }
}
