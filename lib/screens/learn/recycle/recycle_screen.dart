import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:tidy_town/services/translation_service.dart';
import 'package:tidy_town/services/progress_service.dart';
import 'package:tidy_town/services/route_observer.dart';
import 'luna_story_screen.dart';
import 'wally_story_screen.dart';

class RecycleScreen extends StatefulWidget {
  const RecycleScreen({super.key});

  @override
  State<RecycleScreen> createState() => _RecycleScreenState();
}

class _RecycleScreenState extends State<RecycleScreen> {
  final FlutterTts flutterTts = FlutterTts();
  final TranslationService _translationService = TranslationService();

  void _navigateToDetailScreen(int index) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder:
            (context) => RecycleDetailScreen(
              pageIndex: index,
              translationService: _translationService,
            ),
      ),
    ).then((_) {
      setState(() {}); // Trigger rebuild when returning from detail screen
    });
  }

  Widget _buildCard(
    BuildContext context, {
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
    required int index,
  }) {
    return Card(
      elevation: 8,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: InkWell(
        onTap: () => _navigateToDetailScreen(index),
        borderRadius: BorderRadius.circular(20),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [color.withOpacity(0.7), color],
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 50, color: Colors.white),
              const SizedBox(height: 16),
              Text(
                _translationService.translate(title),
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  fontFamily: 'ComicNeue',
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                _translationService.translate(subtitle),
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.black,
                  fontFamily: 'ComicNeue',
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          _translationService.translate('Recycling ♻️'),
          style: const TextStyle(
            fontFamily: 'ComicNeue',
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.blue.shade100,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: Icon(
              _translationService.isSpanish ? Icons.language : Icons.translate,
              color: Colors.black,
            ),
            onPressed: () {
              _translationService.toggleLanguage();
              setState(() {}); // Force rebuild of the entire screen
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: Container(
              // decoration: BoxDecoration(
              //   gradient: LinearGradient(
              //     begin: Alignment.topCenter,
              //     end: Alignment.bottomCenter,
              //     colors: [Colors.blue.shade50, Colors.white],
              //   ),
              // ),
              child: LayoutBuilder(
                builder: (context, constraints) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16.0,
                        vertical: 40.0,
                      ),
                      child: GridView.count(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        crossAxisCount: 2,
                        childAspectRatio: 1,
                        mainAxisSpacing: 16,
                        crossAxisSpacing: 16,
                        children: [
                          _buildCard(
                            context,
                            title: "What is Recycling?",
                            subtitle: "Learn about recycling in a fun way! 🌟",
                            icon: Icons.lightbulb_outline,
                            color: Colors.blue,
                            index: 0,
                          ),
                          _buildCard(
                            context,
                            title: "What Can Be Recycled?",
                            subtitle: "Discover recyclable items! 🔍",
                            icon: Icons.category_outlined,
                            color: Colors.green,
                            index: 1,
                          ),
                          _buildCard(
                            context,
                            title: "Why Should We Recycle?",
                            subtitle: "Meet Tommy the Turtle! 🐢",
                            icon: Icons.eco_outlined,
                            color: Colors.orange,
                            index: 2,
                          ),
                          _buildCard(
                            context,
                            title: "Recycle Quiz",
                            subtitle: "Test your knowledge! 🎯",
                            icon: Icons.quiz_outlined,
                            color: Colors.purple,
                            index: 3,
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildGradientButton(
                icon: Icons.home,
                onPressed: () => Navigator.pop(context),
              ),
              _buildGradientButton(icon: Icons.settings, onPressed: () {}),
              _buildGradientButton(icon: Icons.volume_up, onPressed: () {}),
            ],
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildGradientButton({
    required IconData icon,
    required VoidCallback onPressed,
  }) {
    return Container(
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF5B3B2B), Color(0xFF7B4B35)],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        borderRadius: BorderRadius.circular(25),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            spreadRadius: 1,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: IconButton(
        onPressed: onPressed,
        icon: Container(
          padding: const EdgeInsets.all(12),
          child: Icon(
            icon,
            size: 35,
            color: const Color.fromARGB(255, 255, 250, 250),
          ),
        ),
        padding: EdgeInsets.zero,
      ),
    );
  }
}

class RecycleDetailScreen extends StatefulWidget {
  final int pageIndex;
  final TranslationService translationService;

  const RecycleDetailScreen({
    super.key,
    required this.pageIndex,
    required this.translationService,
  });

  @override
  State<RecycleDetailScreen> createState() => _RecycleDetailScreenState();
}

class _RecycleDetailScreenState extends State<RecycleDetailScreen>
    with RouteAware {
  late final TranslationService _translationService;
  final FlutterTts flutterTts = FlutterTts();
  final AudioPlayer audioPlayer = AudioPlayer();
  Map<String, String> tommyVoice = {'name': 'default', 'locale': 'en-US'};
  Map<String, String> bottleVoice = {'name': 'default', 'locale': 'en-US'};
  bool isPlaying = false;

  late final PageController pageController;
  late final ValueNotifier<int> currentPageNotifier;

  final List<Map<String, dynamic>> recyclableItems = [
    {
      'name': 'Paper and Cardboard',
      'image': 'assets/images/recycle/paper.png',
      'isRecyclable': true,
      'story':
          "Hey! I'm paper, and I'm like a superhero that can transform! I can be recycled up to 7 times before I retire!",
    },
    {
      'name': 'Glass Containers',
      'image': 'assets/images/recycle/glass.png',
      'isRecyclable': true,
      'story':
          "Hi there! I'm glass, and I'm practically immortal! I can be recycled forever without losing my quality!",
    },
    {
      'name': 'Metal Cans',
      'image': 'assets/images/recycle/metal.png',
      'isRecyclable': true,
      'story':
          "Yo! I'm metal, and I'm like a phoenix! I can be melted down and reborn into something new over and over!",
    },
    {
      'name': 'Plastic Bottles',
      'image': 'assets/images/recycle/plastic.png',
      'isRecyclable': true,
      'story':
          "Hello! I'm plastic, and I'm on a mission! When recycled, I can become new bottles, toys, or even clothes!",
    },
    {
      'name': 'Pizza Box (with grease)',
      'image': 'assets/images/recycle/pizza.jpg',
      'isRecyclable': false,
      'story':
          "Oops! I'm a pizza box, and I'm too greasy to be recycled! I'm like a party guest who spilled food everywhere!",
    },
    {
      'name': 'Banana Peel',
      'image': 'assets/images/recycle/banana.jpeg',
      'isRecyclable': false,
      'story':
          "Hi! I'm a banana peel. I don't go in the recycle bin. I belong in compost, where I can break down and help plants grow!",
    },
  ];

  @override
  void initState() {
    super.initState();
    _translationService = widget.translationService;
    _setupTts();
    _setupAudio();
    pageController = PageController();
    currentPageNotifier = ValueNotifier<int>(0);

    flutterTts.setCompletionHandler(() {
      if (!mounted) {
        return;
      }
      setState(() {
        isPlaying = false;
      });
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final route = ModalRoute.of(context);
    if (route is PageRoute) {
      routeObserver.subscribe(this, route);
    }
  }

  @override
  void didPushNext() {
    flutterTts.stop();
    audioPlayer.stop();
  }

  @override
  void didUpdateWidget(RecycleDetailScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.translationService != widget.translationService) {
      _translationService = widget.translationService;
      _setupTts(); // Update TTS language when translation service changes
    }
  }

  @override
  void dispose() {
    routeObserver.unsubscribe(this);
    isPlaying = false;
    flutterTts.stop();
    audioPlayer.stop();
    audioPlayer.dispose();
    pageController.dispose();
    currentPageNotifier.dispose();
    super.dispose();
  }

  Future<void> _setupTts() async {
    await flutterTts.awaitSpeakCompletion(true);
    await flutterTts.setLanguage(
      _translationService.isSpanish ? "es-ES" : "en-US",
    );
    await flutterTts.setSpeechRate(0.3);

    String _nameOf(dynamic voice) {
      if (voice is Map && voice['name'] is String) {
        return (voice['name'] as String);
      }
      return (voice?.name?.toString() ?? '');
    }

    String _localeOf(dynamic voice) {
      if (voice is Map && voice['locale'] is String) {
        return (voice['locale'] as String);
      }
      return (voice?.locale?.toString() ?? '');
    }

    try {
      final voices = await flutterTts.getVoices;
      if (voices == null || voices.isEmpty) {
        return;
      }

      dynamic _pickVoice(bool Function(String lowerName) matches) {
        for (final v in voices) {
          final lower = _nameOf(v).toLowerCase();
          if (matches(lower)) {
            return v;
          }
        }
        return voices.first;
      }

      final tommyVoiceData = _pickVoice(
        (n) =>
            n.contains('male') ||
            n.contains('man') ||
            n.contains('michael') ||
            n.contains('daniel') ||
            n.contains('david'),
      );
      tommyVoice = {
        'name': _nameOf(tommyVoiceData),
        'locale': _localeOf(tommyVoiceData),
      };

      final bottleVoiceData = _pickVoice(
        (n) =>
            n.contains('female') ||
            n.contains('woman') ||
            n.contains('samantha') ||
            n.contains('karen'),
      );
      bottleVoice = {
        'name': _nameOf(bottleVoiceData),
        'locale': _localeOf(bottleVoiceData),
      };
    } catch (_) {
      // Best-effort voice setup; ignore failures.
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

    // Speak the current item's name
    if (startIndex < recyclableItems.length) {
      final item = recyclableItems[startIndex];
      final translatedName = _translationService.translate(item['name']);

      await flutterTts.setVoice(tommyVoice);
      await flutterTts.speak(translatedName);
      await Future.delayed(const Duration(milliseconds: 250));
    }

    if (!mounted) {
      return;
    }
    setState(() {
      isPlaying = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    String title = '';
    Widget content;

    switch (widget.pageIndex) {
      case 0:
        title = "What is Recycling?";
        content = _buildWhatIsRecyclingContent();
        break;
      case 1:
        title = "What Can Be Recycled?";
        content = _buildWhatCanBeRecycledContent();
        break;
      case 2:
        title = "Why Should We Recycle?";
        content = _buildWhyRecycleContent();
        break;
      case 3:
        title = "Recycle Quiz";
        content = _buildRecycleQuizContent();
        break;
      default:
        title = "Recycling";
        content = const Center(child: Text("Content not found"));
    }

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text(
          _translationService.translate(title),
          style: const TextStyle(
            fontFamily: 'ComicNeue',
            fontWeight: FontWeight.bold,
            color: Colors.black,
            shadows: [
              Shadow(
                offset: Offset(1.0, 1.0),
                blurRadius: 3.0,
                color: Colors.black45,
              ),
            ],
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: Icon(
              _translationService.isSpanish ? Icons.language : Icons.translate,
              color: Colors.black,
            ),
            onPressed: () {
              flutterTts.stop();
              setState(() {
                _translationService.toggleLanguage();
                isPlaying = false;
              });
              _setupTts();
            },
          ),
        ],
      ),
      body: content,
    );
  }

  Widget _buildWhatIsRecyclingContent() {
    return LayoutBuilder(
      builder: (context, constraints) {
        const top = 250.0;
        const left = 80.0;
        const right = 40.0;
        const bottomReserved = 140.0; // space for bottom buttons
        final availableHeight = (constraints.maxHeight - top - bottomReserved)
            .clamp(140.0, constraints.maxHeight);

        final text = _translationService.translate(
          "Hi! I'm Captain Recycle! Recycling is like giving trash super powers! We take old things like bottles and paper and turn them into new things. It's like magic that helps keep our Earth clean and happy!",
        );

        final fontSize = (constraints.maxWidth * 0.045).clamp(22.0, 34.0);

        return Stack(
          children: [
            // Background Image
            Positioned.fill(
              child: Image.asset(
                'assets/images/recycle/newb.gif',
                fit: BoxFit.cover,
              ),
            ),
            // Text area (bounded + scrollable so it never spills out)
            Positioned(
              top: top,
              left: left,
              right: right,
              child: SizedBox(
                height: availableHeight,
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Padding(
                    padding: const EdgeInsets.only(top: 20),
                    child: Text(
                      text,
                      style: TextStyle(
                        fontSize: fontSize,
                        height: 1.5,
                        fontFamily: 'ComicNeue',
                        color: Colors.black87,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            // Menu buttons at bottom
            Positioned(
              bottom: 20,
              left: 0,
              right: 0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildGradientButton(
                    icon: Icons.home,
                    onPressed: () => Navigator.pop(context),
                  ),
                  _buildGradientButton(icon: Icons.settings, onPressed: () {}),
                  _buildGradientButton(
                    icon: Icons.volume_up,
                    onPressed: () => _speakLines(0),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildBulletPoint(String text) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 20,
        height: 1.4,
        fontFamily: 'ComicNeue',
        color: Colors.black87,
      ),
    );
  }

  Widget _buildWhatCanBeRecycledContent() {
    return StatefulBuilder(
      builder: (context, setState) {
        return Stack(
          children: [
            Positioned.fill(
              child: Image.asset(
                'assets/images/recycle/whatcanbe.png',
                fit: BoxFit.cover,
              ),
            ),
            Column(
              children: [
                Expanded(
                  child: PageView.builder(
                    controller: pageController,
                    itemCount: recyclableItems.length,
                    onPageChanged: (index) {
                      currentPageNotifier.value = index;
                      setState(() {});
                    },
                    itemBuilder: (context, index) {
                      return Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          const SizedBox(height: 180),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16.0,
                              vertical: 8.0,
                            ),
                            child: SizedBox(
                              height: 350,
                              child: Image.asset(
                                recyclableItems[index]['image'],
                                fit: BoxFit.contain,
                              ),
                            ),
                          ),
                          const SizedBox(height: 0),
                          Expanded(
                            flex: 1,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  _translationService.translate(
                                    recyclableItems[index]['name'],
                                  ),
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                    fontSize: 24,
                                    fontFamily: 'ComicNeue',
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 20),
                                GestureDetector(
                                  onTap: () async {
                                    String story = _translationService
                                        .translate(
                                          recyclableItems[index]['story'],
                                        );
                                    if (isPlaying) {
                                      await flutterTts.stop();
                                      setState(() {
                                        isPlaying = false;
                                      });
                                    } else {
                                      setState(() {
                                        isPlaying = true;
                                      });
                                      try {
                                        await flutterTts.setLanguage(
                                          _translationService.isSpanish
                                              ? "es-ES"
                                              : "en-US",
                                        );
                                        await flutterTts.setSpeechRate(
                                          _translationService.isSpanish
                                              ? 0.34
                                              : 0.4,
                                        );
                                        flutterTts.speak(story);
                                      } catch (_) {
                                        if (!mounted) {
                                          return;
                                        }
                                        setState(() {
                                          isPlaying = false;
                                        });
                                      }
                                    }
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 20,
                                      vertical: 10,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Colors.blue.shade100,
                                      borderRadius: BorderRadius.circular(20),
                                      border: Border.all(
                                        color: Colors.blue.shade300,
                                        width: 2,
                                      ),
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Icon(
                                          isPlaying
                                              ? Icons.stop
                                              : Icons.volume_up,
                                          color: Colors.blue.shade700,
                                        ),
                                        const SizedBox(width: 8),
                                        Text(
                                          _translationService.translate(
                                            isPlaying
                                                ? 'Stop Story'
                                                : 'Tap to hear my story!',
                                          ),
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontFamily: 'ComicNeue',
                                            color: Colors.blue.shade700,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 20),
                        ],
                      );
                    },
                  ),
                ),
                // Page Indicator
                ValueListenableBuilder<int>(
                  valueListenable: currentPageNotifier,
                  builder: (context, currentPage, _) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(recyclableItems.length, (
                          index,
                        ) {
                          return Container(
                            width: 12,
                            height: 12,
                            margin: const EdgeInsets.symmetric(horizontal: 4),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color:
                                  currentPage == index
                                      ? Colors.blue.shade700
                                      : Colors.blue.shade200,
                            ),
                          );
                        }),
                      ),
                    );
                  },
                ),
                // Navigation Buttons
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 80,
                    vertical: 20,
                  ),
                  child: ValueListenableBuilder<int>(
                    valueListenable: currentPageNotifier,
                    builder: (context, currentPage, _) {
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          ElevatedButton.icon(
                            onPressed:
                                currentPage > 0
                                    ? () {
                                      pageController.previousPage(
                                        duration: const Duration(
                                          milliseconds: 300,
                                        ),
                                        curve: Curves.easeInOut,
                                      );
                                    }
                                    : null,
                            icon: const Icon(Icons.arrow_back),
                            label: Text(
                              _translationService.translate('Previous'),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue.shade300,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 20,
                                vertical: 12,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                            ),
                          ),
                          ElevatedButton.icon(
                            onPressed:
                                currentPage < recyclableItems.length - 1
                                    ? () {
                                      pageController.nextPage(
                                        duration: const Duration(
                                          milliseconds: 300,
                                        ),
                                        curve: Curves.easeInOut,
                                      );
                                    }
                                    : null,
                            icon: const Icon(Icons.arrow_forward),
                            label: Text(_translationService.translate('Next')),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue.shade300,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 20,
                                vertical: 12,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  Widget _buildWhyRecycleContent() {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          // Background Image
          SizedBox.expand(
            child: Image.asset(
              'assets/images/recycle/learning.png',
              fit: BoxFit.cover,
            ),
          ),
          // Content
          SafeArea(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 30),
                  // Subtitle
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24.0),
                    child: Text(
                      _translationService.translate(
                        "Choose a story to learn why recycling is important!",
                      ),
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'ComicNeue',
                        color: Colors.black,
                        letterSpacing: 1.2,
                        height: 1.5,
                        shadows: [
                          Shadow(
                            offset: Offset(1.0, 1.0),
                            blurRadius: 3.0,
                            color: Color.fromRGBO(255, 255, 255, 0.7),
                          ),
                        ],
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(height: 40),
                  // Story Cards
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Column(
                      children: [
                        _buildStoryCard(
                          title: "Luna the Leaf's Big Idea",
                          icon: Icons.forest,
                          colors: [
                            Colors.green.shade300,
                            Colors.green.shade600,
                          ],
                          onTap:
                              () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder:
                                      (context) => LunaStoryScreen(
                                        translationService: _translationService,
                                      ),
                                ),
                              ),
                        ),
                        const SizedBox(height: 30),
                        _buildStoryCard(
                          title: "Wally the Water Bottle's Second Chance",
                          icon: Icons.water_drop,
                          colors: [Colors.cyan.shade300, Colors.cyan.shade600],
                          onTap:
                              () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder:
                                      (context) => WallyStoryScreen(
                                        translationService: _translationService,
                                      ),
                                ),
                              ),
                        ),
                        const SizedBox(height: 30),
                        _buildStoryCard(
                          title: "Rocky the Robot's Recycling Adventure",
                          icon: Icons.smart_toy,
                          colors: [
                            Colors.purple.shade300,
                            Colors.purple.shade600,
                          ],
                          onTap:
                              () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder:
                                      (context) => StoryDetailScreen(
                                        storyTitle:
                                            "Rocky the Robot's Recycling Adventure",
                                        storyContent: [
                                          "Hi kids! I'm Rocky, a recycling robot from the future! 🤖",
                                          "In my time, we learned how important recycling is for our planet.",
                                          "Did you know? Every item you recycle helps save energy and resources!",
                                          "When we recycle one aluminum can, we save enough energy to power a TV for 3 hours!",
                                          "And when we recycle paper, we save trees that help clean our air!",
                                          "In the future, we have special recycling machines everywhere!",
                                          "But we need YOUR help today to make that future possible!",
                                          "Remember: Every time you recycle, you're a hero for our planet! 🌍✨",
                                        ],
                                        speakers: [
                                          "rocky",
                                          "rocky",
                                          "rocky",
                                          "rocky",
                                          "rocky",
                                          "rocky",
                                          "rocky",
                                          "rocky",
                                        ],
                                        translationService: _translationService,
                                      ),
                                ),
                              ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 30),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStoryCard({
    required String title,
    required IconData icon,
    required List<Color> colors,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        elevation: 8,
        margin: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
        ), // Increased vertical margin
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Container(
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            gradient: LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: colors,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 20.0,
              vertical: 20.0,
            ), // Increased vertical padding
            child: Row(
              children: [
                Icon(icon, size: 40, color: Colors.white),
                const SizedBox(width: 20),
                Expanded(
                  child: Text(
                    _translationService.translate(title),
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontFamily: 'ComicNeue',
                    ),
                  ),
                ),
                const Icon(
                  Icons.arrow_forward_ios,
                  color: Colors.white,
                  size: 24,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildRecycleQuizContent() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(80),
      child: Column(
        children: [
          Text(
            _translationService.translate(
              "Tap the items that can be recycled!",
            ),
            style: const TextStyle(
              fontSize: 18,
              fontFamily: 'ComicNeue',
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.8,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
            ),
            itemCount: recyclableItems.length,
            itemBuilder: (context, index) {
              return Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                color: Colors.blue.shade50,
                child: InkWell(
                  onTap: () async {
                    final isCorrect = recyclableItems[index]['isRecyclable'];

                    // Get current progress
                    int currentProgress = await ProgressService.getProgress(
                      'Recycle',
                    );

                    if (isCorrect) {
                      // Only increment progress if answer is correct and item hasn't been correctly identified before
                      if (currentProgress < index + 1) {
                        await ProgressService.updateProgress(
                          'Recycle',
                          index + 1,
                        );
                      }
                    }

                    // Show feedback
                    if (!mounted) return;
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          _translationService.translate(
                            isCorrect
                                ? "Yes! This can be recycled! ⭐"
                                : "Oops! This cannot be recycled. Try again! 💫",
                          ),
                          style: const TextStyle(fontSize: 16),
                        ),
                        backgroundColor:
                            isCorrect ? Colors.green : Colors.orange,
                        duration: const Duration(seconds: 2),
                      ),
                    );

                    // If all recyclable items have been correctly identified
                    if (isCorrect && currentProgress < index + 1) {
                      int totalRecyclableItems =
                          recyclableItems
                              .where((item) => item['isRecyclable'])
                              .length;
                      int newProgress = await ProgressService.getProgress(
                        'Recycle',
                      );

                      if (newProgress >= totalRecyclableItems) {
                        if (!mounted) return;
                        showDialog(
                          context: context,
                          builder:
                              (context) => AlertDialog(
                                title: const Text('🎉 Congratulations! 🎉'),
                                content: Text(
                                  _translationService.translate(
                                    'You\'ve successfully identified all recyclable items!',
                                  ),
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () => Navigator.pop(context),
                                    child: Text(
                                      _translationService.translate('Continue'),
                                    ),
                                  ),
                                ],
                              ),
                        );
                      }
                    }
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(
                          child: Image.asset(
                            recyclableItems[index]['image'],
                            fit: BoxFit.contain,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          _translationService.translate(
                            recyclableItems[index]['name'],
                          ),
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 16,
                            fontFamily: 'ComicNeue',
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildGradientButton({
    required IconData icon,
    required VoidCallback onPressed,
  }) {
    return Container(
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF5B3B2B), Color(0xFF7B4B35)],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        borderRadius: BorderRadius.circular(25),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            spreadRadius: 1,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: IconButton(
        onPressed: onPressed,
        icon: Container(
          padding: const EdgeInsets.all(12),
          child: Icon(
            icon,
            size: 35,
            color: const Color.fromARGB(255, 255, 250, 250),
          ),
        ),
        padding: EdgeInsets.zero,
      ),
    );
  }
}

class StoryDetailScreen extends StatefulWidget {
  final String storyTitle;
  final List<String> storyContent;
  final List<String> speakers;
  final TranslationService translationService;

  const StoryDetailScreen({
    super.key,
    required this.storyTitle,
    required this.storyContent,
    required this.speakers,
    required this.translationService,
  });

  @override
  State<StoryDetailScreen> createState() => _StoryDetailScreenState();
}

class _StoryDetailScreenState extends State<StoryDetailScreen> with RouteAware {
  final FlutterTts flutterTts = FlutterTts();
  final AudioPlayer audioPlayer = AudioPlayer();
  int currentPage = 0;
  int conversationsPerPage = 2;
  Map<String, String> tommyVoice = {'name': 'default', 'locale': 'en-US'};
  Map<String, String> bottleVoice = {'name': 'default', 'locale': 'en-US'};
  bool isPlaying = false;
  late final TranslationService _translationService;

  @override
  void initState() {
    super.initState();
    _translationService = widget.translationService;
    _setupTts();
    _setupAudio();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final route = ModalRoute.of(context);
    if (route is PageRoute) {
      routeObserver.subscribe(this, route);
    }
  }

  @override
  void didPushNext() {
    _stopNarration();
  }

  @override
  void didUpdateWidget(StoryDetailScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.translationService != widget.translationService) {
      _translationService = widget.translationService;
      _setupTts(); // Update TTS language when translation service changes
      setState(() {}); // Trigger rebuild to update translated text
    }
  }

  @override
  void dispose() {
    routeObserver.unsubscribe(this);
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
    await flutterTts.setLanguage(
      _translationService.isSpanish ? "es-ES" : "en-US",
    );
    await flutterTts.setSpeechRate(0.3);

    String _nameOf(dynamic voice) {
      if (voice is Map && voice['name'] is String) {
        return (voice['name'] as String);
      }
      return (voice?.name?.toString() ?? '');
    }

    String _localeOf(dynamic voice) {
      if (voice is Map && voice['locale'] is String) {
        return (voice['locale'] as String);
      }
      return (voice?.locale?.toString() ?? '');
    }

    try {
      final voices = await flutterTts.getVoices;
      if (voices == null || voices.isEmpty) {
        return;
      }

      dynamic _pickVoice(bool Function(String lowerName) matches) {
        for (final v in voices) {
          final lower = _nameOf(v).toLowerCase();
          if (matches(lower)) {
            return v;
          }
        }
        return voices.first;
      }

      final tommyVoiceData = _pickVoice(
        (n) =>
            n.contains('male') ||
            n.contains('man') ||
            n.contains('michael') ||
            n.contains('daniel') ||
            n.contains('david'),
      );
      tommyVoice = {
        'name': _nameOf(tommyVoiceData),
        'locale': _localeOf(tommyVoiceData),
      };

      final bottleVoiceData = _pickVoice(
        (n) =>
            n.contains('female') ||
            n.contains('woman') ||
            n.contains('samantha') ||
            n.contains('karen'),
      );
      bottleVoice = {
        'name': _nameOf(bottleVoiceData),
        'locale': _localeOf(bottleVoiceData),
      };
    } catch (_) {
      // Best-effort voice setup; ignore failures.
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

    String lastSpeaker = "";
    for (
      int i = startIndex;
      i < startIndex + conversationsPerPage && i < widget.storyContent.length;
      i++
    ) {
      if (!isPlaying) break; // Stop if playing was toggled off

      final line = widget.storyContent[i];
      final speaker = widget.speakers[i];
      final translatedLine = _translationService.translate(line);

      // Short pause when switching speakers
      if (lastSpeaker != "" && lastSpeaker != speaker) {
        await Future.delayed(const Duration(milliseconds: 450));
      }

      // Set appropriate voice based on character
      if (speaker == "tommy") {
        await flutterTts.setVoice(tommyVoice);
      } else if (speaker == "bottle" || speaker == "bobby") {
        await flutterTts.setVoice(bottleVoice);
      } else if (speaker == "narrator") {
        await flutterTts.setVoice({
          'name': 'default',
          'locale': _translationService.isSpanish ? 'es-ES' : 'en-US',
        });
      } else if (speaker == "both") {
        // For the final line, alternate between both voices
        await flutterTts.setVoice(tommyVoice);
        await flutterTts.speak(
          _translationService.translate("Bye! Have a good day kids!"),
        );
        await Future.delayed(const Duration(milliseconds: 800));

        // Play high-five sound effect
        await _playHighFive();
        await Future.delayed(const Duration(milliseconds: 800));

        await flutterTts.setVoice(bottleVoice);
        await flutterTts.speak(
          _translationService.translate("Bye! Have a good day kids!"),
        );
        continue;
      }

      await flutterTts.speak(translatedLine);

      await Future.delayed(const Duration(milliseconds: 250));

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
    final endIndex = (startIndex + conversationsPerPage).clamp(
      0,
      widget.storyContent.length,
    );
    return widget.storyContent.sublist(startIndex, endIndex);
  }

  bool get hasNextPage =>
      (currentPage + 1) * conversationsPerPage < widget.storyContent.length;
  bool get hasPreviousPage => currentPage > 0;

  @override
  Widget build(BuildContext context) {
    final currentLines = getCurrentPageLines();
    final isFirstPage = currentPage == 0;
    final isSecondPage = currentPage == 1;
    final isThirdPage = currentPage == 2;
    final isFourthPage = currentPage == 3;

    return WillPopScope(
      onWillPop: () async {
        await _stopNarration();
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            _translationService.translate(widget.storyTitle),
            style: const TextStyle(
              fontFamily: 'ComicNeue',
              fontWeight: FontWeight.bold,
            ),
          ),
          backgroundColor: Colors.blue.shade100,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.black),
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
                _translationService.isSpanish
                    ? Icons.language
                    : Icons.translate,
                color: Colors.black,
              ),
              onPressed: () {
                _translationService.toggleLanguage();
                setState(() {}); // Force rebuild of the entire screen
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
                    'assets/images/recycle/rocky_pic1.png', // Using a default background image
                    fit: BoxFit.cover,
                  ),
                )
              else if (isSecondPage)
                Positioned.fill(
                  child: Image.asset(
                    'assets/images/recycle/rocky_pic2.png', // Using a default background image
                    fit: BoxFit.cover,
                  ),
                )
              else if (isThirdPage)
                Positioned.fill(
                  child: Image.asset(
                    'assets/images/recycle/rocky_pic3.png', // Using a default background image
                    fit: BoxFit.cover,
                  ),
                )
              else if (isFourthPage)
                Positioned.fill(
                  child: Image.asset(
                    'assets/images/recycle/rocky_pic4.png', // Using a default background image
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
                          final startIndex = currentPage * conversationsPerPage;
                          final line = _translationService.translate(
                            currentLines[index],
                          );
                          final speaker = widget.speakers[startIndex + index];
                          final isTommy = speaker == "tommy";
                          final isNarrator = speaker == "narrator";

                          return Align(
                            alignment:
                                isNarrator
                                    ? Alignment.center
                                    : (isTommy
                                        ? Alignment.centerLeft
                                        : Alignment.centerRight),
                            child: Container(
                              constraints: BoxConstraints(
                                maxWidth:
                                    isNarrator
                                        ? MediaQuery.of(context).size.width *
                                            0.9
                                        : MediaQuery.of(context).size.width *
                                            0.75,
                              ),
                              margin: EdgeInsets.only(
                                bottom: 30,
                                left: isTommy ? 0 : 40,
                                right: isTommy ? 40 : 0,
                                top: index == 0 ? 20 : 0,
                              ),
                              child:
                                  isNarrator
                                      ? Container(
                                        padding: const EdgeInsets.all(16),
                                        decoration: BoxDecoration(
                                          color: Colors.grey.shade200
                                              .withOpacity(0.9),
                                          borderRadius: BorderRadius.circular(
                                            15,
                                          ),
                                        ),
                                        child: Text(
                                          line,
                                          style: const TextStyle(
                                            fontSize: 18,
                                            fontFamily: 'ComicNeue',
                                            fontWeight: FontWeight.bold,
                                            fontStyle: FontStyle.italic,
                                            height: 1.5,
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                      )
                                      : CustomPaint(
                                        painter: CloudBubblePainter(
                                          color:
                                              isTommy
                                                  ? Colors.blue.shade50
                                                      .withOpacity(0.95)
                                                  : Colors.green.shade50
                                                      .withOpacity(0.95),
                                          isLeftAligned: isTommy,
                                        ),
                                        child: Container(
                                          padding: const EdgeInsets.fromLTRB(
                                            20,
                                            16,
                                            20,
                                            24,
                                          ),
                                          child: Text(
                                            line,
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
                              label: Text(
                                _translationService.translate('Previous'),
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blue.shade300,
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 20,
                                  vertical: 12,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                              ),
                            ),
                          ElevatedButton.icon(
                            onPressed:
                                () => _speakLines(
                                  currentPage * conversationsPerPage,
                                ),
                            icon: Icon(
                              isPlaying ? Icons.stop : Icons.volume_up,
                              color: Colors.white,
                            ),
                            label: Text(
                              _translationService.translate(
                                isPlaying ? 'Stop' : 'Listen',
                              ),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  isPlaying
                                      ? Colors.red.shade300
                                      : Colors.blue.shade300,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 20,
                                vertical: 12,
                              ),
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
                              label: Text(
                                _translationService.translate('Next'),
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blue.shade300,
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 20,
                                  vertical: 12,
                                ),
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

  Widget _buildGradientButton({
    required IconData icon,
    required VoidCallback onPressed,
  }) {
    return Container(
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF5B3B2B), Color(0xFF7B4B35)],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        borderRadius: BorderRadius.circular(25),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            spreadRadius: 1,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: IconButton(
        onPressed: onPressed,
        icon: Container(
          padding: const EdgeInsets.all(12),
          child: Icon(
            icon,
            size: 35,
            color: const Color.fromARGB(255, 255, 250, 250),
          ),
        ),
        padding: EdgeInsets.zero,
      ),
    );
  }
}

// Custom painter for cloud-like speech bubbles
class CloudBubblePainter extends CustomPainter {
  final Color color;
  final bool isLeftAligned;

  CloudBubblePainter({required this.color, required this.isLeftAligned});

  @override
  void paint(Canvas canvas, Size size) {
    final paint =
        Paint()
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
    path.quadraticBezierTo(
      size.width + 5,
      size.height / 3,
      size.width - radius,
      size.height - radius,
    );

    // Bottom edge with bumps
    path.quadraticBezierTo(
      size.width * 3 / 4,
      size.height + 5,
      size.width / 2,
      size.height - radius / 2,
    );
    path.quadraticBezierTo(
      size.width / 4,
      size.height - 10,
      radius,
      size.height - radius,
    );

    // Left edge
    path.quadraticBezierTo(-5, size.height / 3, radius, 0);

    // Add tail
    if (isLeftAligned) {
      path.moveTo(30, size.height - radius);
      path.quadraticBezierTo(10, size.height + 10, 0, size.height + 20);
      path.quadraticBezierTo(
        20,
        size.height - radius + 10,
        30,
        size.height - radius,
      );
    } else {
      path.moveTo(size.width - 30, size.height - radius);
      path.quadraticBezierTo(
        size.width - 10,
        size.height + 10,
        size.width,
        size.height + 20,
      );
      path.quadraticBezierTo(
        size.width - 20,
        size.height - radius + 10,
        size.width - 30,
        size.height - radius,
      );
    }

    canvas.drawPath(path, paint);

    // Add subtle shadow
    final shadowPaint =
        Paint()
          ..color = Colors.black.withOpacity(0.1)
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 3);
    canvas.drawPath(path, shadowPaint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
