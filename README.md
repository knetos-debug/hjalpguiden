# Hjälpguiden

A mobile-first Flutter app that provides step-by-step guides for Swedish government e-services in simple Swedish and 9 other languages, with built-in text-to-speech functionality.

## 📱 About

Hjälpguiden (The Help Guide) is designed for adults with low digital literacy and limited Swedish language skills (A1-A2 level). The app helps users complete common tasks with Swedish government services like 1177, Kivra, Arbetsförmedlingen, and more.

### Key Features

- **Bilingual Display**: Each step shown in both simple Swedish and the user's home language
- **Text-to-Speech**: 912 pre-recorded MP3 files using Microsoft Edge TTS (high quality)
- **100% Offline**: Works completely offline after first download - no internet required
- **10 Languages**: Swedish, Arabic, Somali, Russian, Ukrainian, English, Turkish, Persian, Dari, Tigrinya
- **19 Guides**: Covering common e-services tasks (mobile basics, BankID, 1177, Kivra, AF, FK, Skatteverket, etc.)
- **Accessibility**: Large touch targets (48×48 dp), high contrast, screen reader support
- **No Tracking**: No personal data stored, no third-party trackers

## 🛠️ Tech Stack

- **Framework**: Flutter 3.8+
- **State Management**: Riverpod
- **Routing**: go_router
- **Audio**: just_audio + flutter_tts
- **Data**: JSON-based content with code generation
- **TTS**: Pre-generated MP3 files using Edge TTS (offline playback)

## 🚀 Getting Started

### Prerequisites

- Flutter SDK 3.8 or higher
- Dart SDK 3.0 or higher
- Android Studio / Xcode (for mobile development)
- Python 3 (for TTS generation script)

### Installation

1. Clone the repository:
```bash
git clone https://github.com/knetos-debug/hjalpguiden.git
cd hjalpguiden
```

2. Install dependencies:
```bash
flutter pub get
```

3. Generate JSON serialization code:
```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

4. Run the app:
```bash
flutter run
```

## 🔊 TTS Audio Files

The app includes 912 pre-generated MP3 files (~40 MB total) for offline text-to-speech functionality.

### Regenerating Audio Files

If you need to regenerate the TTS audio files:

1. Install edge-tts:
```bash
pip3 install edge-tts
```

2. Run the generation script:
```bash
python3 generate_tts_audio.py
```

This will generate all MP3 files in `assets/audio/` (takes ~15-30 minutes).

## 📦 Building for Production

### Android APK

```bash
flutter build apk --release
```

Output: `build/app/outputs/flutter-apk/app-release.apk`

### iOS

```bash
flutter build ios --release
```

Note: Requires Xcode and Apple Developer account for distribution.

## 📁 Project Structure

```
lib/
├── features/           # Feature-based modules
│   ├── home/          # Home screen with guide grid
│   ├── guides/        # Guide detail view
│   └── language/      # Language selection
├── models/            # Data models (Guide, LangLine, etc.)
├── providers/         # Riverpod providers
├── services/          # TTS service, content loading
├── widgets/           # Reusable widgets
└── main.dart          # App entry point

assets/
├── content/           # JSON guide files (19 guides × 10 languages)
└── audio/            # Pre-generated TTS MP3 files (912 files)
```

## 🌍 Supported Languages

| Language | Code | TTS Status |
|----------|------|------------|
| Swedish | sv | ✅ Base language |
| Arabic | ar | ✅ Edge TTS |
| Somali | so | ✅ Edge TTS |
| Russian | ru | ✅ Edge TTS |
| Ukrainian | uk | ✅ Edge TTS |
| English | en | ✅ Edge TTS |
| Turkish | tr | ✅ Edge TTS |
| Persian | fa | ✅ Edge TTS |
| Dari | prs | ✅ Edge TTS (uses Persian voice) |
| Tigrinya | ti | ❌ No TTS available |

## 📖 Available Guides

### Mobile Basics (3 guides)
- Connect to Wi-Fi
- Open links/QR codes
- Take screenshots

### Translation & AI (2 guides)
- Google Translate with camera
- Google Translate with voice

### Government Services (14 guides)
- BankID login (same/other device)
- 1177 login and messaging (3 guides)
- Kivra activation and reading letters (2 guides)
- Arbetsförmedlingen document upload
- Försäkringskassan login
- Skatteverket personal certificate
- Email login and file sending (2 guides)
- Emergency phrases (2 guides)

## 🎨 Future Enhancements

- [ ] Custom app icon and splash screen
- [ ] iOS TestFlight distribution
- [ ] Additional guides based on user feedback
- [ ] Tigrinya TTS (requires manual recording)
- [ ] Screenshots/illustrations in guides

## 👥 Target Audience

This app is designed for:
- Adults new to Sweden with low digital literacy
- Swedish language learners (A1-A2 level)
- Individuals who struggle with Swedish government e-services
- Users who need step-by-step guidance in their native language

## 📄 License

This project is intended for educational purposes. All content is based on publicly available information from official Swedish government sources.

## 🙏 Acknowledgments

- Swedish government e-services documentation
- Microsoft Edge TTS for high-quality neural voices
- The Flutter community for excellent packages and support

## 📞 Contact

Created by Kenneth Mellkvist as a free resource for students learning to navigate Swedish digital services.

---

**Note**: This app does not store any personal data, require login, or track users in any way. It's a simple, offline-first guide book.
