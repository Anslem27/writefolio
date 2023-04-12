// ignore_for_file: library_private_types_in_public_api

// ignore: unused_import, implementation_imports
import "package:flutter/src/material/theme.dart" hide Theme;
import 'package:flutter/material.dart' hide Theme;
import 'package:google_fonts/google_fonts.dart';
import 'package:writefolio/editor/create_article.dart';
import 'package:writefolio/utils/theme/theme_model.dart';

class ThemePage extends StatefulWidget {
  const ThemePage({Key? key}) : super(key: key);

  @override
  _ThemePageState createState() => _ThemePageState();
}

class _ThemePageState extends State<ThemePage> {
  late String _selectedColorName;
  late Color _selectedColor;
  bool _isSelected = false;

  void _saveThemeToDatabase() {
    final theme = Theme(_selectedColorName, _selectedColor.value);
    themeBox.put('selected_theme', theme);
    logger.i(
        "theme color changed to $_selectedColorName and ${_selectedColor.value}");
  }

  @override
  void initState() {
    super.initState();

    // Load saved theme from the database
    final savedTheme = themeBox.get('selected_theme');
    if (savedTheme != null) {
      _selectedColorName = savedTheme.name;
      _selectedColor = Color(savedTheme.colorValue);
      _isSelected = true;
    } else {
      // Use default theme if no saved theme is found
      _selectedColorName = _colors.keys.first;
      _selectedColor = _colors.values.first;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Theme color'),
      ),
      body: ListView(
        physics: const ScrollPhysics(),
        shrinkWrap: true,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 500),
              curve: Curves.easeInOut,
              height:
                  _isSelected ? MediaQuery.of(context).size.height / 3.5 : 0,
              foregroundDecoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
              ),
              decoration: BoxDecoration(
                color: _selectedColor,
                borderRadius: BorderRadius.circular(
                  _isSelected ? 0 : 10,
                ),
              ),
              child: Align(
                alignment: Alignment.bottomRight,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    _selectedColorName,
                    style: GoogleFonts.roboto(
                      color: Colors.white,
                      fontSize: 24.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ),
          GridView.count(
            shrinkWrap: true,
            physics: const ScrollPhysics(),
            crossAxisCount: 3,
            padding: const EdgeInsets.all(50.0),
            children: _colors.entries
                .map(
                  (entry) => GestureDetector(
                    onTap: () {
                      try {
                        setState(() {
                          _selectedColorName = entry.key;
                          _selectedColor = entry.value;
                          _isSelected = true;
                          _saveThemeToDatabase();
                        });
                      } on Exception {
                        logger.e("Error putting to Box");
                      }
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        decoration: BoxDecoration(
                          color: entry.value,
                          borderRadius: BorderRadius.circular(16.0),
                        ),
                        child: _isSelected && _selectedColor == entry.value
                            ? const Center(
                                child: Icon(
                                  Icons.check_circle,
                                  size: 30.0,
                                  color: Colors.white,
                                ),
                              )
                            : const SizedBox(),
                      ),
                    ),
                  ),
                )
                .toList(),
          ),
        ],
      ),
    );
  }
}

final Map<String, Color> _colors = {
  'Pumpkin': const Color(0xFFFF7518),
  'Cinnamon': const Color(0xFFD2691E),
  'Olive': const Color(0xFF808000),
  'Teal': const Color(0xFF008080),
  'Midnight': const Color(0xFF1E90FF),
  'Lilac': const Color(0xFFC8A2C8),
  'Moss': const Color(0xFFADDFAD),
  'Steel': const Color(0xFF4682B4),
  'Salmon': const Color(0xFFFA8072),
  'Rose': const Color(0xFFFFC0CB),
  'Marigold': const Color(0xFFFFB347),
  'Cerulean': const Color(0xFF9BC4E2),
};
