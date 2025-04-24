import 'package:block/src/features/video_call/presentation/pages/video_call_screen.dart';
import 'package:flutter/material.dart';

class BlockApp extends StatelessWidget {
  const BlockApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: VideoCallScreen(),
    );
  }
}
