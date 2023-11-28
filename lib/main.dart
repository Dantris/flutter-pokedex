import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'screens/pokedex_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final ThemeData base = ThemeData.light();

    return MaterialApp(
      title: 'Pokedex App',
      theme: base.copyWith(
        primaryColor: Colors.blue,
        primaryColorDark: Colors.blue[700], // Adjust the shade if needed
        primaryColorLight: Colors.blue[300],
        // Adjust other theme elements as needed
        // For example, text themes, button themes, etc.
        textTheme: _buildTextTheme(base.textTheme), colorScheme: ColorScheme.fromSwatch().copyWith(secondary: Colors.teal),
      ),
      home: Scaffold(
        body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Colors.blue, Colors.teal], // Adjust colors as needed
            ),
          ),
          child: PokedexScreen(),
        ),
      ),
    );
  }

  // Define a custom text theme based on the base text theme
  TextTheme _buildTextTheme(TextTheme base) {
    return base.copyWith(
      // Adjust text styles like headline, body, subtitle, etc., as needed
      // For example:
      headline6: base.headline6!.copyWith(
        fontSize: 18.0,
        fontWeight: FontWeight.bold,
        color: Colors.white, // Text color based on the gradient
      ),
    );
  }
}
