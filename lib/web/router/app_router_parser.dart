import 'package:flutter/cupertino.dart';
import 'package:learning_navigator_api/web/router/app_router_state.dart';

final class AppRouterParser extends RouteInformationParser<AppRouterState> {
  @override
  Future<AppRouterState> parseRouteInformation(RouteInformation routeInformation) async {
    final path = routeInformation.uri.path;

    if (path.length == 1) {
      if (path == PageName.home.name) {
        return AppRouterState.home(currentPath: path);
      }

      if (path == PageName.profile.name) {
        return AppRouterState.profile(currentPath: path);
      }

      if (path == PageName.chat.name) {
        return AppRouterState.chat(currentPath: path);
      }

      if (path == PageName.friends.name) {
        return AppRouterState.friends(currentPath: path);
      }
    }

    return AppRouterState.unknown(currentPath: path);
  }

  @override
  RouteInformation? restoreRouteInformation(AppRouterState configuration) {
    if (configuration.isChat) return RouteInformation(uri: Uri.parse('/chat'));
    if (configuration.isFriends) return RouteInformation(uri: Uri.parse('/friends'));
    if (configuration.isProfile) return RouteInformation(uri: Uri.parse('/Profile'));
    if (configuration.isUnknown) return RouteInformation(uri: Uri.parse('/404'));

    return RouteInformation(uri: Uri.parse('/'));
  }
}
