# Hjälpguiden - Myndighetstjänster på ditt språk

En Flutter-app som visar steg-för-steg guider för svenska myndighetstjänster på enkel svenska + hemspråk med text-to-speech.

## 🎯 Målgrupp

Vuxna med låg digital vana och svenska på A1-A2 nivå.

## ✨ Funktioner

- **Flerspråkigt stöd**: 10 språk (arabiska, somaliska, tigrinska, persiska, dari, ukrainska, ryska, turkiska, engelska, svenska)
- **Text-to-Speech**: Uppläsning av hemspråksraden för varje steg
- **Offline-stöd**: Guider fungerar offline efter första visning
- **Tillgänglig design**: Stora tryckytor (min 48×48 dp), hög kontrast, skärmläsarstöd
- **Integritetsfokus**: Inga personuppgifter, ingen spårning

## 📱 MVP-guider

1. **1177** - Logga in (samma/annan enhet)
2. **Kivra** - Aktivera & logga in, Läsa nytt brev
3. **Arbetsförmedlingen** - Ladda upp dokument/foto

## 🚀 Installation och körning

### Förutsättningar

- Flutter SDK 3.0+ ([installationsguide](https://docs.flutter.dev/get-started/install))
- Dart 3.0+
- Android Studio / Xcode (för mobil)
- Chrome (för web)

### Steg 1: Klona och installera

```bash
# Installera dependencies
flutter pub get

# Generera JSON-serialization kod
dart run build_runner build --delete-conflicting-outputs
```

### Steg 2: Skapa guide.g.dart (krävs)

Eftersom projektet använder `json_serializable`, måste du först generera kod:

```bash
dart run build_runner build
```

### Steg 3: Kör appen

**Android/iOS:**
```bash
flutter run
```

**Web (PWA):**
```bash
flutter run -d chrome
```

**Produktionsbygge:**
```bash
# Android
flutter build apk --release
# eller
flutter build appbundle --release

# iOS
flutter build ipa --release

# Web
flutter build web --release
```

## 📂 Projektstruktur

```
lib/
├── main.dart                    # Entry point
├── app.dart                     # App widget + routing
├── models/
│   └── guide.dart              # Data models (Guide, Step, etc.)
├── services/
│   ├── content_loader.dart     # Laddar och mergar JSON-innehåll
│   └── tts_service.dart        # Text-to-speech (lokal + moln-fallback)
├── providers/
│   └── providers.dart          # Riverpod state providers
├── features/
│   ├── language/
│   │   └── select_language_screen.dart
│   ├── home/
│   │   └── home_screen.dart
│   └── guides/
│       └── guide_view.dart
└── widgets/
    ├── step_card.dart          # Stegkort med två rader
    └── tts_button.dart         # TTS-kontroll

assets/content/
├── mvp-guides.json             # Basguider (svenska)
├── mvp-ar.json                 # Arabisk översättning
└── mvp-so.json                 # Somalisk översättning

test/
└── widget_test.dart            # Widget-tester

integration_test/
└── app_test.dart               # Integration-tester
```

## 📝 Lägga till nytt språk

### Steg 1: Skapa översättningsfil

Skapa `assets/content/mvp-XX.json` där XX är språkkoden:

```json
{
  "guides": [
    {
      "id": "1177-login-same",
      "module": "m1177",
      "title": "1177 – Logga in (samma enhet)",
      "prereq": [
        {
          "sv_enkel": "",
          "hs": "Din översättning här"
        }
      ],
      "steps": [
        {
          "sv_enkel": "",
          "hs": "Översättning av steget"
        }
      ],
      "troubleshoot": [],
      "sources": [],
      "lastVerified": null
    }
  ]
}
```

**Viktigt:** 
- Behåll samma `id` som i basfilen
- Lämna `sv_enkel` tom (kopieras från basen)
- Fyll endast i `hs` (hemspråk)

### Steg 2: Lägg till i språkväljaren

I `lib/features/language/select_language_screen.dart`:

```dart
static final List<LanguageOption> _languages = [
  // ... befintliga språk
  LanguageOption('xx', 'Endonym', 'Svenska namn', '🇫🇱'),
];
```

### Steg 3: Konfigurera TTS

I `lib/services/tts_service.dart`, lägg till i `_mapLangCode`:

```dart
String _mapLangCode(String code) {
  final map = {
    // ... befintliga
    'xx': 'xx-XX', // BCP 47 locale code
  };
  return map[code] ?? 'sv-SE';
}
```

### Steg 4: Testa

```bash
flutter run
# Välj ditt nya språk och kontrollera att översättningarna visas
```

## 📚 Lägga till ny guide

### Steg 1: Lägg till i mvp-guides.json

```json
{
  "id": "ny-guide-id",
  "module": "ModulNamn",
  "title": "Guidens titel",
  "prereq": [
    {
      "sv_enkel": "Förberedelse 1 på enkel svenska",
      "hs": "[HS]"
    }
  ],
  "steps": [
    {
      "sv_enkel": "Steg 1 text (max 9-12 ord, verb först)",
      "hs": "[HS]"
    }
  ],
  "troubleshoot": [
    {
      "sv_enkel": "Problem → Lösning",
      "hs": "[HS]",
      "stepIndex": 2
    }
  ],
  "sources": [
    {
      "label": "Källans namn",
      "url": "https://example.com"
    }
  ],
  "lastVerified": "2025-10-23"
}
```

### Steg 2: Översätt till alla språk

Lägg till samma guide-struktur i varje `mvp-XX.json` med översatta `hs`-värden.

### Steg 3: Lägg till modul-ikon (valfritt)

I `lib/features/home/home_screen.dart`, uppdatera:

```dart
IconData _getModuleIcon(Module module) {
  switch (module) {
    case Module.DinModul:
      return Icons.din_ikon;
    // ...
  }
}

Color _getModuleColor(Module module) {
  switch (module) {
    case Module.DinModul:
      return Colors.dinFarg;
    // ...
  }
}
```

## 🧪 Testning

### Widget-tester

```bash
flutter test
```

Testar:
- Språkval visas vid start
- GuideView renderar två rader per steg
- TTS-knapp är synlig
- Tillgänglighet (touch targets, semantics)

### Integration-tester

```bash
flutter test integration_test
```

Testar:
- Fullständigt användarflöde
- Språkbyte
- Offline-beteende
- Scrollning och prestanda

### Lighthouse (PWA)

```bash
# Bygg web-version
flutter build web --release

# Servera lokalt
cd build/web
python3 -m http.server 8000

# Öppna Chrome DevTools > Lighthouse
# Kör audit för PWA, Accessibility, Performance
```

**Målvärden:**
- PWA: 100
- Accessibility: 95+
- Performance: 90+

## 🌐 PWA-konfiguration

### Service Worker

Flutter genererar automatiskt service worker. För att uppdatera cache:

1. Ändra innehåll i `assets/content/`
2. Bumpa version i `pubspec.yaml`
3. Bygg om: `flutter build web --release`

### Offline-stöd

**Mobil:** JSON packas i assets, fungerar offline automatiskt.

**Web PWA:** 
- JSON-filer läggs i `web/` för att precachas
- Vid första besök cachas allt innehåll
- Fungerar offline därefter

### Deployment

**GitHub Pages / Netlify / Vercel:**

```bash
flutter build web --release --base-href /repo-name/
# Deploya build/web/
```

**Firebase Hosting:**

```bash
firebase init hosting
# Välj build/web som public directory
firebase deploy
```

## 🔒 Säkerhet & Integritet

- ✅ Ingen analytics
- ✅ Inga personuppgifter lagras
- ✅ Inga tredjeparts-trackers
- ✅ Moln-TTS (om implementerad) via proxy utan API-nycklar i klient

## 🎨 Tillgänglighet

- ✅ Stora tryckytor (min 48×48 dp)
- ✅ Hög kontrast (WCAG AA)
- ✅ Semantics för skärmläsare
- ✅ Logisk fokusordning
- ✅ Synlig fokusram

## 🔊 Text-to-Speech

### Lokal TTS

Använder plattformens inbyggda TTS-röster via `flutter_tts`.

### Moln-TTS (fallback)

För språk utan lokal röst (t.ex. tigrinska, somali):

1. **Sätt upp endpoint** (Azure Cognitive Services, Google Cloud TTS)
2. **Uppdatera** `_cloudTtsEndpoint` i `tts_service.dart`
3. **Implementera proxy** för att dölja API-nycklar
4. **Ljud cachas** lokalt för offline-användning

### Tigrinska (specialfall)

Initialt: förinspelade MP3 i `assets/audio/ti/`

```dart
// I tts_service.dart
if (langCode == 'ti') {
  await _playPrerecorded(text);
}
```

## 📊 Innehållsprocess

### 1. Källor

Använd endast officiella, publika källor:
- 1177.se
- Kivra.se/support
- Arbetsformedlingen.se
- Skatteverket.se
- Forsakringskassan.se

### 2. Extrakt

Plocka ut korta, verifierbara texter från FAQ/guides.

### 3. A1-svenska

Skriv om till:
- Kommandon (verb först)
- Max 9-12 ord per steg
- Konkret, undvik abstrakt språk
- Nutid, aktiv form

### 4. Översättning

1. Maskinöversättning (Google Translate, DeepL)
2. Back-translation för kvalitetskontroll
3. Termbank för myndighetstermer
4. Mänsklig koll för riskkritiska språk

### 5. Metadata

```json
"sources": [{"label": "...", "url": "..."}],
"lastVerified": "YYYY-MM-DD"
```

### 6. Månadsvis kontroll

Snabb runda på källsidor → uppdatera `lastVerified`.

## 🚧 Backlog (efter MVP)

- [ ] Fler guider (Skatteverket, FK, E-post, Mobil, AI, Kommun)
- [ ] Skärmbilder med pilar
- [ ] Favoriter (lokal lagring)
- [ ] "Visa-upp-kort" i helskärm
- [ ] Sökfunktion
- [ ] Feedback-mekanism
- [ ] Offline-indikator

## 📄 Licens

[Din licens här]

## 🤝 Bidra

Välkommen att bidra med:
- Nya språköversättningar
- Fler guider
- Förbättringar av tillgänglighet
- Buggfixar

## 📞 Support

[Dina kontaktuppgifter här]

---

**Version:** 1.0.0  
**Senast uppdaterad:** 2025-10-23  
**Innehåll verifierat:** 2025-10-23