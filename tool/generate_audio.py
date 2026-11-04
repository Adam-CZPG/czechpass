#!/usr/bin/env python3
"""Tinglash dialoglari uchun MP3 fayllarni Azure Neural TTS bilan yaratadi.

Ovozlar: ayol — cs-CZ-VlastaNeural, erkak — cs-CZ-AntoninNeural (jinsi a2_listening.json'dagi
"speakers" maydonidan olinadi). Faqat matni o'zgargan topshiriqlar qayta yaratiladi
(manifest.json'dagi sha256 xesh bo'yicha), shuning uchun bepul limit tejaladi.

Kalit faqat muhit o'zgaruvchilaridan olinadi (GitHub Secrets):
  AZURE_SPEECH_KEY, AZURE_SPEECH_REGION
"""
import hashlib
import json
import os
import sys
import time
import urllib.error
import urllib.request
from pathlib import Path
from xml.sax.saxutils import escape

ROOT = Path(__file__).resolve().parent.parent
SOURCE = ROOT / 'assets' / 'questions' / 'a2_listening.json'
OUT = ROOT / 'assets' / 'audio' / 'listening'
MANIFEST = OUT / 'manifest.json'

VOICES = {'f': 'cs-CZ-VlastaNeural', 'm': 'cs-CZ-AntoninNeural'}
# Har bir ovozning tabiiy tezligi har xil: Vlasta o'zi sekinroq gapiradi, shuning uchun
# deyarli tabiiy tezlikda; Antonín A2 darajasi uchun biroz sekinlashtiriladi.
RATES = {'f': '+4%', 'm': '-4%'}
PAUSE = '700ms'
FORMAT = 'audio-24khz-48kbitrate-mono-mp3'


def gender_of(task, speaker):
    return task.get('speakers', {}).get(speaker) or ('m' if speaker == 'B' else 'f')


def build_ssml(task):
    parts = []
    for line in task['lines']:
        gender = gender_of(task, line['speaker'])
        parts.append(
            f'<voice name="{VOICES[gender]}"><prosody rate="{RATES[gender]}">{escape(line["text"])}</prosody>'
            f'<break time="{PAUSE}"/></voice>'
        )
    return ('<speak version="1.0" xmlns="http://www.w3.org/2001/10/synthesis" xml:lang="cs-CZ">'
            + ''.join(parts) + '</speak>')


def synthesize(ssml, key, region):
    request = urllib.request.Request(
        f'https://{region}.tts.speech.microsoft.com/cognitiveservices/v1',
        data=ssml.encode('utf-8'),
        method='POST',
        headers={
            'Ocp-Apim-Subscription-Key': key,
            'Content-Type': 'application/ssml+xml',
            'X-Microsoft-OutputFormat': FORMAT,
            'User-Agent': 'czechpass-audio-generator',
        },
    )
    for attempt in range(4):
        try:
            with urllib.request.urlopen(request, timeout=60) as response:
                return response.read()
        except urllib.error.HTTPError as error:
            # 429 — bepul tarifda so'rovlar tezligi cheklangan: biroz kutib qayta urinamiz.
            if error.code == 429 and attempt < 3:
                time.sleep(5 * (attempt + 1))
                continue
            body = error.read().decode('utf-8', 'replace')[:300]
            raise SystemExit(f'Azure xatosi {error.code}: {body}')


def main():
    key = os.environ.get('AZURE_SPEECH_KEY', '').strip()
    region = os.environ.get('AZURE_SPEECH_REGION', '').strip()
    if not key or not region:
        raise SystemExit('AZURE_SPEECH_KEY va AZURE_SPEECH_REGION muhit o\'zgaruvchilari kerak')

    tasks = json.loads(SOURCE.read_text(encoding='utf-8'))['tasks']
    OUT.mkdir(parents=True, exist_ok=True)
    old = json.loads(MANIFEST.read_text(encoding='utf-8')) if MANIFEST.exists() else {}
    old_hashes = old.get('hashes', {})

    hashes, created, characters = {}, 0, 0
    for task in tasks:
        ssml = build_ssml(task)
        digest = hashlib.sha256(ssml.encode('utf-8')).hexdigest()
        target = OUT / f'{task["id"]}.mp3'
        hashes[task['id']] = digest
        if target.exists() and old_hashes.get(task['id']) == digest:
            continue
        target.write_bytes(synthesize(ssml, key, region))
        created += 1
        characters += sum(len(line['text']) for line in task['lines'])
        print(f'  ✓ {task["id"]}')
        time.sleep(1)

    # Bazadan o'chirilgan topshiriqlarning fayllarini olib tashlaymiz.
    for mp3 in OUT.glob('*.mp3'):
        if mp3.stem not in hashes:
            mp3.unlink()
            print(f'  − {mp3.name}')

    manifest = {'voices': VOICES, 'clips': sorted(hashes), 'hashes': hashes}
    MANIFEST.write_text(json.dumps(manifest, ensure_ascii=False, indent=1) + '\n', encoding='utf-8')
    print(f'Yaratildi: {created} ta fayl, taxminan {characters} belgi. Jami: {len(hashes)} ta.')


if __name__ == '__main__':
    sys.exit(main())
