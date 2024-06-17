import 'package:flutter/material.dart';

//  Diseño Bottom Bar Wave
class FooterWidget extends StatelessWidget {
  final double height;
  final Color color;

  const FooterWidget({
    super.key,
    this.height = 127,
    this.color = const Color.fromRGBO(83, 80, 236, 1),
  });

  @override
  Widget build(BuildContext context) {
    return ClipPath(
      clipper: FooterClipper(),
      child: Container(
        color: color,
        height: height,
        
      ),
    );
  }
}

class FooterClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();
    path.lineTo(
        0, size.height - size.height / 3); // Ajusté la posición de la curva
    var controlPoint = Offset(size.width / 2, size.height);
    var endPoint = Offset(size.width, size.height - size.height / 3);
    path.quadraticBezierTo(
        controlPoint.dx, controlPoint.dy, endPoint.dx, endPoint.dy);

    // Añadí estas líneas para hacer la curva similar a la de la imagen.
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);

    path.close();

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
