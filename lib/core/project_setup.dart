import 'dart:io';

import 'constants.dart';
import 'utils.dart';

Future<void> createFlutterProject(String projectName, String projectPath, String? organization, String? description) async {
  print(creatingProjectMessage.replaceFirst('{projectName}', projectName));

  final args = [
    'create', '$projectPath/$projectName',
    '--project-name', projectName,
    if (organization != null) ...['--org', organization],
    if (description != null) ...['--description', description],
  ];

  final result = await runCommand('flutter', args);
  if (result.exitCode != 0) {
    print('❌ Error: ${result.stderr}');
    exit(1);
  }

  print(projectDirectorySwitchMessage.replaceFirst('{projectDirPath}', '$projectPath/$projectName'));
}

void cleanLibDirectory() {
  print(cleaningLibDirectoryMessage);
  final libDir = Directory('lib');
  if (libDir.existsSync()) libDir.deleteSync(recursive: true);
  libDir.createSync();
}

Future<void> createProjectStructure() async {
  final directories = ['lib/core', 'lib/features', 'lib/features/pages', 'lib/features/components'];
  for (var dir in directories) {
    await Directory(dir).create(recursive: true);
    print(directoryCreationMessage.replaceFirst('{dir}', dir));
  }
}

Future<void> generateBaseFiles(String projectName) async {
  File('lib/main.dart').writeAsStringSync('''
import 'package:flutter/material.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '$projectName',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const Scaffold(body: Center(child: Text('Clean Arch Ready!'))),
    );
  }
}
''');
  print(baseFilesGeneratedMessage);
}

Future<void> generateReadme(String projectName, String? projectDescription) async {
  final readmeContent = '''
# $projectName

${projectDescription ?? 'This project is a starting point for a Flutter application.'}

---

*This README was autogenerated by **FlutterProjectGenerator***.
  ''';

  final readmeFile = File('README.md');
  await readmeFile.writeAsString(readmeContent);

  print(readmeGeneratedMessage);
}