import 'package:flutter/material.dart';
import 'package:learning_navigator_api/web/common/router/pages/app_pages.dart';

import '../router_configuration.dart';

class PageBuilder extends StatefulWidget {
  const PageBuilder({
    super.key,
    required this.builder,
    required this.configuration,
    this.child,
  });

  final IAppRouteConfiguration configuration;
  final ValueWidgetBuilder<List<AppPage<Object?>>> builder;
  final Widget? child;

  static List<AppPage<Object?>> buildAndReduce(
    BuildContext context, {
    required IAppRouteConfiguration configuration,
  }) {
    final segments = configuration.uri.pathSegments;
    final state = Map<String, Object?>.of(
      configuration.state ?? <String, Object?>{},
    );
    final home = HomePage();
    final pages = <String, AppPage<Object?>>{
      home.name: home,
    };

    for (final path in segments) {
      try {
        if (path.isEmpty) continue;
        final page = AppPage.fromPath(
          path,
          arguments: state.remove(path),
        );
        pages[page.name] = page;
      } on Object catch (error) {
        print('Ошибка разбора пути при построении списка пейджей, путь: $path, error: $error');
      }
    }

    return pages.values.toList(growable: false);
  }

  @override
  State<PageBuilder> createState() => _PageBuilderState();
}

class _PageBuilderState extends State<PageBuilder> {
  late IAppRouteConfiguration? configuration;
  List<AppPage<Object?>> pages = [];

  @override
  void initState() {
    super.initState();
    _preparePages();
  }

  @override
  void didUpdateWidget(covariant PageBuilder oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (configuration != widget.configuration) {
      _preparePages();
    }
  }

  void _preparePages() {
    configuration = widget.configuration;
    pages = PageBuilder.buildAndReduce(context, configuration: widget.configuration);
  }

  @override
  Widget build(BuildContext context) => widget.builder(
        context,
        pages,
        widget.child,
      );
}
