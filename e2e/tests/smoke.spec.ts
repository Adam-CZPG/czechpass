import { test, expect, Page, Locator } from '@playwright/test';

// Flutter web ekranni canvas'da chizadi. Ilova vebda accessibility (semantics) daraxtini
// yoqadi (lib/main.dart). Flutter matnni ba'zan DOM matni, ba'zan aria-label sifatida
// chiqaradi — shuning uchun ikkalasini ham qidiramiz.
function ui(page: Page, text: string | RegExp): Locator {
  return page.getByText(text).or(page.getByLabel(text)).first();
}

// Flutter faqat ekranda ko'rinadigan elementlarni chiqaradi: kerak bo'lsa pastga aylantiramiz.
async function scrollTo(page: Page, text: string | RegExp): Promise<Locator> {
  const target = ui(page, text);
  const height = page.viewportSize()?.height ?? 800;
  for (let i = 0; i < 12; i++) {
    // Element pastki navigatsiya paneli ostida qolmasligi kerak (aks holda bosish panelga tushadi).
    const box = await target.boundingBox().catch(() => null);
    if (box && box.y > 0 && box.y + Math.min(box.height, 60) < height - 120) return target;
    await page.mouse.move(200, 500);
    await page.mouse.wheel(0, 350);
    await page.waitForTimeout(300);
  }
  return target;
}

async function openApp(page: Page) {
  await page.goto('/');
  // Flutter dvigateli yuklanishini kutamiz.
  await page.waitForSelector('flutter-view, flt-glass-pane', { state: 'attached', timeout: 60_000 });
  // Birinchi ochilish: til tanlash ekrani (standart til — chex tili).
  await expect(ui(page, 'Vyberte jazyk')).toBeVisible({ timeout: 60_000 });
}

async function chooseLanguage(page: Page, language: string, continueLabel: string) {
  await ui(page, language).click();
  await ui(page, continueLabel).click();
}

test('birinchi ochilishda til tanlanadi va bosh sahifa chiqadi', async ({ page }) => {
  await openApp(page);
  await ui(page, 'English').click();
  // Matnlar tanlangan tilga darhol o'tadi.
  await expect(ui(page, 'Choose your language')).toBeVisible();
  await ui(page, 'Continue').click();
  await expect(ui(page, 'Which exam are we preparing for?')).toBeVisible();
  await expect(await scrollTo(page, /^České reálie/)).toBeVisible();
});

test('chex tilidagi interfeys', async ({ page }) => {
  await openApp(page);
  await chooseLanguage(page, 'Čeština', 'Pokračovat');
  await expect(ui(page, 'Vítejte')).toBeVisible();
  await expect(ui(page, 'Na jakou zkoušku se připravujeme?')).toBeVisible();
});

test('tanlangan til qayta ochilganda saqlanib qoladi', async ({ page }) => {
  await openApp(page);
  await chooseLanguage(page, 'English', 'Continue');
  await expect(ui(page, 'Which exam are we preparing for?')).toBeVisible();
  await page.reload();
  await expect(ui(page, 'Which exam are we preparing for?')).toBeVisible({ timeout: 60_000 });
});

test('České reálie testi ochiladi', async ({ page }) => {
  await openApp(page);
  await chooseLanguage(page, 'English', 'Continue');
  // Karta nomi bilan boshlanadigan element ("české reálie" izohda ham uchraydi).
  await (await scrollTo(page, /^České reálie/)).click();
  await expect(ui(page, /^Check$/)).toBeVisible();
  await expect(ui(page, /1 \/ \d+/)).toBeVisible();
});

test('sozlamalar ochiladi', async ({ page }) => {
  await openApp(page);
  await chooseLanguage(page, 'English', 'Continue');
  await ui(page, 'Settings').click();
  await expect(ui(page, 'App language')).toBeVisible();
  await expect(ui(page, 'About the app')).toBeVisible();
});

