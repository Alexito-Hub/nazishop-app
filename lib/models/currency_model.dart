class Currency {
  final String code;
  final String symbol;
  final String name;
  final double exchangeRate;
  final bool isDefault;

  Currency({
    required this.code,
    required this.symbol,
    required this.name,
    required this.exchangeRate,
    this.isDefault = false,
  });

  factory Currency.fromJson(Map<String, dynamic> json) {
    return Currency(
      code: json['code'] ?? 'USD',
      symbol: json['symbol'] ?? '\$',
      name: json['name'] ?? 'US Dollar',
      exchangeRate: (json['exchangeRate'] ?? 1.0).toDouble(),
      isDefault: json['isDefault'] ?? false,
    );
  }

  Map<String, dynamic> toJson() => {
        'code': code,
        'symbol': symbol,
        'name': name,
        'exchangeRate': exchangeRate,
        'isDefault': isDefault,
      };

  // Convert from USD to this currency
  double convertFromUSD(double amountInUSD) {
    return amountInUSD * exchangeRate;
  }

  // Convert from this currency to USD
  double convertToUSD(double amount) {
    return amount / exchangeRate;
  }

  // Format amount with currency symbol
  String format(double amount) {
    return '$symbol${amount.toStringAsFixed(2)}';
  }
}
