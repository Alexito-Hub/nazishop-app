import 'package:flutter/material.dart';

class IconUtils {
  static IconData parseIcon(String? iconName) {
    if (iconName == null) return Icons.category_outlined;
    final lowerName = iconName.toLowerCase();

    final iconMap = {
      'movie': Icons.movie_outlined,
      'movies': Icons.movie_outlined,
      'music': Icons.music_note_outlined,
      'audio': Icons.headset_outlined,
      'sports': Icons.sports_soccer_outlined,
      'sport': Icons.sports_soccer_outlined,
      'games': Icons.games_outlined,
      'gaming': Icons.sports_esports_outlined,
      'vpn': Icons.vpn_key_outlined,
      'security': Icons.security_outlined,
      'cloud': Icons.cloud_outlined,
      'tv': Icons.tv_outlined,
      'iptv': Icons.live_tv_outlined,
      'play': Icons.play_circle_outline,
      'star': Icons.star_border,
      'shop': Icons.shopping_bag_outlined,
      'streaming': Icons.live_tv,
      'social': Icons.people_outline,
      'gift': Icons.card_giftcard,
      'play_arrow': Icons.play_arrow,
      'music_note': Icons.music_note,
      'sports_esports': Icons.sports_esports,
      'shopping_cart': Icons.shopping_cart,
      'build': Icons.build,
      'cloud_queue': Icons.cloud_queue,
    };

    if (iconMap.containsKey(lowerName)) {
      return iconMap[lowerName]!;
    }

    if (lowerName.contains('game')) return Icons.sports_esports_outlined;
    if (lowerName.contains('music')) return Icons.music_note_outlined;
    if (lowerName.contains('movie') || lowerName.contains('film')) {
      return Icons.movie_outlined;
    }
    if (lowerName.contains('tv') || lowerName.contains('stream')) {
      return Icons.tv_outlined;
    }

    return Icons.category_outlined;
  }
}
