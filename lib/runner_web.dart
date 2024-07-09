import 'dart:async';

void run() => runZonedGuarded(
      () {},
      (error, stackTrace) {
        throw UnimplementedError(error.toString());
      },
    );
