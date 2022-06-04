import 'package:flutter/material.dart';
import 'package:service_mobil_mobile/halaman/login.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Service Mobil',
      debugShowCheckedModeBanner: false,
      home: Login(),
    );
  }
}
