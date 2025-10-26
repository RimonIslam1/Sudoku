# App Logo Setup Guide

## Overview
To set the Sudoku logo as your app icon, you need to replace the existing icon files in multiple locations for different platforms.

## Required Icon Sizes

### Android Icons (in `android/app/src/main/res/`)
Replace these files with your Sudoku logo:
- `mipmap-mdpi/ic_launcher.png` (48x48px)
- `mipmap-hdpi/ic_launcher.png` (72x72px)
- `mipmap-xhdpi/ic_launcher.png` (96x96px)
- `mipmap-xxhdpi/ic_launcher.png` (144x144px)
- `mipmap-xxxhdpi/ic_launcher.png` (192x192px)

### iOS Icons (in `ios/Runner/Assets.xcassets/AppIcon.appiconset/`)
Replace these files with your Sudoku logo:
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
Replace these files with your Sudoku logo:
- `favicon.png` (32x32px)
- `icons/Icon-192.png` (192x192px)
- `icons/Icon-512.png` (512x512px)
- `icons/Icon-maskable-192.png` (192x192px)
- `icons/Icon-maskable-512.png` (512x512px)

## Steps to Update Icons

1. **Prepare Your Logo**: Create your Sudoku logo in high resolution (at least 1024x1024px)

2. **Resize for Each Platform**: Use an image editor or online tool to create all required sizes

3. **Replace Files**: 
   - Copy the appropriately sized images to replace the existing icon files
   - Keep the same filenames
   - Ensure PNG format

4. **Clean and Rebuild**:
   ```bash
   flutter clean
   flutter pub get
   flutter build apk  # for Android
   flutter build ios   # for iOS
   ```

## Alternative: Using flutter_launcher_icons Package

You can also use the `flutter_launcher_icons` package to automate this process:

1. Add to `pubspec.yaml`:
```yaml
dev_dependencies:
  flutter_launcher_icons: ^0.13.1

flutter_launcher_icons:
  android: "launcher_icon"
  ios: true
  image_path: "assets/icon/icon.png"
  min_sdk_android: 21
  web:
    generate: true
    image_path: "assets/icon/icon.png"
    background_color: "#hexcode"
    theme_color: "#hexcode"
```

2. Place your logo as `assets/icon/icon.png`

3. Run:
```bash
flutter pub get
flutter pub run flutter_launcher_icons:main
```

## Notes
- Ensure your logo looks good at small sizes
- Consider using a simplified version for smaller icons
- Test on actual devices to ensure the icon displays correctly
- The icon should be square and work well on both light and dark backgrounds
