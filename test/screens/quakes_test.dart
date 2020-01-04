import 'dart:io';

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:geonet_flutter/bloc/bloc.dart';
import 'package:geonet_flutter/entity/entity.dart';
import 'package:geonet_flutter/localisation/localisation.dart';
import 'package:geonet_flutter/screens/quakes.dart';
import 'package:geonet_flutter/widget/widget.dart';
import 'package:mockito/mockito.dart';

class MockQuakesBloc extends MockBloc<QuakesEvent, QuakesState>
    implements QuakesBloc {}

QuakesBloc quakesBloc;
final k = Key('testKey');

class _testWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<QuakesBloc>.value(
          value: quakesBloc,
        ),
      ],
      key: k,
      child: MaterialApp(
        home: Scaffold(
          body: QuakesScreen(),
        ),
        localizationsDelegates: [LocalisationDelegate()],
      ),
    );
  }
}

void main() {
  // for widget tests the default http client is replaced with one that returns 400's,
  // disable that for all these tests.
  setUpAll(() => HttpOverrides.global = null);

  group('Quakes Screen', () {
    setUp(() {
      quakesBloc = MockQuakesBloc();
    });

    testWidgets('loading', (WidgetTester t) async {
      when(quakesBloc.state).thenAnswer((_) => QuakesLoading());

      await t.pumpWidget(_testWidget());
      // https://github.com/flutter/flutter/issues/22193
      await t.idle();
      await t.pump();

      expect(find.byKey(k), findsOneWidget);
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('loaded', (WidgetTester t) async {
      when(quakesBloc.state).thenAnswer((_) => QuakesLoaded(3, [
            Quake(
                magnitude: 3.4,
                locality: 'test',
                depth: 23.3,
                time: DateTime.now(),
                mmi: 3,
                quality: 'best',
                longitude: 178.0,
                latitude: -38.0)
          ]));

      await t.pumpWidget(_testWidget());
      // https://github.com/flutter/flutter/issues/22193
      await t.idle();
      await t.pump();

      expect(find.byKey(k), findsOneWidget);
      expect(find.byType(QuakeList), findsOneWidget);
    });

    testWidgets('loaded found no quakes', (WidgetTester t) async {
      when(quakesBloc.state).thenAnswer((_) => QuakesLoaded(3, List<Quake>()));

      await t.pumpWidget(_testWidget());
      // https://github.com/flutter/flutter/issues/22193
      await t.idle();
      await t.pump();

      expect(find.byKey(k), findsOneWidget);
      expect(find.text('Found no quakes to display for that intensity.'), findsOneWidget);
    });

    testWidgets('error', (WidgetTester t) async {
      when(quakesBloc.state).thenAnswer((_) => QuakesError());

      await t.pumpWidget(_testWidget());
      // https://github.com/flutter/flutter/issues/22193
      await t.idle();
      await t.pump();

      expect(find.byKey(k), findsOneWidget);
      expect(find.text('Something went wrong!'), findsOneWidget);
    });
  });
}
