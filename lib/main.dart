import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(const FavColorApp());
}

class FavColorApp extends StatelessWidget {
  const FavColorApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return const SelectThemeColor(title: 'Favorite Color');
  }
}

class SelectThemeColor extends StatefulWidget {
  const SelectThemeColor({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<SelectThemeColor> createState() => _SelectThemeColorState();
}

class _SelectThemeColorState extends State<SelectThemeColor> {
  late String selectedColor;
  final Map<String, Color> _colorThemes = {
    "Blue": Colors.blue,
    "Purple": Colors.purple,
    "Pink": Colors.pink,
    "Teal": Colors.teal,
    "Orange": Colors.orange,
    "Yellow": Colors.yellow,
  };

  _SelectThemeColorState() {
    this.selectedColor = "Blue";
    _getStoredColor();
  }

  void _getStoredColor() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? storedColor = prefs.getString("themeColor");
    setState(() {
      selectedColor = storedColor ?? selectedColor;
    });
  }

  void setThemeColor(String color) async {
    // Save to local storage
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString("themeColor", color);

    // Save in state
    setState(() {
      selectedColor = color;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Favorite Color',
        theme: ThemeData(
          primarySwatch: (_colorThemes[selectedColor] as MaterialColor),
        ),
        home: ColorSelector(_colorThemes, setThemeColor));
  }
}

class ColorSelector extends StatelessWidget {
  final _colors;
  final void Function(String) handleSelect;

  const ColorSelector(@required this._colors, @required this.handleSelect);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Select your favourite colour:"),
        ),
        body: Center(
            child: Column(
          children: <Widget>[
            for (var entry in _colors.entries)
              Container(
                  width: double.infinity,
                  margin: const EdgeInsets.all(30),
                  child: ElevatedButton(
                      onPressed: () => handleSelect(entry.key),
                      child: Text(entry.key),
                      style: ElevatedButton.styleFrom(
                          primary: entry.value,
                          minimumSize: const Size(300, 60),
                          maximumSize: const Size(400, 70)))),
          ],
        )));
  }
}
