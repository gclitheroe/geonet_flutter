import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:geonet_flutter/entity/entity.dart' as quake;
import 'package:http/http.dart' as http;

class GeoNetAPI {
  final http.Client httpClient;

  GeoNetAPI({this.httpClient});

  Future<List<quake.Quake>> getQuakes(int mmi) async {
    final response =
        await httpClient.get('https://api.geonet.org.nz/quake?MMI=$mmi');

    return compute(quake.fromFeatureCollection, response.body);
  }
}
