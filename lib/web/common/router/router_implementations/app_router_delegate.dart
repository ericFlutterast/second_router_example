import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:learning_navigator_api/web/common/router/observers/observers.dart';

final class AppRouterDelegate<IAppRouteConfiguration> extends RouterDelegate<IAppRouteConfiguration>
    with ChangeNotifier, PopNavigatorRouterDelegateMixin {
  AppRouterDelegate()
      : _modalObserver = ModalObserver(),
        _pageObserver = PageObserver();

  final ModalObserver _modalObserver;
  final PageObserver _pageObserver;
  IAppRouteConfiguration? _currentConfiguration;

  @override
  IAppRouteConfiguration? get currentConfiguration {
    if (_currentConfiguration == null) {
      UnsupportedError('Не установленна превоначалная конфигурация');
    }
    return _currentConfiguration!;
  }

  @override
  GlobalKey<NavigatorState>? get navigatorKey => GlobalKey<NavigatorState>();

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }

  //Получаем новую конфигурацию из парсера
  @override
  Future<void> setNewRoutePath(IAppRouteConfiguration configuration) async {
    if (configuration == _currentConfiguration) {
      //Конфигурация не изменилась
      return SynchronousFuture<void>(null);
    }

    _currentConfiguration = configuration;
    notifyListeners();
    return SynchronousFuture<void>(null);
  }

  //вызывается когда платформа уведомяляет об анализе начальеого маршрута
  @override
  Future<void> setInitialRoutePath(IAppRouteConfiguration configuration) {
    print('setInitialRoutePath');
    return super.setInitialRoutePath(configuration);
  }

  //вызывается когда происходит воставновление состояния
  @override
  Future<void> setRestoredRoutePath(IAppRouteConfiguration configuration) {
    print('setRestoredRoutePath');
    return super.setRestoredRoutePath(configuration);
  }
}
