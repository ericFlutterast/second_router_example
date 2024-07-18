import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:learning_navigator_api/web/common/router/app_router.dart';
import 'package:learning_navigator_api/web/common/router/observers/observers.dart';
import 'package:learning_navigator_api/web/common/router/pages/app_pages.dart';
import 'package:learning_navigator_api/web/common/router/pages/page_builder.dart';
import 'package:learning_navigator_api/web/common/router/router_configuration.dart';

final class AppRouterDelegate extends RouterDelegate<IAppRouteConfiguration> with ChangeNotifier {
  AppRouterDelegate()
      : _modalObserver = ModalObserver(),
        _pageObserver = PageObserver();

  final ModalObserver _modalObserver;
  final PageObserver _pageObserver;
  IAppRouteConfiguration? _currentConfiguration;

  ModalObserver get modalObserver => _modalObserver;
  PageObserver get pageObserver => _pageObserver;

  GlobalKey<NavigatorState>? get navigatorKey => GlobalKey<NavigatorState>();

  @override
  IAppRouteConfiguration get currentConfiguration {
    final configuration = _currentConfiguration;
    if (configuration == null) {
      throw UnsupportedError('Не установленна превоначальная конфигурация');
    }
    return configuration;
  }

  @override
  Widget build(BuildContext context) {
    final configuration = currentConfiguration;
    return AppRouter(
      delegate: this,
      child: PageBuilder(
        builder: (BuildContext context, List<AppPage<Object?>> pages, Widget? child) {
          return Navigator(
            transitionDelegate: const DefaultTransitionDelegate(),
            onUnknownRoute: (settings) {}, //TODO : вынести в метод
            reportsRouteUpdateToEngine: true,
            observers: [
              _modalObserver,
              _pageObserver,
            ],
            pages: pages,
            onPopPage: (rout, result) {
              return false;
            }, //TODO: добавить обработку
          );
        },
        configuration: configuration,
      ),
    );
  }

  //Получаем новую конфигурацию из парсера

  @override
  Future<void> setNewRoutePath(IAppRouteConfiguration configuration) {
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

  @override
  Future<bool> popRoute() {
    final NavigatorState? navigator = navigatorKey?.currentState;
    return navigator?.maybePop() ?? SynchronousFuture<bool>(false);
  }
}
