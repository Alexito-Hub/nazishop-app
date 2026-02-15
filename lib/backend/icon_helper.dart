import 'package:flutter/material.dart';

class IconHelper {
  static const Map<int, IconData> _iconMap = {
    // Default / Common
    0xe3af: Icons.star_border, // Default fallback often used
    0xe838: Icons.star,
    0xe83a: Icons.star_half,
    0xe839: Icons.star_outline,

    // Streaming / Video
    0xe038: Icons.movie,
    0xe039: Icons.movie_creation,
    0xe04b: Icons.play_circle,
    0xe04c: Icons.play_circle_filled,
    0xe04d: Icons.play_circle_outline,
    0xe639: Icons.tv,
    0xe63b: Icons.live_tv,
    0xe63a: Icons.ondemand_video,
    0xe405: Icons.music_note,
    0xe310: Icons.headphones,

    // Social Media
    0xe8dc: Icons.thumb_up,
    0xe8db: Icons.thumb_up_alt,
    0xe87d: Icons.favorite,
    0xe87e: Icons.favorite_border,
    0xe7fb: Icons.people,
    0xe7fd: Icons.person,
    0xe80d: Icons.share,
    0xe3b0: Icons.camera_alt,
    0xe0b7: Icons.chat,
    0xe0c9: Icons.message,

    // Methods / Security / Education
    0xe32a: Icons.vpn_key,
    0xe897: Icons.lock,
    0xe898: Icons.lock_open,
    0xe32b: Icons.security,
    0xe80c: Icons.school,
    0xe865: Icons.book,
    0xe873: Icons.description,
    0xe227: Icons.attach_money,
    0xe850: Icons.credit_card,

    // General / Shop
    0xe8cc: Icons.shopping_cart,
    0xe8cb: Icons.shopping_bag,
    0xe8d1: Icons.store,
    0xe574: Icons.category,
    0xe54e: Icons.local_offer,
    0xe03e: Icons.new_releases,
    0xe88e: Icons.info,
    0xe88f: Icons.info_outline,
    0xe000: Icons.error,
    0xe001: Icons.error_outline,
    0xe5c9: Icons.cancel,
    0xe5ca: Icons.check,
    0xe5cb: Icons.check_circle,
    0xe5cc: Icons.check_circle_outline,
  };

  static IconData getIcon(int? code) {
    if (code == null) return Icons.category;
    return _iconMap[code] ?? Icons.category;
  }
}
