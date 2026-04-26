import 'core/config/flavor_config.dart';
import 'main.dart' as runner;

void main() {
  FlavorConfig.initialize(Flavor.production);
  runner.main();
}