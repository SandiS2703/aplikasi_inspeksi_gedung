// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:uas_application/home_page.dart';
import 'package:uas_application/pages/area_add.dart';
import 'package:uas_application/pages/area_list.dart';
import 'package:uas_application/pages/galery_list.dart';
import 'package:uas_application/pages/inspection_add.dart';
import 'package:uas_application/pages/inspection_detail.dart';
import 'package:uas_application/pages/inspection_list.dart';
import 'package:uas_application/pages/login_page.dart';
import 'package:uas_application/pages/register_page.dart';
import 'package:uas_application/pages/search_area.dart';
import 'package:uas_application/pages/update_area.dart';
import 'package:uas_application/pages/update_inspection.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'UAS',
      theme: ThemeData(
        
        primarySwatch: Colors.blue,
      ),
      home: LoginScreen(),
      routes: {
        'login':(context) => LoginScreen(),
        //'home' :(context) => MyWidget(),
        'register' :(context) => RegistrationScreen(),
        'list' :(context) => InspectionList(),
        'add' :(context) => InspectionAdd(),
        'area' :(context) => AreaList(),
        'area_add':(context) => AreaAdd(),
        'detail' :(context) => Detail(),
        'gallery_list' :(context) => ManuallyControlledSlider(),
        'search_area' :(context) => SearchArea(),
        'update_area' :(context) => AreaUpdate(),
        'update_inspection' :(context) => InspectionUpdate()
      },
      debugShowCheckedModeBanner: false,
    );
  }
}