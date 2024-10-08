// ignore_for_file: prefer_interpolation_to_compose_strings, use_build_context_synchronously

import 'dart:convert';
import 'dart:async';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:file_picker/file_picker.dart';
import 'package:uas_application/restapi.dart';
import 'package:uas_application/models/inspection_model.dart';
import 'package:uas_application/models/gallery_model.dart';

class Detail extends StatefulWidget {
  const Detail({super.key});

  @override
  State<Detail> createState() => _DetailState();
}

class _DetailState extends State<Detail> {
  DataService ds = DataService();
  DataService ds2 = DataService();
  List dtgl = [];

  List<GalleryModel> gl = [];

  List dtInspection = [];
  List<InspectionModel> ins = [];

  File? image;
  String? imageProfpic;

  selectIdIns(String id) async {
    dtInspection = jsonDecode(await ds.selectId('63476a7599b6c11c094bd4ff',
        'site_inspector', 'inspection', '63b6240abc64651ccd513b91', id));
    ins = dtInspection.map((e) => InspectionModel.fromJson(e)).toList();

    dtgl = jsonDecode(await ds2.selectWhere(
        '63476a7599b6c11c094bd4ff',
        'site_inspector',
        'gallery',
        '63b6240abc64651ccd513b91',
        'inspection_id',
        id));
    gl = dtgl.map((e) => GalleryModel.fromJson(e)).toList();
  }

  // selectIdGl(String id) async {
  //   dtgl = jsonDecode(await ds2.selectId('63476b5c99b6c11c094bd512',
  //       'site_inspector', 'galery', '63bab30bbc64651ccd513d58', id));
  //   gl = dtgl.map((e) => GaleryModel.fromJson(e)).toList();
  // }

  FutureOr reloadDataIns(dynamic value) {
    setState(() {
      final args = ModalRoute.of(context)?.settings.arguments as List<String>;
      selectIdIns(args[3]);
    });
  }

  FutureOr reloadDataGalery(dynamic value) {
    setState(() {
      final args2 = ModalRoute.of(context)?.settings.arguments as List<String>;
      selectIdIns(args2[3]);
    });
  }

