import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:geonet_flutter/entity/entity.dart';
import 'package:geonet_flutter/localisation/localisation.dart';
import 'package:geonet_flutter/widget/widget.dart';

void main() {
  // for widget tests the default http client is replaced with one that returns 400's,
  // disable that for all these tests.
  setUpAll(() => HttpOverrides.global = null);

  testWidgets('quake list', (WidgetTester t) async {
      final k = Key('testKey');

      await t.pumpWidget(
        MaterialApp(
          key: k,
          home: Scaffold(
            body: QuakeList(
              quakes: [
                Quake(
                    magnitude: 3.4,
                    locality: 'test location',
                    depth: 23.3,
                    time: DateTime.now(),
                    mmi: 3,
                    quality: 'best',
                    longitude: 178.0,
                    latitude: -38.0)
              ],
            ),
          ),
          localizationsDelegates: [
            const LocalisationDelegate(),
          ],
        ),
      );

      expect(find.byKey(k), findsOneWidget);
  });
}
