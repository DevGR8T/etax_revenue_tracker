enum Flavor { dev, staging, production }

abstract final class FlavorConfig {
  static late Flavor flavor;
  static late String baseUrl;
  static late String reqresUrl;
  static late String appName;

  static void initialize(Flavor f) {
    flavor = f;
    switch (f) {
      case Flavor.dev:
        baseUrl = 'https://dummyjson.com';
        reqresUrl = 'https://reqres.in';
        appName = 'eTax Dev';
      case Flavor.staging:
        baseUrl = 'https://dummyjson.com';
        reqresUrl = 'https://reqres.in';
        appName = 'eTax Staging';
      case Flavor.production:
        baseUrl = 'https://dummyjson.com';
        reqresUrl = 'https://reqres.in';
        appName = 'eTax Revenue Tracker';
    }
  }

  static bool get isDev => flavor == Flavor.dev;
  static bool get isProduction => flavor == Flavor.production;
}