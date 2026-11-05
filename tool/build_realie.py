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

PATH = ROOT / 'assets' / 'questions' / 'realie.json'
LANGS = {'cs', 'en', 'uz', 'ru', 'uk', 'vi'}

# Rasmiy NPI ČR savollari bilan bir xil faktni bir xil javob bilan so'raydigan eski savollar.
REMOVED = {
    'own-sta-002', 'own-sta-004', 'own-sta-006', 'own-sta-008', 'own-sta-009', 'own-sta-010', 'own-sta-011',
    'own-kul-002', 'own-kul-006', 'own-kul-007', 'own-kul-008', 'own-his-007', 'own-his-010', 'own-geo-006',
}


def main():
    data = json.loads(PATH.read_text(encoding='utf-8'))
    kept = [q for q in data['questions'] if q['id'] not in REMOVED]
    new = realie_stat.QUESTIONS + realie_geo_hist.QUESTIONS
    known = {q['id'] for q in kept}
    questions = kept + [q for q in new if q['id'] not in known]

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
