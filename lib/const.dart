const baseURL =
    "https://zany-space-telegram-x4w9qvv6jgvfvpgp-8000.app.github.dev";
final apiUrl = buildUrl(baseURL, "/api/v1");

final registerOptionsEndpoint = buildUrl(apiUrl, "auth/register/options");
final registerEndEndpoint = buildUrl(apiUrl, "auth/register/verify");
final loginOptionsEndpoint = buildUrl(apiUrl, "auth/authenticate/options");
final loginEndEndpoint = buildUrl(apiUrl, "auth/authenticate/verify");

String buildUrl(String endpoint, String additionalPath) {
  if (additionalPath.startsWith("/")) {
    additionalPath = additionalPath.substring(1);
  }
  if (endpoint.endsWith("/")) {
    endpoint = endpoint.substring(0, endpoint.length - 1);
  }
  return "$endpoint/$additionalPath";
}
