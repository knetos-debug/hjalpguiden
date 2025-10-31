# 🇸🇪 Hjälpguiden

> **Steg-för-steg-guider för svenska myndighetstjänster – på ditt språk**

En mobil-först Progressive Web App (PWA) byggd med Flutter som hjälper personer med låg digital vana att navigera svenska e-tjänster. Varje guide presenteras på enkel svenska tillsammans med användarens hemspråk, med uppläsning via förinspelade MP3-filer.

[![Deploy Status](https://img.shields.io/badge/Deployed%20on-Vercel-black?logo=vercel)](https://vercel.com)
[![Flutter](https://img.shields.io/badge/Flutter-3.8+-02569B?logo=flutter)](https://flutter.dev)
[![License](https://img.shields.io/badge/License-MIT-green.svg)](#)

---

## ✨ Features

- 🌍 **Flerspråksstöd** – Arabiska, Somaliska, Ryska, Ukrainska, Engelska, Farsi, Dari, Turkiska + Svenska
- 🔊 **Ljuduppläsning** – Förinspelade MP3-filer för varje steg på användarens hemspråk
- 📱 **Mobil-först design** – Optimerad för smartphones och surfplattor
- 🌐 **Fungerar offline** – Guider och ljudfiler cachas för användning utan internet
- ♿ **Tillgänglig** – Stora tryckytor, hög kontrast, skärmläsarstöd
- 🔒 **Integritetsfokuserad** – Ingen inloggning, inga personuppgifter, ingen spårning
- ⚡ **Progressive Web App** – Installeras direkt från webbläsaren, ingen app store behövs

---

## 📚 Tillgängliga guider

### 🏥 1177 Vårdguiden
- Logga in (samma enhet)
- Logga in (annan enhet)
- Läsa meddelande
- Boka tid

### 📨 Kivra
- Aktivera & logga in
- Läsa nytt brev

### 💼 Arbetsförmedlingen
- Logga in
- Ladda upp dokument/foto

### 🏛️ Skatteverket
- Logga in
- Hämta personbevis

### 🆔 BankID
- Logga in (samma enhet)
- Logga in (annan enhet)
- Byta säkerhetskod

### 📱 Mobilens grunder
- Ansluta till Wi-Fi
- Öppna länkar och QR-koder
- Ta skärmdumpar

### 🌐 Översättning & AI
- Google Översätt med kamera
- Google Översätt röst↔text

---

## 🛠️ Tech Stack

- **Frontend:** Flutter (Dart)
- **State Management:** Riverpod
- **Routing:** go_router
- **Audio Playback:** just_audio + förinspelade MP3-filer
- **Deployment:** Vercel
- **Build Tool:** Flutter Web (PWA)
- **Offline Support:** Service Workers + Cache API

---

## 🚀 Kom igång

### Förutsättningar

- Flutter SDK `>=3.8.0`
- Dart SDK
- Git

### Installation

```bash
# Klona repot
git clone https://github.com/knetos-debug/hjalpguiden.git
cd hjalpguiden

# Installera dependencies
flutter pub get

# Kör appen i utvecklingsläge
flutter run -d chrome
```

### Bygg för produktion

```bash
# Bygg Flutter Web PWA
flutter build web --release --pwa-strategy=offline-first

# Output hamnar i build/web/
```

---

## 📦 Deployment (Vercel)

Projektet är konfigurerat för automatisk deployment på Vercel via Git.

### Vercel Build Script

Se `vercel-build.sh` för build-konfiguration:

```bash
#!/usr/bin/env bash
set -euo pipefail

# 1) Hämta Flutter (stable)
git clone https://github.com/flutter/flutter.git -b stable --depth 1
export PATH="$PWD/flutter/bin:$PATH"

# 2) Bygg Flutter Web
flutter --version
flutter pub get
flutter build web --release --pwa-strategy=offline-first
```

### Vercel Configuration

Se `vercel.json` för routing och headers:

```json
{
  "headers": [
    {
      "source": "/assets/audio/(.*)",
      "headers": [
        {
          "key": "Content-Type",
          "value": "audio/mpeg"
        },
        {
          "key": "Cache-Control",
          "value": "public, max-age=31536000, immutable"
        }
      ]
    }
  ]
}
```

---

## 🎨 Projektstruktur

```
hjalpguiden/
├── assets/
│   ├── audio/           # Förinspelade MP3-filer (~900+ filer)
│   │   ├── ar/         # Arabiska
│   │   ├── en/         # Engelska
│   │   ├── fa/         # Farsi
│   │   ├── ru/         # Ryska
│   │   ├── so/         # Somaliska
│   │   ├── tr/         # Turkiska
│   │   └── uk/         # Ukrainska
│   └── content/        # Guide-innehåll (JSON)
├── lib/
│   ├── features/
│   │   ├── guides/     # Guide-vyer
│   │   ├── home/       # Hemskärm
│   │   └── language/   # Språkväljare
│   ├── models/         # Data models (Guide, Step, etc.)
│   ├── providers/      # Riverpod providers
│   ├── services/       # TTS service, content loader
│   └── widgets/        # Återanvändbara widgets
├── web/
│   ├── index.html
│   ├── manifest.json   # PWA manifest
│   └── icons/          # PWA ikoner
├── pubspec.yaml
├── vercel-build.sh     # Vercel build script
└── vercel.json         # Vercel konfiguration
```

---

## 🎯 Målgrupp & Design

### Personas

**Persona A:** Ny i Sverige, låg digital vana, saknar ibland BankID
**Persona B:** Har BankID, låg svenska, rädd att göra fel
**Persona C:** Klarar grunderna men fastnar på "ladda upp/foto/PDF"

### Designprinciper

- ✅ **Enkel svenska** (A1–A2 nivå)
- ✅ **Tvåradigt format** – Rad 1: Enkel svenska, Rad 2: Hemspråk
- ✅ **Verb först** – Maximalt 9–12 ord per instruktion
- ✅ **Stora tryckytor** – Minst 48×48 dp enligt WCAG
- ✅ **Hög kontrast** – För lättläst text
- ✅ **Konsekvent språk** – Samma termer genom hela appen

---

## 🔊 Audio System

### Hur det fungerar

1. **Förinspelade MP3-filer** – ~900+ ljudfiler genererade med TTS
2. **Språkspecifika mappar** – En fil per steg, per språk
3. **just_audio package** – Cross-platform audio playback
4. **iOS Safari unlock** – "Silent audio trick" för att kringgå autoplay-restriktioner
5. **Offline caching** – Alla ljudfiler cachas efter första laddningen

### Filnamnskonvention

```
assets/audio/{langCode}/{guideId}-step-{stepNumber}.mp3

Exempel:
assets/audio/ar/1177-login-other-step-1.mp3
assets/audio/ru/kivra-activate-step-3.mp3
```

### Web/PWA Audio Path Fix

På grund av hur Flutter kopierar assets till `build/web/`, serveras filerna från `/assets/assets/audio/` (dubbla "assets" prefix) i produktionsmiljön.

---

## 🌍 Språkstöd

| Språk | Kod | Status | Audio |
|-------|-----|--------|-------|
| Svenska | sv | ✅ Komplett | - |
| Arabiska | ar | ✅ Komplett | ✅ MP3 |
| Somaliska | so | ✅ Komplett | ✅ MP3 |
| Ryska | ru | ✅ Komplett | ✅ MP3 |
| Ukrainska | uk | ✅ Komplett | ✅ MP3 |
| Engelska | en | ✅ Komplett | ✅ MP3 |
| Farsi | fa | ⚠️ Delvis | ✅ MP3 |
| Dari | prs | ⚠️ Delvis | ✅ MP3 |
| Turkiska | tr | ⚠️ Delvis | ✅ MP3 |

---

## 🐛 Kända problem & lösningar

### Audio fungerar inte på iPhone/iOS Safari

**Problem:** iOS Safari blockerar audio utan user interaction.

**Lösning:** Implementerad "silent audio unlock" i `tts_service.dart`:
- Första klicket spelar en tyst ljudfil för att låsa upp audio context
- Efterföljande klick fungerar normalt

### Vercel serverar MP3 med fel Content-Type

**Problem:** MP3-filer serverades som `text/html`.

**Lösning:** Explicit Content-Type i `vercel.json`:
```json
{
  "source": "/assets/audio/(.*)",
  "headers": [
    { "key": "Content-Type", "value": "audio/mpeg" }
  ]
}
```

---

## 🤝 Bidra

Vi välkomnar bidrag! Här är några sätt du kan hjälpa till:

### Rapportera buggar
Öppna ett issue med:
- Beskrivning av problemet
- Steg för att återskapa
- Förväntad vs faktisk beteende
- Screenshots om möjligt

### Föreslå nya guider
Vi letar efter:
- Vanliga e-tjänster som saknas
- Myndighetsprocedurer som är svåra att förstå
- Feedback från målgruppen

### Förbättra översättningar
Om du är modersmålstalare för något av våra språk, hjälp oss granska och förbättra översättningar!

---

## 📄 Licens

Detta projekt är licensierat under MIT License.

---

## 🙏 Tack till

- **Flutter Team** – För ett fantastiskt framework
- **Vercel** – För enkel och snabb hosting
- **just_audio package** – För pålitlig cross-platform audio
- **Alla översättare och testare** som hjälper till att göra appen tillgänglig för fler

---

## 📞 Kontakt

För frågor eller feedback, öppna ett issue på GitHub.

---

<p align="center">
  Gjord med ❤️ för alla som behöver hjälp att navigera svenska myndighetstjänster
</p>
