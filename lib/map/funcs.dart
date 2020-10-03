import 'package:latlong/latlong.dart';
import 'dart:math';
import 'package:http/http.dart' as http;
import 'dart:convert';

bool _onSegment(LatLng a, LatLng b, LatLng c) {
  if (b.longitude <= max(a.longitude, c.longitude) &&
      b.longitude >= min(a.longitude, c.longitude) &&
      b.latitude <= max(a.latitude, c.latitude) &&
      b.latitude >= min(a.latitude, c.latitude)) return true;

  return false;
}

int _orientation(LatLng p, LatLng q, LatLng r) {
  double val = (q.latitude - p.latitude) * (r.longitude - q.longitude) -
      (q.longitude - p.longitude) * (r.latitude - q.latitude);
  if (val == 0.0) return 0; // colinear
  return (val > 0) ? 1 : 2; // clock or counterclock wise
}

bool _intersec(LatLng p1, LatLng q1, LatLng p2, LatLng q2) {
  int o1 = _orientation(p1, q1, p2);
  int o2 = _orientation(p1, q1, q2);
  int o3 = _orientation(p2, q2, p1);
  int o4 = _orientation(p2, q2, q1);

  // General case
  if (o1 != o2 && o3 != o4) return true;

  // Special Cases
  // p1, q1 and p2 are colinear and p2 lies on segment p1q1
  if (o1 == 0 && _onSegment(p1, p2, q1)) return true;

  // p1, q1 and q2 are colinear and q2 lies on segment p1q1
  if (o2 == 0 && _onSegment(p1, q2, q1)) return true;

  // p2, q2 and p1 are colinear and p1 lies on segment p2q2
  if (o3 == 0 && _onSegment(p2, p1, q2)) return true;

  // p2, q2 and q1 are colinear and q1 lies on segment p2q2
  if (o4 == 0 && _onSegment(p2, q1, q2)) return true;

  return false; // Doesn't fall in any of the above cases
}

//funcao para validar o poligono!
bool intersecList(List<LatLng> L) {
  int v = L.length - 1;
  if (v < 3) return true;
  LatLng a1, a2, b1, b2;
  //o flutter aceita um double como parametro de indice
  for (int x = 0; x < v - 2; x++) {
    //print("x=" + x.toString());
    a1 = L[x];
    a2 = L[x + 1];
    for (int y = 0; y < v - 3; y++) {
      //print("x+2+y%v=" + ((x + 2 + y) % v).toString());
      b1 = L[((x + 2 + y) % v).toInt()];
      b2 = L[((x + 3 + y) % v).toInt()];
      if (_intersec(a1, a2, b1, b2)) {
        //print("INTERSEC!");
        return true;
      }
    }
  }

  return false;
}

LatLng getPolygonCentroid(List<LatLng> L) {
  double xf = 0, yf = 0;
  int n = L.length;
  double signedArea = 0;
  for (int i = 0; i < n; i++) {
    double x0 = L[i].longitude, y0 = L[i].latitude;
    double x1 = L[(i + 1) % n].longitude, y1 = L[(i + 1) % n].latitude;
    double A = (x0 * y1) - (x1 * y0);
    signedArea += A;
    xf += (x0 + x1) * A;
    yf += (y0 + y1) * A;
  }
  signedArea *= 0.5;
  xf = xf / (6 * signedArea);
  yf = yf / (6 * signedArea);
  if (xf == 0 && yf == 0) return null;
  return new LatLng(yf, xf);
}

double calculatePropertyRadius(LatLng centro, List<LatLng> L) {
  final Distance distance = Distance();
  double ret = 0, dist = 0;
  for (int i = 0; i < L.length; i++) {
    dist = distance.as(LengthUnit.Kilometer, centro, L[i]);
    if (dist > ret) ret = dist;
  }
  return ret; // *1.1;
}

//code cloned from https://github.com/AliatiSoftware/nominatim_location_picker (26/09/20)
class NominatimService {
  Future<List<Map>> getAddressLatLng(String address) async {
    var url =
        "https://nominatim.openstreetmap.org/search?q=${address.replaceAll(RegExp(' '), '+')}&format=json&addressdetails=1";
    print(url);
    var response = await http.get(url);
    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');
    List addresses = jsonDecode(response.body);
    List<Map> share = List<Map>();
    for (Map ad in addresses) {
      share.add({
        'lat': ad['lat'],
        'lng': ad['lon'],
        'description': ad['display_name'],
        'state': ad['address']['state'] == null ? "na" : ad['address']['state'],
        'city': ad['address']['city'] == null ? "na" : ad['address']['city'],
        'suburb':
            ad['address']['suburb'] == null ? "na" : ad['address']['suburb'],
        'neighbourhood': ad['address']['neighbourhood'] == null
            ? "na"
            : ad['address']['neighbourhood'],
        'road': ad['address']['road'] == null ? "na" : ad['address']['road'],
      });
    }
    return share;
  }
}
