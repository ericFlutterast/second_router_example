import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:learning_navigator_api/web/common/router/router_configuration.dart';

class AppRouterParser = RouteInformationParser<IAppRouteConfiguration>
    with _ParseRouteInformationMixin, _RestoreRouteInformationMixin;

mixin _ParseRouteInformationMixin on RouteInformationParser<IAppRouteConfiguration> {
  ///Метод для обработки информации из
  ///платформы и составления конфигурации на ее основе
  @override
  Future<IAppRouteConfiguration> parseRouteInformation(RouteInformation routeInformation) {
    try {
      if (routeInformation is IAppRouteConfiguration) {
        return SynchronousFuture<IAppRouteConfiguration>(routeInformation);
      }

      //TODO: тут можно добавить нормалищацию маршрута, например отбрасывания посторяющихся имен
      var state = routeInformation.state;
      if (routeInformation.state is! Map<String, Map<String, Object?>>) {
        state = null;
      }

      final newConfiguration =
          DynamicRouteConfiguration(routeInformation.uri, state as Map<String, Object?>?);
      return SynchronousFuture<IAppRouteConfiguration>(newConfiguration);
    } catch (error) {
      print('Произошла ошибка навигации: $error');
      return SynchronousFuture<IAppRouteConfiguration>(NotFoundRouteConfiguration());
    }
  }
}

mixin _RestoreRouteInformationMixin on RouteInformationParser<IAppRouteConfiguration> {
  ///Метод для получения информации из
  ///конфигурации и уведомлении платформы об текущем состоянии
  @override
  RouteInformation? restoreRouteInformation(IAppRouteConfiguration configuration) {
    try {
      //TODO: тут можно добавить нормалищацию маршрута, например отбрасывания посторяющихся имен
      final uri = configuration.uri;
      final state = configuration.state;
      return RouteInformation(uri: uri, state: state);
    } catch (error) {
      print('Произошла ошибка навигации: $error');
      return RouteInformation(uri: Uri.parse('home'));
    }
  }
}
