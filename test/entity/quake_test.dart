import 'dart:io';

import 'package:geonet_flutter/entity/entity.dart';
import 'package:test/test.dart';

void main() {
  test('parse quakes', () {
// work around for file loading so that it works in the IDE or cli.
    String jsonString;
    try {
      jsonString = File('entity/resources/quakes.json').readAsStringSync();
    } catch (e) {
      jsonString = File('test/entity/resources/quakes.json').readAsStringSync();
    }

    var quakes = fromFeatureCollection(jsonString);

    expect(quakes.length, 83);

    var q = quakes[0];

    expect(q.longitude, 178.0783081);
    expect(q.latitude, -38.54507065);
    expect(q.depth, 23.02728653);
    expect(q.quality, 'best');
    expect(q.locality, "10 km north of Gisborne");
    expect(q.magnitude, 2.620937342);
    expect(q.mmi, 3);

    expect(q.iconURL(),
        'https://static.geonet.org.nz/maps/4/quake/xxxhdpi/178E39S-weak.png');

    q = Quake(mmi: 0);
    expect(q.intensity(), 'Unnoticeable');
    q = Quake(mmi: 1);
    expect(q.intensity(), 'Unnoticeable');
    q = Quake(mmi: 2);
    expect(q.intensity(), 'Unnoticeable');
    q = Quake(mmi: 3);
    expect(q.intensity(), 'Weak');
    q = Quake(mmi: 4);
    expect(q.intensity(), 'Light');
    q = Quake(mmi: 5);
    expect(q.intensity(), 'Moderate');
    q = Quake(mmi: 6);
    expect(q.intensity(), 'Strong');
    q = Quake(mmi: 7);
    expect(q.intensity(), 'Severe');
    q = Quake(mmi: 8);
    expect(q.intensity(), 'Extreme');
    q = Quake(mmi: 9);
    expect(q.intensity(), 'Extreme');
  });
}
