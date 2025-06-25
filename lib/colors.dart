import 'package:flutter/material.dart';

// --- V13 Soft, Playful & Dyslexia-Friendly LIGHT Palette ---
// This palette uses a gentle off-white background to reduce glare and high-contrast text.
// Accent colors are clear and friendly without being overly bright.

// Primary Brand & Background Colors
const Color primaryDark =
    Color(0xFFFFFFFF); // Cards and surfaces will be pure white.
const Color backgroundDark =
    Color(0xFFFBF9F3); // The main soft, off-white/cream background.
const Color accentBlue = Color(0xFF4A90E2); // A friendly, primary blue.
const Color accentYellow = Color(0xFFF5A623); // A warm, sunny orange/yellow.
const Color accentRed = Color(0xFFE94B3C); // A soft, clear red.
const Color accentGreen = Color(0xFF50E3C2); // A playful, minty green.

// Neutral & UI Colors
const Color lightText =
    Color(0xFF3D4A55); // A dark charcoal/slate for main text.
const Color mediumText = Color(0xFF7F8C9A); // A softer grey for secondary text.
const Color white =
    Color(0xFFFFFFFF); // Pure white, for text on colored buttons.
const Color errorRed = Color(0xFFE94B3C); // Reusing accent red.
const Color successGreen = Color(0xFF50E3C2); // Reusing accent green.

// --- Palettes for UI elements ---

// Gradient for the background (subtle off-white/cream gradient)
const LinearGradient backgroundGradient = LinearGradient(
  colors: [backgroundDark, Color(0xFFF7F4EC)],
  begin: Alignment.topCenter,
  end: Alignment.bottomCenter,
);

// Game Card Colors - a list of friendly, distinct colors
const List<Color> gameCardColors = [
  Color(0xFF4A90E2), // Blue
  Color(0xFFE94B3C), // Red
  Color(0xFF50E3C2), // Mint Green
  Color(0xFFF5A623), // Orange/Yellow
  Color(0xFF9013FE), // Purple
  Color(0xFFF8E71C), // Bright Yellow
];

// Dyslexia Word Colors for games like Sentence Builder
const List<Color> dyslexiaWordColors = [
  Color(0xFF4A90E2), // Blue
  Color(0xFFE94B3C), // Red
  Color(0xFF50E3C2), // Mint Green
  Color(0xFFF5A623), // Orange/Yellow
];

// Game Feedback Colors
const Color gameSuccessColor = accentGreen;
const Color gameFailColor = errorRed;
const Color gameNeutralColor = accentBlue;
