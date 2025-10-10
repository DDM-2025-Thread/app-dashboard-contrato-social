import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final Color? backgroundColor;
  final Color? textColor;
  final double? fontSize;
  final FontWeight? fontWeight;
  final double? width;
  final double? height;
  final double? borderRadius;
  final EdgeInsetsGeometry? padding;
  final bool isLoading;

  const CustomButton({
    Key? key,
    required this.text,
    required this.onPressed,
    this.backgroundColor,
    this.textColor = Colors.white,
    this.fontSize = 18,
    this.fontWeight = FontWeight.normal,
    this.width = double.infinity,
    this.height = 50,
    this.borderRadius = 10,
    this.padding,
    this.isLoading = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor ?? Colors.deepPurple.shade500,
          padding: padding,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius!),
          ),
          disabledBackgroundColor:
              backgroundColor?.withOpacity(0.6) ??
              Colors.deepPurple.shade500.withOpacity(0.6),
        ),
        child: isLoading
            ? SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(textColor!),
                ),
              )
            : Text(
                text,
                style: TextStyle(
                  fontSize: fontSize,
                  color: textColor,
                  fontWeight: fontWeight,
                ),
              ),
      ),
    );
  }
}
