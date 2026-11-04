# CzechPass: yangi kodni ochgandan keyin bir marta ishga tushiring.
# Ishga tushirish: powershell -ExecutionPolicy Bypass -File .\setup.ps1
# Skriptni qayta ishga tushirish xavfsiz: bor narsani ikkinchi marta qo'shmaydi.

Set-Location $PSScriptRoot

function Add-Once([string]$path, [string]$marker, [string]$anchor, [string]$insert, [string]$label) {
    if (-not (Test-Path $path)) { Write-Host "  - $label : file not found, skipped" -ForegroundColor Yellow; return }
    $full = (Resolve-Path $path).Path
    $text = [IO.File]::ReadAllText($full)
    if ($text.Contains($marker)) { Write-Host "  - $label : already present" -ForegroundColor Green; return }
    $i = $text.IndexOf($anchor)
    if ($i -lt 0) { Write-Host "  - $label : anchor not found, add manually" -ForegroundColor Red; return }
    $text = $text.Insert($i, $insert)
    [IO.File]::WriteAllText($full, $text)
    Write-Host "  - $label : added" -ForegroundColor Green
}

# 1. pubspec.yaml: savollar papkasi
Write-Host "[1/6] pubspec.yaml" -ForegroundColor Cyan
$pubspec = (Resolve-Path 'pubspec.yaml').Path
$text = [IO.File]::ReadAllText($pubspec)
if ($text -notmatch 'assets/questions/') {
    $text = $text.Replace("  uses-material-design: true", "  uses-material-design: true`n  assets:`n    - assets/questions/")
    [IO.File]::WriteAllText($pubspec, $text)
    Write-Host "  - assets : added" -ForegroundColor Green
} else {
    Write-Host "  - assets : already present" -ForegroundColor Green
}

# 2. Paketlar: telefonning o'z ovozi (TTS) va nutqni aniqlash (STT)
Write-Host "[2/6] packages" -ForegroundColor Cyan
flutter pub add shared_preferences flutter_tts speech_to_text

# 3. Android: mikrofon ruxsati va TTS/STT xizmatlarini ko'rish
Write-Host "[3/6] AndroidManifest.xml" -ForegroundColor Cyan
$androidBlock = @"
    <uses-permission android:name="android.permission.INTERNET"/>
    <uses-permission android:name="android.permission.RECORD_AUDIO"/>
    <queries>
        <intent>
            <action android:name="android.speech.RecognitionService" />
        </intent>
        <intent>
            <action android:name="android.intent.action.TTS_SERVICE" />
        </intent>
    </queries>

"@
Add-Once 'android\app\src\main\AndroidManifest.xml' 'android.permission.RECORD_AUDIO' '    <application' $androidBlock 'microphone + speech services'

# 4. iOS: mikrofon va nutqni aniqlash uchun izoh (keyinchalik iOS versiya uchun)
Write-Host "[4/6] Info.plist" -ForegroundColor Cyan
$iosBlock = @"
	<key>NSMicrophoneUsageDescription</key>
	<string>The microphone is used for Czech speaking practice.</string>
	<key>NSSpeechRecognitionUsageDescription</key>
	<string>Speech recognition turns your Czech answer into text.</string>

"@
Add-Once 'ios\Runner\Info.plist' 'NSMicrophoneUsageDescription' "</dict>`n</plist>" $iosBlock 'microphone description'

# 5. Kodni tekshirish
Write-Host "[5/6] flutter analyze" -ForegroundColor Cyan
flutter analyze

# 6. Testlar
Write-Host "[6/6] flutter test" -ForegroundColor Cyan
flutter test

Write-Host ""
Write-Host "Done. Run the app with: flutter run -d chrome" -ForegroundColor Green
