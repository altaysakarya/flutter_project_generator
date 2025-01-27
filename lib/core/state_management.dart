import 'cli_helpers.dart';
import 'constants.dart';
import 'utils.dart';

Future<void> configureStateManagement() async {
  print(stateManagementPrompt);
  print(stateManagementOptions);
  final choice = getUserInput(stateManagementChoicePrompt);

  switch (choice) {
    case '1':
      await addFlutterDependency('get');
      break;
    case '2':
      await addFlutterDependency('flutter_bloc');
      await addFlutterDependency('bloc');
      break;
    case '0':
      print(skippingStateManagementMessage);
      return;
    default:
      print(invalidStateManagementChoiceMessage);
  }
}