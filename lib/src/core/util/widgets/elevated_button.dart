import 'package:flutter/material.dart';

class CustomElevatedButton extends StatelessWidget {
  final void Function() onPressed;
  final String text;
  final void Function()? onLongPress;
  final Color? backgroundColor;
  const CustomElevatedButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.onLongPress,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      onLongPress: onLongPress,
      style: ButtonStyle(
        shape: WidgetStatePropertyAll(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        backgroundColor: WidgetStatePropertyAll(
            backgroundColor ?? Theme.of(context).primaryColor),
        elevation: const WidgetStatePropertyAll(0),
        minimumSize: const WidgetStatePropertyAll(Size(500, 45)),
        alignment: Alignment.center,
      ),
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: Theme.of(context).textTheme.titleMedium!.copyWith(
              fontWeight: FontWeight.w500,
              color: Colors.black,
            ),
      ),
    );
  }
}
