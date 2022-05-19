class Configuration {
  static const String _debugAwsEndpoint = "http://localhost:4566/";
  static const String _productionAwsEndpoint = "";
  static const bool debug = true;

  static String get awsEndpoint => debug ? _debugAwsEndpoint : _productionAwsEndpoint;
}