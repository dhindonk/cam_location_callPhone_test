import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
      print('INI LOKASI ke2 : ');
      getLocation();
    }
  }

  @override
  void initState() {
    super.initState();
    mintaAkses();
  }

  Future<void> mintaAkses() async {
    LocationPermission permission;
    permission = await Geolocator.requestPermission();
  }

//   Future<void> getAddress() async {
//     List<Placemark> placemarks =
//         await placemarkFromCoordinates(-6.5993931,106.8097919);

//     setState(() {
//       addressFull = placemarks.last.name;
// // subLocality,locality,subAdministrativeArea , administrativeArea, postalCode

//       // addressFull = placemarks
//       //     .map((placemark) =>
//       //         "${placemark.country}, ${placemark.subLocality}, ${placemark.locality}, ${placemark.subAdministrativeArea}, ${placemark.administrativeArea} ${placemark.postalCode}, ${placemark.country}")
//       //     .join(", ");
//     });
//   }

Future<void> getAddress(double latitude, double longitude) async {
  List<Placemark> placemarks = await placemarkFromCoordinates(latitude, longitude);

  if (placemarks != null && placemarks.isNotEmpty) {
    Placemark placemark = placemarks.first; 

    
    String? street = placemark.name; // Jl. Pakuan
    String? subLocality = placemark.subLocality; // Tegallega
    String? locality = placemark.locality; // Kota Bogor
    String? subAdminArea = placemark.subAdministrativeArea; // Kecamatan Bogor Tengah
    String? postalCode = placemark.postalCode; // 16129
    String? administrativeArea = placemark.administrativeArea; // Jawa Barat
    String name = placemark.name!; //

    // Mencari RT/RW
    RegExp rtRwRegex = RegExp(r'RT\.(\d+)\/RW\.(\d+)');
    Match? rtRwMatch = rtRwRegex.firstMatch(name);
    String rt = rtRwMatch != null ? 'RT.${rtRwMatch.group(1)}/' : '';
    String rw = rtRwMatch != null ? 'RW.${rtRwMatch.group(2)}' : '';

   
    String addressFulls = '$street, $rt/$rw, $subLocality, $subAdminArea, $locality, $administrativeArea $postalCode';

    setState(() {
      addressFull = addressFulls;
    });
  } else {
    setState(() {
      addressFull = "Alamat tidak ditemukan";
    });
  }
}

  

  void getLocation() async {
    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    var tanggalSekarang =
        DateFormat.yMMMMEEEEd().format(DateTime.now().toLocal());
    var waktuSekarang = DateFormat.jms().format(DateTime.now().toLocal());

    print('LATITUDE : ${position.latitude}');
    print('LONGTITUDE : ${position.longitude}');
    print('Akurasi : ${position.accuracy}');
    print('Heading : ${position.heading}');
    print('TIMESTAMP : ${tanggalSekarang} - ${waktuSekarang} ');
    print('Full Address : ');
    print('altitude : ${position.altitude}');
    print('ISMOCKED : ${position.isMocked}');
    print('speed  : ${position.speed}');
    print('speed akurasi : ${position.speedAccuracy}');
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
              child: Text('Klik'),
            ),
            SizedBox(
              height: 50,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text('Full Alamat : ${addressFull}'),
            ),
            SizedBox(
              height: 50,
            ),
            ElevatedButton(
              onPressed: () => getAddress(-6.5993931,106.8097919),
              child: Text('Cek COntary'),
            ),
          ],
        ),
      ),
    );
  }
}
