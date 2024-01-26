import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import 'package:geocoding/geocoding.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tes Camera and Location',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const ImagePickers(),
    );
  }
}

class ImagePickers extends StatefulWidget {
  const ImagePickers({Key? key}) : super(key: key);

  @override
  State<ImagePickers> createState() => _ImagePickersState();
}

class _ImagePickersState extends State<ImagePickers> {
  late XFile image;
  late Position? currentPosition;
  String? addressFull ='';
  String? latLong = '';
  String? date = '';
  bool one = false;

  void imgFromCamera() async {
    XFile? pickedImg = await ImagePicker().pickImage(
      source: ImageSource.camera,
      imageQuality: 50,
    );

    if (pickedImg != null) {
      setState(() {
        image = pickedImg;
        print('INI PATH NYA : ${image.path}');
      });
      getLocation();
    }
  }

  @override
  void initState() {
    super.initState();
    mintaAkses();
  }

  Future<void> mintaAkses() async {
    await Geolocator.requestPermission();
  }

  bool isLoading = false;

  Future<void> getLocation() async {
    setState(() {
      isLoading = !isLoading;
    });
    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    var tanggalSekarang = DateFormat.yMMMMEEEEd('id_ID').format(DateTime.now().toLocal());
    var waktuSekarang = DateFormat('HH:mm:ss').format(DateTime.now().toLocal());
    List<Placemark> placemarks =
        await placemarkFromCoordinates(position.latitude, position.longitude);

    if (placemarks.isNotEmpty) {
      Placemark placemark = placemarks.first;
      Placemark placemark2 = placemarks.last;
      String address31 = placemark.street ?? ''; // Nama jalan
      String address33 = placemark2.street ?? ''; // Nama jalan
      String subLocality = placemark.subLocality ?? ''; // Kelurahan
      String locality = placemark.locality ?? ''; // Kota
      String subAdminArea = placemark.subAdministrativeArea ?? ''; // Kecamatan
      String postalCode = placemark.postalCode ?? ''; // Kode pos
      String administrativeArea =
          placemark.administrativeArea ?? ''; // Provinsi
      String country = placemark.country ?? ''; // Negara

      String fullAddress =
          ' $address31 / $address33, $subLocality, $locality, $subAdminArea, $administrativeArea $postalCode, $country';
      String dateNew = '$tanggalSekarang - $waktuSekarang';

      setState(() {
        one = !one;
        addressFull = fullAddress;
        date = dateNew;
        isLoading = !isLoading;
        latLong =
            'Latitude : ${position.latitude} \n Long : ${position.longitude}';
      });
    } else {
      setState(() {
        addressFull = "Alamat tidak ditemukan";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () => imgFromCamera(),
              child: const Text('Take Picture'),
            ),
            const SizedBox(
              height: 50,
            ),
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text('Date : $date'),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text('Full Alamat : $addressFull'),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(latLong.toString()),
                ),
              ],
            ),
            const SizedBox(
              height: 50,
            ),
            isLoading == true
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
                : ElevatedButton(
                    onPressed: one == false ? () => getLocation() : () {},
                    child: one == false
                        ? const Text('Cek COntary')
                        : const Text("CAN'T KLIK"),
                  ),
          ],
        ),
      ),
    );
  }
}
