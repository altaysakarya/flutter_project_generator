const String projectNamePrompt = '🎯 Flutter project name: ';
const String invalidProjectNameMessage = '❌ Please enter a valid project name (letters, numbers, underscores, no leading numbers).';
const String projectDescriptionPrompt = '📝 Enter project description (optional): ';
const String projectPathPrompt = '📁 Enter project path (leave empty for current directory): ';
const String organizationPrompt = '🏢 Organization (optional): (e.g. com.example) ';
const String invalidPathMessage = '❌ The specified path does not exist.';
const String creatingProjectMessage = "🚀 Creating Flutter project '{projectName}'...";
const String projectDirectorySwitchMessage = "📂 Switched to project directory: {projectDirPath}";
const String projectDirectoryErrorMessage = '❌ Project directory does not exist. Something went wrong.';
const String cleaningLibDirectoryMessage = "🧹 Cleaning 'lib/' directory...";
const String directoryCreationMessage = '✅ Created directory: {dir}';
const String baseFilesGeneratedMessage = '📝 Base files generated successfully.';
const String stateManagementPrompt = '\n🗂 Choose a state management solution:';
const String stateManagementOptions = '0️⃣ Continue without state management\n1️⃣ GetX\n2️⃣ BLoC';
const String stateManagementChoicePrompt = 'Enter your choice (0/1/2): ';
const String skippingStateManagementMessage = '🚫 Skipping state management setup.';
const String invalidStateManagementChoiceMessage = '❌ Invalid choice. No state management added.';
const String firebaseSupportPrompt = '\n🔥 Do you want to include Firebase support? (y/n): ';
const String addingFirebasePackagesMessage = '📦 Adding Firebase packages...';
const String skippingFirebaseSupportMessage = '🚫 Firebase support not included.';
const String flutterFireConfigurationPrompt = '\n⚙️ Would you like to configure Firebase using FlutterFire CLI? (y/n): ';
const String flutterFireConfigurationInstructions = '''
🚀 To configure Firebase manually, follow these steps:

1️⃣ Install FlutterFire CLI by running the following command in your terminal:
  ➡️ dart pub global activate flutterfire_cli

2️⃣ Add the CLI to your PATH if not already done:
  ➡️ export PATH="\$PATH":"\$HOME/.pub-cache/bin" (for macOS/Linux)
  ➡️ setx PATH "%PATH%;%APPDATA%\\Pub\\Cache\\bin" (for Windows)

3️⃣ Run the FlutterFire configuration command:
  ➡️ flutterfire configure

After completing these steps, you can proceed with Firebase integration.
''';
const String skippingFirebaseConfigurationMessage = '🚫 Skipping Firebase configuration.';
const String commandExecutionSuccessMessage = '✅ Successfully executed {command} {args}';
const String commandExecutionErrorMessage = '❌ Error: {stderr}';
const String readmeGeneratedMessage = '📝 README.md file generated successfully.';
const String completionMessage = '''
🎉 Great! Your Clean Architecture structure is ready.
👉 Don't forget to run "flutter pub get" after adding the dependencies!
🎉 Project "{projectName}" is all set up!
''';