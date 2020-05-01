import 'package:flutter_project_template/view_models/notifiers/interfaces/ThemeNotifierInterface.dart';
import 'package:flutter/material.dart';

/// This class mainly notifies changes in the theme
/// 
/// In order to work properly, screen dimensions should be provided
/// at the start of the app, use [setWidth] and [setHeight] to do so.
/// Use [setfontSizeScale] to change the generall proportions of the 
/// [fontSize], which is proportional to the [_screenWidth]
/// To change the current use [DataTheme] modify [getTheme].
class ThemeNotifier extends ChangeNotifier implements ThemeNotifierInterface{
  // TODO: get colors from db
  Color _primaryColor = Color.fromARGB(255, 151, 41, 27);
  Color _secondaryColor = Color.fromARGB(255, 240, 76, 78);
  Color _thirdColor = Color.fromARGB(255, 96, 171, 171);
  Color _backgroundColor = Color.fromARGB(255, 238, 236, 236);
  ThemeData _themeData;
  double _screenWidth = 320;
  double _screenHeight = 569;
  double _fontSizeScale = 0.0028;

  ThemeNotifier();

  getTheme(){
    return ThemeData(
      primaryColor: _primaryColor,
      accentColor: _secondaryColor,
      fontFamily: 'Monserrat',

      

      textTheme: TextTheme(
        display1: TextStyle(
            color: Colors.black, 
            fontSize: 28.0 * _screenWidth * _fontSizeScale, 
            fontWeight: FontWeight.bold, 
            fontFamily: 'Monserrat'
        ),
        display2: TextStyle(
            color: Colors.black, 
            fontSize: 32.0 * _screenWidth * _fontSizeScale, 
            fontWeight: FontWeight.bold, 
            fontFamily: 'Monserrat'
        ),
        display3: TextStyle(
            color: Colors.black, 
            fontSize: 28.0 * _screenWidth * _fontSizeScale,
            fontWeight: FontWeight.bold, 
            fontFamily: 'Monserrat'
        ),
        headline: TextStyle(
            color: Colors.black, 
            fontSize: 32.0 * _screenWidth * _fontSizeScale, 
            fontWeight: FontWeight.bold, 
            fontFamily: 'Monserrat'
        ),
        display4: TextStyle(
            color: Colors.white, 
            fontSize: 16.0 * _screenWidth * _fontSizeScale, 
            fontFamily: 'Monserrat'
        ),
        title: TextStyle(
            color: Colors.white, 
            fontSize: 20.0 * _screenWidth * _fontSizeScale,
            fontWeight: FontWeight.bold, 
            fontFamily: 'Monserrat',
            fontStyle: FontStyle.italic
        ),
        subhead: TextStyle(
            color: Colors.black, 
            fontSize: 16.0 * _screenWidth * _fontSizeScale, 
            fontWeight: FontWeight.bold, 
            fontFamily: 'Monserrat'
        ),
        body1:
            TextStyle(color: Colors.black,
            fontSize: 14.0 * _screenWidth * _fontSizeScale,
            fontFamily: 'Monserrat'
        ),
        body2: TextStyle(
            color: _secondaryColor,
            fontSize: 16.0 * _screenWidth * _fontSizeScale,
            fontWeight: FontWeight.bold,
            fontFamily: 'Monserrat'
        ),
        overline: TextStyle(
            color: _thirdColor,
            fontSize: 16.0 * _screenWidth * _fontSizeScale,
            fontWeight: FontWeight.bold,
            fontFamily: 'Monserrat',
        ),
        caption: TextStyle(
            color: Colors.grey, 
            fontSize: 14.0 * _screenWidth * _fontSizeScale, 
            fontFamily: 'Monserrat'
        ),
        button: TextStyle(
            color: Colors.black, 
            fontSize: 14.0 * _screenWidth * _fontSizeScale, 
            fontFamily: 'Monserrat'
        ),
        subtitle: TextStyle(
          color: Colors.black, 
          fontSize: 14.0 * _screenWidth * _fontSizeScale, 
          fontFamily: 'Monserrat'
        ),
      ),
    
    );
  }
  setTheme(ThemeData theme){
    _themeData = theme;
    notifyListeners();
  }

  getWidth() => _screenWidth;
  setWidth(double width){
    print(width);
    _screenWidth = width;
    notifyListeners();
  }

  getHeight() => _screenHeight;
  setHeight(double height){
    _screenHeight = height;
    notifyListeners();
  }

  getFontSizeScale() => _fontSizeScale;
  setFontSizeScale(double newSize){
    _fontSizeScale = newSize;
    notifyListeners();
  }

  getPrimaryColor() => _primaryColor;
  setPrimaryColor(Color newColor){
    _primaryColor = newColor;
    notifyListeners();
  }

  getSecondaryColor() => _secondaryColor;
  setSecondaryColor(Color newColor){
    _secondaryColor = newColor;
    notifyListeners();
  }

  getThirdColor() => _thirdColor;
  setThirdColor(Color newColor){
    _thirdColor = newColor;
    notifyListeners();
  }

  getBackgroundColor() => _backgroundColor;
  setBackgroundColor(Color newColor){
    _backgroundColor = newColor;
    notifyListeners();
  }
}