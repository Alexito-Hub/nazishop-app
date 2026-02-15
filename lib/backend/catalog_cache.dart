import '../models/category_model.dart';
import 'catalog_service.dart';

/// Singleton que cachea el catálogo para evitar recargas innecesarias
class CatalogCache {
  static final CatalogCache _instance = CatalogCache._internal();
  factory CatalogCache() => _instance;
  CatalogCache._internal();

  List<Category>? _cachedCategories;
  DateTime? _lastFetch;
  static const Duration _cacheDuration = Duration(minutes: 5);

  /// Obtiene el catálogo, usando caché si está disponible y vigente
  Future<List<Category>> getCategories({bool forceRefresh = false}) async {
    final now = DateTime.now();

    // Si tenemos caché válido y no se fuerza refresh, retornarlo
    if (!forceRefresh &&
        _cachedCategories != null &&
        _lastFetch != null &&
        now.difference(_lastFetch!) < _cacheDuration) {
      return _cachedCategories!;
    }

    // Cargar catálogo fresco
    try {
      final categories = await CatalogService.getFullCatalog();
      _cachedCategories = categories;
      _lastFetch = now;
      return categories;
    } catch (e) {
      // Si falla y tenemos caché, devolver caché aunque esté viejo
      if (_cachedCategories != null) {
        return _cachedCategories!;
      }
      rethrow;
    }
  }

  /// Invalida el caché forzando una recarga en la próxima petición
  void invalidateCache() {
    _cachedCategories = null;
    _lastFetch = null;
  }

  /// Retorna el caché actual sin hacer fetch (útil para UI inmediata)
  List<Category>? get cachedCategories => _cachedCategories;
}
