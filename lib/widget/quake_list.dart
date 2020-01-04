import 'package:geonet_flutter/entity/entity.dart';
import 'package:flutter/material.dart';
import 'package:geonet_flutter/localisation/localisation.dart';
import 'package:intl/intl.dart';
import 'package:timeago/timeago.dart' as timeago;

final DateFormat _qf = new DateFormat('EEE, MMM d yyyy, h:mm aaa');

/// A list of quakes - icon images and descriptions.
class QuakeList extends StatelessWidget {
  final List<Quake> quakes;

  QuakeList({Key key, this.quakes}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (quakes.length > 0) {
      return ListView.builder(
        itemCount: quakes.length,
        itemBuilder: (context, i) {
          return Card(
            child: _QuakeListItem(quake: quakes[i]),
          );
        },
      );
    } else {
      return Text(Localisation.of(context).noQuakes);

    }
  }
}

class _QuakeListItem extends StatelessWidget {
  final Quake quake;

  const _QuakeListItem({this.quake});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          flex: 1,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 5.0),
            child: Image.network(quake.iconURL(), height: 100.0),
          ),
        ),
        Expanded(
          flex: 3,
          child: Padding(
            padding: EdgeInsets.fromLTRB(15.0, 15.0, 5.0, 15.0),
            child: _QuakeDescription(quake: quake),
          ),
        ),
      ],
    );
  }
}

/// A text description of the quake.
class _QuakeDescription extends StatelessWidget {
  final Quake quake;

  const _QuakeDescription({this.quake});

  @override
  Widget build(BuildContext context) {
    final ln = Localisation.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        _Title(
            intensity: quake.intensity(),
            when: timeago
                .format(quake.time.add(DateTime.now().timeZoneOffset))
                .toString()),
        const Padding(padding: EdgeInsets.symmetric(vertical: 2.0)),
        _Row(title: ln.magnitude, text: quake.magnitude.toStringAsFixed(1)),
        _Row(title: ln.depth, text: quake.depth.toStringAsFixed(0) + ' ' + ln.km),
        _Row(title: ln.location, text: quake.locality),
        _Row(title: ln.quality, text: quake.quality),
        _Row(
          title: DateTime.now().timeZoneName,
          text: _qf.format(quake.time.add(DateTime.now().timeZoneOffset)),
        ),
      ],
    );
  }
}

/// a row in the quake description.
class _Row extends StatelessWidget {
  final String title;
  final String text;

  const _Row({this.title, this.text});

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        style: TextStyle(color: Colors.black.withOpacity(0.9)),
        children: <TextSpan>[
          TextSpan(
            text: title + ': ',
            style: TextStyle(color: Colors.black.withOpacity(0.5)),
          ),
          TextSpan(text: text),
        ],
      ),
    );
  }
}

/// the title (first) row in the quake description.
class _Title extends StatelessWidget {
  final String intensity;
  final String when;

  _Title({this.intensity, this.when});

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: new TextSpan(
        style: new TextStyle(
            color: Colors.black.withOpacity(0.9), fontWeight: FontWeight.bold),
        children: <TextSpan>[
          new TextSpan(text: '$intensity ${Localisation.of(context).earthquake} '),
          new TextSpan(
              text: '($when)',
              style: new TextStyle(
                  fontStyle: FontStyle.italic, fontWeight: FontWeight.normal)),
        ],
      ),
    );
  }
}

