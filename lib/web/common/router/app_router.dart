import 'package:flutter/material.dart';
import 'package:learning_navigator_api/web/common/router/observers/observers.dart';
import 'package:learning_navigator_api/web/common/router/router_configuration.dart';
import 'package:learning_navigator_api/web/common/router/router_implementations/app_router_delegate.dart';

typedef NavigateCallback = IAppRouteConfiguration Function(IAppRouteConfiguration);

@immutable
class AppRouter extends InheritedNotifier {
  const AppRouter({
    required AppRouterDelegate delegate,
    required super.child,
    super.key,
  })  : _appRouterDelegate = delegate,
        super(notifier: delegate);

  final AppRouterDelegate _appRouterDelegate;

  AppRouterDelegate get router => _appRouterDelegate;
  NavigatorState? get navigator => router.pageObserver.navigator;

  static AppRouter of(BuildContext context, {bool listen = false}) {
    AppRouter? router;
    if (listen) {
      router = context.dependOnInheritedWidgetOfExactType<AppRouter>();
    } else {
      final inhW = context.getElementForInheritedWidgetOfExactType()?.widget;
      router = inhW is AppRouter ? inhW : null;
    }

    return router ?? _notInScope();
  }

  static Never _notInScope() => throw UnsupportedError('Not AppRouter in scope');

  ///Получить навигатор из контекста
  static NavigatorState? navigatorOf(BuildContext context) => of(context).navigator;

  ///Получить роутер из контекста
  static AppRouterDelegate routerOf(BuildContext context) => of(context).router;

  ///Получить обозреватель страниц
  static PageObserver pageObserverOf(BuildContext context) => of(context).router.pageObserver;

  ///Получить обозреватель модальных страниц
  static ModalObserver modalObserverOf(BuildContext context) => of(context).router.modalObserver;

  ///Проверяем сможем ли мы закрыть роут
  static bool canPop(BuildContext context, {bool listen = false}) =>
      listen ? (ModalRoute.of(context)?.canPop ?? false) : (navigatorOf(context)?.canPop() ?? false);

  ///Пробуем закрыть предыдущий роут
  static Future<bool> maybePop<T>(BuildContext context, {T? result}) =>
      navigatorOf(context)?.maybePop(result) ?? Future<bool>.value(false);

  ///Обновить конфигурацию и перейти на новую страницу
  static void navigate(
    BuildContext context,
    NavigateCallback callback, {
    NavigateMode mode = NavigateMode.auto,
  }) {
    final delegate = routerOf(context);

    switch (mode) {
      case NavigateMode.force:
        Router.navigate(
          context,
          () => delegate.setNewRoutePath(callback(delegate.currentConfiguration)),
        );
        break;

      case NavigateMode.neglect:
        Router.neglect(
          context,
          () => delegate.setNewRoutePath(callback(delegate.currentConfiguration)),
        );
        break;

      case NavigateMode.auto:
      default:
        delegate.setNewRoutePath(callback(delegate.currentConfiguration));
        break;
    }
  }

  ///Обновить конфигурацию и перейти на новую страницу
  static Future<bool> pop(BuildContext context) => routerOf(context).popRoute();

  ///Переход на домашнюю страницу
  static void goHome(
    BuildContext context, {
    NavigateMode mode = NavigateMode.neglect,
  }) =>
      navigate(
        context,
        (_) => HomeRouteConfiguration(),
        mode: mode,
      );

  ///Получить аргументы роутинга
  static Object? routeArguments(BuildContext context) => ModalRoute.of(context)?.settings.arguments;

  ///Проверить есть роутер в этом контексте
  static bool containIn<T extends AppRouter>(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<T>() != null;

  ///Добавить в навигатор анонимный экран
  ///для передачи не анонимных маршрутов лучше рассмотреть [navigate]
  static Future<T?> push<T extends Object?>(
    BuildContext context,
    WidgetBuilder builder, {
    Object? arguments,
  }) =>
      navigatorOf(context)?.push<T>(
        MaterialPageRoute<T>(
          builder: builder,
          settings: RouteSettings(arguments: arguments),
        ),
      ) ??
      Future<T?>.value(null);

  static Future<T?> showModalDialog<T extends Object?>(
    BuildContext context,
    WidgetBuilder builder, {
    RouteSettings? routeSettings,
    bool useRootNavigator = true,
  }) {
    final navigator = navigatorOf(context);
    if (navigator == null) return Future<T?>.value(null);
    return showDialog<T>(
      context: navigator.context,
      builder: builder,
      routeSettings: routeSettings,
      barrierColor: Colors.black54,
      useRootNavigator: useRootNavigator,
    );
  }

  ///Образить модал боттом щит
  static Future<T?> showAppModalBottomSheet<T extends Object?>(
    BuildContext context,
    WidgetBuilder builder, {
    RouteSettings? routeSettings,
    Color? backgroundColor,
    String? barrierLabel,
    double? elevation,
    ShapeBorder? shape,
    Clip? clipBehavior,
    BoxConstraints? constraints,
    Color? barrierColor,
    bool isScrollControlled = false,
    bool useRootNavigator = false,
    bool isDismissible = true,
    bool enableDrag = true,
    bool? showDragHandle,
    bool useSafeArea = false,
    AnimationController? transitionAnimationController,
    Offset? anchorPoint,
    AnimationStyle? sheetAnimationStyle,
  }) {
    final navigator = navigatorOf(context);
    if (navigator == null) return Future<T?>.value(null);
    return showModalBottomSheet(
      context: navigator.context,
      builder: builder,
      routeSettings: routeSettings,
      backgroundColor: backgroundColor,
      barrierLabel: barrierLabel,
      elevation: elevation,
      shape: shape,
      clipBehavior: clipBehavior,
      constraints: constraints,
      barrierColor: barrierColor,
      isScrollControlled: isScrollControlled,
      useRootNavigator: useRootNavigator,
      isDismissible: isDismissible,
      enableDrag: enableDrag,
      showDragHandle: showDragHandle,
      useSafeArea: useSafeArea,
      transitionAnimationController: transitionAnimationController,
      anchorPoint: anchorPoint,
      sheetAnimationStyle: sheetAnimationStyle,
    );
  }
}

enum NavigateMode {
  ///создает новую запись если URL отличается
  auto,

  ///Принудительно создает запись в истории браузера
  force,

  ///Принудительно не создает запись в истории браузера
  neglect,
}
