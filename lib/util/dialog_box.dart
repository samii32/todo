import 'package:flutter/material.dart';
import 'package:my_first_flutter/util/my_button.dart';
    
    class DialogBox extends StatelessWidget {
      MaterialColor _appBarColor = Colors.green;
      final controller;
      VoidCallback onSave;
      VoidCallback onCancel;

      DialogBox({
        super.key,
        required this.controller,
        required this.onSave,
        required this.onCancel,

      });

      MaterialColor createMaterialColor(Color color) {
        List strengths = <double>[.05];
        Map<int, Color> swatch = <int, Color>{};
        final int r = color.red, g = color.green, b = color.blue;

        for (int i = 1; i < 10; i++) {
          strengths.add(0.1 * i);
        }

        for (var strength in strengths) {
          final double ds = 0.5 - strength;
          swatch[(strength * 1000).round()] = Color.fromRGBO(
            r + ((ds < 0 ? r : (255 - r)) * ds).round(),
            g + ((ds < 0 ? g : (255 - g)) * ds).round(),
            b + ((ds < 0 ? b : (255 - b)) * ds).round(),
            1,
          );
        }

        return MaterialColor(color.value, swatch);
      }

      @override
      Widget build(BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          content: Container(
              height:120,
            child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
              // get user input
              TextField(
                controller: controller,
                decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.greenAccent,
                    )
                  ),
                hintText: "Add a new task",
                  hintStyle: TextStyle(color: Colors.greenAccent)

                ),
                style: TextStyle(color: Colors.black),
              ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                //save button
              MyButton(text: "Save", onPressed: onSave,
                isWhiteText: _appBarColor == createMaterialColor(Color(0xFF191b42)), // _appBarColor 값에 따라 텍스트 색상 설정
              ),
                const SizedBox(width: 8),
                //cancel button
              MyButton(text: "Cancel", onPressed: onCancel,
                isWhiteText: _appBarColor == createMaterialColor(Color(0xFF191b42)),) // _appBarColor 값에 따라 텍스트 색상 설정)
              ],
            )
              //buttons -> save + cancel

            ]),
            ),

        );
      }
    }
    