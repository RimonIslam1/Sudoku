# Sudoku App Logo Setup Guide

## Overview
This guide will help you set up the Sudoku logo (blue neon-style grid with "SUDOKU" text) as your app icon for real devices.

## Step 1: Prepare Your Logo Image

1. **Save the Sudoku logo** as `sudoku_logo.png` in the `assets/images/` folder
2. **Recommended size**: At least 1024x1024 pixels for best quality
3. **Format**: PNG with transparent background (if possible)

## Step 2: Automated Setup (Recommended)

I've already configured the `flutter_launcher_icons` package in your `pubspec.yaml`. Follow these steps:

### 2.1 Install Dependencies
```bash
flutter pub get
```

### 2.2 Generate Icons
```bash
flutter pub run flutter_launcher_icons:main
```

This will automatically:
- Generate all required Android icon sizes
- Generate all required iOS icon sizes  
- Generate web icons (favicon, PWA icons)
- Update all configuration files

### 2.3 Clean and Rebuild
```bash
flutter clean
flutter pub get
flutter build apk  # for Android
flutter build ios  # for iOS
```

## Step 3: Manual Setup (Alternative)

If you prefer manual setup, here are the required files:

### Android Icons (in `android/app/src/main/res/`)
- `mipmap-mdpi/ic_launcher.png` (48x48px)
- `mipmap-hdpi/ic_launcher.png` (72x72px)
- `mipmap-xhdpi/ic_launcher.png` (96x96px)
- `mipmap-xxhdpi/ic_launcher.png` (144x144px)
- `mipmap-xxxhdpi/ic_launcher.png` (192x192px)

### iOS Icons (in `ios/Runner/Assets.xcassets/AppIcon.appiconset/`)
- `Icon-App-20x20@1x.png` (20x20px)
- `Icon-App-20x20@2x.png` (40x40px)
- `Icon-App-20x20@3x.png` (60x60px)
- `Icon-App-29x29@1x.png` (29x29px)
- `Icon-App-29x29@2x.png` (58x58px)
- `Icon-App-29x29@3x.png` (87x87px)
- `Icon-App-40x40@1x.png` (40x40px)
- `Icon-App-60x60@2x.png` (120x120px)
- `Icon-App-60x60@3x.png` (180x180px)
- `Icon-App-76x76@1x.png` (76x76px)
- `Icon-App-83.5x83.5@2x.png` (167x167px)
- `Icon-App-1024x1024@1x.png` (1024x1024px)

### Web Icons (in `web/`)
- `favicon.png` (32x32px)
- `icons/Icon-192.png` (192x192px)
- `icons/Icon-512.png` (512x512px)
- `icons/Icon-maskable-192.png` (192x192px)
- `icons/Icon-maskable-512.png` (512x512px)

## Step 4: Testing

1. **Android**: Install the APK on your device and check the app icon
2. **iOS**: Build and install on iOS device/simulator
3. **Web**: Open the web version and check the browser tab icon

## Troubleshooting

### If icons don't appear:
1. **Clean build**: `flutter clean && flutter pub get`
2. **Check file paths**: Ensure images are in correct locations
3. **Verify image format**: Use PNG format
4. **Check image size**: Ensure minimum required dimensions

### If automated generation fails:
1. **Check pubspec.yaml**: Verify flutter_launcher_icons configuration
2. **Manual setup**: Use the manual file replacement method
3. **Image quality**: Ensure source image is high resolution

## Logo Design Tips

For the best results with your Sudoku logo:
- **High contrast**: The blue neon effect should be clearly visible
- **Simple design**: Avoid too much detail for small icon sizes
- **Square format**: Icons are displayed in square containers
- **Test at small sizes**: Ensure readability at 20x20px

## Current Configuration

Your `pubspec.yaml` is already configured with:
- **Android**: Uses "launcher_icon" as the icon name
- **iOS**: Enabled for all device types
- **Web**: Configured with black background (#000000) and blue theme (#64B5F6)
- **Source**: `assets/images/sudoku_logo.png`

Just place your Sudoku logo file in the assets/images/ folder and run the generation command!
