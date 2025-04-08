import 'package:flutter/material.dart';

void showCompactDialog(BuildContext context, String markPlace) {
  showDialog(
    context: context,
    barrierDismissible: true,
    builder: (BuildContext context) {
      return AlertDialog(
        titlePadding: EdgeInsets.symmetric(horizontal: 8, vertical: 8), // Minimize padding
        contentPadding: EdgeInsets.zero, // Remove padding for compactness
        title: Text(
          'Confirm $markPlace?',
          style: TextStyle(fontSize: 16), // Smaller font size for compact title
        ),
        content: SizedBox(
          width: 160, // Narrower width
          height: 40, // Shorter height
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop(); // Close the dialog
                },
                child: Text('Yes', style: TextStyle(fontSize: 14)), // Smaller font for button
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop(); // Close the dialog
                },
                child: Text('No', style: TextStyle(fontSize: 14)), // Smaller font for button
              ),
            ],
          ),
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8), // Slight border radius for style
        ),
      );
    },
  );
}
