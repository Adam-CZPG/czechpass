import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:in_app_update/in_app_update.dart';

import 'package:czech_pass/l10n/strings.dart';

/// Ilova ochilganda Google Play'da yangi versiya bor-yo'qligini tekshiradi va
/// "Yangi versiya mavjud" oynasini ko'rsatadi. Yangilash eski versiya ustidan o'rnatiladi,
/// shuning uchun sozlamalar, progress va tugallanmagan mashg'ulotlar saqlanib qoladi.
///
/// Faqat Google Play'dan o'rnatilgan ilovada ishlaydi; APK qo'lda o'rnatilgan bo'lsa,
/// tekshiruv jimgina o'tkazib yuboriladi.
class AppUpdate {
  static bool _checked = false;

  static Future<void> check(GlobalKey<NavigatorState> navigator, String lang) async {
    if (_checked || kIsWeb || defaultTargetPlatform != TargetPlatform.android) return;
    _checked = true;
    try {
      final info = await InAppUpdate.checkForUpdate();
      if (info.updateAvailability != UpdateAvailability.updateAvailable) return;
      final context = navigator.currentContext;
      if (context == null || !context.mounted) return;
      final s = S(lang);
      final accepted = await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          icon: const Icon(Icons.system_update_outlined),
          title: Text(s.updateTitle),
          content: Text(s.updateText),
          actions: [
            TextButton(onPressed: () => Navigator.of(context).pop(false), child: Text(s.later)),
            FilledButton(onPressed: () => Navigator.of(context).pop(true), child: Text(s.updateNow)),
          ],
        ),
      );
      if (accepted != true) return;
      if (info.immediateUpdateAllowed) {
        await InAppUpdate.performImmediateUpdate();
      } else if (info.flexibleUpdateAllowed) {
        await InAppUpdate.startFlexibleUpdate();
        await InAppUpdate.completeFlexibleUpdate();
      }
    } catch (_) {
      // Google Play'siz o'rnatilgan yoki internet yo'q — hech narsa qilmaymiz.
    }
  }
}
