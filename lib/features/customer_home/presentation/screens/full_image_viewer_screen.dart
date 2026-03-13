import 'package:flutter/material.dart';
import 'package:gymbook/features/home/presentation/widgets/full_image_viewer_args.dart';
import 'package:gymbook/features/home/presentation/widgets/full_image_viewer_screen_body.dart';

class FullImageViewerScreen extends StatelessWidget {
  final FullImageViewerArgs args;

  const FullImageViewerScreen({super.key, required this.args});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: FullImageViewerScreenBody(
        images: args.images,
        initialImage: args.initialImage,
      ),
    );
  }
}
