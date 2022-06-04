import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:dio/dio.dart';
import 'package:service_mobil_mobile/halaman/jasa_detail.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class Home extends StatefulWidget {
  Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  getAkun() async {
    SharedPreferences _pref = await SharedPreferences.getInstance();
    setState(() {
      nama = _pref.getString("nama")!;
    });
  }

  String nama = "";
  List promo = [];
  Dio dio = Dio();
  List jasa = [];

  @override
  void initState() {
    super.initState();
    getBanner();
    getJasa();
    getAkun();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Aplikasi Service Mobil'),
      ),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: ListView(
          children: [
            Text(
              'Hai, ' + nama,
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: 50,
            ),
            Text(
              'Informasi Promo',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: 20,
            ),
            promo.isNotEmpty
                ? CarouselSlider(
                    options: CarouselOptions(height: 170.0),
                    items: promo.map((gambar) {
                      return Image.network(
                          "https://bengkel.famenarakudus.com/storage/foto_banner/" +
                              gambar['gambar_banner']);
                    }).toList(),
                  )
                : CircularProgressIndicator(),
            SizedBox(
              height: 20,
            ),
            Text('Jasa Pekerjaan Kami',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            SizedBox(
              height: 20,
            ),
            SizedBox(
              height: 180,
              child: SingleChildScrollView(
                child: Column(
                  children: jasa.map((list_jasa) {
                    return InkWell(
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => JasaDetail(
                                  idJasa: list_jasa['id_jasa'],
                                )));
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(top: 10.0),
                        child: SizedBox(
                          width: MediaQuery.of(context).size.width,
                          child: Card(
                            child: Padding(
                              padding: const EdgeInsets.all(20),
                              child: Text(
                                list_jasa['nm_jasa'],
                                style: TextStyle(
                                  fontSize: 20,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),
            SizedBox(
              height: 30,
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                primary: Color.fromARGB(255, 12, 227, 119), // background
                onPrimary: Color.fromARGB(255, 255, 255, 255), // foreground
              ),
              onPressed: () async {
                await launchUrl(Uri.parse(
                    "https://wa.me/6285713844212/?text=Aplikasi Tes"));
              },
              child: Text(
                'Call Canter Bangkel',
                style: TextStyle(fontSize: 20),
              ),
            ),
          ],
        ),
      ),
    );
  }

  getBanner() async {
    try {
      final response =
          await dio.get("https://bengkel.famenarakudus.com/api/promo");
      print(response.data);
      if (response.statusCode == 200) {
        // var data = jsonDecode(response.data);
        setState(() {
          promo.addAll(response.data['data']);
        });
      }
    } on DioError catch (e) {
      print(e.message);
    }
  }

  getJasa() async {
    try {
      final response =
          await dio.get("https://bengkel.famenarakudus.com/api/jasa");
      print(response.data);
      if (response.statusCode == 200) {
        // var data = jsonDecode(response.data);
        setState(() {
          jasa.addAll(response.data['data']);
        });
      }
    } on DioError catch (e) {
      print(e.message);
    }
  }
}
