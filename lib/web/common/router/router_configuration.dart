import 'package:flutter/widgets.dart';

abstract interface class IAppRouteConfiguration implements RouteInformation {
  ///является ли эта конфигурация корневой
  bool get isRoot;

  ///получить пердыдущую конфигурацию
  ///если null значит это корневая конфигурация
  IAppRouteConfiguration? get previousConfiguration;

  @override
  Map<String, Object?>? get state;

  ///Добавить страницу, роут к приложению и выпустить новую
  ///кофигурацию на основе текущей
  IAppRouteConfiguration add(Object? appPage); //TODO: Oject заменить на AppPAge
}

///Базовая конфигурация, шаблонный метод
abstract class RouterConfigurationBase implements IAppRouteConfiguration {
  const RouterConfigurationBase();

  @override
  bool get isRoot => previousConfiguration != null;

  @override
  IAppRouteConfiguration? get previousConfiguration {
    IAppRouteConfiguration? getPrevious() {
      final path = uri.path;
      if (path == '/' || path == 'home' || path.isEmpty) return null;
      try {
        final pathSegments = uri.pathSegments;
        if (pathSegments.length == 1) {
          return HomeRouteConfiguration();
        }

        final newPath = pathSegments.sublist(0, pathSegments.length - 1).join('/');
        final newState = state;
        if (newState != null) {
          newState.remove(pathSegments.last); //TODO: продебажить посмотреть как изменяется
        }

        //TODO: Вернуть конфигурацию на основе нового пути
        return null;
      } on Object catch (error, stackTrace) {
        return null;
      }
    }

    return null;
  }

  @override
  IAppRouteConfiguration add(Object? appPage) {
    //TODO: Реализовать логику, на вход должна поступать пейджа
    //TODO: на основе которой будет реализована конфигурация
    return this;
  }

  @override
  int get hashCode => Object.hash(state, uri.path);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is IAppRouteConfiguration && other.uri.path == uri.path && other.state == state);
  }

  @override
  String toString() {
    return 'configuration: ${uri.path}';
  }
}

final class HomeRouteConfiguration extends RouterConfigurationBase {
  @override
  bool get isRoot => true;

  @override
  String location = 'home';

  @override
  Map<String, Object?>? get state => <String, Object?>{};

  @override
  IAppRouteConfiguration? get previousConfiguration => null;

  @override
  Uri get uri => Uri.parse(location);
}

final class NotFoundRouteConfiguration extends RouterConfigurationBase {
  @override
  String location = 'home/404';

  @override
  bool get isRoot => false;

  @override
  IAppRouteConfiguration? get previousConfiguration => HomeRouteConfiguration();

  @override
  Map<String, Object?>? get state => <String, Object?>{};

  @override
  Uri get uri => Uri.parse(location);
}
