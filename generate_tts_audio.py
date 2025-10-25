#!/usr/bin/env python3
"""
Script to generate TTS audio files for all guides and languages using Edge TTS.
This creates pre-generated MP3 files so the app can work 100% offline.
"""

import asyncio
import json
import os
from pathlib import Path
import edge_tts

# Map language codes to Edge TTS voice names
VOICE_MAP = {
    'ar': 'ar-SA-ZariyahNeural',      # Arabic (Saudi) - Female
    'so': 'so-SO-UbaxNeural',          # Somali - Female
    'fa': 'fa-IR-DilaraNeural',        # Persian - Female
    'prs': 'fa-IR-DilaraNeural',       # Dari (uses Persian voice) - Female
    'uk': 'uk-UA-PolinaNeural',        # Ukrainian - Female
    'ru': 'ru-RU-SvetlanaNeural',      # Russian - Female
    'tr': 'tr-TR-EmelNeural',          # Turkish - Female
    'en': 'en-US-JennyNeural',         # English - Female
    'sv': 'sv-SE-SofieNeural',         # Swedish - Female
    # Note: 'ti' (Tigrinya) is excluded - no TTS available
}

# Content directory
CONTENT_DIR = Path('assets/content')
AUDIO_DIR = Path('assets/audio')

async def generate_audio_file(text: str, voice: str, output_path: Path):
    """Generate a single audio file using Edge TTS."""
    try:
        # Create communicate object with slower speed for clarity
        communicate = edge_tts.Communicate(text, voice, rate='-20%')

        # Ensure directory exists
        output_path.parent.mkdir(parents=True, exist_ok=True)

        # Generate and save
        await communicate.save(str(output_path))
        print(f"✓ Generated: {output_path}")
        return True
    except Exception as e:
        print(f"✗ Error generating {output_path}: {e}")
        return False

async def process_language_file(lang_code: str, voice: str):
    """Process a single language file and generate all audio."""
    json_path = CONTENT_DIR / f'mvp-{lang_code}.json'

    if not json_path.exists():
        print(f"⚠ Skipping {lang_code}: File not found")
        return

    print(f"\n{'='*60}")
    print(f"Processing {lang_code.upper()} with voice: {voice}")
    print(f"{'='*60}")

    # Read JSON file
    with open(json_path, 'r', encoding='utf-8') as f:
        data = json.load(f)

    guides = data.get('guides', [])
    total_files = 0
    success_count = 0

    tasks = []

    for guide in guides:
        guide_id = guide.get('id')
        steps = guide.get('steps', [])

        for step_index, step in enumerate(steps):
            # Get the text from 'hs' field (home language)
            text = step.get('hs', '').strip()

            if not text:
                continue

            # Create output filename: [guide-id]-step-[number].mp3
            output_filename = f"{guide_id}-step-{step_index + 1}.mp3"
            output_path = AUDIO_DIR / lang_code / output_filename

            # Add to tasks list
            tasks.append((text, voice, output_path))
            total_files += 1

    print(f"Found {total_files} text segments to generate")

    # Process in batches to avoid overwhelming the system
    BATCH_SIZE = 5
    for i in range(0, len(tasks), BATCH_SIZE):
        batch = tasks[i:i + BATCH_SIZE]
        results = await asyncio.gather(
            *[generate_audio_file(text, voice, path) for text, voice, path in batch]
        )
        success_count += sum(results)

        # Small delay between batches to be nice to the service
        if i + BATCH_SIZE < len(tasks):
            await asyncio.sleep(0.5)

    print(f"\n{'='*60}")
    print(f"✓ {lang_code.upper()}: {success_count}/{total_files} files generated")
    print(f"{'='*60}\n")

async def main():
    """Main function to generate all TTS files."""
    print("\n" + "="*60)
    print("TTS Audio Generation Script")
    print("Generating pre-recorded audio for offline use")
    print("="*60)

    # Create base audio directory
    AUDIO_DIR.mkdir(exist_ok=True)

    # Process each language
    for lang_code, voice in VOICE_MAP.items():
        await process_language_file(lang_code, voice)

    print("\n" + "="*60)
    print("✓ All audio files generated successfully!")
    print(f"Audio files saved in: {AUDIO_DIR.absolute()}")
    print("="*60 + "\n")

if __name__ == '__main__':
    # Check if edge-tts is installed
    try:
        import edge_tts
    except ImportError:
        print("\n⚠ Error: edge-tts not installed")
        print("Please install it with: pip3 install edge-tts")
        print("\n")
        exit(1)

    # Run the async main function
    asyncio.run(main())
