import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:ophthalmology_board/animations/delayed_animation.dart';
import 'package:ophthalmology_board/views/auth/login_view.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  final int delayedAmount = 500;
  double? scale;
  AnimationController? _controller;

  @override
  void initState() {
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(
        milliseconds: 200,
      ),
      lowerBound: 0.0,
      upperBound: 0.1,
    )..addListener(() {
        setState(() {});
      });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    const color = Colors.white;
    scale = 1 - _controller!.value;
    return SafeArea(
      child: Scaffold(
          body: Container(
        decoration: const BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                colors: [Colors.lightBlue, Colors.blueAccent])),
        child: Center(
          child: Column(
            children: <Widget>[
              AvatarGlow(
                endRadius: 90,
                duration: const Duration(seconds: 2),
                glowColor: Colors.white24,
                repeat: true,
                repeatPauseDuration: const Duration(seconds: 2),
                startDelay: const Duration(seconds: 1),
                child: Material(
                    elevation: 8.0,
                    shape: const CircleBorder(),
                    child: CircleAvatar(
                      child: Image.asset('graphics/iris_logo_and_wordmark.png'),
                      radius: 50.0,
                    )),
              ),
              DelayedAnimation(
                child: const Text(
                  "Kuwait Ophthalmology Board",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 23.0,
                      color: color),
                ),
                delay: delayedAmount,
              ),
              const SizedBox(
                height: 30.0,
              ),
              DelayedAnimation(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  width: double.infinity,
                  child: const Text(
                    "A cloud based app, that can help you in your journey at you residency in the Kuwaiti ophthalmology board",
                    style: TextStyle(fontSize: 20.0, color: color),
                  ),
                ),
                delay: delayedAmount,
              ),
              const SizedBox(
                height: 75.0,
              ),
              DelayedAnimation(
                child: Container(
                  height: 60,
                  width: 270,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(100.0),
                    color: Colors.white,
                  ),
                  child: TextButton(
                    child: const Text(
                      'Sign In',
                      style: TextStyle(
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF8185E2),
                      ),
                    ),
                    onPressed: () {
                      Get.to(() => LoginView());
                    },
                  ),
                ),
                delay: delayedAmount + 1000,
              ),
            ],
          ),
        ),
      )),
    );
  }
}
