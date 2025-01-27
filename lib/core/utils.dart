import 'dart:io';

import 'constants.dart';

Future<void> addFlutterDependency(String packageName) async {
  await runCommand('flutter', ['pub', 'add', packageName]);
}

Future<ProcessResult> runCommand(String command, List<String> args) async {
  final result = await Process.run(command, args);
  if (result.exitCode == 0) {
    print(commandExecutionSuccessMessage.replaceFirst('{command}', command).replaceFirst('{args}', args.join(" ")));
  } else {
    print(commandExecutionErrorMessage.replaceFirst('{stderr}', result.stderr));
  }
  return result;
}