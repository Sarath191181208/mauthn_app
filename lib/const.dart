const baseURL = "https://zany-space-telegram-x4w9qvv6jgvfvpgp-8000.app.github.dev";
final apiUrl = buildUrl(baseURL, "/api/v1");
final registerOptionsEndpoint = buildUrl(apiUrl, "auth/register/options");

String buildUrl(String endpoint, String additionalPath) {
  if (additionalPath.startsWith("/")) {
    additionalPath = additionalPath.substring(1);
  }
  if (endpoint.endsWith("/")) {
    endpoint = endpoint.substring(0, endpoint.length - 1);
  }
  return "$endpoint/$additionalPath";
}
