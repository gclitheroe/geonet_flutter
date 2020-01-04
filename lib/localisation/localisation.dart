import 'dart:async';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

// l10n/messages_all.dart was generated in two steps, using the Dart intl tools. With the
// app's root directory (the one that contains pubspec.yaml) as the current
// directory.  'intl_translation' needs adding to pubspec.yaml
//
// flutter pub pub run intl_translation:extract_to_arb --output-dir=lib/localisation/l10n l10n lib/localisation/localisation.dart
// cp lib/localisation/intl_lib/localisation/messages.arb en_message.arb
// flutter pub pub run intl_translation:generate_from_arb --output-dir=lib/l10n --no-use-deferred-loading lib/main.dart lib/l10n/intl_*.arb
//
// More about this process at https://pub.dev/packages/intl.
import 'l10n/messages_all.dart';

class Localisation {
  Localisation(this.localeName);

  static Future<Localisation> load(Locale locale) {
    final String name =
        locale.countryCode.isEmpty ? locale.languageCode : locale.toString();
    final String localeName = Intl.canonicalizedLocale(name);

    return initializeMessages(localeName).then((_) {
      return Localisation(localeName);
    });
  }

  static Localisation of(BuildContext context) {
    return Localizations.of<Localisation>(context, Localisation);
  }

  final String localeName;

  String get title {
    return Intl.message(
      'GeoNet Flutter',
      name: 'title',
      desc: 'Title for the application',
      locale: localeName,
    );
  }

  String get quakesTitle {
    return Intl.message('Quakes',
        name: 'quakesTitle',
        desc: 'Title for the quakes screen',
        locale: localeName);
  }

  String get noQuakes {
    return Intl.message('Found no quakes to display for that intensity.',
        name: 'noQuakes', locale: localeName);
  }

  String get error {
    return Intl.message('Something went wrong!');
  }

  String get selectQuakeFilter {
    return Intl.message('Please select a quake filter.');
  }

  String get filterQuakes {
    return Intl.message('Filter Quakes');
  }

  String get magnitude {
    return Intl.message('Magnitude');
  }

  String get depth {
    return Intl.message('Depth');
  }

  String get location {
    return Intl.message('Magnitude');
  }

  String get quality {
    return Intl.message('Quality');
  }

  String get earthquake {
    return Intl.message('earthquake');
  }

  String get km {
    return Intl.message('km');
  }

}

class LocalisationDelegate extends LocalizationsDelegate<Localisation> {
  const LocalisationDelegate();

  @override
  bool isSupported(Locale locale) => ['en'].contains(locale.languageCode);

  @override
  Future<Localisation> load(Locale locale) => Localisation.load(locale);

  @override
  bool shouldReload(LocalisationDelegate old) => false;
}
