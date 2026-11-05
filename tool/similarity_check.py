#!/usr/bin/env python3
"""O'zimizning savollarni rasmiy materiallar bilan solishtiradi (o'xshashlik bo'lmasligi uchun).

Rasmiy materiallarning o'zi repoga qo'yilmaydi. Ma'lumotnoma fayli alohida beriladi:
  python tool/similarity_check.py <rasmiy_fayl.txt> [savollar.json ...]

Ma'lumotnoma formati (har qatorda): mavzu | savol mazmuni (inglizcha) | to'g'ri javob
yoki rasmiy savollarning to'liq matni (har qatorda bitta savol).

Belgilanadi: (1) to'g'ri javob bir xil VA savol mazmuni o'xshash; (2) matn deyarli bir xil.
"""
import difflib
import json
import re
import sys
import unicodedata
from pathlib import Path

THRESHOLD = 0.15
STOP = set('the a an of in on to for and or is are was were which what who whom when where how many much '
           'does do did be by with from at as that this czech republic czechia mean called name'.split())


def fold(s):
    s = unicodedata.normalize('NFKD', s.lower())
    return ''.join(c for c in s if not unicodedata.combining(c))


def words(s):
    return {w for w in re.findall(r'[a-z0-9]+', fold(s)) if w not in STOP and len(w) > 2}


def same_answer(a, b):
    a, b = re.sub(r'[^a-z0-9]', '', fold(a)), re.sub(r'[^a-z0-9]', '', fold(b))
    if not a or not b:
        return False
    return a == b or (min(len(a), len(b)) >= 4 and (a in b or b in a))


def load_reference(path):
    rows = []
    for line in Path(path).read_text(encoding='utf-8').splitlines():
        if not line.strip() or line.startswith('#'):
            continue
        parts = [p.strip() for p in line.split('|')]
        if len(parts) >= 3:
            rows.append({'topic': parts[0], 'text': parts[1], 'answer': parts[2]})
        else:
            rows.append({'topic': '', 'text': line.strip(), 'answer': ''})
    return rows


def iter_questions(path):
    data = json.loads(Path(path).read_text(encoding='utf-8'))
    if 'questions' in data:
        for q in data['questions']:
            yield q['id'], q['question'], q['options'][q['correct']]
    for task in data.get('tasks', []):
        for q in task.get('questions', []):
            yield q['id'], q['question'], q['options'][q['correct']]
        if 'text' in task:
            yield task['id'], {'cs': task['text']}, ''


def main():
    if len(sys.argv) < 2:
        raise SystemExit(__doc__)
    ref = load_reference(sys.argv[1])
    files = sys.argv[2:] or ['assets/questions/realie.json']
    flagged = 0
    for f in files:
        for qid, text, answer in iter_questions(f):
            en = text.get('en', '')
            cs = text.get('cs', '')
            for r in ref:
                ratio = difflib.SequenceMatcher(None, fold(cs), fold(r['text'])).ratio() if cs else 0
                overlap = 0.0
                if en and r['text']:
                    a, b = words(en), words(r['text'])
                    overlap = len(a & b) / max(1, min(len(a), len(b)))
                if ratio >= 0.75 or (answer and r['answer'] and same_answer(answer, r['answer']) and overlap >= THRESHOLD):
                    flagged += 1
                    print(f'⚠ {qid}: «{cs}» → {answer}\n    rasmiy: {r["text"]} → {r["answer"]} (matn {ratio:.2f}, mazmun {overlap:.2f})')
    print(f'Belgilangan: {flagged}')
    return 1 if flagged else 0


if __name__ == '__main__':
    sys.exit(main())
