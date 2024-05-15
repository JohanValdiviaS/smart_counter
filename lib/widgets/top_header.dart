import 'package:flutter/material.dart';

class CurvedContainer extends StatelessWidget {
  final double height;
  final Color color;

  const CurvedContainer({
    super.key,
    this.height = 135,
    this.color = const Color.fromRGBO(195, 151, 229, 1),
  });

  @override
  Widget build(BuildContext context) {
    return ClipPath(
      clipper: CurveClipper(),
      child: Container(
        color: color,
        height: height,
        alignment: Alignment.center,
      ),
    );
  }
}

class CurveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();
    path.lineTo(0, size.height - 50);
    var controlPoint = Offset(size.width / 2, size.height);
    var endPoint = Offset(size.width, size.height - 50);
    path.quadraticBezierTo(
        controlPoint.dx, controlPoint.dy, endPoint.dx, endPoint.dy);
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
