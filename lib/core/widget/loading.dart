import 'package:flutter/material.dart';
import '../../../../../core/const/assets.dart';

class LoadingWidget extends StatefulWidget {
  const LoadingWidget({super.key});

  @override
  State<LoadingWidget> createState() => LoadingWidgetState();
}

class LoadingWidgetState extends State<LoadingWidget>
    with TickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );
    _controller.repeat();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF202A35),
      body: Center(
        child: RotationTransition(
          turns: Tween<double>(begin: 0, end: 1).animate(_controller),
          child: Image.asset(
            ImageAssets.icLoading,
            width: 96,
            height: 96,
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
