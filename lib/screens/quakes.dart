import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geonet_flutter/bloc/bloc.dart';
import 'package:geonet_flutter/localisation/localisation.dart';
import 'package:geonet_flutter/widget/widget.dart';

final LinkedHashMap _intensity = {
  0: 'All',
  3: 'Weak+',
  4: 'Light+',
  5: 'Moderate+',
  6: 'Strong+',
  7: 'Severe+',
  8: 'Extreme',
} as LinkedHashMap;

final _labels = (_intensity.values as Iterable<String>)
    .map<DropdownMenuItem<String>>((String value) {
  return DropdownMenuItem<String>(value: value, child: Text(value));
}).toList();

final Map _mmi = {
  'All': 0,
  'Weak+': 3,
  'Light+': 4,
  'Moderate+': 5,
  'Strong+': 6,
  'Severe+': 7,
  'Extreme': 8,
};

/// A list of quakes with an intensity filter button.
class QuakesScreen extends StatelessWidget {
  QuakesScreen({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(Localisation.of(context).quakesTitle),
      ),
      body: Center(
        child: BlocBuilder<QuakesBloc, QuakesState>(
          builder: (context, state) {
            if (state is QuakesLoading) {
              return Center(child: CircularProgressIndicator());
            }
            if (state is QuakesLoaded) {
              return QuakeList(quakes: state.quakes);
            }
            if (state is QuakesLoadedFirst) {
              return QuakeList(quakes: state.quakes);
            }
            if (state is QuakesError) {
              return Text(
                Localisation.of(context).error,
                style: TextStyle(color: Colors.red),
              );
            }
            if (state is QuakesStarted) {
              BlocProvider.of<QuakesBloc>(context).add(QuakesFetchFirst(3));
              return Center(child: CircularProgressIndicator());
            }
            return Center(
                child: Text(Localisation.of(context).selectQuakeFilter));
          },
        ),
      ),
      floatingActionButton: Container(
        child: BlocBuilder<QuakesBloc, QuakesState>(
          builder: (context, state) {
            // on the first load or an error leave value in the button null so that the hint is shown.
            String _value;

            if (state is QuakesLoaded) {
              _value = _intensity[state.mmi];
            }

            return Container(
              color: Colors.lightBlue,
              padding: EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 8.0),
              child: Theme(
                data: Theme.of(context).copyWith(canvasColor: Colors.lightBlue),
                child: DropdownButton<String>(
                  hint: Text(
                    Localisation.of(context).filterQuakes,
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                  icon: Icon(Icons.arrow_drop_up),
                  iconSize: 24,
                  elevation: 16,
                  iconEnabledColor: Colors.white,
                  focusColor: Colors.white,
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 20.0),
                  underline: Container(
                    height: 0,
                  ),
                  onChanged: (String newValue) {
                    BlocProvider.of<QuakesBloc>(context)
                        .add(QuakesFetch(_mmi[newValue]));
                  },
                  items: _labels,
                  value: _value,
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
