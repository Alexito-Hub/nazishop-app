// Servicio para manejar detección de país y monedas
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/currency_model.dart';
import 'api_client.dart';

class CurrencyService {
  static const String _selectedCurrencyKey = 'selected_currency';
  static const String _detectedCountryKey = 'detected_country';
  static const String _currenciesCacheKey = 'currencies_cache';
  static const String _lastFetchKey = 'currencies_last_fetch';

  // Cache de monedas disponibles
  static final Map<String, Currency> _currenciesCache = {};
  static Currency? _selectedCurrency;

  // Mapeo de países a códigos de moneda
  static const Map<String, String> countryToCurrency = {
    'US': 'USD',
    'CO': 'COP',
    'MX': 'MXN',
    'PE': 'PEN',
    'AR': 'ARS',
    'CL': 'CLP',
    'BR': 'BRL',
  };

  // Inicializar el servicio de monedas (llamar al inicio de la app)
  static Future<void> initialize() async {
    debugPrint('💱 Initializing currency service...');
    await fetchCurrencies();
    await _loadSelectedCurrency();
  }

  // Obtener monedas desde el backend
  static Future<void> fetchCurrencies() async {
    try {
      debugPrint('🌐 Fetching currencies from backend...');

      // Verificar si hay cache válido (menos de 24 horas)
      final prefs = await SharedPreferences.getInstance();
      final lastFetch = prefs.getInt(_lastFetchKey) ?? 0;
      final now = DateTime.now().millisecondsSinceEpoch;

      if (now - lastFetch < 86400000 && _currenciesCache.isNotEmpty) {
        debugPrint('✅ Using cached currencies');
        return;
      }

      final data = await ApiClient.get('/api/currencies');

      if (data['status'] == true && data['data'] != null) {
        _currenciesCache.clear();

        for (var currencyData in data['data']) {
          final currency = Currency.fromJson(currencyData);
          _currenciesCache[currency.code] = currency;
        }

        // Guardar en cache
        await prefs.setString(_currenciesCacheKey, json.encode(data['data']));
        await prefs.setInt(_lastFetchKey, now);

        debugPrint(
            '✅ Loaded ${_currenciesCache.length} currencies from backend');
      }
    } catch (e) {
      debugPrint('⚠️ Error fetching currencies: $e');
      // Intentar cargar desde cache
      await _loadFromCache();
    }

    // Si no hay monedas, usar USD por defecto
    if (_currenciesCache.isEmpty) {
      _currenciesCache['USD'] = Currency(
        code: 'USD',
        symbol: '\$',
        name: 'US Dollar',
        exchangeRate: 1.0,
        isDefault: true,
      );
    }
  }

