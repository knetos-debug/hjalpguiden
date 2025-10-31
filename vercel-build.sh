#!/usr/bin/env bash
set -euo pipefail

# 1) Hämta Flutter (stable)
git clone https://github.com/flutter/flutter.git -b stable --depth 1
export PATH="$PWD/flutter/bin:$PATH"

# 2) Bygg Flutter Web
flutter --version
flutter pub get
flutter build web --release --pwa-strategy=offline-first

# 3) (valfritt) lista utdata, så vi ser i loggen att build/web finns
ls -la build/web