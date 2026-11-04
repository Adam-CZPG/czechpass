#!/usr/bin/env bash
# CzechPass: oddiy xavfsizlik qoidalari. Biror qoida buzilsa, CI to'xtaydi.
set -u
fail=0
manifest="android/app/src/main/AndroidManifest.xml"

error() { echo "::error::$1"; fail=1; }
ok() { echo "OK: $1"; }

# 1. Shifrlanmagan HTTP trafigiga ruxsat berilmasin.
if grep -q 'usesCleartextTraffic="true"' "$manifest"; then
  error "AndroidManifest: usesCleartextTraffic=\"true\" bo'lmasligi kerak"
else
  ok "shifrlanmagan HTTP o'chirilgan"
fi

# 2. Release manifestda debuggable bo'lmasin.
if grep -q 'android:debuggable="true"' "$manifest"; then
  error "AndroidManifest: android:debuggable=\"true\" bo'lmasligi kerak"
else
  ok "debuggable yoqilmagan"
fi

# 3. Faqat kerakli ruxsatlar (yangi ruxsat qo'shilsa, shu ro'yxatni ataylab yangilash kerak).
allowed="android.permission.INTERNET android.permission.RECORD_AUDIO android.permission.POST_NOTIFICATIONS android.permission.RECEIVE_BOOT_COMPLETED"
for perm in $(grep -o 'android.permission\.[A-Z_]*' "$manifest" | sort -u); do
  case " $allowed " in
    *" $perm "*) ok "ruxsat: $perm" ;;
    *) error "kutilmagan ruxsat: $perm (kerak bo'lsa, tool/security_check.sh ga qo'shing)" ;;
  esac
done

# 4. Kodda http:// havolalar bo'lmasin (faqat https).
if grep -rn --include='*.dart' 'http://' lib; then
  error "lib/ ichida http:// havola bor — https ishlating"
else
  ok "kodda http:// havola yo'q"
fi

# 5. Imzo kalitlari va maxfiy fayllar repoga tushmasin.
leaked=$(git ls-files | grep -Ei '\.(jks|keystore|p12|pem)$|key\.properties$|google-services\.json$|\.env$' || true)
if [ -n "$leaked" ]; then
  error "maxfiy fayllar repoda: $leaked"
else
  ok "imzo kalitlari va .env repoda yo'q"
fi

# 6. Kodda API kalitiga o'xshash qatorlar bo'lmasin.
if grep -rnE --include='*.dart' '(AIza[0-9A-Za-z_-]{35}|sk-[A-Za-z0-9]{20,}|service_role)' lib; then
  error "lib/ ichida API kalitiga o'xshash qator topildi"
else
  ok "kodda API kaliti yo'q"
fi

exit $fail
