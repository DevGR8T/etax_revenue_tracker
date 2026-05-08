/// All DummyJSON endpoint strings.
/// Supabase auth endpoints are handled by the SDK —
abstract final class Endpoints {
  // ── DummyJSON — Users ──────────────────────────────────────
  static const String user = '/users/1';

  // ── DummyJSON — Products ───────────────────────────────────
  static const String products = '/products';
  static const String productsSearch = '/products/search';
  static const String productsAdd = '/products/add';

  /// Get single product by id.
  static String productById(int id) => '/products/$id';
}