import 'package:flutter/material.dart';
import 'package:learning_navigator_api/web/common/router/router_implementations/app_router_delegate.dart';
import 'package:learning_navigator_api/web/common/router/router_implementations/app_router_parser.dart';

import '../router/router_configuration.dart';

class AppMaterial extends StatefulWidget {
  const AppMaterial({super.key});

  @override
  State<AppMaterial> createState() => _AppMaterialState();
}

class _AppMaterialState extends State<AppMaterial> {
  final RouteInformationParser<IAppRouteConfiguration> _appRouterParser = const AppRouterParser();
  final AppRouterDelegate<AppRouterParser> _routerDelegate = AppRouterDelegate<AppRouterParser>();

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      routerDelegate: _routerDelegate,
      routeInformationParser: _appRouterParser,
    );
  }
}
