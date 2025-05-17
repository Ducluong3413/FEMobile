import 'package:flutter/material.dart';

class HomeStrokeIcon extends StatelessWidget {
  const HomeStrokeIcon({super.key});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.sizeOf(context);
    debugPrint('Image path: assets/images/icon/IMG_1616.JPG');
    return Container(
      width: size.width / 1.5,
      padding: const EdgeInsets.all(20),
      margin: const EdgeInsets.only(bottom: 50),
      // child: Image.asset('assets/images/icon/IMG_1616.JPG', fit: BoxFit.cover),
      child: Image.asset('assets/images/icon/logo.png', fit: BoxFit.cover),
    );
  }
}
