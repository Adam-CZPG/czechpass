import 'package:flutter/material.dart';

import 'package:czech_pass/app/theme.dart';

/// Oq fonli, chegarali karta.
class AppCard extends StatelessWidget {
  const AppCard({super.key, required this.child, this.onTap, this.padding = const EdgeInsets.all(18)});

  final Widget child;
  final VoidCallback? onTap;
  final EdgeInsets padding;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
        side: const BorderSide(color: AppColors.border),
      ),
      child: InkWell(
        onTap: onTap,
        child: Padding(padding: padding, child: child),
      ),
    );
  }
}

/// Ekran tepasidagi qator: orqaga/yopish tugmasi va sarlavha.
class ScreenHeader extends StatelessWidget {
  const ScreenHeader({
    super.key,
    required this.title,
    required this.tooltip,
    this.icon = Icons.arrow_back,
    this.trailing,
  });

  final String title;
  final String tooltip;
  final IconData icon;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        IconButton.filledTonal(
          tooltip: tooltip,
          onPressed: () => Navigator.of(context).maybePop(),
          icon: Icon(icon),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            title,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
          ),
        ),
        ?trailing,
      ],
    );
  }
}

enum OptionState { idle, picked, correct, wrong }

/// Javob varianti (A, B, C, D).
class OptionTile extends StatelessWidget {
  const OptionTile({
    super.key,
    required this.letter,
    required this.text,
    required this.state,
    required this.onTap,
  });

  final String letter;
  final String text;
  final OptionState state;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final (Color background, Color border, Color badge, Color badgeText) = switch (state) {
      OptionState.idle => (Colors.white, AppColors.border, AppColors.surface, AppColors.ink),
      OptionState.picked => (AppColors.accentSoft, AppColors.accent, AppColors.accent, Colors.white),
      OptionState.correct => (AppColors.successSoft, AppColors.success, AppColors.success, Colors.white),
      OptionState.wrong => (AppColors.errorSoft, AppColors.error, AppColors.error, Colors.white),
    };

    return Semantics(
      inMutuallyExclusiveGroup: true,
      checked: state == OptionState.picked,
      button: true,
      child: Material(
        color: background,
        clipBehavior: Clip.antiAlias,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
          side: BorderSide(color: border, width: 2),
        ),
        child: InkWell(
          onTap: onTap,
          child: ConstrainedBox(
            constraints: const BoxConstraints(minHeight: 56),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              child: Row(
                children: [
                  Container(
                    width: 32,
                    height: 32,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(color: badge, borderRadius: BorderRadius.circular(9)),
                    child: Text(
                      letter,
                      style: TextStyle(fontSize: 14, fontWeight: FontWeight.w800, color: badgeText),
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Text(text, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Ingichka progress chizig'i.
class ProgressLine extends StatelessWidget {
  const ProgressLine({super.key, required this.value, this.height = 8, this.color = AppColors.accent});

  final double value;
  final double height;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(height / 2),
      child: LinearProgressIndicator(
        value: value,
        minHeight: height,
        backgroundColor: AppColors.border,
        color: color,
      ),
    );
  }
}

/// A, B, C, D harflari.
String optionLetter(int index) => String.fromCharCode(65 + index);

void showComingSoon(BuildContext context, String message) {
  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(SnackBar(content: Text(message)));
}
