import 'dart:async';

void run() => runZonedGuarded<void>(
      () {},
      (error, stackTrace) {
        throw UnimplementedError(error.toString());
      },
    );
