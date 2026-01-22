import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:audioplayers/audioplayers.dart';
import '../services/translation_service.dart';

class WallyWormStoryScreen extends StatefulWidget {
  final TranslationService translationService;

  const WallyWormStoryScreen({
    super.key,
    required this.translationService,
  });

  @override
  State<WallyWormStoryScreen> createState() => _WallyWormStoryScreenState();
}

class _WallyWormStoryScreenState extends State<WallyWormStoryScreen> {
  final FlutterTts flutterTts = FlutterTts();
  final AudioPlayer audioPlayer = AudioPlayer();
  int currentPage = 0;
  int conversationsPerPage = 1;  // One dialogue per page
  Map<String, String> wallyVoice = {'name': 'default', 'locale': 'en-US'};
  Map<String, String> bananaVoice = {'name': 'default', 'locale': 'en-US'};
  Map<String, String> narratorVoice = {'name': 'default', 'locale': 'en-US'};
  bool isPlaying = false;
  late final TranslationService _translationService;

  List<String> get storyContent => [
    _translationService.translate("Deep under the garden, in a cozy pile of leaves and peels, lived a wiggly little worm named Wally. Wally wasn't just any worm—he was a Compost Explorer!"),
    _translationService.translate("Oh no! So much yummy food is being thrown away into the trash!"),
    _translationService.translate("He wiggled and wriggled his way toward the kitchen window and saw a banana peel, carrot tops, and a sad slice of bread all being dumped in the garbage bin."),
    _translationService.translate("\"They don't belong there,\" said Wally. \"They could join our compost party and become soil superheroes!\""),
    _translationService.translate("🪱💬 Wally shouted, \"Hey friends! Want to help flowers grow? Follow me!\""),
    _translationService.translate("The banana peel blinked. \"We can help plants grow?\""),
    _translationService.translate("Wally nodded. \"Absolutely! When we compost together, we turn into magic soil that makes gardens bloom!\""),
    _translationService.translate("So one by one, the food scraps jumped out of the trash and followed Wally into the compost pile. It was warm, squishy, and full of other friendly worms."),
    _translationService.translate("Wally led them on a journey deep into the pile, where they met dancing microbes and giggling bugs working together to turn everything into dark, rich compost."),
    _translationService.translate("After a few days of wiggling, munching, and mixing…"),
    _translationService.translate("✨POOF!✨ The banana peel and all her new friends had transformed into super soil!"),
    _translationService.translate("🌼 They were spread across a garden, helping sunflowers grow tall, strawberries turn sweet, and trees grow strong."),
    _translationService.translate("Wally smiled proudly. \"Another compost mission complete!\""),
    _translationService.translate("And off he went, ready for his next big adventure…")
  ];

  final List<String> speakers = [
    "narrator",
    "wally",
    "narrator",
    "wally",
    "wally",
    "banana",
    "wally",
    "narrator",
    "narrator",
    "narrator",
    "narrator",
    "narrator",
    "wally",
    "narrator"
  ];

  @override
  void initState() {
    super.initState();
    _translationService = widget.translationService;
    _setupTts();
    _setupAudio();
  }

