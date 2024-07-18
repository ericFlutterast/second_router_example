import 'package:learning_navigator_api/runner_stub.dart'
    if (dart.library.io) 'package:learning_navigator_api/runner_io.dart'
    if (dart.library.html) 'package:learning_navigator_api/runner_web.dart' as runner;

void main() => runner.run();
