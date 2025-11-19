import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:audioplayers/audioplayers.dart';
import '../services/translation_service.dart';

class CompostStoryScreen extends StatefulWidget {
  final TranslationService translationService;

  const CompostStoryScreen({
    super.key,
    required this.translationService,
  });

  @override
  State<CompostStoryScreen> createState() => _CompostStoryScreenState();
}

class _CompostStoryScreenState extends State<CompostStoryScreen> {
  final FlutterTts flutterTts = FlutterTts();
  final AudioPlayer audioPlayer = AudioPlayer();
  int currentPage = 0;
  int conversationsPerPage = 1;  // One dialogue per page
  Map<String, String> miraVoice = {'name': 'default', 'locale': 'en-US'};
  Map<String, String> bananaVoice = {'name': 'default', 'locale': 'en-US'};
  Map<String, String> wigglesVoice = {'name': 'default', 'locale': 'en-US'};
  Map<String, String> narratorVoice = {'name': 'default', 'locale': 'en-US'};
  bool isPlaying = false;
  late final TranslationService _translationService;

  List<String> get storyContent => [
    _translationService.translate("Once upon a time, in a cozy kitchen, lived a little apple core named Mira. She had just been munched by a kid and was about to be thrown in the trash."),
    _translationService.translate("But wait! \"I can still help the Earth!"),
    _translationService.translate("If we go into the trash, we'll be stuck in a stinky bin forever!"),
    _translationService.translate("Hello there! Don't be sad… Come with me and I'll turn you into magic soil!"),
    _translationService.translate("Magic soil? Really?"),
    _translationService.translate("Yes! You'll help flowers grow and make the Earth happy again!"),
    _translationService.translate("Mira and her friends turned into rich, dark compost—superfood for plants!")
  ];

 

  final List<String> speakers = [
    "narrator",
    "mira",
    "banana",
    "wiggles",
    "mira",
    "wiggles",
    "narrator"
  ];

  final List<String> moralSpeakers = ["narrator"];

  @override
  void initState() {
    super.initState();
    _translationService = widget.translationService;
    _setupTts();
    _setupAudio();
  }

