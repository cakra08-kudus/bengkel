import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:service_mobil_mobile/halaman/garasi.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GarasiTambah extends StatefulWidget {
  GarasiTambah({Key? key}) : super(key: key);

  @override
  State<GarasiTambah> createState() => _GarasiTambahState();
}

class _GarasiTambahState extends State<GarasiTambah> {
  Dio dio = Dio();

  TextEditingController nomorPolisiController = TextEditingController();
  TextEditingController nomorRangkaController = TextEditingController();
  TextEditingController namaKendaraanController = TextEditingController();
  TextEditingController tahunKendaraanController = TextEditingController();
  TextEditingController bahanBakarController = TextEditingController();

  final kategori = [];
  String? selectedKategori;

  final transmisi = ['Manual', 'Matic'];
  String? selectedTransmisi;

  getKategori() async {
    try {
      final response =
          await dio.get("https://bengkel.famenarakudus.com/api/kategori");
      print(response.data);
      if (response.statusCode == 200) {
        var data = response.data;
        setState(() {
          kategori.addAll(data['data']);
        });
      }
    } on DioError catch (e) {
      print(e.message);
    }
  }

  simpan() async {
    var no_polisi = nomorPolisiController.text;
    var no_rangka = nomorRangkaController.text;
    var nm_kendaraan = namaKendaraanController.text;
    var tahun_kendaraan = tahunKendaraanController.text;
    var bahan_bakar = bahanBakarController.text;
    SharedPreferences _pref = await SharedPreferences.getInstance();
    var idUser = _pref.getInt("id_user");

    var form = FormData.fromMap({
      "id_user": idUser,
      "kategori": selectedKategori,
      "transmisi": selectedTransmisi,
      "no_polisi": no_polisi,
      "no_rangka": no_rangka,
      "nm_kendaraan": nm_kendaraan,
      "tahun_kendaraan": tahun_kendaraan,
      "bahan_bakar": bahan_bakar,
    });

    final res = await dio
        .post("https://bengkel.famenarakudus.com/api/tambahGarasi", data: form);

    if (res.statusCode == 200) {
      print("Berhasil Simpan");
      Navigator.of(context)
          .pushReplacement(MaterialPageRoute(builder: (context) => Garasi()));
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Berhasil Simpan Data')));
    }
  }

  @override
  void initState() {
    super.initState();
    getKategori();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tambah Kendaraan'),
      ),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: ListView(
          children: [
            DropdownButtonFormField<String>(
              decoration: const InputDecoration(
                  border: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(10)),
              )),
              hint: const Text("Kategori Kendaraan"),
              value: selectedKategori,
              items: kategori
                  .map((row) => DropdownMenuItem<String>(
                        value: row['id_kategori_kendaraan'],
                        child: Text(
                          row['nm_kategori_kendaraan'],
                          style: const TextStyle(fontSize: 18),
                        ),
                      ))
                  .toList(),
              onChanged: (val) {
                print(val);
                setState(() => selectedKategori = val);
              },
            ),
            SizedBox(
              height: 20,
            ),
            TextField(
              controller: nomorPolisiController,
              decoration: InputDecoration(
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10))),
                  labelText: 'Nomor Polisi'),
            ),
            SizedBox(
              height: 20,
            ),
            TextField(
              controller: nomorRangkaController,
              decoration: InputDecoration(
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10))),
                  labelText: 'Nomor Rangka Kendaraan'),
            ),
            SizedBox(
              height: 20,
            ),
            TextField(
              controller: namaKendaraanController,
              decoration: InputDecoration(
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10))),
                  labelText: 'Nama Kendaraan'),
            ),
            SizedBox(
              height: 20,
            ),
            TextField(
              controller: tahunKendaraanController,
              decoration: InputDecoration(
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10))),
                  labelText: 'Tahun Kendaraan'),
            ),
            SizedBox(
              height: 20,
            ),
            TextField(
              controller: bahanBakarController,
              decoration: InputDecoration(
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10))),
                  labelText: 'Bahan Bakar'),
            ),
            SizedBox(
              height: 20,
            ),
            DropdownButtonFormField<String>(
              decoration: InputDecoration(
                  border: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(10)),
              )),
              hint: Text("Jenis Transmisi Kendaraan"),
              value: selectedTransmisi,
              items: transmisi
                  .map((row) => DropdownMenuItem(
                        value: row,
                        child: Text(
                          row,
                          style: const TextStyle(fontSize: 18),
                        ),
                      ))
                  .toList(),
              onChanged: (val) => setState(() => selectedTransmisi = val),
            ),
            SizedBox(
              height: 20,
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                primary: Color.fromARGB(255, 65, 110, 224), // background
                onPrimary: Color.fromARGB(255, 255, 255, 255), // foreground
              ),
              onPressed: () {
                // proses simpan
                simpan();
              },
              child: Text('Simpan Data', style: TextStyle(fontSize: 18)),
            ),
          ],
        ),
      ),
    );
  }
}
