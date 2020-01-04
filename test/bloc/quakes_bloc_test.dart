import 'dart:convert';
import 'dart:io';

import 'package:geonet_flutter/api/api.dart';
import 'package:geonet_flutter/bloc/bloc.dart';
import 'package:geonet_flutter/entity/entity.dart';
import 'package:http/http.dart';
import 'package:http/testing.dart';
import 'package:test/test.dart';

void main() {
  test("JSON that can't be parsed should give an error", () async {
    final client = MockClient((request) async {
      final mapJson = {'id': 123};
      return Response(json.encode(mapJson), 200);
    });

    final geoNetAPI = GeoNetAPI(httpClient: client);

    QuakesBloc quakesBloc = QuakesBloc(geoNet: geoNetAPI);

    expectLater(
        quakesBloc,
        emitsInOrder([
          QuakesStarted(),
          QuakesLoading(),
          QuakesError()
        ]));

    quakesBloc.add(QuakesFetch(3));
  });

  test("Test fetching quakes", () async {
    // work around for file loading so that it works in the IDE or cli.
    String jsonString;
    try {
      jsonString = File('bloc/resources/quakes.json').readAsStringSync();
    } catch (e) {
      jsonString = File('test/bloc/resources/quakes.json').readAsStringSync();
    }

    final client = MockClient((request) async {
      return Response(jsonString, 200);
    });

    final geoNetAPI = GeoNetAPI(httpClient: client);

    QuakesBloc quakesBloc = QuakesBloc(geoNet: geoNetAPI);

    expectLater(
        quakesBloc,
        emitsInOrder([
          QuakesStarted(),
          QuakesLoading(),
          QuakesLoaded(3, List<Quake>()),
          QuakesLoading(),
          QuakesLoaded(5, List<Quake>())
        ]));

    quakesBloc.add(QuakesFetch(5));
    quakesBloc.add(QuakesFetch(5));
  });
}