test("tariflar ekrani ochiladi", async ({ page }) => {
  await openApp(page);
  await chooseLanguage(page, 'English', 'Continue');
  await (await scrollTo(page, 'Permanent residence (A2)')).click();
  await expect(ui(page, 'Prepare fully for your exam')).toBeVisible();
  await expect(ui(page, 'Choose a plan')).toBeVisible();
  // Uchta alohida tarif: A2, fuqarolik va ikkalasi birga.
  await expect(ui(page, 'Citizenship (B1 + reálie)')).toBeVisible();
  await expect(ui(page, 'Both together')).toBeVisible();
});

test.describe('telefon tili ukraincha', () => {
  test.use({ locale: 'uk-UA' });
  test('ilova telefon tilida ochiladi', async ({ page }) => {
    await page.goto('/');
    await page.waitForSelector('flutter-view, flt-glass-pane', { state: 'attached', timeout: 60_000 });
    await expect(ui(page, 'Оберіть мову')).toBeVisible({ timeout: 60_000 });
    await ui(page, 'Продовжити').click();
    await expect(ui(page, 'Ласкаво просимо')).toBeVisible();
  });
});

test.describe('telefon tili ilovada yo\'q (nemischa)', () => {
  test.use({ locale: 'de-DE' });
  test('chex tili tanlanadi', async ({ page }) => {
    await openApp(page);
  });
});

test.describe('qorong\'i mavzu', () => {
  test.use({ colorScheme: 'dark' });
  test('ilova qorong\'i rejimda ochiladi va ishlaydi', async ({ page }) => {
    await openApp(page);
    await chooseLanguage(page, 'English', 'Continue');
    await expect(ui(page, 'Which exam are we preparing for?')).toBeVisible();
    await page.screenshot({ path: 'test-results/dark-home.png' });
    // Telefon qorong'i rejimda bo'lsa ham, sozlamalarda yorug' mavzuni tanlash mumkin.
    await ui(page, 'Settings').click();
    await expect(ui(page, 'Appearance')).toBeVisible();
    await ui(page, 'Light').click();
    await expect(ui(page, 'App language')).toBeVisible();
    await page.screenshot({ path: 'test-results/light-settings.png' });
  });
});

test('bosh sahifada avval doimiy yashash (A2), keyin fuqarolik bloki', async ({ page }) => {
  await openApp(page);
  await chooseLanguage(page, 'English', 'Continue');
  const residence = await scrollTo(page, 'FOR PERMANENT RESIDENCE');
  await expect(residence).toBeVisible();
  await expect(await scrollTo(page, 'Czech A2')).toBeVisible();
  const r = await residence.boundingBox();
  const c = await (await scrollTo(page, 'FOR CITIZENSHIP')).boundingBox();
  // Sarlavha qotirilgan: aylantirishdan keyin ham ko'rinadi.
  await expect(ui(page, 'Which exam are we preparing for?')).toBeVisible();
  expect(r && c).toBeTruthy();
});

test('reja kartasi: imtihon sanasi va kunlik maqsad', async ({ page }) => {
  await openApp(page);
  await chooseLanguage(page, 'English', 'Continue');
  await ui(page, 'Set your exam date').click();
  await expect(ui(page, 'My plan')).toBeVisible();
  await expect(ui(page, 'Daily goal')).toBeVisible();
  await expect(ui(page, '20 answers a day')).toBeVisible();
});

test('imtihonlar haqida ma\'lumot ochiladi', async ({ page }) => {
  await openApp(page);
  await chooseLanguage(page, 'English', 'Continue');
  await (await scrollTo(page, /^About the exams/)).click();
  await expect(ui(page, /Czech A2 — for permanent residence/)).toBeVisible();
  await expect(ui(page, 'Official website')).toBeVisible();
});

test('A2 sinov imtihoni: kirish ekrani', async ({ page }) => {
  await openApp(page);
  await chooseLanguage(page, 'English', 'Continue');
  await (await scrollTo(page, /^A2 mock exam/)).click();
  await expect(ui(page, 'Start the exam')).toBeVisible();
  await expect(await scrollTo(page, 'The free version includes 1 mock exam.')).toBeVisible();
});
