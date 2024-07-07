import 'package:flutter/material.dart';

///Описание пейджи приложения
@immutable
abstract class AppPage<T extends Object?> extends Page<T> {
  AppPage({
    required this.name,
    super.arguments,
    super.restorationId,
    this.fullscreenDialog = false,
    this.maintainState = false,
    super.key,
  })  : assert(name.toLowerCase().trim() == name, 'Предполагается что путь написан в нижнем регистре'),
        super(name: name);

  final String name;
  final bool maintainState;
  final bool fullscreenDialog;

  ///Создать пейджу на сегмента пути
  static AppPage? fromPath(String path, {Object? arguments}) {
    //Предполагаем что каждый сегмент состоит из имени
    //и разделен '-' после которого могут идти допольнительные параметры, индекс и так далее
    final segments = path.toLowerCase().split('-');
    final name = segments.firstOrNull?.trim();
    final args = segments.length > 1 ? segments.sublist(0) : <String>[];

    return null; //TODO:
  }

  @override
  Route<T> createRoute(BuildContext context) {
    return MaterialPageRoute(
        builder: build, settings: this, maintainState: maintainState, fullscreenDialog: fullscreenDialog);
  }

  Widget build(BuildContext context);
}

final class HomePage extends AppPage {
  HomePage({super.name = 'home'});

  @override
  Widget build(BuildContext context) {
    return const Text("Home");
  }
}

final class NotFoundPage extends AppPage {
  NotFoundPage({super.name = '404'});

  @override
  Widget build(BuildContext context) {
    return const Text('404');
  }
}

final class SettingsPage extends AppPage {
  SettingsPage({super.name = 'settings'});

  @override
  Widget build(BuildContext context) {
    return const Text('Settings');
  }
}

final class AboutPage extends AppPage {
  AboutPage({super.name = 'about'});

  @override
  Widget build(BuildContext context) {
    return const Text('About');
  }
}

final class ColorPage extends AppPage {
  ColorPage._({
    required this.colorName,
    required this.color,
  }) : super(name: 'color-$colorName');

  factory ColorPage.pink() => ColorPage._(colorName: 'pink', color: Colors.pink);
  factory ColorPage.purple() => ColorPage._(colorName: 'purple', color: Colors.purple);
  factory ColorPage.pinkAccent() => ColorPage._(colorName: 'pinkAccent', color: Colors.pinkAccent);

  static AppPage fromArguments(List<String> args) {
    final argument = args.first;
    return switch (argument) {
      'pink' => ColorPage.pink(),
      'purple' => ColorPage.purple(),
      'pinkAccent' => ColorPage.pinkAccent(),
      _ => NotFoundPage(),
    };
  }

  final String colorName;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return const Text('Color screen');
  }
}

final class AccentPage extends AppPage {
  AccentPage._({
    required this.color,
    required this.accent,
    required this.colorName,
  }) : super(name: 'accent-$colorName-$accent');

  factory AccentPage({
    required Color color,
    required String colorName,
    required int accent,
  }) =>
      AccentPage._(color: color, accent: accent, colorName: colorName);

  factory AccentPage.pink(int accent) => AccentPage._(
        colorName: 'pink',
        accent: accent,
        color: Colors.pink[accent]!,
      );

  factory AccentPage.purple(int accent) => AccentPage._(
        colorName: 'purple',
        accent: accent,
        color: Colors.purple[accent]!,
      );

  factory AccentPage.pinkAccent(int accent) => AccentPage._(
        colorName: 'pinkAccent',
        accent: accent,
        color: Colors.pinkAccent[accent]!,
      );

  static AppPage fromArguments(List<String> args) {
    final name = args.first;
    final argument = int.parse(args[1]);
    return switch (name) {
      'pink' => AccentPage.pink(argument),
      'purple' => AccentPage.purple(argument),
      'pinkAccent' => AccentPage.pinkAccent(argument),
      _ => NotFoundPage(),
    };
  }

  final int accent;
  final String colorName;
  final Color color;

  @override
  Widget build(BuildContext context) {
    throw const Text('Accent screen');
  }
}
