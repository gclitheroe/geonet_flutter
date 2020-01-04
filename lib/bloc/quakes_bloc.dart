import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'dart:async';

import 'package:geonet_flutter/api/api.dart';
import 'package:geonet_flutter/entity/entity.dart';

/// The parent for events for the quakes screen.
abstract class QuakesEvent {
  final int mmi;

  const QuakesEvent({this.mmi});
}

/// A request to fetch quakes with MMI >= mmi.
class QuakesFetch extends QuakesEvent {
  const QuakesFetch(int mmi) : super(mmi: mmi);
}

/// A request to fetch quakes with MMI >= mmi for
/// the first time the quakes screen is loaded.
class QuakesFetchFirst extends QuakesEvent {
  const QuakesFetchFirst(int mmi) : super(mmi: mmi);
}

/// The parent for states returned to the quakes screen.
abstract class QuakesState extends Equatable {
  const QuakesState();

  @override
  List<Object> get props => [];
}

/// For indicating initial on load state of the quakes screen.
class QuakesStarted extends QuakesState {
  @override
  List<Object> get props => [];
}

class QuakesLoading extends QuakesState {
  @override
  List<Object> get props => [];
}

class QuakesLoaded extends QuakesState {
  final List<Quake> quakes;
  final int mmi;

  const QuakesLoaded(this.mmi, this.quakes);

  @override
  List<Object> get props => [];
}

class QuakesLoadedFirst extends QuakesState {
  final List<Quake> quakes;
  final int mmi;

  const QuakesLoadedFirst(this.mmi, this.quakes);

  @override
  List<Object> get props => [];
}

class QuakesError extends QuakesState {
  @override
  List<Object> get props => [];
}

/// Maps events to states for the quakes screen.
class QuakesBloc extends Bloc<QuakesEvent, QuakesState> {
  final GeoNetAPI geoNet;

  QuakesBloc({this.geoNet}) : assert(geoNet != null);

  @override
  QuakesState get initialState => QuakesStarted();

  @override
  Stream<QuakesState> mapEventToState(QuakesEvent event) async* {
    yield QuakesLoading();
    try {
      final List<Quake> quakes = await geoNet.getQuakes(event.mmi);
      if (event is QuakesFetch) {
        yield QuakesLoaded(event.mmi, quakes);
      } else {
        yield QuakesLoadedFirst(event.mmi, quakes);
      }
    } catch (e) {
      yield QuakesError();
    }
  }
}