  @override
  void didUpdateWidget(WallyWormStoryScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.translationService != widget.translationService) {
      _translationService = widget.translationService;
      _setupTts();
      setState(() {});
    }
  }

  @override
  void dispose() {
    isPlaying = false;
    flutterTts.stop();
    audioPlayer.stop();
    audioPlayer.dispose();
    super.dispose();
  }

  Future<void> _stopNarration() async {
    isPlaying = false;
    await flutterTts.stop();
    await audioPlayer.stop();
  }

  Future<void> _setupTts() async {
    await flutterTts.setLanguage(_translationService.isSpanish ? "es-ES" : "en-US");
    await flutterTts.setSpeechRate(0.3);
    
    final voices = await flutterTts.getVoices;
    
    if (voices != null) {
      // Look for a friendly male voice for Wally
      final wallyVoiceData = voices.firstWhere(
        (voice) => voice.name.toLowerCase().contains('male') || 
                   voice.name.toLowerCase().contains('man') ||
                   voice.name.toLowerCase().contains('michael') ||
                   voice.name.toLowerCase().contains('daniel'),
        orElse: () => voices.first,
      );
      wallyVoice = {'name': wallyVoiceData.name, 'locale': wallyVoiceData.locale};

      // Look for a friendly voice for banana peel
      final bananaVoiceData = voices.firstWhere(
        (voice) => voice.name.toLowerCase().contains('female') || 
                   voice.name.toLowerCase().contains('woman') ||
                   voice.name.toLowerCase().contains('samantha') ||
                   voice.name.toLowerCase().contains('karen'),
        orElse: () => voices.first,
      );
      bananaVoice = {'name': bananaVoiceData.name, 'locale': bananaVoiceData.locale};

      // Default narrator voice
      narratorVoice = {'name': 'default', 'locale': _translationService.isSpanish ? 'es-ES' : 'en-US'};
    }
  }

  Future<void> _setupAudio() async {
    await audioPlayer.setSource(AssetSource('sounds/high-five.mp3'));
    await audioPlayer.setVolume(1.0);
  }

  Future<void> _playHighFive() async {
    await audioPlayer.stop();
    await audioPlayer.play(AssetSource('sounds/high-five.mp3'));
  }

  Future<void> _speakLines(int startIndex) async {
    if (isPlaying) {
      await flutterTts.stop();
      setState(() {
        isPlaying = false;
      });
      return;
    }

    setState(() {
      isPlaying = true;
    });

    final linesToSpeak = storyContent;
    final speakersForLines = speakers;
    final currentStartIndex = startIndex;

    String lastSpeaker = "";
    for (int i = currentStartIndex; i < (currentStartIndex + conversationsPerPage) && i < linesToSpeak.length; i++) {
      if (!isPlaying) break;
      
      final line = linesToSpeak[i];
      final speaker = speakersForLines[i];
      final translatedLine = _translationService.translate(line);
      
      if (lastSpeaker != "" && lastSpeaker != speaker) {
        await Future.delayed(const Duration(milliseconds: 1500));
      }
      
      if (speaker == "wally") {
        await flutterTts.setVoice(wallyVoice);
        await flutterTts.setPitch(0.8); // Medium pitch for friendly worm
        await flutterTts.setSpeechRate(0.4);
      } else if (speaker == "banana") {
        await flutterTts.setVoice(bananaVoice);
        await flutterTts.setPitch(1.1); // Higher pitch for banana peel
        await flutterTts.setSpeechRate(0.3);
      } else if (speaker == "narrator") {
        await flutterTts.setVoice(narratorVoice);
        await flutterTts.setPitch(0.8);
        await flutterTts.setSpeechRate(0.2);
      }
      
      await flutterTts.speak(translatedLine);
      
      final length = translatedLine.length;
      final basePause = 1000;
      final charPause = (length * 50).clamp(500, 2000);
      await Future.delayed(Duration(milliseconds: charPause + basePause));
      
      lastSpeaker = speaker;
    }

    if (!mounted) {
      return;
    }
    setState(() {
      isPlaying = false;
    });
  }

  List<String> getCurrentPageLines() {
    final startIndex = currentPage * conversationsPerPage;
    final endIndex = (startIndex + conversationsPerPage).clamp(0, storyContent.length);
    return storyContent.sublist(startIndex, endIndex);
  }

  bool get hasNextPage => currentPage < storyContent.length - 1;
  bool get hasPreviousPage => currentPage > 0;

  @override
  Widget build(BuildContext context) {
    final currentLines = getCurrentPageLines();
    final isFirstPage = currentPage == 0;
    final isSecondPage = currentPage == 1;
    final isThirdPage = currentPage == 2;
    final isFourthPage = currentPage == 3;
    final isFifthPage = currentPage == 4;
    final isSixthPage = currentPage == 5;
    final isSeventhPage = currentPage == 6;
    final isEighthPage = currentPage == 7;
    final isNinthPage = currentPage == 8;
    final isTenthPage = currentPage == 9;
    final isEleventhPage = currentPage == 10;
    final isTwelfthPage = currentPage == 11;
    final isThirteenthPage = currentPage == 12;
    final isLastPage = currentPage == 13;
    
    return WillPopScope(
      onWillPop: () async {
        await _stopNarration();
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            _translationService.translate("Wally the Worm's Adventure"),
            style: const TextStyle(
              fontFamily: 'ComicNeue',
              fontWeight: FontWeight.bold,
            ),
          ),
          backgroundColor: Colors.green.shade100,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () async {
              await _stopNarration();
              if (!mounted) {
                return;
              }
              Navigator.pop(context);
            },
          ),
          actions: [
            IconButton(
              icon: Icon(
                _translationService.isSpanish ? Icons.language : Icons.translate,
                color: Colors.green.shade900,
              ),
              onPressed: () {
                _translationService.toggleLanguage();
                setState(() {});
              },
            ),
          ],
        ),
        body: Container(
          color: Colors.white,
          child: Stack(
            children: [
              // Background image based on page
              if (isFirstPage)
                Positioned.fill(
                  child: Image.asset(
                    'assets/images/compost/wally1.png',
                    fit: BoxFit.cover,
                  ),
                )
              else if (isSecondPage)
                Positioned.fill(
                  child: Image.asset(
                    'assets/images/compost/wally2.png',
                    fit: BoxFit.cover,
                  ),
                )
              else if (isThirdPage)
                Positioned.fill(
                  child: Image.asset(
                    'assets/images/compost/wally3.png',
                    fit: BoxFit.cover,
                  ),
                )
              else if (isFourthPage)
                Positioned.fill(
                  child: Image.asset(
                    'assets/images/compost/wally4.png',
                    fit: BoxFit.cover,
                  ),
                )
              else if (isFifthPage)
                Positioned.fill(
                  child: Image.asset(
                    'assets/images/compost/wally5.png',
                    fit: BoxFit.cover,
                  ),
                )
              else if (isSixthPage)
                Positioned.fill(
                  child: Image.asset(
                    'assets/images/compost/wally6.png',
                    fit: BoxFit.cover,
                  ),
                )
              else if (isSeventhPage)
                Positioned.fill(
                  child: Image.asset(
                    'assets/images/compost/wally7.png',
                    fit: BoxFit.cover,
                  ),
                )
              else if (isEighthPage)
                Positioned.fill(
                  child: Image.asset(
                    'assets/images/compost/wally8.png',
                    fit: BoxFit.cover,
                  ),
                )
              else if (isNinthPage)
                Positioned.fill(
                  child: Image.asset(
                    'assets/images/compost/wally9.png',
                    fit: BoxFit.cover,
                  ),
                )
              else if (isTenthPage)
                Positioned.fill(
                  child: Image.asset(
                    'assets/images/compost/wally10.png',
                    fit: BoxFit.cover,
                  ),
                )
              else if (isEleventhPage)
                Positioned.fill(
                  child: Image.asset(
                    'assets/images/compost/wally11.png',
                    fit: BoxFit.cover,
                  ),
                )
              else if (isTwelfthPage)
                Positioned.fill(
                  child: Image.asset(
                    'assets/images/compost/wally12.png',
                    fit: BoxFit.cover,
                  ),
                )
              else if (isThirteenthPage)
                Positioned.fill(
                  child: Image.asset(
                    'assets/images/compost/wally13.png',
                    fit: BoxFit.cover,
                  ),
                )
              else if (isLastPage)
                Positioned.fill(
                  child: Image.asset(
                    'assets/images/compost/wallylast.gif',
                    fit: BoxFit.cover,
                  ),
                ),
              // Content
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 40, 20, 20),
                child: Column(
                  children: [
                    Expanded(
                      child: ListView.builder(
                        itemCount: currentLines.length,
                        itemBuilder: (context, index) {
                          final speaker = speakers[currentPage * conversationsPerPage + index];
                          final line = currentLines[index];
                          final isWally = speaker == "wally";
                          final isBanana = speaker == "banana";
                          final isNarrator = speaker == "narrator";
                          
                          return Align(
                            alignment: isNarrator ? Alignment.center : (isWally ? Alignment.centerLeft : Alignment.centerRight),
                            child: Container(
                              constraints: BoxConstraints(
                                maxWidth: isNarrator ? MediaQuery.of(context).size.width * 0.9 : MediaQuery.of(context).size.width * 0.75,
                              ),
                              margin: EdgeInsets.only(
                                bottom: 30,
                                left: isWally ? 0 : 40,
                                right: isWally ? 40 : 0,
                                top: index == 0 ? 20 : 0,
                              ),
                              child: isNarrator ? 
                                Container(
                                  padding: const EdgeInsets.all(16),
                                  decoration: BoxDecoration(
                                    color: Colors.green.shade100.withOpacity(0.9),
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  child: Text(
                                    _translationService.translate(line),
                                    style: const TextStyle(
                                      fontSize: 24,
                                      fontFamily: 'ComicNeue',
                                      fontWeight: FontWeight.bold,
                                      fontStyle: FontStyle.italic,
                                      height: 1.5,
                                      color: Colors.black,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ) :
                                CustomPaint(
                                  painter: CloudBubblePainter(
                                    color: isWally 
                                      ? Colors.green.shade50.withOpacity(0.95)
                                      : isBanana
                                        ? Colors.yellow.shade50.withOpacity(0.95)
                                        : Colors.brown.shade50.withOpacity(0.95),
                                    isLeftAligned: isWally,
                                  ),
                                  child: Container(
                                    padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
                                    child: Text(
                                      _translationService.translate(line),
                                      style: const TextStyle(
                                        fontSize: 18,
                                        fontFamily: 'ComicNeue',
                                        fontWeight: FontWeight.bold,
                                        height: 1.5,
                                      ),
                                    ),
                                  ),
                                ),
                            ),
                          );
                        },
                      ),
                    ),
                    // Navigation Buttons at bottom
                    Padding(
                      padding: const EdgeInsets.only(top: 16, bottom: 16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          if (hasPreviousPage)
                            ElevatedButton.icon(
                              onPressed: () async {
                                await flutterTts.stop();
                                setState(() {
                                  isPlaying = false;
                                  currentPage--;
                                });
                              },
                              icon: const Icon(Icons.arrow_back),
                              label: Text(_translationService.translate('Previous')),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.green.shade300,
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                              ),
                            ),
                          ElevatedButton.icon(
                            onPressed: () => _speakLines(currentPage * conversationsPerPage),
                            icon: Icon(
                              isPlaying ? Icons.stop : Icons.volume_up,
                              color: Colors.white,
                            ),
                            label: Text(_translationService.translate(isPlaying ? 'Stop' : 'Listen')),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: isPlaying ? Colors.red.shade300 : Colors.green.shade300,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                            ),
                          ),
                          if (hasNextPage)
                            ElevatedButton.icon(
                              onPressed: () async {
                                await flutterTts.stop();
                                setState(() {
                                  isPlaying = false;
                                  currentPage++;
                                });
                              },
                              icon: const Icon(Icons.arrow_forward),
                              label: Text(_translationService.translate('Next')),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.green.shade300,
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Custom painter for cloud-like speech bubbles
class CloudBubblePainter extends CustomPainter {
  final Color color;
  final bool isLeftAligned;

  CloudBubblePainter({
    required this.color,
    required this.isLeftAligned,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final path = Path();
    final radius = 20.0;
    
    // Main bubble
    path.moveTo(radius, 0);
    
    // Top edge with bumps
    path.quadraticBezierTo(size.width / 4, -10, size.width / 2, 0);
    path.quadraticBezierTo(size.width * 3 / 4, 10, size.width - radius, 0);
    
    // Right edge
    path.quadraticBezierTo(size.width + 5, size.height / 3, size.width - radius, size.height - radius);
    
    // Bottom edge with bumps
    path.quadraticBezierTo(size.width * 3 / 4, size.height + 5, size.width / 2, size.height - radius / 2);
    path.quadraticBezierTo(size.width / 4, size.height - 10, radius, size.height - radius);
    
    // Left edge
    path.quadraticBezierTo(-5, size.height / 3, radius, 0);

    // Add tail
    if (isLeftAligned) {
      path.moveTo(30, size.height - radius);
      path.quadraticBezierTo(10, size.height + 10, 0, size.height + 20);
      path.quadraticBezierTo(20, size.height - radius + 10, 30, size.height - radius);
    } else {
      path.moveTo(size.width - 30, size.height - radius);
      path.quadraticBezierTo(size.width - 10, size.height + 10, size.width, size.height + 20);
      path.quadraticBezierTo(size.width - 20, size.height - radius + 10, size.width - 30, size.height - radius);
    }

    canvas.drawPath(path, paint);

    // Add subtle shadow
    final shadowPaint = Paint()
      ..color = Colors.black.withOpacity(0.1)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 3);
    canvas.drawPath(path, shadowPaint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