  @override
  void didUpdateWidget(CompostStoryScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.translationService != widget.translationService) {
      _translationService = widget.translationService;
      _setupTts();
      setState(() {});
    }
  }

  @override
  void dispose() {
    flutterTts.stop();
    audioPlayer.dispose();
    super.dispose();
  }

  Future<void> _setupTts() async {
    await flutterTts.setLanguage(_translationService.isSpanish ? "es-ES" : "en-US");
    await flutterTts.setSpeechRate(0.3);
    
    final voices = await flutterTts.getVoices;
    
    if (voices != null) {
      // Look for a gentle female voice for Mira
      final miraVoiceData = voices.firstWhere(
        (voice) => voice.name.toLowerCase().contains('female') || 
                   voice.name.toLowerCase().contains('woman') ||
                   voice.name.toLowerCase().contains('samantha') ||
                   voice.name.toLowerCase().contains('karen') ||
                   voice.name.toLowerCase().contains('child') ||
                   voice.name.toLowerCase().contains('girl'),
        orElse: () => voices.first,
      );
      miraVoice = {'name': miraVoiceData.name, 'locale': miraVoiceData.locale};

      // Look for a friendly voice for banana peel
      final bananaVoiceData = voices.firstWhere(
        (voice) => voice.name.toLowerCase().contains('male') || 
                   voice.name.toLowerCase().contains('man') ||
                   voice.name.toLowerCase().contains('michael') ||
                   voice.name.toLowerCase().contains('daniel'),
        orElse: () => voices.first,
      );
      bananaVoice = {'name': bananaVoiceData.name, 'locale': bananaVoiceData.locale};

      // Look for a magical voice for Wiggles
      final wigglesVoiceData = voices.firstWhere(
        (voice) => voice.name.toLowerCase().contains('male') || 
                   voice.name.toLowerCase().contains('man') ||
                   voice.name.toLowerCase().contains('david'),
        orElse: () => voices.first,
      );
      wigglesVoice = {'name': wigglesVoiceData.name, 'locale': wigglesVoiceData.locale};

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

    // final isMoralPage = currentPage >= storyContent.length;
    final linesToSpeak =  storyContent;
    final speakersForLines =  speakers;
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
      
      if (speaker == "mira") {
        await flutterTts.setVoice(miraVoice);
        await flutterTts.setPitch(1.2); // Higher pitch for young female voice
        await flutterTts.setSpeechRate(0.4);
      } else if (speaker == "banana") {
        await flutterTts.setVoice(bananaVoice);
        await flutterTts.setPitch(0.8); // Medium pitch for banana peel
        await flutterTts.setSpeechRate(0.3);
      } else if (speaker == "wiggles") {
        await flutterTts.setVoice(wigglesVoice);
        await flutterTts.setPitch(0.6); // Lower pitch for magical wizard
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
    // final isMoralPage = currentPage >= storyContent.length;
    final currentLines =  getCurrentPageLines();
    final isFirstPage = currentPage == 0;
    final isSecondPage = currentPage == 1;
    final isThirdPage = currentPage == 2;
    final isFourthPage = currentPage == 3;
    final isFifthPage = currentPage == 4;
    final isSixthPage = currentPage == 5;
    final isSeventhPage = currentPage == 6;
    
    return WillPopScope(
      onWillPop: () async {
        await flutterTts.stop();
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(
           
              _translationService.translate("Mira the Apple Core's Magic"),
            style: const TextStyle(
              fontFamily: 'ComicNeue',
              fontWeight: FontWeight.bold,
            ),
          ),
          backgroundColor: Colors.brown.shade100,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => Navigator.pop(context),
          ),
          actions: [
            IconButton(
              icon: Icon(
                _translationService.isSpanish ? Icons.language : Icons.translate,
                color: Colors.brown.shade900,
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
                    'assets/images/compost/mira1.png',
                    fit: BoxFit.cover,
                  ),
                )
              else if (isSecondPage)
                Positioned.fill(
                  child: Image.asset(
                    'assets/images/compost/mira2.png',
                    fit: BoxFit.cover,
                  ),
                )
              else if (isThirdPage)
                Positioned.fill(
                  child: Image.asset(
                    'assets/images/compost/mira3.png',
                    fit: BoxFit.cover,
                  ),
                )
              else if (isFourthPage)
                Positioned.fill(
                  child: Image.asset(
                    'assets/images/compost/mira4.png',
                    fit: BoxFit.cover,
                  ),
                )
              else if (isFifthPage)
                Positioned.fill(
                  child: Image.asset(
                    'assets/images/compost/mira5.png',
                    fit: BoxFit.cover,
                  ),
                )
              else if (isSixthPage)
                Positioned.fill(
                  child: Image.asset(
                    'assets/images/compost/mira6.png',
                    fit: BoxFit.cover,
                  ),
                )
              else if (isSeventhPage)
                Positioned.fill(
                  child: Image.asset(
                    'assets/images/compost/mira7.png',
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
                          final speaker = 
                            speakers[currentPage * conversationsPerPage + index];
                          final line = currentLines[index];
                          final isMira = speaker == "mira";
                          final isBanana = speaker == "banana";
                          final isWiggles = speaker == "wiggles";
                          final isNarrator = speaker == "narrator";
                          
                          return Align(
                            alignment: isNarrator ? Alignment.center : (isMira ? Alignment.centerLeft : Alignment.centerRight),
                            child: Container(
                              constraints: BoxConstraints(
                                maxWidth: isNarrator ? MediaQuery.of(context).size.width * 0.9 : MediaQuery.of(context).size.width * 0.75,
                              ),
                              margin: EdgeInsets.only(
                                bottom: 30,
                                left: isMira ? 0 : 40,
                                right: isMira ? 40 : 0,
                                top: index == 0 ? 20 : 0,
                              ),
                              child: isNarrator ? 
                                Container(
                                  padding: const EdgeInsets.all(16),
                                  decoration: BoxDecoration(
                                    color: Colors.brown.shade100.withOpacity(0.9),
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  child: Text(
                                    _translationService.translate(line),
                                    style: TextStyle(
                                      fontSize:  24,
                                      fontFamily: 'ComicNeue',
                                      fontWeight: FontWeight.bold,
                                      fontStyle: FontStyle.italic,
                                      height: 1.5,
                                      color:  Colors.black,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ) :
                                CustomPaint(
                                  painter: CloudBubblePainter(
                                    color: isMira 
                                      ? Colors.red.shade50.withOpacity(0.95)
                                      : isBanana
                                        ? Colors.yellow.shade50.withOpacity(0.95)
                                        : isWiggles
                                          ? Colors.purple.shade50.withOpacity(0.95)
                                          : Colors.brown.shade50.withOpacity(0.95),
                                    isLeftAligned: isMira,
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
                                backgroundColor: Colors.brown.shade300,
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                              ),
                            ),
                          ElevatedButton.icon(
                            onPressed: () => _speakLines( currentPage * conversationsPerPage),
                            icon: Icon(
                              isPlaying ? Icons.stop : Icons.volume_up,
                              color: Colors.white,
                            ),
                            label: Text(_translationService.translate(isPlaying ? 'Stop' : 'Listen')),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: isPlaying ? Colors.red.shade300 : Colors.brown.shade300,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                            ),
                          ),
                          if (hasNextPage )
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
                                backgroundColor: Colors.brown.shade300,
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
