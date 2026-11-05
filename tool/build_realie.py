#!/usr/bin/env python3
"""realie.json'ni yangilaydi: rasmiy bazadagi savollar bilan kesishgan eski savollarni olib tashlaydi
va tool/content/ ichidagi yangi savollarni qo'shadi. Takroriy id'lar va tuzilma tekshiriladi."""
import json
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent
sys.path.insert(0, str(ROOT / 'tool' / 'content'))
import realie_stat  # noqa: E402
import realie_geo_hist  # noqa: E402
import realie_hist2  # noqa: E402

PATH = ROOT / 'assets' / 'questions' / 'realie.json'
LANGS = {'cs', 'en', 'uz', 'ru', 'uk', 'vi'}

# Rasmiy NPI ČR savollari bilan bir xil faktni bir xil javob bilan so'raydigan eski savollar.
REMOVED = {
    'own-sta-002', 'own-sta-004', 'own-sta-006', 'own-sta-008', 'own-sta-009', 'own-sta-010', 'own-sta-011',
    'own-kul-002', 'own-kul-006', 'own-kul-007', 'own-kul-008', 'own-his-007', 'own-his-010', 'own-geo-006',
    # Rasmiy bazaning 25–30-mavzulari va to'liq PDF bilan solishtirilgandan keyin (2026-11-05).
    'own-his-001', 'own-his-002', 'own-his-003', 'own-his-004', 'own-his-005', 'own-his-006', 'own-his-008',
    'own-his-009', 'own-his-011', 'own-his-012', 'own-his-013', 'own-his-016', 'own-his-018', 'own-his-019',
    'own-his-020', 'own-his-023',
    'own-kul-003', 'own-kul-004', 'own-kul-005', 'own-kul-012', 'own-kul-013', 'own-kul-016', 'own-kul-018',
    'own-sta-051', 'own-sta-052',
}

# Javob variantlarini aniqlashtirish (savol qayta yozilganda).
OPTIONS = {
    'own-sta-001': ['Volí ho přímo občané', 'Volí ho Poslanecká sněmovna', 'Jmenuje ho vláda', 'Jmenuje ho Ústavní soud'],
}


def main():
    data = json.loads(PATH.read_text(encoding='utf-8'))
    kept = [q for q in data['questions'] if q['id'] not in REMOVED]
    new = realie_stat.QUESTIONS + realie_geo_hist.QUESTIONS + realie_hist2.QUESTIONS
    new = [q for q in new if q['id'] not in REMOVED]
    known = {q['id'] for q in kept}
    questions = kept + [q for q in new if q['id'] not in known]
    for q in questions:
        if q['id'] in realie_hist2.REWORD:
            q['question'] = realie_hist2.REWORD[q['id']]
        if q['id'] in OPTIONS:
            q['options'] = OPTIONS[q['id']]
            q['correct'] = 0

    ids = [q['id'] for q in questions]
    assert len(ids) == len(set(ids)), 'takroriy id'
    for q in questions:
        assert q['topic'] in data['topics'], q['id']
        assert set(q['question']) == LANGS, (q['id'], 'question')
        assert set(q['explanation']) == LANGS, (q['id'], 'explanation')
        assert len(q['options']) == 4 and len(set(q['options'])) == 4, (q['id'], 'options')
        assert 0 <= q['correct'] < 4
    # Savollarni mavzu bo'yicha tartiblaymiz (bepul versiya har mavzuning boshidagilarini ko'rsatadi).
    order = list(data['topics'])
    questions.sort(key=lambda q: (order.index(q['topic']), q['id']))
    data['questions'] = questions
    PATH.write_text(json.dumps(data, ensure_ascii=False, indent=1) + '\n', encoding='utf-8')
    counts = {t: sum(q['topic'] == t for q in questions) for t in order}
    print(f'Jami: {len(questions)} ta savol', counts)


if __name__ == '__main__':
    main()
