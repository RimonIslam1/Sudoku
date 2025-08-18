# Sudoku App

A beautiful and challenging Sudoku game built with Flutter, featuring Material 3 design, multiple difficulty levels, and customizable themes.

## Features

### 🎮 Game Features
- **Multiple Difficulty Levels**: Easy, Medium, and Hard
- **Interactive 9x9 Grid**: Clean and intuitive Sudoku board
- **Smart Cell Selection**: Visual highlighting of rows, columns, and 3x3 boxes
- **Number Input**: Easy-to-use number pad for entering digits 1-9
- **Undo Functionality**: Step back through your moves
- **Game Completion Detection**: Automatic detection when puzzle is solved
- **Reset Game**: Start fresh with the same puzzle

### 🎨 UI/UX Features
- **Material 3 Design**: Modern, clean interface following Material Design principles
- **Dark/Light Mode**: Toggle between dark and light themes
- **Customizable Color Themes**: Choose from 8 different color schemes
- **Smooth Animations**: Elegant transitions and animations throughout the app
- **Responsive Design**: Works perfectly on different screen sizes

### 📱 App Flow
1. **Splash Screen**: Beautiful animated logo for 5 seconds
2. **Main Menu**: Choose between Difficulties and Settings
3. **Difficulty Selection**: Pick Easy, Medium, or Hard level
4. **Game Screen**: Interactive Sudoku gameplay
5. **Settings**: Customize app appearance and theme

## Technical Features

- **State Management**: Uses Provider pattern for clean state management
- **Flutter Best Practices**: Follows Flutter conventions and best practices
- **Clean Architecture**: Well-organized code structure
- **Responsive UI**: Adapts to different screen sizes
- **Performance Optimized**: Efficient rendering and state updates

## Getting Started

### Prerequisites
- Flutter SDK (>=3.0.0)
- Dart SDK
- Android Studio / VS Code
- Android Emulator or Physical Device

## Project Structure

```
lib/
├── main.dart                 # App entry point
├── providers/               # State management
│   ├── game_provider.dart   # Game logic and state
│   └── theme_provider.dart  # Theme and appearance state
├── screens/                 # App screens
│   ├── splash_screen.dart   # Splash screen
│   ├── main_menu_screen.dart # Main menu
│   ├── difficulties_screen.dart # Difficulty selection
│   ├── game_screen.dart     # Main game interface
│   └── settings_screen.dart # Settings and customization
└── widgets/                 # Reusable widgets
    ├── sudoku_grid.dart     # 9x9 Sudoku grid
    └── number_pad.dart      # Number input pad
```
## How to Play

1. **Select Difficulty**: Choose Easy, Medium, or Hard from the main menu
2. **Understand the Grid**: 
   - Bold numbers are pre-filled and cannot be changed
   - Empty cells can be filled with numbers 1-9
   - Each row, column, and 3x3 box must contain all digits 1-9 without repetition
3. **Make Moves**:
   - Tap on an empty cell to select it
   - Use the number pad to input a digit
   - Use the "Clear" button to remove a number
   - Use "Undo" to step back through your moves
4. **Complete the Puzzle**: Fill all cells correctly to win!
