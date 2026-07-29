/// Centralizes every raw value related to the Rick and Morty REST API.
/// Single responsibility: hold API configuration only — no logic here.
class ApiConstants {
  const ApiConstants._();

  static const String baseUrl = 'https://rickandmortyapi.com/api';
  static const String characterEndpoint = '/character';
// Widened from 1600ms so the staged splash sequence (gradient settle
  // -> logo entrance -> wordmark reveal) has room to finish before nav.
  static const Duration splashDuration = Duration(milliseconds: 2000);
  static const Duration connectTimeout = Duration(seconds: 15);
  static const Duration receiveTimeout = Duration(seconds: 15);

  // Filter query keys, as documented by the API.
  static const String queryName = 'name';
  static const String queryStatus = 'status';
  static const String querySpecies = 'species';
  static const String queryGender = 'gender';
  static const String queryPage = 'page';
}
