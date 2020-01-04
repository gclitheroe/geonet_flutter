import 'package:bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:geonet_flutter/bloc/quakes_bloc.dart';
import 'package:geonet_flutter/screens/quakes.dart';
import 'package:http/http.dart' as http;

import 'api/geonet.dart';
import 'package:flutter/material.dart';

import 'localisation/localisation.dart';

final geoNet = new GeoNetAPI();

/// Simple interceptor to print information about Bloc events.
class SimpleBlocDelegate extends BlocDelegate {
  @override
  void onEvent(Bloc bloc, Object event) {
    super.onEvent(bloc, event);
    print(event);
  }

  @override
  onTransition(Bloc bloc, Transition transition) {
    super.onTransition(bloc, transition);
    print(transition);
  }

  @override
  void onError(Bloc bloc, Object error, StackTrace stacktrace) {
    super.onError(bloc, error, stacktrace);
    print(error);
  }
}

void main() {
  final geoNet = new GeoNetAPI(httpClient: http.Client());

  BlocSupervisor.delegate = SimpleBlocDelegate();

  runApp(App(geoNet: geoNet));
}

class App extends StatelessWidget {
  final GeoNetAPI geoNet;

  App({Key key, this.geoNet}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      onGenerateTitle: (BuildContext context) => Localisation.of(context).title,
      localizationsDelegates: [
        const LocalisationDelegate(),
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      supportedLocales: [
        const Locale('en', ''),
      ],
      home: BlocProvider(
        create: (context) => QuakesBloc(geoNet: geoNet),
        child: QuakesScreen(),
      ),
    );
  }
}
