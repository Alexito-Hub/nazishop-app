class AppConfig {
  final SiteConfig site;
  final SupportConfig support;
  final AppVersionConfig app;

  AppConfig({required this.site, required this.support, required this.app});

  factory AppConfig.fromJson(Map<String, dynamic> json) {
    return AppConfig(
      site: SiteConfig.fromJson(json['site'] ?? {}),
      support: SupportConfig.fromJson(json['support'] ?? {}),
      app: AppVersionConfig.fromJson(json['app'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'site': site.toJson(),
      'support': support.toJson(),
      'app': app.toJson(),
    };
  }
}

class SiteConfig {
  String name;
  bool maintenanceMode;
  String announcementText;
  bool showAnnouncement;

  SiteConfig({
    required this.name,
    required this.maintenanceMode,
    required this.announcementText,
    required this.showAnnouncement,
  });

  factory SiteConfig.fromJson(Map<String, dynamic> json) {
    final ann = json['announcement'] ?? {};
    return SiteConfig(
      name: json['name'] ?? 'Nazi Shop',
      maintenanceMode: json['maintenanceMode'] ?? false,
      announcementText: ann['text'] ?? '',
      showAnnouncement: ann['show'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'maintenanceMode': maintenanceMode,
      'announcement': {
        'text': announcementText,
        'show': showAnnouncement,
      }
    };
  }
}

class SupportConfig {
  String email;
  String whatsapp;

  SupportConfig({required this.email, required this.whatsapp});

  factory SupportConfig.fromJson(Map<String, dynamic> json) {
    return SupportConfig(
      email: json['email'] ?? '',
      whatsapp: json['whatsapp'] ?? '',
    );
  }

  Map<String, dynamic> toJson() => {'email': email, 'whatsapp': whatsapp};
}

class AppVersionConfig {
  String minVersion;
  String latestVersion;

  AppVersionConfig({required this.minVersion, required this.latestVersion});

  factory AppVersionConfig.fromJson(Map<String, dynamic> json) {
    return AppVersionConfig(
      minVersion: json['minVersion'] ?? '1.0.0',
      latestVersion: json['latestVersion'] ?? '1.0.0',
    );
  }

  Map<String, dynamic> toJson() =>
      {'minVersion': minVersion, 'latestVersion': latestVersion};
}
