import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

/// On Flutter web, letterboxes the app to tablet portrait ratio on laptop/desktop
/// browsers so layouts match the tablet design instead of stretching wide.
class DesktopWebFrame extends StatelessWidget {
  const DesktopWebFrame({super.key, required this.child});

  final Widget child;

  /// Matches [TidyTown_Homepage.png] (1086×1448) — the tablet layout you designed.
  static const double designWidth = 1086;
  static const double designHeight = 1448;
  static const double designAspectRatio = designWidth / designHeight;

  /// True only for wide landscape web viewports (typical laptop browser).
  static bool shouldApplyFrame(Size viewport) {
    if (!kIsWeb) return false;

    final isLandscape = viewport.width > viewport.height;
    final isLaptopWidth = viewport.width >= 1100;

    return isLandscape && isLaptopWidth;
  }

  @override
  Widget build(BuildContext context) {
    final viewport = MediaQuery.sizeOf(context);

    if (!shouldApplyFrame(viewport)) {
      return child;
    }

    return ColoredBox(
      color: Colors.black,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final maxW = constraints.maxWidth;
          final maxH = constraints.maxHeight;

          var frameHeight = maxH;
          var frameWidth = frameHeight * designAspectRatio;

          if (frameWidth > maxW) {
            frameWidth = maxW;
            frameHeight = frameWidth / designAspectRatio;
          }

          final parentQuery = MediaQuery.of(context);
          final designQuery = parentQuery.copyWith(
            size: const Size(designWidth, designHeight),
            padding: _scaleEdgeInsets(
              parentQuery.padding,
              viewport,
              const Size(designWidth, designHeight),
            ),
          );

          return Center(
            child: SizedBox(
              width: frameWidth,
              height: frameHeight,
              child: FittedBox(
                fit: BoxFit.contain,
                alignment: Alignment.center,
                child: SizedBox(
                  width: designWidth,
                  height: designHeight,
                  child: MediaQuery(
                    data: designQuery,
                    child: child,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  static EdgeInsets _scaleEdgeInsets(
    EdgeInsets padding,
    Size viewport,
    Size designSize,
  ) {
    if (padding == EdgeInsets.zero) return EdgeInsets.zero;

    final scaleW = designSize.width / viewport.width;
    final scaleH = designSize.height / viewport.height;

    return EdgeInsets.fromLTRB(
      padding.left * scaleW,
      padding.top * scaleH,
      padding.right * scaleW,
      padding.bottom * scaleH,
    );
  }
}
