import 'dart:async';

import 'package:learning_navigator_api/web/app.dart';

void run() => runZonedGuarded(
      () {
        App.run();
      },
      (error, stackTrace) {
        throw UnimplementedError(error.toString());
      },
    );
