# TTS Audio Generation - Setup Guide

Detta script genererar alla TTS-ljudfiler i förväg så appen kan fungera 100% offline.

## 📋 Förberedelser

### 1. Installera Python 3
Om du inte har Python 3 installerat:
```bash
# Kolla om du har Python
python3 --version

# Om inte, installera via Homebrew (Mac)
brew install python3
```

### 2. Installera edge-tts
```bash
pip3 install edge-tts
```

## 🚀 Kör scriptet

```bash
cd /path/to/hjalpguiden
python3 generate_tts_audio.py
```

## ⏱️ Tidsåtgång

Scriptet kommer att:
- Läsa alla JSON-filer (9 språk)
- Generera ~100-150 MP3-filer per språk
- **Total tid: ~15-30 minuter** (beroende på internetuppkoppling)

## 📁 Resultat

Ljudfiler sparas i:
```
assets/audio/
├── ar/          # Arabiska
│   ├── mobil-wifi-step-1.mp3
│   ├── mobil-wifi-step-2.mp3
│   └── ...
├── so/          # Somaliska
│   └── ...
├── ru/          # Ryska
├── uk/          # Ukrainska
├── en/          # Engelska
├── tr/          # Turkiska
├── fa/          # Persiska
├── prs/         # Dari
└── sv/          # Svenska
```

## 📊 Filstorlek

- **Per fil:** ~20-50 KB
- **Total:** ~30-40 MB för alla språk

## ✅ Nästa steg

Efter att scriptet är klart:
1. Kolla att `assets/audio/` mappen innehåller filer
2. Jag uppdaterar `TtsService` att läsa från lokala filer
3. Bygg appen - den kommer nu fungera 100% offline!

## ⚠️ Felsökning

### "edge-tts not installed"
```bash
pip3 install edge-tts
```

### "No module named 'edge_tts'"
Prova:
```bash
python3 -m pip install edge-tts
```

### Timeout-fel
Om du får timeout-fel, kör scriptet igen - det hoppar över redan genererade filer.
