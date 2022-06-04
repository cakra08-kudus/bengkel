import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class JasaDetail extends StatefulWidget {
  final String idJasa;

  JasaDetail({required this.idJasa});

  @override
  State<JasaDetail> createState() => _JasaDetailState();
}

class _JasaDetailState extends State<JasaDetail> {
  Dio dio = Dio();

  String namaJasa = "";
  String ketJasa = "";

  get data => null;

  tampil() async {
    var form = FormData.fromMap({
      "id_jasa": widget.idJasa,
    });
    final respon = await dio
        .post("https://bengkel.famenarakudus.com/api/detailJasa", data: form);
    if (respon.statusCode == 200) {
      var data = jsonDecode(respon.data);
      setState(() {
        namaJasa = data['nm_jasa'];
        ketJasa = data['ket_jasa'];
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    tampil();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Detail Jasa"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: ListView(
          children: [
            Text(namaJasa,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                )),
            SizedBox(
              height: 50,
            ),
            Text(
              ketJasa,
              textAlign: TextAlign.justify,
              style: TextStyle(
                fontSize: 15,
              ),
            )
          ],
        ),
      ),
    );
  }
}
