import 'cli_helpers.dart';
import 'constants.dart';
import 'utils.dart';

Future<bool> askFirebaseSupport() async {
  final choice = getUserInput(firebaseSupportPrompt).toLowerCase();
  if (choice == 'y') {
    print(addingFirebasePackagesMessage);
    await addFlutterDependency('firebase_core');
    await addFlutterDependency('cloud_firestore');
    await addFlutterDependency('firebase_auth');
    await addFlutterDependency('firebase_storage');
    return true;
  }
  print(skippingFirebaseSupportMessage);
  return false;
}

Future<void> setupFlutterFire() async {
  final choice = getUserInput(flutterFireConfigurationPrompt).toLowerCase();
  if (choice == 'y') {
    print(flutterFireConfigurationInstructions);
  } else {
    print(skippingFirebaseConfigurationMessage);
  }
}