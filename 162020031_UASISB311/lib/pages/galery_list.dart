// ignore_for_file: avoid_web_libraries_in_flutter, prefer_interpolation_to_compose_strings, prefer_const_constructors

import 'dart:async';
import 'dart:convert';
import 'dart:html';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:uas_application/models/gallery_model.dart';
import 'package:uas_application/restapi.dart';
import 'package:flutter/material.dart';

// final List<GaleryModel> imgList = [
// ];

List<GalleryModel> gl = [];

class ManuallyControlledSlider extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _ManuallyControlledSliderState();
  }
}

final List<Widget> imageSliders = gl
    .map((item) => Container(
          child: Container(
            margin: EdgeInsets.all(5.0),
            child: ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(10.0)),
                child: Stack(
                  children: <Widget>[
                    Image.network(
                        "https://file.etter.cloud/d226fd9f5fcf8bc3cbdff22e2bd79efe/" +
                            item.file_name,
                        width: 1000.0),
                    Positioned(
                      bottom: 0.0,
                      left: 0.0,
                      right: 0.0,
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            // ignore: prefer_const_literals_to_create_immutables
                            colors: [
                              Color.fromARGB(200, 0, 0, 0),
                              Color.fromARGB(0, 0, 0, 0)
                            ],
                            begin: Alignment.bottomCenter,
                            end: Alignment.topCenter,
                          ),
                        ),
                        padding: EdgeInsets.symmetric(
                            vertical: 10.0, horizontal: 20.0),
                      ),
                    ),
                  ],
                )),
          ),
        ))
    .toList();

class _ManuallyControlledSliderState extends State<ManuallyControlledSlider> {
  DataService ds = DataService();
  List dtgl = [];
  List dtInspection = [];

  File? image;
  String? imageProfpic;

  selectIdIns(String id) async {
    dtgl = jsonDecode(await ds.selectWhere(
        '63476a7599b6c11c094bd4ff',
        'site_inspector',
        'gallery',
        '63b6240abc64651ccd513b91',
        'inspection_id',
        id));
    gl = dtgl.map((e) => GalleryModel.fromJson(e)).toList();
    if(this.mounted){
    setState(() {
      gl = gl;
    });
    }
  }

  FutureOr reloadDataGalery(dynamic value) {
    setState(() {
      final args = ModalRoute.of(context)?.settings.arguments as String;
      selectIdIns(value);
      //print(args);
    });
  }

  @override
  Widget build(BuildContext context) {
    final args2 = ModalRoute.of(context)?.settings.arguments as String;

    reloadDataGalery(args2);

    return Scaffold(
      backgroundColor: Color.fromARGB(255, 24, 11, 38),
      appBar: AppBar(
        backgroundColor: Colors.indigo,
        title: const Center(
          child: Text('Gallery List'),
        ),
        actions: <Widget>[
          Padding(
            padding: const EdgeInsets.only(right: 20.0),
            child: GestureDetector(
              onTap: () {
                print(gl.toString());
              },
              child: const Icon(
                Icons.camera_alt,
                size: 26.0,
              ),
            ),
          ),
        ],
      ),
      body: Builder(
        builder: (context) {
          final double height = MediaQuery.of(context).size.height;
          return CarouselSlider(
            options: CarouselOptions(
              height: height,
              viewportFraction: 1.0,
              enlargeCenterPage: false,
              // autoPlay: false,
            ),
            items: gl
                .map((item) => Container(
                      child: Center(
                          child: Image.network(
                        "https://file.etter.cloud/d226fd9f5fcf8bc3cbdff22e2bd79efe/" +
                            item.file_name,
                        height: height,
                      )),
                    ))
                .toList(),
          );
        },
      ),
    );
  }
}
