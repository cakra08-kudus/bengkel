import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:service_mobil_mobile/halaman/garasi_detail.dart';
import 'package:service_mobil_mobile/halaman/perbaikan_detail.dart';
import 'package:service_mobil_mobile/halaman/perbaikan_tambah.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Perbaikan extends StatefulWidget {
  Perbaikan({Key? key}) : super(key: key);

  @override
  State<Perbaikan> createState() => _PerbaikanState();
}

class _PerbaikanState extends State<Perbaikan> {
  Dio dio = Dio();
  List perbaikan = [];

  getPerbaikan() async {
    SharedPreferences _pref = await SharedPreferences.getInstance();
    var idUser = 18;
    print(idUser);

    var form = FormData.fromMap({
      "id_user": idUser,
    });

    final respon = await dio.post(
        "https://bengkel.famenarakudus.com/api/tampilService",
        data: form);
    if (respon.statusCode == 200) {
      var data = jsonDecode(respon.data);

      setState(() {
        perbaikan.addAll(data);
      });
    }
  }

  hapus(id) async {
    var form = FormData.fromMap({
      "id_service": id,
    });

    final res = await dio
        .post("https://bengkel.famenarakudus.com/api/hapusService", data: form);
    if (res.statusCode == 200) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Berhasil Menghapus')));
      getPerbaikan();
    }
  }

  @override
  void initState() {
    super.initState();
    getPerbaikan();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Service Kendaraan'),
      ),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: ListView(
          children: [
            Text(
              'List Service',
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
                    MaterialPageRoute(builder: (context) => PerbaikanTambah()));
              },
              child: Text(
                'Tambah Service',
                style: TextStyle(fontSize: 18),
              ),
            ),
            SizedBox(
              height: 15,
            ),
            Text(
              'List Service Anda',
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
                borderRadius: const BorderRadius.all(Radius.circular(12)),
              ),
              child: SizedBox(
                width: 300,
                height: 420,
                child: SingleChildScrollView(
                  child: Column(
                    children: perbaikan.map((listService) {
                      var judul;
                      if (listService['no_urutan'] != '') {
                        judul = listService['no_urutan'];
                      } else {
                        judul = listService['merek_kendaraan'];
                      }
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
                                  judul,
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
                                listService['no_urutan'] != ''
                                    ? ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          primary: Color.fromARGB(
                                              255, 12, 227, 119), // background
                                          onPrimary: Color.fromARGB(
                                              255, 255, 255, 255), // foreground
                                        ),
                                        onPressed: () {
                                          Navigator.of(context).push(
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      GarasiDetail(
                                                        idGarasi: listService[
                                                            'id_service'],
                                                      )));
                                        },
                                        child: Text(
                                          'Detail',
                                          style: TextStyle(fontSize: 20),
                                        ),
                                      )
                                    : Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          ElevatedButton(
                                            style: ElevatedButton.styleFrom(
                                              primary: Color.fromARGB(255, 12,
                                                  227, 119), // background
                                              onPrimary: Color.fromARGB(255,
                                                  255, 255, 255), // foreground
                                            ),
                                            onPressed: () {
                                              Navigator.of(context).push(
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          PerbaikanDetail(
                                                            idPerbaikan:
                                                                listService[
                                                                    'id_service'],
                                                          )));
                                            },
                                            child: Text(
                                              'Edit',
                                              style: TextStyle(fontSize: 20),
                                            ),
                                          ),
                                          SizedBox(width: 20),
                                          ElevatedButton(
                                            style: ElevatedButton.styleFrom(
                                              primary: Color.fromARGB(255, 227,
                                                  12, 12), // background
                                              onPrimary: Color.fromARGB(255,
                                                  255, 255, 255), // foreground
                                            ),
                                            onPressed: () {
                                              hapus(listService['id_service']);
                                            },
                                            child: Text(
                                              'Hapus',
                                              style: TextStyle(fontSize: 20),
                                            ),
                                          ),
                                        ],
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
