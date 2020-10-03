import 'package:geolocator/geolocator.dart';

class Pos {
  Position pos = null;

  Future init() async {
    pos = await getCurrentPosition(desiredAccuracy: LocationAccuracy.high)
        .then((value) => null)
        .catchError((e) {
      print(e.toString());
    });
  }
}
