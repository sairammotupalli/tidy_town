import 'package:flutter/widgets.dart';

/// Global route observer used to detect when a screen is covered by another
/// page route. Screens that play audio/TTS should subscribe and stop audio in
/// `didPushNext()` so narration never continues in the background.
final RouteObserver<PageRoute<dynamic>> routeObserver =
    RouteObserver<PageRoute<dynamic>>();

