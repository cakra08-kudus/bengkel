import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:service_mobil_mobile/halaman/garasi_detail.dart';
import 'package:service_mobil_mobile/halaman/garasi_tambah.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Garasi extends StatefulWidget {
  Garasi({Key? key}) : super(key: key);

  @override
  State<Garasi> createState() => _GarasiState();
}

class _GarasiState extends State<Garasi> {
  Dio dio = Dio();
  List garasi = [];

  hapus(id) async {
    var form = FormData.fromMap({
      "id_kendaraan": id,
    });

    final res = await dio
        .post("https://bengkel.famenarakudus.com/api/hapusGarasi", data: form);
    if (res.statusCode == 200) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Berhasil Menghapus')));
      getGarasi();
    }
  }

  getGarasi() async {
    SharedPreferences _pref = await SharedPreferences.getInstance();
    var idUser = _pref.getInt("id_user");

    var form = FormData.fromMap({
      "id_user": idUser,
    });

    final res = await dio
        .post("https://bengkel.famenarakudus.com/api/tampilGarasi", data: form);

    if (res.statusCode == 200) {
      var data = jsonDecode(res.data);
      // print(res.data);
      setState(() {
        garasi.addAll(data);
      });
    }
  }

  @override
  void initState() {
    super.initState();
    getGarasi();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Garasi Mobil'),
      ),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: ListView(
          children: [
            Text(
              'List Kendaraan',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: 30,
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                primary: Color.fromARGB(255, 65, 110, 224), // background
                onPrimary: Color.fromARGB(255, 255, 255, 255), // foreground
              ),
              onPressed: () {
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => GarasiTambah()));
              },
              child: Text(
                'Tambah Kendaraan',
                style: TextStyle(fontSize: 18),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Text(
              'List Kendaraan Anda',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            SizedBox(
              height: 30,
            ),
            Card(
              shape: RoundedRectangleBorder(
                side: BorderSide(
                  color: Theme.of(context).colorScheme.outline,
                ),
                borderRadius: const BorderRadius.all(Radius.circular(15)),
              ),
              child: SizedBox(
                width: 300,
                height: 420,
                child: SingleChildScrollView(
                  child: Column(
                    children: garasi.map((listGarasi) {
                      return Padding(
                        padding: const EdgeInsets.only(top: 20.0),
                        child: Card(
                          shape: RoundedRectangleBorder(
                            side: BorderSide(
                              color: Theme.of(context).colorScheme.outline,
                            ),
                            borderRadius:
                                const BorderRadius.all(Radius.circular(10)),
                          ),
                          elevation: 10,
                          child: Padding(
                            padding: const EdgeInsets.all(15),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  listGarasi['no_polisi'],
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20),
                                ),
                                // Text(
                                //   listGarasi['merek_kendaraan'],
                                //   style: TextStyle(
                                //       fontWeight: FontWeight.bold,
                                //       fontSize: 20),
                                // ),
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    primary: Color.fromARGB(
                                        255, 12, 227, 119), // background
                                    onPrimary: Color.fromARGB(
                                        255, 255, 255, 255), // foreground
                                  ),
                                  onPressed: () {
                                    Navigator.of(context)
                                        .push(MaterialPageRoute(
                                            builder: (context) => GarasiDetail(
                                                  idGarasi: listGarasi[
                                                      'id_kendaraan_pelanggan'],
                                                )));
                                  },
                                  child: Text(
                                    'Edit',
                                    style: TextStyle(fontSize: 20),
                                  ),
                                ),
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    primary: Color.fromARGB(
                                        255, 227, 12, 12), // background
                                    onPrimary: Color.fromARGB(
                                        255, 255, 255, 255), // foreground
                                  ),
                                  onPressed: () {
                                    hapus(listGarasi['id_kendaraan_pelanggan']);
                                  },
                                  child: Text(
                                    'Hapus',
                                    style: TextStyle(fontSize: 20),
                                  ),
                                ),
                              ],
                            ),
                            // child: Text(
                            //   listGarasi['no_polisi'],
                            //   style: const TextStyle(
                            //     fontSize: 20,
                            //   ),
                            // ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
