class ApiEndpoints {
  // Your ASP.NET Core Backend
  static const String baseUrl = "http://10.79.99.92:5085/api";

  // Authentication
  static const String login = "$baseUrl/Auth/login";

  // Dashboard
  static const String dashboard = "$baseUrl/Dashboard";

  // Modules
  static const String customers = "$baseUrl/Customers";
  static const String shipments = "$baseUrl/Shipments";
  static const String dispatches = "$baseUrl/Dispatches";
  static const String trips = "$baseUrl/Trips";
  static const String vehicles = "$baseUrl/Vehicles";
  static const String drivers = "$baseUrl/Drivers";
  static const tracking = "$baseUrl/Tracking";
}