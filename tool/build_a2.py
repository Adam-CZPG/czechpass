#!/usr/bin/env python3
"""A2 topshiriqlar fayllarini yangilaydi: tool/content/ dagi topshiriqlar bir xil id bo'lsa almashtiriladi,
yangilari qo'shiladi. Tuzilma va yozish namunalari (salomlashuv/xayrlashuv/uzunlik) tekshiriladi."""
import json
import re
import sys
import unicodedata
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent
sys.path.insert(0, str(ROOT / 'tool' / 'content'))
import a2_reading  # noqa: E402
import a2_listening  # noqa: E402
import a2_speaking_writing  # noqa: E402

LANGS = {'cs', 'en', 'uz', 'ru', 'uk', 'vi'}
GREETINGS = ['ahoj', 'dobry den', 'mily', 'mila', 'mili', 'vazen', 'zdravim', 'cau', 'dobry vecer']
CLOSINGS = ['s pozdravem', 'pozdravem', 'mej se', 'mejte se', 'ahoj', 'cau', 'dekuji', 'diky', 'zdravi', 'tvuj',
            'tvoje', 'na shledanou', 's diky']


def fold(s):
    return ''.join(c for c in unicodedata.normalize('NFKD', s.lower()) if not unicodedata.combining(c))


def check_questions(task):
    for q in task['questions']:
        assert set(q['question']) == LANGS, (task['id'], q['id'])
        assert len(q['options']) == 4 and len(set(q['options'])) == 4, (task['id'], q['id'])


def check(kind, task):
    assert set(task['title']) == LANGS, task['id']
    if kind in ('reading', 'listening'):
        check_questions(task)
    if kind == 'listening':
        for line in task['lines']:
            assert task['speakers'].get(line['speaker']) in ('f', 'm'), (task['id'], line)
    if kind in ('speaking', 'writing'):
        assert set(task['prompt']) == LANGS, task['id']
    if kind == 'speaking':
        model = fold(task['model'])
        assert all(fold(k) in model for k in task['keywords']), (task['id'], 'kalit so\'zlar namunada yo\'q')
    if kind == 'writing':
        for p in task['points']:
            assert set(p) == LANGS, task['id']
        model = fold(task['model'].strip())
        assert len(task['model'].split()) >= task['minWords'], (task['id'], 'namuna qisqa')
        assert any(g in model[:40] for g in GREETINGS), (task['id'], 'salomlashuv yo\'q')
        assert any(c in model[-80:] for c in CLOSINGS), (task['id'], 'xayrlashuv yo\'q')


def merge(kind, filename, new_tasks):
    path = ROOT / 'assets' / 'questions' / filename
    data = json.loads(path.read_text(encoding='utf-8'))
    by_id = {t['id']: t for t in data['tasks']}
    for t in new_tasks:
        by_id[t['id']] = t
    tasks = sorted(by_id.values(), key=lambda t: t['id'])
    for t in tasks:
        check(kind, t)
    data['tasks'] = tasks
    path.write_text(json.dumps(data, ensure_ascii=False, indent=1) + '\n', encoding='utf-8')
    print(f'{filename}: {len(tasks)} ta topshiriq')


def main():
    merge('reading', 'a2_reading.json', a2_reading.TASKS)
    merge('listening', 'a2_listening.json', a2_listening.TASKS)
    merge('speaking', 'a2_speaking.json', a2_speaking_writing.SPEAKING)
    merge('writing', 'a2_writing.json', a2_speaking_writing.WRITING)


if __name__ == '__main__':
    main()
