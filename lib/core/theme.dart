import "package:flutter/material.dart";

// Same text styles as the student application (Poppins and Inter)
const TextTheme ecoMindTextTheme = TextTheme(
  // Text of the large rounded buttons
  headlineSmall: TextStyle(
    fontFamily: 'Poppins',
    fontWeight: FontWeight.w700,
    fontSize: 24,
    height: 1.5,
    letterSpacing: -0.53,
  ),
  // Section titles and text links
  titleMedium: TextStyle(
    fontFamily: 'Poppins',
    fontWeight: FontWeight.w500,
    fontSize: 16,
  ),
  // Counters of the top bar
  titleSmall: TextStyle(
    fontFamily: 'Inter',
    fontWeight: FontWeight.w700,
    fontSize: 15,
    height: 1.5,
    letterSpacing: -0.33,
  ),
  // Text typed in the fields
  bodyLarge: TextStyle(
    fontFamily: 'Poppins',
    fontWeight: FontWeight.w400,
    fontSize: 16,
    height: 1.5,
  ),
  bodyMedium: TextStyle(
    fontFamily: 'Poppins',
    fontWeight: FontWeight.w500,
    fontSize: 13,
  ),
  bodySmall: TextStyle(
    fontFamily: 'Poppins',
    fontWeight: FontWeight.w500,
    fontSize: 12,
  ),
  // Text of the primary button
  labelLarge: TextStyle(
    fontFamily: 'Poppins',
    fontWeight: FontWeight.w400,
    fontSize: 16,
    height: 1.5,
    letterSpacing: -0.35,
  ),
  // Label above each field
  labelMedium: TextStyle(
    fontFamily: 'Poppins',
    fontWeight: FontWeight.w500,
    fontSize: 12,
  ),
  labelSmall: TextStyle(
    fontFamily: 'Poppins',
    fontWeight: FontWeight.w500,
    fontSize: 10,
  ),
);

class MaterialTheme {
  final TextTheme textTheme;

  const MaterialTheme(this.textTheme);

  static ColorScheme lightScheme() {
    return const ColorScheme(
      brightness: Brightness.light,
      primary: Color(0xff69a44e),
      surfaceTint: Color(0xff69a44e),
      onPrimary: Color(0xffffffff),
      primaryContainer: Color(0xffe5ffd8),
      onPrimaryContainer: Color(0xff3f662d),
      secondary: Color(0xff73806a),
      onSecondary: Color(0xffffffff),
      tertiary: Color(0xff23bee3),
      onTertiary: Color(0xffffffff),
      error: Color(0xffb43e2c),
      onError: Color(0xffffffff),
      errorContainer: Color(0xfffff2ed),
      onErrorContainer: Color(0xffa03524),
      surface: Color(0xffffffff),
      onSurface: Color(0xff262626),
      onSurfaceVariant: Color(0xff73806a),
      outline: Color(0xffd9e5cf),
      outlineVariant: Color(0xffe8ece4),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      surfaceContainerLowest: Color(0xffffffff),
      surfaceContainerLow: Color(0xfff7f9f4),
      surfaceContainer: Color(0xfff2f7ec),
      surfaceContainerHigh: Color(0xffefefef),
      surfaceContainerHighest: Color(0xffefefef),
    );
  }

  ThemeData light() {
    return theme(lightScheme());
  }

  static ColorScheme darkScheme() {
    return const ColorScheme(
      brightness: Brightness.dark,
      primary: Color(0xff69a44e),
      surfaceTint: Color(0xff69a44e),
      onPrimary: Color(0xffffffff),
      primaryContainer: Color(0xff22301e),
      onPrimaryContainer: Color(0xffe6ebe3),
      secondary: Color(0xffa9b5a1),
      onSecondary: Color(0xff121512),
      tertiary: Color(0xff23bee3),
      onTertiary: Color(0xff121512),
      error: Color(0xffff8a75),
      onError: Color(0xff121512),
      errorContainer: Color(0xff3a2521),
      onErrorContainer: Color(0xfff4b3a6),
      surface: Color(0xff121512),
      onSurface: Color(0xffe6ebe3),
      onSurfaceVariant: Color(0xffa9b5a1),
      outline: Color(0xff3e4b37),
      outlineVariant: Color(0xff343d31),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      surfaceContainerLowest: Color(0xff121512),
      surfaceContainerLow: Color(0xff1f261d),
      surfaceContainer: Color(0xff22301e),
      surfaceContainerHigh: Color(0xff1c211b),
      surfaceContainerHighest: Color(0xff262c24),
    );
  }

  ThemeData dark() {
    return theme(darkScheme());
  }

  ThemeData theme(ColorScheme colorScheme) => ThemeData(
    useMaterial3: true,
    brightness: colorScheme.brightness,
    colorScheme: colorScheme,
    fontFamily: 'Poppins',
    textTheme: textTheme.apply(
      bodyColor: colorScheme.onSurface,
      displayColor: colorScheme.onSurface,
    ),
    scaffoldBackgroundColor: colorScheme.surface,
    canvasColor: colorScheme.surface,
  );
}
