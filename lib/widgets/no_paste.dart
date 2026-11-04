import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Matnni faqat qo'lda yozishga ruxsat beradigan cheklov (yozish bo'limi uchun).
///
/// Bir vaqtning o'zida [maxInsert] belgidan ko'p matn qo'shilsa (nusxa qo'yish,
/// klaviaturaning bufer taklifi, Ctrl+V), o'zgarish rad etiladi. Oddiy yozish,
/// klaviatura tavsiyalari va "swipe" bilan yozish bir so'zdan oshmaydi, shuning uchun ishlaydi.
class NoPasteFormatter extends TextInputFormatter {
  NoPasteFormatter({this.maxInsert = 20, this.onBlocked});

  final int maxInsert;
  final VoidCallback? onBlocked;

  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    final inserted = newValue.text.length - oldValue.text.length;
    if (inserted > maxInsert) {
      onBlocked?.call();
      return oldValue;
    }
    return newValue;
  }
}

/// Qo'lda yozish uchun matn maydoni: nusxa olish/qo'yish menyusi va belgilash o'chirilgan,
/// Ctrl+V / Cmd+V tugmalari ishlamaydi, katta matn qo'yish rad etiladi.
class ManualTextField extends StatelessWidget {
  const ManualTextField({
    super.key,
    required this.controller,
    required this.decoration,
    required this.onPasteBlocked,
    this.onChanged,
    this.minLines,
    this.maxLines,
  });

  final TextEditingController controller;
  final InputDecoration decoration;
  final VoidCallback onPasteBlocked;
  final ValueChanged<String>? onChanged;
  final int? minLines;
  final int? maxLines;

  @override
  Widget build(BuildContext context) {
    return Actions(
      actions: <Type, Action<Intent>>{
        PasteTextIntent: CallbackAction<PasteTextIntent>(onInvoke: (intent) {
          onPasteBlocked();
          return null;
        }),
      },
      child: TextField(
        controller: controller,
        minLines: minLines,
        maxLines: maxLines,
        keyboardType: TextInputType.multiline,
        // Belgilash, nusxa olish va qo'yish menyusi o'chiriladi.
        enableInteractiveSelection: false,
        contextMenuBuilder: null,
        inputFormatters: [NoPasteFormatter(onBlocked: onPasteBlocked)],
        onChanged: onChanged,
        decoration: decoration,
      ),
    );
  }
}
