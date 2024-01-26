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
  String? addressFull;
  String? latLong;
  String? date;
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

    var tanggalSekarang =
        DateFormat.yMMMMEEEEd().format(DateTime.now().toLocal());
    var waktuSekarang = DateFormat('HH:mm:ss').format(DateTime.now().toLocal());
    List<Placemark> placemarks =
        await placemarkFromCoordinates(-4.4992317,105.2413371);

    if (placemarks.isNotEmpty) {
      Placemark placemark = placemarks.first;

      String address11 = placemark.thoroughfare ?? ''; // Nama jalan
      String address21 = placemark.subThoroughfare ?? ''; // Nama jalan
      String address31 = placemark.street ?? ''; // Nama jalan
      
      String subLocality = placemark.subLocality ?? ''; // Kelurahan
      String locality = placemark.locality ?? ''; // Kota
      String subAdminArea = placemark.subAdministrativeArea ?? ''; // Kecamatan
      String postalCode = placemark.postalCode ?? ''; // Kode pos
      String administrativeArea =
          placemark.administrativeArea ?? ''; // Provinsi
      String country = placemark.country ?? ''; // Negara

      String fullAddress =
          '\n First : $address11 || $address21 || $address31   \n $subLocality, $locality, $subAdminArea, $administrativeArea $postalCode, $country';
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

    // print('LATITUDE : ${position.latitude}');
    // print('LONGTITUDE : ${position.longitude}');
    // print('Akurasi : ${position.accuracy}');
    // print('Heading : ${position.heading}');
    // print('TIMESTAMP : ${tanggalSekarang} - ${waktuSekarang} ');
    // print('Full Address : ');
    // print('altitude : ${position.altitude}');
    // print('ISMOCKED : ${position.isMocked}');
    // print('speed  : ${position.speed}');
    // print('speed akurasi : ${position.speedAccuracy}');
  }
  //
  // https://medium.com/@fernnandoptr/how-to-get-users-current-location-address-in-flutter-geolocator-geocoding-be563ad6f66a

  // try {
  //   // Mendapatkan alamat lengkap
  //   String fullAddress = placemarks
  //       .map((placemark) =>
  //           "${placemark.name}, ${placemark.subLocality}, ${placemark.locality}, ${placemark.subAdministrativeArea}, ${placemark.administrativeArea} ${placemark.postalCode}, ${placemark.country}")
  //       .join(", ");
  // } catch (e) {
  //   print("Error: $e");
  // }
  // getUserLocation() async {
  //   //call this async method from whereever you need
  //   LocationData myLocation;
  //   String error;
  //   Location location = new Location();
  //   try {
  //     myLocation = await location.getLocation();
  //   } on PlatformException catch (e) {
  //     if (e.code == 'PERMISSION_DENIED') {
  //       error = 'please grant permission';
  //       print(error);
  //     }
  //     if (e.code == 'PERMISSION_DENIED_NEVER_ASK') {
  //       error = 'permission denied- please enable it from app settings';
  //       print(error);
  //     }
  //     myLocation = null;
  //   }
  //   currentLocation = myLocation;
  //   final coordinates =
  //       new Coordinates(myLocation.latitude, myLocation.longitude);
  //   var addresses =
  //       await Geocoder.local.findAddressesFromCoordinates(coordinates);
  //   var first = addresses.first;
  //   print(
  //       ' ${first.locality}, ${first.adminArea},${first.subLocality}, ${first.subAdminArea},${first.addressLine}, ${first.featureName},${first.thoroughfare}, ${first.subThoroughfare}');
  //   return first;
  // }

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
