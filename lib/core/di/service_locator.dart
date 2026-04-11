import 'set_controllers.dart';
import 'setup_core.dart';
import 'setup_repository.dart';
import 'setup_services.dart';
import 'setup_usecases.dart';

Future<void> setupServiceLocator() async {
  // Core Services - wait for async initialization
  await setupCore();

  // Repositories
  setupRepository();

  // Use Cases
  setupUsecases();

  // Controllers
  setupController();

  // Services
  setupServices();
}
