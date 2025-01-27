import 'dart:io';

void main() async {
  final projectName = _getProjectName();
  final projectDescription = _getProjectDescription();
  final projectPath = _getProjectPath();
  final organization = _getOrganization();

  if (!_validatePath(projectPath)) return;

  await _createFlutterProject(
      projectName, projectPath, organization, projectDescription);
  Directory.current = Directory('$projectPath/$projectName');

  _cleanLibDirectory();
  await _createProjectStructure();
  await _generateBaseFiles(projectName);

  await _generateReadme(projectName, projectDescription);

  await _configureStateManagement();

  final firebaseAdded = await _askFirebaseSupport();
  if (firebaseAdded) {
    await _setupFlutterFire();
  }

  _printCompletionMessage(projectName);
}

String _getProjectName() {
  stdout.write('🎯 Flutter project name: ');
  while (true) {
    final input = stdin.readLineSync();
    if (_isValidProjectName(input)) {
      return input!;
    } else {
      print(
          '❌ Please enter a valid project name (letters, numbers, underscores, no leading numbers).');
    }
  }
}

String? _getProjectDescription() {
  stdout.write('📝 Enter project description (optional): ');
  final input = stdin.readLineSync();
  return input?.isNotEmpty == true ? input : null;
}

String _getProjectPath() {
  stdout.write('📁 Enter project path (leave empty for current directory): ');
  final input = stdin.readLineSync();
  return input != null && input.isNotEmpty
      ? input.trim()
      : Directory.current.path;
}

String? _getOrganization() {
  stdout.write('🏢 Organization (optional): (e.g. com.example) ');
  final input = stdin.readLineSync();
  return input?.isNotEmpty == true ? input : null;
}

bool _validatePath(String path) {
  if (!Directory(path).existsSync()) {
    print('❌ The specified path does not exist.');
    return false;
  }
  return true;
}

Future<void> _createFlutterProject(String projectName, String projectPath,
    String? organization, String? description) async {
  print("🚀 Creating Flutter project '$projectName'...");
  projectPath = projectPath.endsWith('/') ? projectPath : '$projectPath/';
  final args = [
    'create',
    projectPath + projectName,
    ...["--project-name", projectName],
    if (organization != null) ...['--org', organization],
    if (description != null) ...['--description', description],
  ];

  final result = await Process.run('flutter', args);

  if (result.exitCode != 0) {
    print('❌ Error creating Flutter project: ${result.stderr}');
    exit(1);
  }

  final projectDir = Directory('$projectPath$projectName');
  print("PATH:: ${projectDir.path}");
  if (await projectDir.exists()) {
    Directory.current = projectDir;
    print("📂 Switched to project directory: ${projectDir.path}");
  } else {
    print('❌ Project directory does not exist. Something went wrong.');
    exit(1);
  }
}

void _cleanLibDirectory() {
  print("🧹 Cleaning 'lib/' directory...");
  final libDir = Directory('lib');
  if (libDir.existsSync()) {
    libDir.deleteSync(recursive: true);
  }
  libDir.createSync();
}

Future<void> _createProjectStructure() async {
  final directories = [
    'lib/core',
    'lib/core/utils',
    'lib/core/errors',
    'lib/core/constants',
    'lib/features',
    'lib/features/page',
    'lib/features/components',
  ];

  for (var dir in directories) {
    await Directory(dir).create(recursive: true);
    print('✅ Created directory: $dir');
  }
}

Future<void> _generateBaseFiles(String projectName) async {
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
  print('📝 Base files generated successfully.');
}

Future<void> _configureStateManagement() async {
  print('\n🗂 Choose a state management solution:');
  print('0️⃣ Continue without state management');
  print('1️⃣ GetX');
  print('2️⃣ BLoC');
  stdout.write('Enter your choice (0/1/2): ');

  final choice = stdin.readLineSync();
  switch (choice) {
    case '1':
      await _addFlutterDependency('get');
      break;
    case '2':
      await _addFlutterDependency('flutter_bloc');
      await _addFlutterDependency('bloc');
      break;
    case '0':
      print('🚫 Skipping state management setup.');
      return;
    default:
      print('❌ Invalid choice. No state management added.');
  }
}

Future<bool> _askFirebaseSupport() async {
  stdout.write('\n🔥 Do you want to include Firebase support? (y/n): ');
  final choice = stdin.readLineSync()?.toLowerCase();

  if (choice == 'y') {
    print('📦 Adding Firebase packages...');
    await _addFlutterDependency('firebase_core');
    await _addFlutterDependency('cloud_firestore');
    await _addFlutterDependency('firebase_auth');
    await _addFlutterDependency('firebase_storage');
    return true;
  }
  print('🚫 Firebase support not included.');
  return false;
}

Future<void> _setupFlutterFire() async {
  stdout.write(
      '\n⚙️ Would you like to configure Firebase using FlutterFire CLI? (y/n): ');
  final choice = stdin.readLineSync()?.toLowerCase();

  if (choice == 'y') {
    print('''
🚀 To configure Firebase manually, follow these steps:

1️⃣ Install FlutterFire CLI by running the following command in your terminal:
   ➡️ dart pub global activate flutterfire_cli

2️⃣ Add the CLI to your PATH if not already done:
   ➡️ export PATH="\$PATH":"\$HOME/.pub-cache/bin" (for macOS/Linux)
   ➡️ setx PATH "%PATH%;%APPDATA%\\Pub\\Cache\\bin" (for Windows)

3️⃣ Run the FlutterFire configuration command:
   ➡️ flutterfire configure

After completing these steps, you can proceed with Firebase integration.
''');
  } else {
    print('🚫 Skipping Firebase configuration.');
  }
}

Future<void> _addFlutterDependency(String packageName) async {
  await _runCommand('flutter', ['pub', 'add', packageName]);
}

Future<void> _runCommand(String command, List<String> args) async {
  final result = await Process.run(command, args);
  if (result.exitCode == 0) {
    print('✅ Successfully executed $command ${args.join(" ")}');
  } else {
    print('❌ Error: ${result.stderr}');
  }
}

bool _isValidProjectName(String? input) {
  if (input == null || input.isEmpty) return false;
  final validCharacters = RegExp(r'^[a-zA-Z0-9_]+$');
  return validCharacters.hasMatch(input) && !input.startsWith(RegExp(r'[0-9]'));
}

Future<void> _generateReadme(
    String projectName, String? projectDescription) async {
  final readmeContent = '''
# $projectName

${projectDescription ?? 'This project is a starting point for a Flutter application.'}

---

*This README was autogenerated by **FlutterProjectGenerator***.
  ''';

  final readmeFile = File('README.md');
  await readmeFile.writeAsString(readmeContent);

  print('📝 README.md file generated successfully.');
}

void _printCompletionMessage(String projectName) {
  print('');
  print('🎉 Great! Your Clean Architecture structure is ready.');
  print(
      '👉 Don\'t forget to run "flutter pub get" after adding the dependencies!');
  print('🎉 Project "$projectName" is all set up!');
}
