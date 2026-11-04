import { defineConfig, devices } from '@playwright/test';

// Flutter web build (../build/web) ni mahalliy serverda ochib, telefon o'lchamida sinaydi.
// Oldin: flutter build web --release
export default defineConfig({
  testDir: './tests',
  timeout: 90_000,
  expect: { timeout: 30_000 },
  fullyParallel: false,
  retries: process.env.CI ? 1 : 0,
  reporter: process.env.CI ? [['github'], ['html', { open: 'never' }]] : [['list'], ['html', { open: 'never' }]],
  use: {
    baseURL: 'http://127.0.0.1:4173',
    trace: 'retain-on-failure',
    screenshot: 'only-on-failure',
  },
  projects: [
    // Telefon tili chexcha deb sinaymiz (boshqa tillar alohida testlarda).
    { name: 'mobile-chrome', use: { ...devices['Pixel 7'], locale: 'cs-CZ' } },
  ],
  webServer: {
    command: 'npx http-server ../build/web -p 4173 -a 127.0.0.1 -s -c-1',
    url: 'http://127.0.0.1:4173',
    reuseExistingServer: !process.env.CI,
    timeout: 60_000,
  },
});
