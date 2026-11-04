import 'package:flutter/material.dart';

import 'package:czech_pass/app/theme.dart';
import 'package:czech_pass/core/question.dart';
import 'package:czech_pass/widgets/common.dart';

/// Matn yoki yozuvga oid bitta savol va uning variantlari (o'qish va tinglash uchun).
class QuestionBlock extends StatelessWidget {
  const QuestionBlock({
    super.key,
    required this.number,
    required this.question,
    required this.order,
    required this.picked,
    required this.checked,
    required this.lang,
    required this.showTranslation,
    required this.onPick,
  });

  final int number;
  final Question question;
  final List<int> order;
  final int? picked;
  final bool checked;
  final String lang;
  final bool showTranslation;
  final ValueChanged<int> onPick;

  OptionState _stateFor(int option) {
    if (checked) {
      if (option == question.correctIndex) return OptionState.correct;
      if (option == picked) return OptionState.wrong;
      return OptionState.idle;
    }
    return option == picked ? OptionState.picked : OptionState.idle;
  }

  @override
  Widget build(BuildContext context) {
    final translation = question.translation(lang);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          '$number. ${question.czech}',
          style: const TextStyle(fontSize: 17, height: 1.35, fontWeight: FontWeight.w800),
        ),
        if (translation != null && showTranslation) ...[
          const SizedBox(height: 4),
          Text(translation, style: const TextStyle(fontSize: 14, height: 1.4, color: AppColors.muted)),
        ],
        const SizedBox(height: 10),
        for (var i = 0; i < order.length; i++) ...[
          OptionTile(
            letter: optionLetter(i),
            text: question.options[order[i]],
            state: _stateFor(order[i]),
            onTap: checked ? null : () => onPick(order[i]),
          ),
          const SizedBox(height: 8),
        ],
      ],
    );
  }
}
