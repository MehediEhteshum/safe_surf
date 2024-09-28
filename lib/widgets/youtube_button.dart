import 'package:flutter/material.dart';

class YoutubeButton extends StatelessWidget {
  final String ytButtonLabel;
  final String ytRouteName;

  const YoutubeButton({
    super.key,
    required this.ytButtonLabel,
    required this.ytRouteName,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: () {
        Navigator.pushNamed(context, ytRouteName);
      },
      icon: const Icon(
        Icons.ondemand_video,
        color: Colors.white,
      ),
      label: Text(
        ytButtonLabel,
        style: const TextStyle(
          color: Colors.white,
        ),
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.red,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        textStyle: const TextStyle(fontSize: 18),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        splashFactory: InkRipple.splashFactory,
      ),
    );
  }
}
