import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:lottie/lottie.dart';

import '../../services/translation_service.dart';
import 'package:tidy_town/services/route_observer.dart';

enum _HouseView { story, sorting }

class _StorySlide {
  final String textKey;
  final String imagePath;

  const _StorySlide({required this.textKey, required this.imagePath});
}

class HouseWasteSortingGame extends StatefulWidget {
  const HouseWasteSortingGame({super.key});

  @override
  State<HouseWasteSortingGame> createState() => _HouseWasteSortingGameState();
}

class _HouseWasteSortingGameState extends State<HouseWasteSortingGame>
    with TickerProviderStateMixin, RouteAware {
  FlutterTts _tts = FlutterTts();
  final TranslationService _translationService = TranslationService();

  int score = 0;
  int currentStageIndex = 0;
  int currentItemIndex = 0;
  bool showFeedback = false;
  bool isCorrectAnswer = false;
  bool showCelebration = false;
  bool showSad = false;
  bool _isDraggingItem = false;
  bool _completionDialogShown = false;
  late final AnimationController _celebrationController;
  late final AnimationController _shakeController;

  _HouseView _view = _HouseView.story;
  List<_StorySlide> _storySlides = const [];
  int _storySlideIndex = 0;
  VoidCallback? _onStoryDone;

  final String _bellaNeutralImage =
      'assets/images/House_cleaning_bella_neutral.png';
  final String _bellaHappyImage =
      'assets/images/House_cleaning_bella_happy.png';
  final String _bellaSadImage =
      'assets/images/House_cleaning_bella_disappointed.png';
  final String _bellaIntroImage = 'assets/images/House_cleaing_slide1.png';
  final String _kitchenStoryImage = 'assets/images/House_cleaing_slide2.png';
  final String _kitchenWasteImage = 'assets/images/House_cleaing_slide3.png';
  final String _finalStoryImage = 'assets/images/House_cleaing_slide6.png';

  final List<_HouseStage> _stages = const [
    _HouseStage(
      titleKey: 'Kitchen Cleanup',
      promptKey: 'Kitchen time! Drag each item into the right bin.',
      storyImage: 'assets/images/House_cleaing_slide2.png',
      items: [
        {
          'nameKey': 'Vegetable Peels',
          'image': 'assets/images/game/vegetable_peels_on_table.png',
          'correctBin': 'compost',
          'descriptionKey':
              'Vegetable peels can break down and become healthy compost.',
        },
        {
          'nameKey': 'Plastic Juice Bottle',
          'image': 'assets/images/game/platic_juice_bottle_on_table.png',
          'correctBin': 'recycle',
          'descriptionKey':
              'An empty plastic juice bottle can be recycled into something new.',
        },
        {
          'nameKey': 'Leftover Food',
          'image': 'assets/images/game/leftover_food_on_table.png',
          'correctBin': 'compost',
          'descriptionKey':
              'Leftover food can go to compost instead of the trash.',
        },
        {
          'nameKey': 'Chips Packet',
          'image': 'assets/images/game/chips_packet_on_table.png',
          'correctBin': 'landfill',
          'descriptionKey':
              'Chips packets are mixed materials, so they go to landfill.',
        },
      ],
    ),
    _HouseStage(
      titleKey: 'Bathroom Cleanup',
      promptKey: 'Bathroom time! Be careful and sort each item properly.',
      storyImage: 'assets/images/House_cleaing_slide4.png',
      items: [
        {
          'nameKey': 'Empty Shampoo Bottle',
          'image': 'assets/images/game/shampoo_bottle_in_bathroom.png',
          'correctBin': 'recycle',
          'descriptionKey':
              'An empty shampoo bottle can be rinsed and recycled.',
        },
        {
          'nameKey': 'Cotton Balls',
          'image': 'assets/images/game/cotton_balls_in_bathroom.png',
          'correctBin': 'landfill',
          'descriptionKey': 'Used cotton balls belong in landfill.',
        },
        {
          'nameKey': 'Expired Medicine',
          'image': 'assets/images/game/Expired_medicine_in_bathroom.png',
          'correctBin': 'landfill',
          'descriptionKey':
              'Expired medicine is hazardous and needs safe disposal.',
        },
        {
          'nameKey': 'Cardboard Toilet Roll',
          'image': 'assets/images/game/toilet_role_in_bathroom.png',
          'correctBin': 'recycle',
          'descriptionKey': 'A cardboard toilet roll can be recycled.',
        },
      ],
    ),
    _HouseStage(
      titleKey: 'Living Room Cleanup',
      promptKey: 'Last stop! Sort the living room waste.',
      storyImage: 'assets/images/House_cleaning_slide5.png',
      items: [
        {
          'nameKey': 'Old Newspaper',
          'image': 'assets/images/game/newspaper_in_livingroom.png',
          'correctBin': 'recycle',
          'descriptionKey': 'Old newspaper can become new paper when recycled.',
        },
        {
          'nameKey': 'Broken Plastic Toy',
          'image': 'assets/images/game/broken_toy_in_livingroom.png',
          'correctBin': 'landfill',
          'descriptionKey':
              'Broken plastic toys are usually mixed materials, so they go to landfill.',
        },
        {
          'nameKey': 'Broken Glass',
          'image': 'assets/images/game/Broken_glassframe_in_livingroom.png',
          'correctBin': 'landfill',
          'descriptionKey':
              'Broken picture-frame glass should go to landfill for safety.',
        },
        {
          'nameKey': 'Candy Wrapper',
          'image': 'assets/images/game/candy_wrapper_in_livingroom.png',
          'correctBin': 'landfill',
          'descriptionKey':
              'Candy wrappers are not recyclable in regular bins.',
        },
      ],
    ),
  ];

  List<Map<String, dynamic>> _shuffledItems = [];

  int get _totalItems =>
      _stages.fold<int>(0, (sum, stage) => sum + stage.items.length);

  List<Map<String, dynamic>> get currentItems {
    return _shuffledItems
        .map(
          (item) => {
            'name': _translationService.translate(item['nameKey']),
            'image': item['image'],
            'correctBin': item['correctBin'],
            'description': _translationService.translate(
              item['descriptionKey'],
            ),
          },
        )
        .toList();
  }

  @override
  void initState() {
    super.initState();
    _celebrationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    );
    _shakeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _prepareStage(0);
    _startIntroStory();
  }

  Future<void> _startIntroStory() async {
    await _initializeTts();
    if (!mounted) {
      return;
    }
    _showStorySlides(
      slides: [
        _StorySlide(
          imagePath: _bellaIntroImage,
          textKey:
              "Hi! I'm Bella! 👋\nToday is cleaning day at my house!\n\nWill you help me sort the waste we find in each room?",
        ),
        _StorySlide(
          imagePath: _kitchenStoryImage,
          textKey:
              "Let's start in the kitchen — that's where most of the waste comes from!",
        ),
        _StorySlide(
          imagePath: _kitchenWasteImage,
          textKey: "Oh no, look at all this!\nLet's sort it properly.",
        ),
      ],
      onDone: () {
        _tts.stop();
        setState(() {
          _view = _HouseView.sorting;
        });
      },
    );
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
    _tts.stop();
  }

  Future<void> _initializeTts() async {
    _tts = FlutterTts();
    try {
      await _tts.setLanguage(_translationService.isSpanish ? 'es-ES' : 'en-US');
      await _tts.setSpeechRate(0.38);
      await _tts.setVolume(1.0);
      await _tts.setPitch(1.25);
      try {
        await _tts.awaitSpeakCompletion(true);
      } catch (_) {}
    } catch (_) {}
  }

  Future<void> _speakText(String text) async {
    try {
      await _tts.setLanguage(_translationService.isSpanish ? 'es-ES' : 'en-US');
      await _tts.setSpeechRate(0.38);
      await _tts.setPitch(1.25);
      await _tts.speak(text);
    } catch (_) {}
  }

  Future<void> _speakCurrentStorySlide() async {
    if (_view != _HouseView.story || _storySlides.isEmpty) {
      return;
    }
    try {
      await _tts.stop();
      await _speakText(
        _translationService.translate(_storySlides[_storySlideIndex].textKey),
      );
    } catch (_) {}
  }

  Future<void> _handleLanguageToggle() async {
    setState(() {
      _translationService.toggleLanguage();
    });
    await _initializeTts();
    if (_view == _HouseView.story) {
      await _speakCurrentStorySlide();
    }
  }

  Future<void> _speakTapText(String text) async {
    final wasSpanish = _translationService.isSpanish;
    await _speakText(text);
    if (!mounted) {
      return;
    }
    if (wasSpanish) {
      setState(() {
        _translationService.toggleLanguage();
      });
    }
  }

  void _prepareStage(int stageIndex) {
    currentStageIndex = stageIndex;
    currentItemIndex = 0;
    _shuffledItems = List.from(_stages[stageIndex].items);
    _shuffledItems.shuffle();
  }

  void _showStorySlides({
    required List<_StorySlide> slides,
    required VoidCallback onDone,
  }) {
    setState(() {
      _view = _HouseView.story;
      _storySlides = slides;
      _storySlideIndex = 0;
      _onStoryDone = onDone;
    });
    _speakCurrentStorySlide();
  }

  Future<void> _advanceStorySlide() async {
    if (_view != _HouseView.story || _storySlides.isEmpty) {
      return;
    }
    await _tts.stop();
    if (_storySlideIndex + 1 < _storySlides.length) {
      setState(() {
        _storySlideIndex++;
      });
      await _speakCurrentStorySlide();
      return;
    }

    _onStoryDone?.call();
  }

  void _handleAnswer(String selectedBin) {
    final wasSpanish = _translationService.isSpanish;
    final currentItem = currentItems[currentItemIndex];
    final correctBin = currentItem['correctBin'];

    setState(() {
      showFeedback = true;
      isCorrectAnswer = selectedBin == correctBin;
      if (isCorrectAnswer) {
        score++;
        showCelebration = true;
        _celebrationController.forward(from: 0.0);
      } else {
        showSad = true;
        _shakeController.forward(from: 0.0);
      }
    });

    if (isCorrectAnswer) {
      SystemSound.play(SystemSoundType.click);
      _speakText(_translationService.translate("That's right!"));
    } else {
      SystemSound.play(SystemSoundType.alert);
      _speakText(_translationService.translate('Oops wrong!'));
    }

    Future.delayed(const Duration(milliseconds: 2000), () {
      if (!mounted) {
        return;
      }

      setState(() {
        showFeedback = false;
        showCelebration = false;
        showSad = false;
        currentItemIndex++;
        if (wasSpanish) {
          _translationService.toggleLanguage();
        }
      });

      if (currentItemIndex >= currentItems.length) {
        _handleStageComplete();
      }
    });
  }

  void _handleStageComplete() {
    if (currentStageIndex + 1 < _stages.length) {
      _prepareStage(currentStageIndex + 1);
      final nextStage = _stages[currentStageIndex];
      final slideText =
          currentStageIndex == 1
              ? 'Now to the bathroom! Even here we need to be careful about what goes where.'
              : 'Last stop — the living room! Almost done!';

      _showStorySlides(
        slides: [
          _StorySlide(imagePath: nextStage.storyImage, textKey: slideText),
        ],
        onDone: () {
          _tts.stop();
          setState(() {
            _view = _HouseView.sorting;
          });
        },
      );
      return;
    }

    _showStorySlides(
      slides: [
        _StorySlide(
          imagePath: _finalStoryImage,
          textKey:
              "Amazing! The whole house is clean!\nYou're a waste sorting superstar!",
        ),
      ],
      onDone: _showCompletionDialog,
    );
  }

  void _showCompletionDialog() {
    if (_completionDialogShown) {
      return;
    }
    _completionDialogShown = true;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(_translationService.translate('🏠 House Cleaned!')),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset(
                _bellaHappyImage,
                height: 100,
                errorBuilder: (context, error, stackTrace) {
                  return const Icon(
                    Icons.sentiment_very_satisfied,
                    size: 60,
                    color: Colors.green,
                  );
                },
              ),
              const SizedBox(height: 16),
              Text(
                '${_translationService.translate("Amazing! The whole house is clean! You're a waste sorting superstar!")}\n\n${_translationService.translate('Score: ')}$score/$_totalItems',
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 16),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context).pop();
              },
              child: Text(_translationService.translate('Back to Games')),
            ),
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    routeObserver.unsubscribe(this);
    _tts.stop();
    _celebrationController.dispose();
    _shakeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final stage = _stages[currentStageIndex];
    final showSorting = _view == _HouseView.sorting;
    final currentItem = showSorting ? currentItems[currentItemIndex] : null;
    final binImages = {
      'compost': 'assets/images/game/bin_green.png',
      'recycle': 'assets/images/game/bin_yellow.png',
      'landfill': 'assets/images/game/bin_red.png',
    };
    final binOrder = ['compost', 'recycle', 'landfill'];
    final completedBeforeStage = _stages
        .take(currentStageIndex)
        .fold<int>(0, (sum, s) => sum + s.items.length);
    final isFinalStory =
        !showSorting &&
        currentStageIndex == _stages.length - 1 &&
        currentItemIndex >= _shuffledItems.length;
    final progressValue =
        showSorting
            ? (completedBeforeStage + currentItemIndex) / _totalItems
            : isFinalStory
            ? 1.0
            : completedBeforeStage / _totalItems;

    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Color(0xFFFFE2C8), Color(0xFFFFF8E7)],
              ),
            ),
            child: SafeArea(
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: [
                        IconButton(
                          onPressed: () => Navigator.pop(context),
                          icon: const Icon(
                            Icons.arrow_back,
                            color: Colors.white,
                          ),
                          style: IconButton.styleFrom(
                            backgroundColor: Colors.black.withValues(
                              alpha: 0.3,
                            ),
                          ),
                        ),
                        const Spacer(),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.9),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            '${_translationService.translate('Score: ')}$score/$_totalItems',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        IconButton(
                          onPressed: () {
                            _handleLanguageToggle();
                          },
                          icon: Icon(
                            _translationService.isSpanish
                                ? Icons.language
                                : Icons.translate,
                            color: Colors.white,
                          ),
                          style: IconButton.styleFrom(
                            backgroundColor: Colors.orange.withValues(
                              alpha: 0.75,
                            ),
                          ),
                          tooltip:
                              _translationService.isSpanish
                                  ? 'Switch to English'
                                  : 'Cambiar a Español',
                        ),
                      ],
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 16),
                    child: LinearProgressIndicator(
                      value: progressValue,
                      backgroundColor: Colors.white.withValues(alpha: 0.5),
                      valueColor: const AlwaysStoppedAnimation<Color>(
                        Colors.orange,
                      ),
                      minHeight: 6,
                    ),
                  ),
                  if (showSorting && currentItem != null) ...[
                    Expanded(
                      child: Row(
                        children: [
                          Expanded(
                            flex: 3,
                            child: Container(
                              padding: const EdgeInsets.all(16),
                              child: Column(
                                children: [
                                  Expanded(
                                    flex: 3,
                                    child: _buildImageCard(
                                      imagePath:
                                          showFeedback
                                              ? (isCorrectAnswer
                                                  ? _bellaHappyImage
                                                  : _bellaSadImage)
                                              : _bellaNeutralImage,
                                      fallbackIcon:
                                          showFeedback
                                              ? (isCorrectAnswer
                                                  ? Icons
                                                      .sentiment_very_satisfied
                                                  : Icons
                                                      .sentiment_dissatisfied)
                                              : Icons.person,
                                      fallbackColor:
                                          showFeedback
                                              ? (isCorrectAnswer
                                                  ? Colors.green
                                                  : Colors.orange)
                                              : Colors.deepOrange,
                                    ),
                                  ),
                                  const SizedBox(height: 16),
                                  _buildSpeechBubble(
                                    _translationService.translate(
                                      showFeedback
                                          ? (isCorrectAnswer
                                              ? "Hurray right! That's exactly where it belongs!"
                                              : "Sorry it is wrong! But don't worry, let's try the next one!")
                                          : stage.promptKey,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 2,
                            child: Container(
                              padding: const EdgeInsets.all(16),
                              child: Container(
                                padding: const EdgeInsets.all(20),
                                decoration: _cardDecoration(),
                                child: Column(
                                  children: [
                                    Expanded(
                                      flex: 4,
                                      child: Draggable<Map<String, dynamic>>(
                                        data: currentItem,
                                        dragAnchorStrategy:
                                            pointerDragAnchorStrategy,
                                        onDragStarted: () {
                                          setState(() {
                                            _isDraggingItem = true;
                                          });
                                        },
                                        onDragEnd: (_) {
                                          setState(() {
                                            _isDraggingItem = false;
                                          });
                                        },
                                        onDraggableCanceled: (_, __) {
                                          setState(() {
                                            _isDraggingItem = false;
                                          });
                                        },
                                        feedback: Material(
                                          elevation: 4,
                                          borderRadius: BorderRadius.circular(
                                            16,
                                          ),
                                          child: _buildItemImage(
                                            currentItem,
                                            200,
                                          ),
                                        ),
                                        childWhenDragging: Opacity(
                                          opacity: 0.3,
                                          child: _buildItemImage(
                                            currentItem,
                                            320,
                                          ),
                                        ),
                                        child: GestureDetector(
                                          onTap:
                                              () => _speakTapText(
                                                currentItem['name'],
                                              ),
                                          child: _buildItemImage(
                                            currentItem,
                                            320,
                                          ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      currentItem['name'],
                                      style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black87,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (!showFeedback)
                      Padding(
                        padding: const EdgeInsets.only(
                          bottom: 20.0,
                          left: 16,
                          right: 16,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children:
                              binOrder.map((binType) {
                                return Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 6.0,
                                    ),
                                    child: DragTarget<Map<String, dynamic>>(
                                      builder: (
                                        context,
                                        candidateItems,
                                        rejectedItems,
                                      ) {
                                        final label = _translationService
                                            .translate(
                                              binType == 'recycle'
                                                  ? 'Recycle'
                                                  : binType == 'compost'
                                                  ? 'Compost'
                                                  : 'Landfill',
                                            );

                                        return GestureDetector(
                                          onTap:
                                              _isDraggingItem
                                                  ? null
                                                  : () => _speakTapText(label),
                                          child: Stack(
                                            alignment: Alignment.center,
                                            children: [
                                              Image.asset(
                                                binImages[binType]!,
                                                width: 250,
                                                height: 380,
                                                fit: BoxFit.contain,
                                              ),
                                              Positioned(
                                                bottom: 14,
                                                child: Container(
                                                  padding:
                                                      const EdgeInsets.symmetric(
                                                        horizontal: 14,
                                                        vertical: 8,
                                                      ),
                                                  decoration: BoxDecoration(
                                                    color: Colors.white
                                                        .withValues(alpha: 0.9),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                          14,
                                                        ),
                                                    border: Border.all(
                                                      color: Colors.black
                                                          .withValues(
                                                            alpha: 0.15,
                                                          ),
                                                    ),
                                                  ),
                                                  child: Text(
                                                    label,
                                                    style: const TextStyle(
                                                      fontWeight:
                                                          FontWeight.w800,
                                                      fontSize: 18,
                                                      color: Colors.black87,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        );
                                      },
                                      onWillAcceptWithDetails: (item) => true,
                                      onAcceptWithDetails:
                                          (item) => _handleAnswer(binType),
                                    ),
                                  ),
                                );
                              }).toList(),
                        ),
                      ),
                  ] else
                    Expanded(
                      child: GestureDetector(
                        behavior: HitTestBehavior.opaque,
                        onTap: _advanceStorySlide,
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            children: [
                              Expanded(
                                flex: 3,
                                child: _buildImageCard(
                                  imagePath:
                                      _storySlides.isNotEmpty
                                          ? _storySlides[_storySlideIndex]
                                              .imagePath
                                          : _bellaIntroImage,
                                  fallbackIcon: Icons.home,
                                  fallbackColor: Colors.deepOrange,
                                ),
                              ),
                              const SizedBox(height: 16),
                              Container(
                                width: double.infinity,
                                padding: const EdgeInsets.all(16),
                                decoration: _cardDecoration(),
                                child: Column(
                                  children: [
                                    Text(
                                      _translationService.translate(
                                        _storySlides.isNotEmpty
                                            ? _storySlides[_storySlideIndex]
                                                .textKey
                                            : '',
                                      ),
                                      style: const TextStyle(
                                        fontSize: 20,
                                        color: Colors.black87,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      _translationService.translate(
                                        '(Tap anywhere to continue)',
                                      ),
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.grey.shade700,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
          if (showCelebration)
            Positioned.fill(
              child: Container(
                color: Colors.white,
                child: Center(
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      SizedBox.expand(
                        child: Lottie.asset(
                          'assets/animations/confetti.json',
                          fit: BoxFit.cover,
                          repeat: false,
                        ),
                      ),
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Image.asset(
                            _bellaHappyImage,
                            width: 380,
                            height: 380,
                            fit: BoxFit.contain,
                          ),
                          const SizedBox(height: 16),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 32,
                              vertical: 24,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.green.shade400.withValues(
                                alpha: 0.95,
                              ),
                              borderRadius: BorderRadius.circular(32),
                            ),
                            child: Text(
                              _translationService.translate('Hurray right!'),
                              style: const TextStyle(
                                fontSize: 36,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                fontFamily: 'ComicNeue',
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          if (showSad)
            Positioned.fill(
              child: Container(
                color: Colors.red.shade400.withValues(alpha: 0.95),
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Image.asset(
                        _bellaSadImage,
                        width: 380,
                        height: 380,
                        fit: BoxFit.contain,
                      ),
                      const SizedBox(height: 16),
                      Lottie.asset(
                        'assets/animations/sad.json',
                        width: 300,
                        height: 300,
                        fit: BoxFit.contain,
                        repeat: false,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        _translationService.translate('Oops wrong!!'),
                        style: const TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          fontFamily: 'ComicNeue',
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildImageCard({
    required String imagePath,
    required IconData fallbackIcon,
    required Color fallbackColor,
  }) {
    return Container(
      width: double.infinity,
      decoration: _cardDecoration(),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Image.asset(
          imagePath,
          fit: BoxFit.contain,
          errorBuilder: (context, error, stackTrace) {
            return Container(
              color: fallbackColor,
              child: Icon(fallbackIcon, size: 80, color: Colors.white),
            );
          },
        ),
      ),
    );
  }

  Widget _buildSpeechBubble(String text) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: _cardDecoration(),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: Colors.black87,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _buildItemImage(Map<String, dynamic> currentItem, double size) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Image.asset(
          currentItem['image'],
          fit: BoxFit.contain,
          errorBuilder: (context, error, stackTrace) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.eco, size: 60, color: Colors.grey.shade400),
                const SizedBox(height: 8),
                Text(
                  currentItem['name'],
                  style: TextStyle(
                    color: Colors.grey.shade600,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  BoxDecoration _cardDecoration() {
    return BoxDecoration(
      color: Colors.white.withValues(alpha: 0.95),
      borderRadius: BorderRadius.circular(20),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.12),
          blurRadius: 8,
          offset: const Offset(0, 4),
        ),
      ],
    );
  }
}

class _HouseStage {
  final String titleKey;
  final String promptKey;
  final String storyImage;
  final List<Map<String, dynamic>> items;

  const _HouseStage({
    required this.titleKey,
    required this.promptKey,
    required this.storyImage,
    required this.items,
  });
}