  Future pickImage(String id) async {
    try {
      var picked = await FilePicker.platform.pickFiles();

      if (picked != null) {
        var response = await ds.upload(
            '63476a7599b6c11c094bd4ff',
            'site_inspector',
            picked.files.first.bytes!,
            picked.files.first.extension.toString());

        var file = jsonDecode(response);

        var addPict = await ds.insertGallery(
            '63b6240abc64651ccd513b91', id, file['file_name'], '-');
        setState(() {});
      }
    } on PlatformException catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)?.settings.arguments as List<String>;
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 24, 11, 38),
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 76, 0, 111),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pushNamed(context, 'list',
              arguments: [args[0], args[1], args[2]]),
        ),
        title: const Text("Inspection Detail"),
        elevation: 0,
        actions: <Widget>[
          Padding(
            padding: const EdgeInsets.only(right: 20.0),
            child: GestureDetector(
              onTap: () {
                Navigator.pushNamed(context, 'gallery_list', arguments: args[3])
                    .then(reloadDataIns);
                print(gl.length);
              },
              child: const Icon(
                Icons.camera_alt,
                size: 26.0,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 20.0),
            child: GestureDetector(
              onTap: () {
                Navigator.pushNamed(context, 'update_inspection',
                        arguments: [args[0], args[1], args[2], args[3]])
                    .then(reloadDataIns);
              },
              child: const Icon(
                Icons.edit,
                size: 26.0,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 20.0),
            child: GestureDetector(
              onTap: () {
                showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: const Text("Warning"),
                      content: const Text("Remove this data?"),
                      actions: <Widget>[
                        TextButton(
                          child: const Text('CANCEL'),
                          onPressed: () {
                            // Close Dialog
                            Navigator.of(context).pop();
                          },
                        ),
                        TextButton(
                          child: const Text('REMOVE'),
                          onPressed: () async {
                            // Close Dialog
                            //Navigator.of(context).pop();

                            bool response = await ds.removeId(
                                '63476a7599b6c11c094bd4ff',
                                'site_inspector',
                                'inspection',
                                '63b6240abc64651ccd513b91',
                                args[3]);

                            var response2 = await ds.removeWhere(
                                '63476a7599b6c11c094bd4ff',
                                'site_inspector',
                                'gallery',
                                '63b6240abc64651ccd513b91',
                                'inspection_id',
                                args[3]);

                            if (response) {
                              Navigator.pop(context, true);
                            }
                          },
                        )
                      ],
                    );
                  },
                );
              },
              child: const Icon(
                Icons.delete_outline,
                size: 26.0,
              ),
            ),
          ),
        ],
      ),
      body: FutureBuilder<dynamic>(
        future: selectIdIns(args[3]),
        builder: (context, AsyncSnapshot<dynamic> snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.none:
              {
                return const Text('none');
              }
            case ConnectionState.waiting:
              {
                return const Center(child: CircularProgressIndicator());
              }
            case ConnectionState.active:
              {
                return const Text('Active');
              }
            case ConnectionState.done:
              {
                if (snapshot.hasError) {
                  return Text('${snapshot.error}',
                      style: const TextStyle(color: Colors.red));
                } else {
                  return ListView(
                    children: [
                      Container(
                        //decoration: const BoxDecoration(color: Colors.indigo),
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height * 0.40,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Stack(
                              alignment: Alignment.bottomRight,
                              children: [
                                // gl[1].file_name == '-'
                                //     ? const Align(
                                //         alignment: Alignment.bottomCenter,
                                //         child: Icon(
                                //           Icons.person,
                                //           color: Colors.white,
                                //           size: 130,
                                //         ),
                                //       )
                                // if (gl.isNotEmpty)
                                //   // ignore: prefer_const_constructors
                                //   Align(
                                //     alignment: Alignment.bottomCenter,
                                //     // ignore: prefer_const_constructors
                                //     child: Icon(Icons.image, size: 100, color: Colors.white,),
                                //   ),
                                InkWell(
                                    onTap: () => pickImage(args[3]),
                                    child: Align(
                                        alignment: Alignment.bottomCenter,
                                        child: Container(
                                            height: 30.00,
                                            width: 30.00,
                                            margin: const EdgeInsets.only(
                                              left: 183.00,
                                              top: 10.00,
                                              right: 113.00,
                                            ),
                                            child: const Icon(
                                              Icons.camera_alt_outlined,
                                              size: 40,
                                              color: Colors.white,
                                            )))),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Padding(
                                  padding: const EdgeInsets.all(5),
                                  child: Text(
                                    ins[0].notes_inspection,
                                    style: const TextStyle(
                                        color: Colors.white, fontSize: 30),
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Padding(
                                  padding: const EdgeInsets.all(2),
                                  child: Text(
                                    ins[0].id,
                                    style: const TextStyle(
                                        color: Colors.white, fontSize: 15),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Card(
                        child: ListTile(
                          title: Text(ins[0].area),
                          subtitle: const Text(
                            "Location",
                            style: TextStyle(color: Colors.white),
                          ),
                          leading: IconButton(
                              icon: const Icon(Icons.apartment,
                                  color: Colors.white),
                              onPressed: () {}),
                          tileColor: Color.fromARGB(255, 76, 0, 111),
                          textColor: Colors.white,
                        ),
                      ),
                      Card(
                        child: ListTile(
                          title: Text(ins[0].notes_inspection),
                          subtitle: const Text(
                            "Note",
                            style: TextStyle(color: Colors.white),
                          ),
                          leading: IconButton(
                              icon: const Icon(Icons.note, color: Colors.white),
                              onPressed: () {}),
                          tileColor: Color.fromARGB(255, 76, 0, 111),
                          textColor: Colors.white,
                        ),
                      ),
                      Card(
                        child: ListTile(
                          title: Text(ins[0].date_inspection),
                          subtitle: const Text(
                            "Date",
                            style: TextStyle(color: Colors.white),
                          ),
                          leading: IconButton(
                              icon: const Icon(Icons.calendar_month,
                                  color: Colors.white),
                              onPressed: () {}),
                          tileColor: Color.fromARGB(255, 76, 0, 111),
                          textColor: Colors.white,
                        ),
                      ),
                      Card(
                        child: ListTile(
                          title: Text(ins[0].time_inspection),
                          subtitle: const Text(
                            "Time",
                            style: TextStyle(color: Colors.white),
                          ),
                          leading: IconButton(
                              icon:
                                  const Icon(Icons.timer, color: Colors.white),
                              onPressed: () {}),
                          tileColor: Color.fromARGB(255, 76, 0, 111),
                          textColor: Colors.white,
                        ),
                      ),
                      Card(
                        child: ListTile(
                          title: Text(ins[0].status),
                          subtitle: const Text(
                            "Status",
                            style: TextStyle(color: Colors.white),
                          ),
                          leading: IconButton(
                              icon: const Icon(Icons.view_in_ar,
                                  color: Colors.white),
                              onPressed: () {}),
                          tileColor: Color.fromARGB(255, 76, 0, 111),
                          textColor: Colors.white,
                        ),
                      ),
                    ],
                  );
                }
              }
          }
        },
      ),
    );
  }
}
