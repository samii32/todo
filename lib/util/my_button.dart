import 'package:flutter/material.dart';

class MyButton extends StatelessWidget {
  final String text;
  final bool isWhiteText;
  VoidCallback onPressed;

  MyButton({
    Key? key,
    required this.text,
    required this.onPressed,
  this.isWhiteText = false, // 기본값은 false (검은색 텍스트)
  }): super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
        onPressed: onPressed,
        color: Theme.of(context).primaryColor,
        child: Text(text,
          style: TextStyle(
            color: isWhiteText
                ? Colors.white
                : Theme.of(context).primaryTextTheme.button?.color,
            // 텍스트 색상을 isWhiteText 값에 따라 흰색 또는 검은색으로 설정
        ),
        ),
        );
  }
}
