import 'dart:io';

import '../lib/core/cli_helpers.dart';
import '../lib/core/constants.dart';
import '../lib/core/firebase_setup.dart';
import '../lib/core/project_setup.dart';
import '../lib/core/state_management.dart';

void main() async {
  final projectName = getProjectName();
  final projectDescription = getUserInput(projectDescriptionPrompt, false);
  final projectPath = getUserInput(projectPathPrompt, false);
  final organization = getUserInput(organizationPrompt, false);

  if (!validatePath(projectPath)) return;

  await createFlutterProject(
      projectName, projectPath, organization, projectDescription);
  Directory.current = Directory('$projectPath/$projectName');

  cleanLibDirectory();
  await createProjectStructure();
  await generateBaseFiles(projectName);

  await generateReadme(projectName, projectDescription);

  await configureStateManagement();

  final firebaseAdded = await askFirebaseSupport();
  if (firebaseAdded) {
    await setupFlutterFire();
  }

  printCompletionMessage(projectName);
}
