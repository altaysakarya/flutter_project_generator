import 'dart:io';

import 'constants.dart';

String getUserInput(String prompt, [bool isRequired = true]) {
  stdout.write(prompt);
  while (true) {
    final input = stdin.readLineSync()?.trim();
    if (!isRequired || (input != null && input.isNotEmpty)) {
      return input ?? '';
    }
    print(invalidProjectNameMessage);
  }
}

String getProjectName() {
  return getUserInput(projectNamePrompt);
}

bool validatePath(String path) {
  if (!Directory(path).existsSync()) {
    print(invalidPathMessage);
    return false;
  }
  return true;
}
void printCompletionMessage(String projectName) {
  print(completionMessage.replaceFirst('{projectName}', projectName));
}