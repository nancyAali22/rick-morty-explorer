/// Central registry of route paths and names — no magic strings in the UI.
class RouteNames {
  const RouteNames._();

  static const String splash = '/';
  static const String characters = '/characters';
  static const String characterDetails = '/characters/:id';

  static String characterDetailsPath(int id) => '/characters/$id';
}
