import 'package:flutter/material.dart';
import 'package:safe_surf/utils/constants.dart';

class YoutubeButton extends StatelessWidget {
  const YoutubeButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: () {
        Navigator.pushNamed(context, ytWebRoute);
      },
      icon: const Icon(
        Icons.ondemand_video,
        color: Colors.white,
      ),
      label: const Text(
        'YouTube',
        style: TextStyle(
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
