import 'package:flutter/material.dart';

/// This class mainly notifies changes in the theme
/// 
/// In order to work properly, screen dimensions should be provided
/// at the start of the app, use [setWidth] and [setHeight] to do so.
/// Use [setfontSizeScale] to change the generall proportions of the 
/// [fontSize], which is proportional to the [_screenWidth]
/// To change the current use [DataTheme] modify [getTheme].
// TODO: more documentation
abstract class ThemeNotifierInterface{
  Color _primaryColor;
  Color _secondaryColor;
  Color _thirdColor;
  Color _backgroundColor;
  ThemeData _themeData;
  double _screenWidth;
  double _screenHeight;
  double _fontSizeScale;

  ThemeNotifierInterface();

  getTheme();
  setTheme(ThemeData theme);

  getWidth();
  setWidth(double width);

  getHeight() => _screenHeight;
  setHeight(double height);

  getFontSizeScale() => _fontSizeScale;
  setFontSizeScale(double newSize){
    _fontSizeScale = newSize;
  }

  getPrimaryColor();
  setPrimaryColor(Color newColor);

  getSecondaryColor();
  setSecondaryColor(Color newColor);

  getThirdColor();
  setThirdColor(Color newColor);

  getBackgroundColor();
  setBackgroundColor(Color newColor);
}