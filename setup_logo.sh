#!/bin/bash

# Sudoku App Logo Setup Script
# This script helps set up the Sudoku logo as the app icon

echo "🎯 Sudoku App Logo Setup"
echo "========================"

# Check if logo file exists
if [ ! -f "assets/images/sudoku_logo.png" ]; then
    echo "❌ Logo file not found!"
    echo "📁 Please place your Sudoku logo as 'sudoku_logo.png' in the 'assets/images/' folder"
    echo "📏 Recommended size: 1024x1024 pixels"
    echo "🎨 Format: PNG with transparent background"
    echo ""
    echo "Once you've added the logo file, run this script again."
    exit 1
fi

echo "✅ Logo file found: assets/images/sudoku_logo.png"

# Install dependencies
echo "📦 Installing dependencies..."
flutter pub get

# Generate icons
echo "🎨 Generating app icons..."
flutter pub run flutter_launcher_icons:main

# Clean and rebuild
echo "🧹 Cleaning and rebuilding..."
flutter clean
flutter pub get

echo ""
echo "🎉 Logo setup complete!"
echo ""
echo "Next steps:"
echo "1. Build your app: flutter build apk (Android) or flutter build ios (iOS)"
echo "2. Install on your device to see the new logo"
echo "3. For web: flutter run -d chrome"
echo ""
echo "📱 Your Sudoku logo will now appear as the app icon on real devices!"