  // Cargar monedas desde cache
  static Future<void> _loadFromCache() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final cached = prefs.getString(_currenciesCacheKey);
      if (cached != null) {
        final List<dynamic> data = json.decode(cached);
        _currenciesCache.clear();
        for (var currencyData in data) {
          final currency = Currency.fromJson(currencyData);
          _currenciesCache[currency.code] = currency;
        }
        debugPrint('✅ Loaded ${_currenciesCache.length} currencies from cache');
      }
    } catch (e) {
      debugPrint('⚠️ Error loading from cache: $e');
    }
  }

  // Cargar moneda seleccionada
  static Future<void> _loadSelectedCurrency() async {
    final prefs = await SharedPreferences.getInstance();
    final currencyCode = prefs.getString(_selectedCurrencyKey);

    if (currencyCode != null && _currenciesCache.containsKey(currencyCode)) {
      _selectedCurrency = _currenciesCache[currencyCode];
      debugPrint('✅ Loaded selected currency: $currencyCode');
      return;
    }

    // Si no hay moneda guardada, detectar por país
    await detectAndSetCurrencyByCountry();
  }

  static Future<Currency> getSelectedCurrency() async {
    if (_selectedCurrency != null) {
      return _selectedCurrency!;
    }

    await _loadSelectedCurrency();
    return _selectedCurrency ?? _getDefaultCurrency();
  }

  static Currency _getDefaultCurrency() {
    // Buscar la moneda por defecto en el cache
    final defaultCurrency = _currenciesCache.values
        .firstWhere((c) => c.isDefault, orElse: () => _currenciesCache['USD']!);
    return defaultCurrency;
  }

  static Future<Currency> detectAndSetCurrencyByCountry() async {
    final prefs = await SharedPreferences.getInstance();

    try {
      // Intentar detectar país por zona horaria o locale
      final String? detectedCountry = await _detectCountryCode();

      if (detectedCountry != null) {
        await prefs.setString(_detectedCountryKey, detectedCountry);

        // Buscar moneda correspondiente
        if (countryToCurrency.containsKey(detectedCountry)) {
          final currencyCode = countryToCurrency[detectedCountry]!;
          if (_currenciesCache.containsKey(currencyCode)) {
            _selectedCurrency = _currenciesCache[currencyCode];
            await prefs.setString(_selectedCurrencyKey, currencyCode);
            debugPrint(
                '✅ Detected and set currency: $currencyCode for country: $detectedCountry');
            return _selectedCurrency!;
          }
        }
      }
    } catch (e) {
      debugPrint('Error detecting country: $e');
    }

    // Por defecto, usar USD
    _selectedCurrency = _getDefaultCurrency();
    await prefs.setString(_selectedCurrencyKey, _selectedCurrency!.code);
    return _selectedCurrency!;
  }

  static Future<String?> _detectCountryCode() async {
    try {
      // Opción 1: Usar el locale del sistema
      // En Flutter web, esto devolverá algo como 'es_CO', 'en_US', etc.
      final locale = WidgetsBinding.instance.platformDispatcher.locale;
      final countryCode = locale.countryCode;

      if (countryCode != null && countryCode.isNotEmpty) {
        return countryCode;
      }

      // Opción 2: Basado en zona horaria (menos preciso pero funciona)
      final timeZone = DateTime.now().timeZoneName;
      if (timeZone.contains('COT') || timeZone.contains('America/Bogota')) {
        return 'CO';
      }
      if (timeZone.contains('CST') || timeZone.contains('America/Mexico')) {
        return 'MX';
      }
      if (timeZone.contains('ART') || timeZone.contains('America/Argentina')) {
        return 'AR';
      }
      if (timeZone.contains('EST') || timeZone.contains('America/New_York')) {
        return 'US';
      }
      if (timeZone.contains('PST') ||
          timeZone.contains('America/Los_Angeles')) {
        return 'US';
      }
    } catch (e) {
      debugPrint('Error in country detection: $e');
    }

    return null;
  }

  static Future<void> setSelectedCurrency(String currencyCode) async {
    if (!_currenciesCache.containsKey(currencyCode)) {
      throw ArgumentError('Currency not supported: $currencyCode');
    }

    _selectedCurrency = _currenciesCache[currencyCode];
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_selectedCurrencyKey, currencyCode);
    debugPrint('✅ Currency changed to: $currencyCode');
  }

  // Obtener todas las monedas disponibles
  static Map<String, Currency> getSupportedCurrencies() {
    return Map.from(_currenciesCache);
  }

  // Formatear monto en la moneda seleccionada
  static String formatAmount(double amount, {Currency? currency}) {
    final curr = currency ?? _selectedCurrency ?? _getDefaultCurrency();
    return curr.format(amount);
  }

  // Convertir desde USD a moneda seleccionada y formatear
  static String formatFromUSD(double amountInUSD, {Currency? currency}) {
    final curr = currency ?? _selectedCurrency ?? _getDefaultCurrency();
    final converted = curr.convertFromUSD(amountInUSD);
    return curr.format(converted);
  }

  // Convertir desde USD a moneda seleccionada
  static double convertFromUSD(double amountInUSD, {Currency? currency}) {
    final curr = currency ?? _selectedCurrency ?? _getDefaultCurrency();
    return curr.convertFromUSD(amountInUSD);
  }

  // Convertir a USD desde moneda seleccionada
  static double convertToUSD(double amount, {Currency? currency}) {
    final curr = currency ?? _selectedCurrency ?? _getDefaultCurrency();
    return curr.convertToUSD(amount);
  }

  static String formatAmountWithCode(double amount, Currency currency) {
    return '${formatAmount(amount, currency: currency)} ${currency.code}';
  }
}

// Widget helper para mostrar selector de moneda
class CurrencySelector extends StatefulWidget {
  final Function(String) onCurrencyChanged;

  const CurrencySelector({
    super.key,
    required this.onCurrencyChanged,
  });

  @override
  State<CurrencySelector> createState() => _CurrencySelectorState();
}

class _CurrencySelectorState extends State<CurrencySelector> {
  Currency? _selectedCurrency;

  @override
  void initState() {
    super.initState();
    _loadCurrency();
  }

  Future<void> _loadCurrency() async {
    final currency = await CurrencyService.getSelectedCurrency();
    setState(() {
      _selectedCurrency = currency;
    });
  }

  // Obtener bandera del país basado en código de moneda
  String _getCurrencyFlag(String code) {
    const countryMap = {
      'USD': '🇺🇸',
      'COP': '🇨🇴',
      'MXN': '🇲🇽',
      'PEN': '🇵🇪',
      'ARS': '🇦🇷',
      'CLP': '🇨🇱',
      'BRL': '🇧🇷',
    };
    return countryMap[code] ?? '🌎';
  }

  @override
  Widget build(BuildContext context) {
    if (_selectedCurrency == null) {
      return const CircularProgressIndicator();
    }

    final currencies = CurrencyService.getSupportedCurrencies();

    return PopupMenuButton<String>(
      onSelected: (code) async {
        await CurrencyService.setSelectedCurrency(code);
        widget.onCurrencyChanged(code);
        await _loadCurrency();
      },
      itemBuilder: (context) {
        return currencies.entries.map((entry) {
          final currency = entry.value;
          return PopupMenuItem<String>(
            value: entry.key,
            child: Row(
              children: [
                Text(
                  _getCurrencyFlag(currency.code),
                  style: const TextStyle(fontSize: 24),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        currency.code,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text(
                        currency.name,
                        style:
                            const TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                    ],
                  ),
                ),
                Text(
                  currency.symbol,
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          );
        }).toList();
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade300),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              _getCurrencyFlag(_selectedCurrency!.code),
              style: const TextStyle(fontSize: 20),
            ),
            const SizedBox(width: 8),
            Text(
              _selectedCurrency!.code,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            const Icon(Icons.arrow_drop_down),
          ],
        ),
      ),
    );
  }
}
