import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../../../core/utils/app_colors.dart';

enum HeaderAnimationType { mapPin, float }

class PreferenceAnimatedHeader extends StatefulWidget {
  final String bgSvgPath;
  final HeaderAnimationType animationType;

  const PreferenceAnimatedHeader({
    Key? key,
    required this.bgSvgPath,
    this.animationType = HeaderAnimationType.mapPin,
  }) : super(key: key);

  @override
  State<PreferenceAnimatedHeader> createState() =>
      _PreferenceAnimatedHeaderState();
}

class _PreferenceAnimatedHeaderState extends State<PreferenceAnimatedHeader>
    with TickerProviderStateMixin {
  late AnimationController _mapAnimationController;
  late Animation<double> _pinDropAnimation;
  late Animation<double> _circleScaleAnimation;
  late Animation<double> _circleOpacityAnimation;

  late AnimationController _floatAnimationController;
  late Animation<double> _floatAnimation;

  @override
  void initState() {
    super.initState();

    if (widget.animationType == HeaderAnimationType.mapPin) {
      _mapAnimationController = AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 1800),
      );

      _pinDropAnimation = Tween<double>(begin: -150, end: 0).animate(
        CurvedAnimation(
          parent: _mapAnimationController,
          curve: const Interval(0.0, 0.6, curve: Curves.bounceOut),
        ),
      );

      _circleScaleAnimation = Tween<double>(begin: 0.3, end: 1.0).animate(
        CurvedAnimation(
          parent: _mapAnimationController,
          curve: const Interval(0.4, 1.0, curve: Curves.easeOut),
        ),
      );

      _circleOpacityAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(
          parent: _mapAnimationController,
          curve: const Interval(0.4, 0.8, curve: Curves.easeOut),
        ),
      );

      _mapAnimationController.forward();
    } else if (widget.animationType == HeaderAnimationType.float) {
      _floatAnimationController = AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 2000),
      );

      _floatAnimation = Tween<double>(begin: -8, end: 8).animate(
        CurvedAnimation(
          parent: _floatAnimationController,
          curve: Curves.easeInOutSine,
        ),
      );

      _floatAnimationController.repeat(reverse: true);
    }
  }

  @override
  void dispose() {
    if (widget.animationType == HeaderAnimationType.mapPin) {
      _mapAnimationController.dispose();
    } else {
      _floatAnimationController.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.35,
      width: double.infinity,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Background SVG Map (Floating if float animation)
          if (widget.animationType == HeaderAnimationType.float)
            Positioned.fill(
              child: AnimatedBuilder(
                animation: _floatAnimationController,
                builder: (context, child) {
                  return Transform.translate(
                    offset: Offset(0, _floatAnimation.value),
                    child: child,
                  );
                },
                child: SvgPicture.asset(widget.bgSvgPath, fit: BoxFit.cover),
              ),
            )
          else
            Positioned.fill(
              child: SvgPicture.asset(widget.bgSvgPath, fit: BoxFit.cover),
            ),

          // Map Pin specific animations
          if (widget.animationType == HeaderAnimationType.mapPin) ...[
            // Animated Concentric Circles
            AnimatedBuilder(
              animation: _mapAnimationController,
              builder: (context, child) {
                return CustomPaint(
                  size: const Size(200, 200),
                  painter: _ConcentricCirclesPainter(
                    scale: _circleScaleAnimation.value,
                    opacity: _circleOpacityAnimation.value,
                  ),
                );
              },
            ),

            // Animated Pin dropping
            AnimatedBuilder(
              animation: _mapAnimationController,
              builder: (context, child) {
                // Shift up by 24 so the bottom tip of the 48-height pin is at the center (0,0)
                return Transform.translate(
                  offset: Offset(0, _pinDropAnimation.value - 24),
                  child: Opacity(
                    opacity: _pinDropAnimation.value < -140
                        ? 0
                        : 1, // small fade in at the very top
                    child: child,
                  ),
                );
              },
              child: CustomPaint(
                size: const Size(36, 48),
                painter: _MapPinPainter(),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _ConcentricCirclesPainter extends CustomPainter {
  final double scale;
  final double opacity;

  _ConcentricCirclesPainter({required this.scale, required this.opacity});

  @override
  void paint(Canvas canvas, Size size) {
    if (opacity == 0) return;

    final paint = Paint()
      ..color = AppColors.primary.withValues(alpha: opacity * 0.4)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;

    final center = Offset(size.width / 2, size.height / 2);

    // Draw 3 concentric circles based on scale
    canvas.drawCircle(center, 30 * scale, paint);
    canvas.drawCircle(center, 60 * scale, paint);
    canvas.drawCircle(center, 90 * scale, paint);
  }

  @override
  bool shouldRepaint(covariant _ConcentricCirclesPainter oldDelegate) {
    return oldDelegate.scale != scale || oldDelegate.opacity != opacity;
  }
}

class _MapPinPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final width = size.width;
    final height = size.height;
    final radius = width / 2;

    final path = Path();
    path.moveTo(width / 2, height);
    path.quadraticBezierTo(0, height * 0.75, 0, radius);
    path.arcToPoint(Offset(width, radius), radius: Radius.circular(radius));
    path.quadraticBezierTo(width, height * 0.75, width / 2, height);
    path.close();

    final fillPaint = Paint()
      ..color = AppColors.primary
      ..style = PaintingStyle.fill;

    final strokePaint = Paint()
      ..color = Colors.white
      ..strokeWidth = 4.0
      ..strokeJoin = StrokeJoin.round
      ..style = PaintingStyle.stroke;

    // Draw shadow/stroke
    canvas.drawPath(path, strokePaint);
    // Draw fill
    canvas.drawPath(path, fillPaint);

    // Draw white dot
    final dotPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;
    canvas.drawCircle(
      Offset(width / 2, radius * 0.95),
      radius * 0.35,
      dotPaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
