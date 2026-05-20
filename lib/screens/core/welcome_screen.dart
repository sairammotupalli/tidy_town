import 'package:flutter/material.dart';
import 'package:tidy_town/screens/core/home_screen.dart';
import 'package:tidy_town/services/translation_service.dart';
import 'package:tidy_town/utils/transitions.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final translationService = TranslationService();

    return Scaffold(
      body: Stack(
        children: [
          SizedBox.expand(
            child: Image.asset(
              'assets/images/TidyTown_Homepage.png',
              fit: BoxFit.cover,
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).size.height * 0.06,
                left: 32,
                right: 32,
              ),
              child: _GetStartedButton(
                label: translationService.translate('Get Started!'),
                onPressed: () {
                  Navigator.of(context).push(
                    AppTransitions.zoom(const HomeScreen()),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Pill button styled to match the Tidy Town homepage artwork.
class _GetStartedButton extends StatelessWidget {
  const _GetStartedButton({
    required this.label,
    required this.onPressed,
  });

  final String label;
  final VoidCallback onPressed;

  static const _creamBorder = Color(0xFFFFF5DC);
  static const _borderOutline = Color(0xFFD9C9A8);
  static const _yellowTop = Color(0xFFFFEE7A);
  static const _yellowBottom = Color(0xFFFFD633);
  static const _textBrown = Color(0xFF4A3728);
  static const _shadowBrown = Color(0xFF6B5344);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(999),
        splashColor: _textBrown.withValues(alpha: 0.12),
        highlightColor: _textBrown.withValues(alpha: 0.06),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(999),
            boxShadow: [
              BoxShadow(
                color: _shadowBrown.withValues(alpha: 0.45),
                offset: const Offset(0, 5),
                blurRadius: 10,
                spreadRadius: 0,
              ),
              BoxShadow(
                color: Colors.white.withValues(alpha: 0.35),
                offset: const Offset(0, -1),
                blurRadius: 2,
                spreadRadius: 0,
              ),
            ],
          ),
          child: Container(
            padding: const EdgeInsets.all(7),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(999),
              color: _creamBorder,
              border: Border.all(color: _borderOutline, width: 1.5),
            ),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(999),
                gradient: const LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [_yellowTop, _yellowBottom],
                  stops: [0.0, 1.0],
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.white.withValues(alpha: 0.55),
                    offset: const Offset(0, 2),
                    blurRadius: 4,
                    spreadRadius: 0,
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  const _LeafPairIcon(),
                  const SizedBox(width: 14),
                  Flexible(
                    child: Text(
                      label,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 26,
                        fontFamily: 'ComicNeue',
                        fontWeight: FontWeight.bold,
                        color: _textBrown,
                        height: 1.1,
                        letterSpacing: 0.3,
                      ),
                    ),
                  ),
                  const SizedBox(width: 14),
                  const _LeafPairIcon(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _LeafPairIcon extends StatelessWidget {
  const _LeafPairIcon();

  @override
  Widget build(BuildContext context) {
    return const SizedBox(
      width: 28,
      height: 28,
      child: CustomPaint(painter: _LeafPairPainter()),
    );
  }
}

class _LeafPairPainter extends CustomPainter {
  const _LeafPairPainter();

  static const _leafGreen = Color(0xFF5CB85C);
  static const _leafDark = Color(0xFF3D8B3D);
  static const _vein = Color(0xFF2E6B2E);

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    _drawLeaf(
      canvas,
      center: center + const Offset(-4, 1),
      angle: -0.55,
      flip: false,
    );
    _drawLeaf(
      canvas,
      center: center + const Offset(4, 1),
      angle: 0.55,
      flip: true,
    );
  }

  void _drawLeaf(
    Canvas canvas, {
    required Offset center,
    required double angle,
    required bool flip,
  }) {
    canvas.save();
    canvas.translate(center.dx, center.dy);
    canvas.rotate(angle);
    if (flip) {
      canvas.scale(-1, 1);
    }

    final leafPath = Path()
      ..moveTo(0, 10)
      ..quadraticBezierTo(8, 2, 0, -10)
      ..quadraticBezierTo(-8, 2, 0, 10)
      ..close();

    canvas.drawPath(
      leafPath,
      Paint()
        ..color = _leafGreen
        ..style = PaintingStyle.fill,
    );
    canvas.drawPath(
      leafPath,
      Paint()
        ..color = _leafDark
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.2,
    );

    canvas.drawLine(
      const Offset(0, 8),
      const Offset(0, -8),
      Paint()
        ..color = _vein
        ..strokeWidth = 1.1
        ..strokeCap = StrokeCap.round,
    );

    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
