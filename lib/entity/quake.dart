import 'dart:convert';

List<Quake> fromFeatureCollection(String geoJSON) {
  final q = jsonDecode(geoJSON)['features'] as List;

  return q.map<Quake>((json) => Quake.fromFeature(json)).toList();
}

class Quake {
  final String locality;
  final DateTime time;
  final double magnitude;
  final double depth;
  /// THe Modified Mercalli Intensity (MMI) for the quake.
  final int mmi;
  final double longitude;
  final double latitude;
  final String quality;

  Quake(
      {this.locality,
      this.time,
      this.magnitude,
      this.depth,
      this.mmi,
      this.longitude,
      this.latitude,
      this.quality});

  factory Quake.fromFeature(Map<String, dynamic> geoJSON) {
    double lon = 0.0;
    double lat = 0.0;

    List c = geoJSON['geometry']['coordinates'];

    if (c.length == 2) {
      lon = double.parse(geoJSON['geometry']['coordinates'][0].toString());
      lat = double.parse(geoJSON['geometry']['coordinates'][1].toString());
    }

    return Quake(
      mmi: int.parse(geoJSON['properties']['mmi'].toString()),
      magnitude: double.parse(geoJSON['properties']['magnitude'].toString()),
      depth: double.parse(geoJSON['properties']['depth'].toString()),
      locality: geoJSON['properties']['locality'],
      quality: geoJSON['properties']['quality'],
      time: DateTime.parse(geoJSON['properties']['time'].toString()),
      longitude: lon,
      latitude: lat,
    );
  }

  /// Returns an intensity string that relates to the MMI for the quake.
  String intensity() {
    if (mmi >= 8) {
      return 'Extreme';
    }

    switch (mmi) {
      case 3:
        return 'Weak';
      case 4:
        return 'Light';
      case 5:
        return 'Moderate';
      case 6:
        return 'Strong';
      case 7:
        return 'Severe';
    }

    return 'Unnoticeable';
  }

  /// Returns a URL for an xxxhdpi icon map showing the location and intensity of the quake.
  String iconURL() {
    String e = "E";
    String n = "N";
    double lon = longitude;
    double lat = latitude;

    if (lon > 180) {
      lon -= 360.0;
    }

    if (lon < 0.0) {
      e = "W";
      lon *= -1.0;
    }

    if (lat < 0.0) {
      n = "S";
      lat *= -1.0;
    }

    if (lon.round() == 180) {
      e = "E";
    }

    return 'https://static.geonet.org.nz/maps/4/quake/xxxhdpi/' +
        lon.round().toString() +
        e +
        lat.round().toString() +
        n +
        '-' +
        intensity().toLowerCase() +
        '.png';
  }
}
