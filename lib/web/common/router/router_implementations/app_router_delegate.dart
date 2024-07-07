import 'package:flutter/material.dart';

final class AppRouterDelegate<AppRouterState> extends RouterDelegate<AppRouterState>
    with ChangeNotifier, PopNavigatorRouterDelegateMixin {
  @override
  GlobalKey<NavigatorState>? get navigatorKey => GlobalKey<NavigatorState>();

  @override
  Widget build(BuildContext context) {
    return Navigator(
      key: navigatorKey,
      onGenerateRoute: (setting) {
        return switch (setting.name) {
          '/home' => _createRoute(
              Container(color: Colors.orange, child: const Center(child: Text('home'))),
            ),
          '/chat' => _createRoute(
              Container(color: Colors.blue, child: const Center(child: Text('chat'))),
            ),
          '/friends' => _createRoute(
              Container(color: Colors.pink, child: const Center(child: Text('friends'))),
            ),
          '/profile' => _createRoute(
              Container(color: Colors.greenAccent, child: const Center(child: Text('profile'))),
            ),
          _ => _createRoute(
              Container(color: Colors.red, child: const Center(child: Text('404'))),
            ),
        };
      },
      onPopPage: (route, result) {
        //TODO:
        return false;
      },
    );
  }

  @override
  Future<void> setNewRoutePath(AppRouterState configuration) async {
    print('setNewRoutePath');
    notifyListeners();
  }

  Route _createRoute(Widget child) {
    return PageRouteBuilder(
      pageBuilder: (context, _, __) {
        return child;
      },
    );
  }
}
