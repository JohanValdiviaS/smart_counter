import 'package:flutter/material.dart';

class AuthBackground extends StatelessWidget {
  final Widget child;
  const AuthBackground({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      // color: Colors.orangeAccent,
      width: double.infinity,
      height: double.infinity,
      child: Stack(
        children: [
          _OrangeBox(),
          _HeaderIcon(),
          child,
        ],
      ),
    );
  }
}

class _HeaderIcon extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        width: double.infinity,
        margin: const EdgeInsets.only(top: 40),
        child: const Icon(Icons.person_pin, color: Colors.white, size: 100),
      ),
    );
  }
}

class _OrangeBox extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Container(
      width: double.infinity,
      height: size.height * 0.4,
      decoration: _orangeBG(),
      child: Stack(
        children: [
          Positioned(top: 90, left: 30, child: _Bubble()),
          Positioned(top: -10, left: -45, child: _Bubble()),
          Positioned(top: -50, right: -20, child: _Bubble()),
          Positioned(top: 50, right: 120, child: _Bubble()),
          Positioned(bottom: 20, left: -50, child: _Bubble()),
          Positioned(bottom: 20, left: 120, child: _Bubble()),
          Positioned(bottom: 40, right: 60, child: _Bubble()),
        ],
      ),
    );
  }

  BoxDecoration _orangeBG() => const BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Color.fromRGBO(248, 112, 33, 1),
            Color.fromRGBO(255, 171, 64, 1),
          ],
        ),
      );
}

class _Bubble extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100,
      height: 100,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(100),
        color: const Color.fromRGBO(255, 255, 255, 0.1),
      ),
    );
  }
}
