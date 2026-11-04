import { test, expect, Page } from '@playwright/test';

// Flutter web ekranni canvas'da chizadi. Ilova vebda "semantics" (accessibility) daraxtini
// yoqadi (lib/main.dart), shuning uchun Playwright matn va tugmalarni topa oladi.

async function openApp(page: Page) {
  await page.goto('/');
  // Birinchi ochilish: til tanlash ekrani (standart til — o'zbekcha).
  await expect(page.getByText('Tilni tanlang', { exact: true })).toBeVisible({ timeout: 60_000 });
}

async function chooseLanguage(page: Page, language: string, continueLabel: string) {
  await page.getByText(language, { exact: true }).click();
  await page.getByRole('button', { name: continueLabel }).click();
}

test('birinchi ochilishda til tanlanadi va bosh sahifa chiqadi', async ({ page }) => {
  await openApp(page);
  await page.getByText('English', { exact: true }).click();
  // Matnlar tanlangan tilga darhol o'tadi.
  await expect(page.getByText('Choose your language', { exact: true })).toBeVisible();
  await page.getByRole('button', { name: 'Continue' }).click();
  await expect(page.getByText('Which exam are we preparing for?')).toBeVisible();
  await expect(page.getByText('České reálie').first()).toBeVisible();
});

test('chex tilidagi interfeys', async ({ page }) => {
  await openApp(page);
  await chooseLanguage(page, 'Čeština', 'Pokračovat');
  await expect(page.getByText('Vítejte', { exact: true })).toBeVisible();
  await expect(page.getByText('Na jakou zkoušku se připravujeme?')).toBeVisible();
});

test("tanlangan til qayta ochilganda saqlanib qoladi", async ({ page }) => {
  await openApp(page);
  await chooseLanguage(page, 'English', 'Continue');
  await expect(page.getByText('Which exam are we preparing for?')).toBeVisible();
  await page.reload();
  await expect(page.getByText('Which exam are we preparing for?')).toBeVisible({ timeout: 60_000 });
});

test('České reálie testi ochiladi', async ({ page }) => {
  await openApp(page);
  await chooseLanguage(page, 'English', 'Continue');
  await page.getByText('České reálie').first().click();
  // Javob tanlanmaguncha "Check" tugmasi bor (o'chirilgan holatda).
  await expect(page.getByRole('button', { name: 'Check' })).toBeVisible();
  await expect(page.getByText(/1 \/ \d+/)).toBeVisible();
});

test('sozlamalar ochiladi', async ({ page }) => {
  await openApp(page);
  await chooseLanguage(page, 'English', 'Continue');
  await page.getByText('Settings', { exact: true }).click();
  await expect(page.getByText('App language')).toBeVisible();
  await expect(page.getByText('About the app')).toBeVisible();
});

test("to'liq versiya ekrani ochiladi", async ({ page }) => {
  await openApp(page);
  await chooseLanguage(page, 'English', 'Continue');
  await page.getByText('Unlock the full version').click();
  await expect(page.getByText('Prepare fully for your exam')).toBeVisible();
});
