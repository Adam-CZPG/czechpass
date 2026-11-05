#!/usr/bin/env python3
"""České reálie savollarini ekspert tasdig'i uchun PDF'ga chiqaradi (chex tilida).
Foydalanish: python tool/make_review_pdf.py <chiqish.pdf>"""
import json
import sys
from datetime import date
from pathlib import Path
from xml.sax.saxutils import escape

from reportlab.lib import colors
from reportlab.lib.enums import TA_CENTER
from reportlab.lib.pagesizes import A4
from reportlab.lib.styles import ParagraphStyle
from reportlab.lib.units import mm
from reportlab.pdfbase import pdfmetrics
from reportlab.pdfbase.ttfonts import TTFont
from reportlab.platypus import KeepTogether, PageBreak, Paragraph, SimpleDocTemplate, Spacer, Table, TableStyle

ROOT = Path(__file__).resolve().parent.parent
sys.path.insert(0, str(ROOT / 'tool' / 'content'))
from realie_sources import SOURCES  # noqa: E402

FONT_DIR = Path('/usr/share/fonts/truetype/dejavu')
pdfmetrics.registerFont(TTFont('DV', str(FONT_DIR / 'DejaVuSans.ttf')))
pdfmetrics.registerFont(TTFont('DVB', str(FONT_DIR / 'DejaVuSans-Bold.ttf')))
pdfmetrics.registerFont(TTFont('DVI', str(FONT_DIR / 'DejaVuSans-Oblique.ttf')))
pdfmetrics.registerFontFamily('DV', normal='DV', bold='DVB', italic='DVI', boldItalic='DVB')

INK = colors.HexColor('#1f2937')
MUTED = colors.HexColor('#6b7280')
ACCENT = colors.HexColor('#1d4ed8')
LINE = colors.HexColor('#d1d5db')

base = ParagraphStyle('base', fontName='DV', fontSize=9.5, leading=13, textColor=INK)
small = ParagraphStyle('small', parent=base, fontSize=8.5, leading=11.5, textColor=MUTED)
qstyle = ParagraphStyle('q', parent=base, fontName='DVB', fontSize=10.5, leading=14)
h1 = ParagraphStyle('h1', parent=base, fontName='DVB', fontSize=20, leading=25, alignment=TA_CENTER, spaceAfter=6)
h2 = ParagraphStyle('h2', parent=base, fontName='DVB', fontSize=14, leading=18, textColor=ACCENT, spaceBefore=4, spaceAfter=8)
center = ParagraphStyle('center', parent=base, alignment=TA_CENTER)

TOPICS = {'stat': 'Stát, právo a každodenní život', 'geografie': 'Zeměpis', 'historie': 'Dějiny', 'kultura': 'Kultura'}
ORDER = ['stat', 'historie', 'geografie', 'kultura']


def footer(canvas, doc):
    canvas.saveState()
    canvas.setFont('DV', 8)
    canvas.setFillColor(MUTED)
    canvas.drawString(18 * mm, 10 * mm, 'CzechPass – otázky z českých reálií k odbornému posouzení')
    canvas.drawRightString(A4[0] - 18 * mm, 10 * mm, f'Strana {doc.page}')
    canvas.restoreState()


def question_block(n, q):
    letters = 'ABCD'
    rows = []
    for i, opt in enumerate(q['options']):
        ok = i == q['correct']
        text = f'<b>{letters[i]}) {escape(opt)}  ✓</b>' if ok else f'{letters[i]}) {escape(opt)}'
        rows.append(Paragraph(text, base))
    source = SOURCES.get(q['id'])
    src = f'<b>Zdroj:</b> {escape(source)}' if source else '<b>Zdroj:</b> <i>prosíme o ověření</i>'
    parts = [
        Paragraph(f'{n}. {escape(q["question"]["cs"])}', qstyle),
        Spacer(1, 3),
        *rows,
        Spacer(1, 3),
        Paragraph(f'<b>Vysvětlení:</b> {escape(q["explanation"]["cs"])}', small),
        Paragraph(src, small),
        Spacer(1, 4),
        Paragraph('Posouzení:  ☐ Správně     ☐ Opravit     Poznámka: ______________________________________________', small),
        Paragraph(f'<font size="7" color="#9ca3af">ID: {q["id"]}</font>', small),
    ]
    t = Table([[parts]], colWidths=[174 * mm])
    t.setStyle(TableStyle([
        ('BOX', (0, 0), (-1, -1), 0.6, LINE),
        ('LEFTPADDING', (0, 0), (-1, -1), 8), ('RIGHTPADDING', (0, 0), (-1, -1), 8),
        ('TOPPADDING', (0, 0), (-1, -1), 7), ('BOTTOMPADDING', (0, 0), (-1, -1), 7),
    ]))
    return KeepTogether([t, Spacer(1, 7)])


def main():
    out = sys.argv[1] if len(sys.argv) > 1 else 'czechpass_realie_review.pdf'
    data = json.loads((ROOT / 'assets' / 'questions' / 'realie.json').read_text(encoding='utf-8'))
    qs = data['questions']
    doc = SimpleDocTemplate(out, pagesize=A4, leftMargin=18 * mm, rightMargin=18 * mm, topMargin=16 * mm, bottomMargin=18 * mm,
                            title='CzechPass – otázky z českých reálií k posouzení', author='Ing. Akhmadjon Ortikov, Ph.D.')
    story = [
        Spacer(1, 40 * mm),
        Paragraph('CzechPass', h1),
        Paragraph('Cvičné otázky z českých reálií<br/>k odbornému posouzení', ParagraphStyle('sub', parent=h1, fontSize=15, leading=20, fontName='DV')),
        Spacer(1, 10 * mm),
        Paragraph(f'Počet otázek: {len(qs)}  ·  Verze: {date.today().strftime("%d. %m. %Y")}', center),
        Spacer(1, 4),
        Paragraph('Autor: Ing. Akhmadjon Ortikov, Ph.D.', center),
        Spacer(1, 18 * mm),
        Paragraph(
            'Tento dokument obsahuje cvičné otázky z mobilní aplikace CzechPass, která pomáhá cizincům v České republice '
            's přípravou na zkoušku z českých reálií. Všechny otázky jsme vytvořili sami; nejsou převzaty z databanky testových '
            'úloh NPI ČR a jejich znění jsme s databankou porovnali, aby se neopakovaly.', base),
        Spacer(1, 6),
        Paragraph(
            'Prosíme o kontrolu věcné správnosti každé otázky, správné odpovědi (označena ✓) a vysvětlení. U otázek z oblasti '
            'práva uvádíme právní předpis; u ostatních otázek prosíme o ověření. Opravy můžete zapsat přímo k otázce. Děkujeme.', base),
        PageBreak(),
    ]
    n = 0
    for topic in ORDER:
        items = [q for q in qs if q['topic'] == topic]
        story.append(Paragraph(f'{TOPICS[topic]} ({len(items)})', h2))
        for q in items:
            n += 1
            story.append(question_block(n, q))
    doc.build(story, onFirstPage=lambda c, d: None, onLaterPages=footer)
    print(out, n)


if __name__ == '__main__':
    main()
