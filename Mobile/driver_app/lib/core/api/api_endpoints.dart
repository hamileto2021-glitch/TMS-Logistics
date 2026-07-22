class ApiEndpoints {
  static const String server = "http://10.48.91.92:5085";

  static const String baseUrl = "$server/api";

  static const String signalRHub = "$server/trackingHub";

  static const String login = "$baseUrl/Auth/login";

  static const String myTrips = "$baseUrl/Driver/mytrips";

  static const String startTrip = "$baseUrl/Trips";

  static const String tracking = "$baseUrl/Tracking";

  static const String proofOfDelivery =
      "$baseUrl/ProofOfDelivery";

  static const String proofOfDeliveryUpload =
      "$baseUrl/ProofOfDelivery/upload";
}