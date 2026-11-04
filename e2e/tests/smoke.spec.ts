import { test, expect, Page, Locator } from '@playwright/test';

// Flutter web ekranni canvas'da chizadi. Ilova vebda accessibility (semantics) daraxtini
// yoqadi (lib/main.dart). Flutter matnni ba'zan DOM matni, ba'zan aria-label sifatida
// chiqaradi — shuning uchun ikkalasini ham qidiramiz.
function ui(page: Page, text: string | RegExp): Locator {
  return page.getByText(text).or(page.getByLabel(text)).first();
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
  await expect(ui(page, 'České reálie')).toBeVisible();
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
  await ui(page, 'České reálie').click();
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

test("to'liq versiya ekrani ochiladi", async ({ page }) => {
  await openApp(page);
  await chooseLanguage(page, 'English', 'Continue');
  await ui(page, 'Unlock the full version').click();
  await expect(ui(page, 'Prepare fully for your exam')).toBeVisible();
});
