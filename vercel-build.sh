#!/usr/bin/env bash
set -euo pipefail

# 1) Hämta Flutter (stable)
git clone https://github.com/flutter/flutter.git -b stable --depth 1
export PATH="$PWD/flutter/bin:$PATH"

# 2) Bygg Flutter Web
flutter --version
flutter pub get
flutter build web --release --pwa-strategy=offline-first

# 3) Verifiera att assets finns
echo "=== Checking build/web directory ==="
ls -la build/web
echo "=== Checking assets directory ==="
ls -la build/web/assets/ || echo "No assets directory!"
echo "=== Checking audio directory ==="
ls -la build/web/assets/audio/ || echo "No audio directory!"
echo "=== Sample MP3 files ==="
find build/web/assets/audio/ -name "*.mp3" | head -5 || echo "No MP3 files found!"
