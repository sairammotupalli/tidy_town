import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:lottie/lottie.dart';
import 'dart:math';
import '../../services/translation_service.dart';

enum _TownView { story, sorting, question }

class _StorySlide {
  final String textKey;
  final String? imagePath;

  const _StorySlide({
    required this.textKey,
    required this.imagePath,
  });
}

class TownWasteSortingGame extends StatefulWidget {
  const TownWasteSortingGame({super.key});

  @override
  State<TownWasteSortingGame> createState() => _TownWasteSortingGameState();
}

class _TownWasteSortingGameState extends State<TownWasteSortingGame> with TickerProviderStateMixin {
  FlutterTts _tts = FlutterTts();
  final TranslationService _translationService = TranslationService();
  final Random _random = Random();

  int score = 0;
  int currentItemIndex = 0;
  int currentStageIndex = 0;
  bool isGameComplete = false;
  bool showFeedback = false;
  bool isCorrectAnswer = false;
  bool showCelebration = false;
  bool showSad = false;
  String? poppingMessage;
  String? sadMessage;
  late final AnimationController _celebrationController;
  late final AnimationController _shakeController;

  // Placeholder character assets (swap when Maya/Coco images are ready)
  final String _mayaNeutralImage = 'assets/images/maya_neutral.png';
  final String _mayaHappyImage = 'assets/images/maya_happy.png';
  final String _mayaSadImage = 'assets/images/maya_sad.png';
  final String _storyFallbackImage = 'assets/images/maya_neutral.png';
  
  _TownView _view = _TownView.story;
  List<_StorySlide> _storySlides = const [];
  int _storySlideIndex = 0;
  VoidCallback? _onStoryDone;

  _TownQuestion? _activeQuestion;
  bool _questionAnswered = false;
  bool _questionWasCorrect = false;
  String? _questionFeedbackKey;
  VoidCallback? _onQuestionContinue;

  // 6-question pool; each run picks any 2 (one after Park, one after Bus Stand).
  late final List<_TownQuestion> _selectedQuestions;

  final List<_TownStage> _stages = [
    _TownStage(
      titleKey: 'Park Cleanup',
      promptKey: 'Let\'s clean the park first!\nDrag each item into the right bin.',
      introKey: 'My school is over, and I\'m walking back home through my town.lets come with me.\n\n.',
      introImage: 'assets/images/maya_walking_to_park.png',
      items: [
        {
          'nameKey': 'Banana Peel',
          'image': 'assets/images/game/banana_peel.png',
          'correctBin': 'compost',
          'descriptionKey': 'A banana peel from the park snack time!',
        },
        {
          'nameKey': 'Apple Core',
          'image': 'assets/images/game/apple_core.png',
          'correctBin': 'compost',
          'descriptionKey': 'An apple core left near the bench!',
        },
        {
          'nameKey': 'Plastic Water Bottle',
          'image': 'assets/images/game/plastic_bottle.png',
          'correctBin': 'recycle',
          'descriptionKey': 'A plastic water bottle left by someone in the park.',
        },
        {
          'nameKey': 'Candy Wrapper',
          'image': 'assets/images/game/candy_wrapper.png',
          'correctBin': 'landfill',
          'descriptionKey': 'A candy wrapper that should be thrown away.',
        },
      ],
      question: _TownQuestion(
        questionKey: '🌱 Which of these can turn into soil and help plants grow?',
        optionsKeys: [
          'Plastic bottle',
          'Banana peel',
          'Candy wrapper',
        ],
        correctIndex: 1,
        correctMessageKey: '🎉 Awesome!\nBanana peels are food waste. They can turn into compost and help plants grow.',
        wrongMessageKey: '❌ Oops!\nThe correct answer is banana peel 🍌\nFood waste breaks down naturally and becomes compost for plants.',
      ),
      followUpStoryKey: null,
    ),
    _TownStage(
      titleKey: 'Bus Stand Cleanup',
      promptKey: 'People wait here every day.\nLet\'s keep the bus stand clean!',
      introKey: 'Next stop… the bus stand!\nI see trash near the bench and signboard.',
      introImage: 'assets/images/maya_walking_to_bustand.png',
      items: [
        {
          'nameKey': 'Paper Napkin',
          'image': 'assets/images/game/paper_napkin.png',
          'correctBin': 'compost',
          'descriptionKey': 'A used paper napkin from the bus stop.',
        },
        {
          'nameKey': 'Newspaper',
          'image': 'assets/images/game/newspaper.png',
          'correctBin': 'recycle',
          'descriptionKey': 'An old newspaper left on the seat.',
        },
        {
          'nameKey': 'Plastic Straw',
          'image': 'assets/images/game/plastic_straw.png',
          'correctBin': 'landfill',
          'descriptionKey': 'A plastic straw that should go to landfill.',
        },
      ],
      question: _TownQuestion(
        questionKey: '♻️ Why should we recycle bottles and cans?',
        optionsKeys: [
          'To make the trash heavier',
          'To reuse materials and save resources',
          'To throw them on the road',
        ],
        correctIndex: 1,
        correctMessageKey: '🌟 Correct!\nRecycling helps reuse materials and saves energy and natural resources.',
        wrongMessageKey: '❌ Sorry!\nThe correct answer is: to reuse materials and save resources.\nRecycling protects our planet 🌍',
      ),
      followUpStoryKey: null,
    ),
    _TownStage(
      titleKey: 'Grocery Store Cleanup',
      promptKey: 'Great job so far!\nLet\'s finish strong!',
      introKey: 'Maya and Coco reach the grocery store.\nThis is the last place to clean!',
      introImage: null,
      items: [
        {
          'nameKey': 'Fruit Peels',
          'image': 'assets/images/game/fruit_peels.png',
          'correctBin': 'compost',
          'descriptionKey': 'Fruit peels from the produce section.',
        },
        {
          'nameKey': 'Cardboard Box',
          'image': 'assets/images/game/cardboard_box.png',
          'correctBin': 'recycle',
          'descriptionKey': 'A cardboard box used for deliveries.',
        },
        {
          'nameKey': 'Glass Bottle',
          'image': 'assets/images/game/glass_bottle.png',
          'correctBin': 'recycle',
          'descriptionKey': 'A glass bottle that can be recycled.',
        },
        {
          'nameKey': 'Plastic Carry Bag',
          'image': 'assets/images/game/plastic_bag.png',
          'correctBin': 'landfill',
          'descriptionKey': 'A plastic carry bag that should be disposed safely.',
        },
      ],
      question: null,
      followUpStoryKey: null,
    ),
  ];

  List<Map<String, dynamic>> _shuffledItems = [];

  List<Map<String, dynamic>> get currentItems {
    return _shuffledItems.map((item) => {
      'name': _translationService.translate(item['nameKey']),
      'image': item['image'],
      'correctBin': item['correctBin'],
      'description': _translationService.translate(item['descriptionKey']),
    }).toList();
  }

  @override
  void initState() {
    super.initState();
    final questionPool = <_TownQuestion>[
      // Q1
  const _TownQuestion(
    questionKey: '🌱 Which of these can turn into soil and help plants grow?',
    optionsKeys: ['Plastic bottle', 'Banana peel', 'Candy wrapper'],
    correctIndex: 1,
    correctMessageKey:
        '🎉 Awesome!\nBanana peels are food waste. They can turn into compost and help plants grow.',
    wrongMessageKey:
        '❌ Oops!\nThe correct answer is banana peel 🍌\nFood waste breaks down naturally and becomes compost for plants.',
  ),

  // Q2
  const _TownQuestion(
    questionKey: '♻️ Why should we recycle bottles and cans?',
    optionsKeys: [
      'To make the trash heavier',
      'To reuse materials and save resources',
      'To throw them on the road',
    ],
    correctIndex: 1,
    correctMessageKey:
        '🌟 Correct!\nRecycling helps reuse materials and saves energy and natural resources.',
    wrongMessageKey:
        '❌ Sorry!\nThe correct answer is: to reuse materials and save resources.\nRecycling protects our planet 🌍',
  ),

  // Q3 (GK)
  const _TownQuestion(
    questionKey: '🌱 What happens to food waste when it becomes compost?',
    optionsKeys: [
      'It turns into soil for plants',
      'It becomes plastic',
      'It disappears into the air',
    ],
    correctIndex: 0,
    correctMessageKey:
        '✅ Correct!\nCompost turns food waste into soil that helps plants grow.',
    wrongMessageKey:
        '❌ Not quite.\nFood waste turns into soil that helps plants grow.',
  ),

  // Q4 (GK)
  const _TownQuestion(
    questionKey: '♻️ What usually happens to recycled items?',
    optionsKeys: [
      'They are made into new things',
      'They are burned',
      'They stay the same forever',
    ],
    correctIndex: 0,
    correctMessageKey:
        '✅ Correct!\nRecycled items can be made into new products.',
    wrongMessageKey:
        '❌ Oops!\nRecycled items are used to make new products.',
  ),

  // Q5 (GK)
  const _TownQuestion(
    questionKey: '🌍 Why is too much trash bad for the Earth?',
    optionsKeys: [
      'It can pollute land and water',
      'It makes the Earth bigger',
      'It helps animals',
    ],
    correctIndex: 0,
    correctMessageKey:
        '✅ Correct!\nToo much trash can pollute land and water.',
    wrongMessageKey:
        '❌ Not this one.\nToo much trash can pollute land and water.',
  ),

  // Q6 (GK)
  const _TownQuestion(
    questionKey: '⏳ Which item breaks down faster in nature?',
    optionsKeys: [
      'Fruit peel',
      'Plastic bag',
      'Glass bottle',
    ],
    correctIndex: 0,
    correctMessageKey:
        '✅ Correct!\nFruit peels break down faster than plastic or glass.',
    wrongMessageKey:
        '❌ Not quite.\nFruit peels break down faster than plastic or glass.',
  ),
];

    questionPool.shuffle(_random);
    _selectedQuestions = questionPool.take(2).toList(growable: false);

    _initializeTts();
    _celebrationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    );
    _shakeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );

    _prepareStage(0);
    _showStorySlides(
      slides: const [
        _StorySlide(
          imagePath: 'assets/images/maya_intro.png',
          textKey: 'Hi kids! 👋\nI’m Maya.\n\nTap the screen to start our town adventure! ✨',
        ),
        _StorySlide(
          imagePath: 'assets/images/maya_happy.png',
          textKey:
              'School is over, and I’m walking back home through my town.\n\nCome along with me… let’s keep our town clean and happy! ✨',
        ),
        _StorySlide(
          imagePath: 'assets/images/maya_walking_to_park.png',
          textKey:
              'This is the park we have in our town.\nIt’s famous for its big green trees, colorful flowers, and a fun play area.\n\nOn holidays and weekends, kids gather here to laugh, run, and play together!',
        ),
        _StorySlide(
          imagePath: 'assets/images/maya_sad.png',
          textKey:
              'Oh no! Look… there’s some waste on the ground.\n\nSo sad to see trash in such a beautiful place.',
        ),
      ],
      onDone: () {
        setState(() {
          _view = _TownView.sorting;
        });
        _speakText(_translationService.translate("Let's clean the park first!"));
      },
    );
  }

  Future<void> _initializeTts() async {
    _tts = FlutterTts();
    try {
      await _tts.setLanguage(_translationService.isSpanish ? 'es-ES' : 'en-US');
      await _tts.setSpeechRate(0.35);
      await _tts.setVolume(1.0);
      await _tts.setPitch(1.0);
      try {
        await _tts.awaitSpeakCompletion(true);
      } catch (_) {}
    } catch (_) {
      // Ignore TTS init errors
    }
  }

  Future<void> _speakText(String text) async {
    try {
      await _tts.setLanguage(_translationService.isSpanish ? 'es-ES' : 'en-US');
      await _tts.speak(text);
    } catch (_) {
      // Ignore speak errors
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
      _view = _TownView.story;
      _storySlides = slides;
      _storySlideIndex = 0;
      _onStoryDone = onDone;
      _activeQuestion = null;
      _questionAnswered = false;
      _questionFeedbackKey = null;
      _onQuestionContinue = null;
    });
  }

  void _advanceStorySlide() {
    if (_view != _TownView.story || _storySlides.isEmpty) {
      return;
    }
    if (_storySlideIndex + 1 < _storySlides.length) {
      setState(() {
        _storySlideIndex++;
      });
      return;
    }

    final done = _onStoryDone;
    if (done != null) {
      done();
    }
  }

  void _showQuestion(_TownQuestion question, VoidCallback onContinue) {
    setState(() {
      _view = _TownView.question;
      _activeQuestion = question;
      _questionAnswered = false;
      _questionWasCorrect = false;
      _questionFeedbackKey = null;
      _onQuestionContinue = onContinue;
    });
  }

  void _handleQuestionAnswer(int selectedIndex) {
    if (_activeQuestion == null || _questionAnswered) {
      return;
    }

    final isCorrect = selectedIndex == _activeQuestion!.correctIndex;
    setState(() {
      _questionAnswered = true;
      _questionWasCorrect = isCorrect;
      _questionFeedbackKey = isCorrect
          ? _activeQuestion!.correctMessageKey
          : _activeQuestion!.wrongMessageKey;
    });
  }

  void _handleAnswer(String selectedBin) {
    final currentItem = currentItems[currentItemIndex];
    final correctBin = currentItem['correctBin'];

    setState(() {
      showFeedback = true;
      isCorrectAnswer = selectedBin == correctBin;
      if (isCorrectAnswer) {
        score++;
        showCelebration = true;
        poppingMessage = _translationService.translate('Hurray right!');
        _celebrationController.forward(from: 0.0);
      } else {
        showSad = true;
        sadMessage = _translationService.translate('Oops wrong!!');
        _shakeController.forward(from: 0.0);
      }
    });

    if (isCorrectAnswer) {
      SystemSound.play(SystemSoundType.click);
      _speakText(_translationService.translate('That\'s right!'));
    } else {
      SystemSound.play(SystemSoundType.alert);
      _speakText(_translationService.translate('Oops wrong!'));
    }

    Future.delayed(const Duration(milliseconds: 2000), () async {
      if (!mounted) {
        return;
      }

      setState(() {
        showFeedback = false;
        showCelebration = false;
        showSad = false;
        poppingMessage = null;
        sadMessage = null;
        currentItemIndex++;
      });

      if (currentItemIndex >= currentItems.length) {
        await _handleStageComplete();
      }
    });
  }

  Future<void> _handleStageComplete() async {
    final stage = _stages[currentStageIndex];
    // Ask 2 random questions per run: after Park (stage 0) and after Bus Stand (stage 1).
    if (currentStageIndex == 0) {
      _showQuestion(_selectedQuestions[0], () {
        _advanceAfterStageQuestion(stage);
      });
      return;
    }
    if (currentStageIndex == 1) {
      _showQuestion(_selectedQuestions[1], () {
        _advanceAfterStageQuestion(stage);
      });
      return;
    }

    _advanceAfterStageQuestion(stage);
  }

  void _advanceAfterStageQuestion(_TownStage stage) {
    if (currentStageIndex + 1 < _stages.length) {
      setState(() {
        _prepareStage(currentStageIndex + 1);
      });
      final nextStage = _stages[currentStageIndex];
      if (nextStage.introImage != null) {
        if (currentStageIndex == 1) {
          // Bus stand story (after Park + Q1)
          _showStorySlides(
            slides: const [
              _StorySlide(
                imagePath: 'assets/images/maya_walking_to_bustand.png',
                textKey:
                    'Next stop… the bus stand! 🚏\n\nLots of people wait here for the bus.',
              ),
              _StorySlide(
                imagePath: 'assets/images/maya_walking_to_bustand.png',
                textKey:
                    'I see trash near the bus stop bench and signboard.\n\nOh no… it looks messy.',
              ),
              _StorySlide(
                imagePath: 'assets/images/maya_sad.png',
                textKey:
                    'Trash can make this place dirty and unsafe.\n\nLet’s help keep the bus stand clean!',
              ),
              _StorySlide(
                imagePath: 'assets/images/maya_happy.png',
                textKey:
                    'Let’s keep this place clean!\n\nSort each item into the right bin ✅',
              ),
            ],
            onDone: () {
              setState(() {
                _view = _TownView.sorting;
              });
            },
          );
        } else {
          // Fallback: keep existing single-scene screen
          _showStorySlides(
            slides: [
              _StorySlide(
                imagePath: nextStage.introImage,
                textKey: nextStage.introKey,
              ),
              const _StorySlide(
                imagePath: 'assets/images/maya_happy.png',
                textKey: 'Ready? Let’s sort the next items! ✅',
              ),
            ],
            onDone: () {
              setState(() {
                _view = _TownView.sorting;
              });
            },
          );
        }
      } else {
        if (currentStageIndex == 2) {
          // Grocery store story (after Bus + Q2)
          _showStorySlides(
            slides: const [
              _StorySlide(
                imagePath: 'assets/images/maya_seeing_cat.png',
                textKey:
                    'Meow! 🐱\nA small cat walks up.',
              ),
              _StorySlide(
                imagePath: 'assets/images/maya_petting_cat.png',
                textKey:
                    'Hi kitty! I’ll call you Coco 🐱\n\nCoco is my friend.\nLet’s go together! 💛',
              ),
              _StorySlide(
                imagePath: 'assets/images/maya_walking_to_grocery.png',
                textKey:
                    'Now we reach the grocery store. 🏪\n\nThis is our last stop!',
              ),
              _StorySlide(
                imagePath: 'assets/images/maya_sad.png',
                textKey:
                    'Uh oh… more waste near the entrance.\n\nLet’s put it in the right bin!',
              ),
              _StorySlide(
                imagePath: 'assets/images/maya_happy.png',
                textKey:
                    'Great job!\nLet’s finish strong!\n\nSort the last items ✅',
              ),
            ],
            onDone: () {
              setState(() {
                _view = _TownView.sorting;
              });
            },
          );
        } else {
          setState(() {
            _view = _TownView.sorting;
          });
        }
      }
      return;
    }

    setState(() {
      isGameComplete = true;
    });
    _showCompletionDialog();
  }

  void _showCompletionDialog() {
    _speakText(_translationService.translate('You did it! Our town is clean and happy!'));
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(_translationService.translate('🎉 Town Cleaned!')),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset(
                _mayaHappyImage,
                height: 100,
                errorBuilder: (context, error, stackTrace) {
                  return const Icon(Icons.sentiment_very_satisfied, size: 60, color: Colors.green);
                },
              ),
              const SizedBox(height: 16),
              Text(
                '${_translationService.translate('You did it! Because of you, our town is clean and happy!')}\n\n${_translationService.translate('Badge Earned: Town Clean Champion')}\n\n${_translationService.translate('Score: ')}$score/${_stages.fold<int>(0, (sum, stage) => sum + stage.items.length)}',
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
    _tts.stop();
    _celebrationController.dispose();
    _shakeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (isGameComplete) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    final stage = _stages[currentStageIndex];
    final showSorting = _view == _TownView.sorting;
    final showQuestion = _view == _TownView.question;

    final binImages = {
      'compost': 'assets/images/game/bin_green.png',
      'recycle': 'assets/images/game/bin_yellow.png',
      'landfill': 'assets/images/game/bin_red.png',
    };
    final binOrder = ['compost', 'recycle', 'landfill'];

    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/maya_town_background.png'),
                fit: BoxFit.cover,
              ),
            ),
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.cyan.withOpacity(0.1),
                    Colors.blue.withOpacity(0.2),
                  ],
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
                            icon: const Icon(Icons.arrow_back, color: Colors.white),
                            style: IconButton.styleFrom(
                              backgroundColor: Colors.black.withOpacity(0.3),
                            ),
                          ),
                          const Spacer(),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.9),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              '${_translationService.translate('Score: ')}$score/${_stages.fold<int>(0, (sum, stage) => sum + stage.items.length)}',
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
                              setState(() {
                                _translationService.toggleLanguage();
                                _initializeTts();
                              });
                            },
                            icon: Icon(
                              _translationService.isSpanish ? Icons.language : Icons.translate,
                              color: Colors.white,
                            ),
                            style: IconButton.styleFrom(
                              backgroundColor: Colors.cyan.withOpacity(0.7),
                            ),
                            tooltip: _translationService.isSpanish ? 'Switch to English' : 'Cambiar a Español',
                          ),
                        ],
                      ),
                    ),

                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 16),
                      child: LinearProgressIndicator(
                        value: (currentItemIndex + _stages.take(currentStageIndex).fold<int>(0, (sum, s) => sum + s.items.length)) /
                            _stages.fold<int>(0, (sum, s) => sum + s.items.length),
                        backgroundColor: Colors.white.withOpacity(0.3),
                        valueColor: const AlwaysStoppedAnimation<Color>(Colors.orange),
                        minHeight: 6,
                      ),
                    ),

                    if (showSorting) ...[
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
                                      child: Container(
                                        width: double.infinity,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(20),
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.black.withOpacity(0.2),
                                              blurRadius: 10,
                                              offset: const Offset(0, 5),
                                            ),
                                          ],
                                        ),
                                        child: ClipRRect(
                                          borderRadius: BorderRadius.circular(20),
                                          child: Image.asset(
                                            showFeedback
                                                ? (isCorrectAnswer
                                                    ? _mayaHappyImage
                                                    : _mayaSadImage)
                                                : _mayaNeutralImage,
                                            fit: BoxFit.contain,
                                            errorBuilder: (context, error, stackTrace) {
                                              return Container(
                                                decoration: BoxDecoration(
                                                  color: showFeedback
                                                      ? (isCorrectAnswer ? Colors.green : Colors.orange)
                                                      : Colors.cyan,
                                                  borderRadius: BorderRadius.circular(20),
                                                ),
                                                child: Icon(
                                                  showFeedback
                                                      ? (isCorrectAnswer
                                                          ? Icons.sentiment_very_satisfied
                                                          : Icons.sentiment_dissatisfied)
                                                      : Icons.person,
                                                  size: 80,
                                                  color: Colors.white,
                                                ),
                                              );
                                            },
                                          ),
                                        ),
                                      ),
                                    ),

                                    const SizedBox(height: 16),

                                    Container(
                                      width: double.infinity,
                                      padding: const EdgeInsets.all(16),
                                      decoration: BoxDecoration(
                                        color: Colors.white.withOpacity(0.95),
                                        borderRadius: BorderRadius.circular(20),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.black.withOpacity(0.1),
                                            blurRadius: 8,
                                            offset: const Offset(0, 4),
                                          ),
                                        ],
                                      ),
                                      child: Text(
                                        _translationService.translate(
                                          showFeedback
                                              ? (isCorrectAnswer
                                                  ? "Hurray right! That's exactly where it belongs!"
                                                  : "Sorry it is wrong! But don't worry, let's try the next one!")
                                              : stage.promptKey,
                                        ),
                                        style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.black87,
                                        ),
                                        textAlign: TextAlign.center,
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
                                  decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(0.95),
                                    borderRadius: BorderRadius.circular(20),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.2),
                                        blurRadius: 10,
                                        offset: const Offset(0, 5),
                                      ),
                                    ],
                                  ),
                                  child: Column(
                                    children: [
                                      Expanded(
                                        flex: 4,
                                        child: Draggable<Map<String, dynamic>>(
                                          data: currentItems[currentItemIndex],
                                          dragAnchorStrategy: pointerDragAnchorStrategy,
                                          feedback: Material(
                                            elevation: 4,
                                            borderRadius: BorderRadius.circular(16),
                                            child: Container(
                                              width: 200,
                                              height: 200,
                                              decoration: BoxDecoration(
                                                color: Colors.white,
                                                borderRadius: BorderRadius.circular(16),
                                              ),
                                              child: Padding(
                                                padding: const EdgeInsets.all(12.0),
                                                child: Image.asset(
                                                  currentItems[currentItemIndex]['image'],
                                                  fit: BoxFit.contain,
                                                ),
                                              ),
                                            ),
                                          ),
                                          childWhenDragging: Opacity(
                                            opacity: 0.3,
                                            child: Container(
                                              width: 320,
                                              height: 320,
                                              decoration: BoxDecoration(
                                                color: Colors.grey.shade100,
                                                borderRadius: BorderRadius.circular(16),
                                                border: Border.all(color: Colors.grey.shade300),
                                              ),
                                              child: Padding(
                                                padding: const EdgeInsets.all(12.0),
                                                child: Image.asset(
                                                  currentItems[currentItemIndex]['image'],
                                                  fit: BoxFit.contain,
                                                ),
                                              ),
                                            ),
                                          ),
                                          child: Container(
                                            width: 320,
                                            height: 320,
                                            decoration: BoxDecoration(
                                              color: Colors.grey.shade100,
                                              borderRadius: BorderRadius.circular(16),
                                              border: Border.all(color: Colors.grey.shade300),
                                            ),
                                            child: Padding(
                                              padding: const EdgeInsets.all(12.0),
                                              child: Image.asset(
                                                currentItems[currentItemIndex]['image'],
                                                fit: BoxFit.contain,
                                                errorBuilder: (context, error, stackTrace) {
                                                  return Column(
                                                    mainAxisAlignment: MainAxisAlignment.center,
                                                    children: [
                                                      Icon(
                                                        Icons.eco,
                                                        size: 60,
                                                        color: Colors.grey.shade400,
                                                      ),
                                                      const SizedBox(height: 8),
                                                      Text(
                                                        currentItems[currentItemIndex]['name'],
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
                                          ),
                                        ),
                                      ),

                                      const SizedBox(height: 8),

                                      Text(
                                        currentItems[currentItemIndex]['name'],
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

                      if (!showFeedback) ...[
                        Padding(
                          padding: const EdgeInsets.only(bottom: 20.0, left: 16, right: 16),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: binOrder.map((binType) {
                              return Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 6.0),
                                  child: DragTarget<Map<String, dynamic>>(
                                    builder: (context, candidateItems, rejectedItems) {
                                      final label = _translationService.translate(
                                        binType == 'recycle'
                                            ? 'Recycle'
                                            : binType == 'compost'
                                                ? 'Compost'
                                                : 'Landfill',
                                      );

                                      return Stack(
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
                                              padding: const EdgeInsets.symmetric(
                                                horizontal: 14,
                                                vertical: 8,
                                              ),
                                              decoration: BoxDecoration(
                                                color: Colors.white.withOpacity(0.9),
                                                borderRadius: BorderRadius.circular(14),
                                                border: Border.all(
                                                  color: Colors.black.withOpacity(0.15),
                                                ),
                                                boxShadow: [
                                                  BoxShadow(
                                                    color: Colors.black.withOpacity(0.12),
                                                    blurRadius: 6,
                                                    offset: const Offset(0, 3),
                                                  ),
                                                ],
                                              ),
                                              child: Text(
                                                label,
                                                style: const TextStyle(
                                                  fontWeight: FontWeight.w800,
                                                  fontSize: 18,
                                                  color: Colors.black87,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      );
                                    },
                                    onWillAccept: (item) => true,
                                    onAccept: (item) {
                                      _handleAnswer(binType);
                                    },
                                  ),
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                      ],
                    ] else ...[
                      Expanded(
                        child: GestureDetector(
                          behavior: HitTestBehavior.opaque,
                          onTap: () {
                            if (!showQuestion) {
                              _advanceStorySlide();
                              return;
                            }
                            // After showing the question result (right or wrong), wait for a tap anywhere to continue.
                            if (_questionAnswered) {
                              final cb = _onQuestionContinue;
                              if (cb != null) {
                                cb();
                              }
                            }
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              children: [
                                Expanded(
                                  flex: 3,
                                  child: Container(
                                    width: double.infinity,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withOpacity(0.2),
                                          blurRadius: 10,
                                          offset: const Offset(0, 5),
                                        ),
                                      ],
                                    ),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(20),
                                      child: Image.asset(
                                        showQuestion
                                          ? (_questionAnswered
                                              ? (_questionWasCorrect ? _mayaHappyImage : _mayaNeutralImage)
                                              : 'assets/images/maya_questioning.png')
                                            : (_storySlides.isNotEmpty
                                                ? (_storySlides[_storySlideIndex].imagePath ?? _storyFallbackImage)
                                                : _storyFallbackImage),
                                        fit: BoxFit.contain,
                                        errorBuilder: (context, error, stackTrace) {
                                          return Container(
                                            color: Colors.cyan,
                                            child: const Icon(Icons.person, size: 80, color: Colors.white),
                                          );
                                        },
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 16),
                                Container(
                                  width: double.infinity,
                                  padding: const EdgeInsets.all(16),
                                  decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(0.95),
                                    borderRadius: BorderRadius.circular(20),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.1),
                                        blurRadius: 8,
                                        offset: const Offset(0, 4),
                                      ),
                                    ],
                                  ),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.stretch,
                                    children: [
                                      Text(
                                        _translationService.translate(showQuestion ? 'Question' : ''),
                                        style: const TextStyle(
                                          fontSize: 22,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black87,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                      const SizedBox(height: 12),
                                      Text(
                                        _translationService.translate(
                                          showQuestion
                                              ? (_activeQuestion?.questionKey ?? '')
                                              : (_storySlides.isNotEmpty
                                                  ? _storySlides[_storySlideIndex].textKey
                                                  : ''),
                                        ),
                                        style: const TextStyle(
                                          fontSize: 20,
                                          color: Colors.black87,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                      if (!showQuestion && _storySlides.isNotEmpty) ...[
                                        const SizedBox(height: 8),
                                        Text(
                                          _translationService.translate('(Tap anywhere to continue)'),
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: Colors.grey.shade700,
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                      ],
                                      if (showQuestion && _questionFeedbackKey != null) ...[
                                        const SizedBox(height: 12),
                                        Text(
                                          _translationService.translate(_questionFeedbackKey!),
                                          style: const TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.w600,
                                            color: Colors.black87,
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                      ],
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      if (showQuestion && _activeQuestion != null) ...[
                        Padding(
                          padding: const EdgeInsets.only(bottom: 20.0, left: 16, right: 16),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: _activeQuestion!.optionsKeys.asMap().entries.map((entry) {
                              final index = entry.key;
                              final optionKey = entry.value;
                              return Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 6.0),
                                  child: GestureDetector(
                                    onTap: _questionAnswered
                                        ? null
                                        : () => _handleQuestionAnswer(index),
                                    child: AnimatedContainer(
                                      duration: const Duration(milliseconds: 200),
                                      padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 12),
                                      decoration: BoxDecoration(
                                        color: _questionAnswered
                                            ? Colors.grey.shade200
                                            : Colors.white.withOpacity(0.95),
                                        borderRadius: BorderRadius.circular(16),
                                        border: Border.all(
                                          color: Colors.orange.shade400,
                                          width: 2,
                                        ),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.black.withOpacity(0.15),
                                            blurRadius: 8,
                                            offset: const Offset(0, 4),
                                          ),
                                        ],
                                      ),
                                      child: Center(
                                        child: Text(
                                          _translationService.translate(optionKey),
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 14,
                                            color: Colors.black87,
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                      ],
                    ],
                  ],
                ),
              ),
            ),
          ),
          if (showCelebration && poppingMessage != null)
            Positioned(
              left: 0,
              top: 0,
              right: 0,
              bottom: 0,
              child: Container(
                color: Colors.white,
                child: Center(
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      AnimatedScale(
                        scale: showCelebration ? 1.2 : 0.0,
                        duration: const Duration(milliseconds: 8000),
                        curve: Curves.elasticOut,
                        child: SizedBox.expand(
                          child: Lottie.asset(
                            'assets/animations/confetti.json',
                            fit: BoxFit.cover,
                            repeat: false,
                            width: double.infinity,
                            height: double.infinity,
                          ),
                        ),
                      ),
                      AnimatedScale(
                        scale: showCelebration ? 1.2 : 0.0,
                        duration: const Duration(milliseconds: 8000),
                        curve: Curves.elasticOut,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(24),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.15),
                                    blurRadius: 12,
                                    offset: const Offset(0, 4),
                                  ),
                                ],
                              ),
                              padding: const EdgeInsets.all(12),
                              child: Image.asset(
                                _mayaHappyImage,
                                width: 380,
                                height: 380,
                                fit: BoxFit.contain,
                              ),
                            ),
                            const SizedBox(height: 16),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 24),
                              decoration: BoxDecoration(
                                color: Colors.green.shade400.withOpacity(0.95),
                                borderRadius: BorderRadius.circular(32),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.15),
                                    blurRadius: 12,
                                    offset: const Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: Text(
                                _translationService.translate('Hurray right!'),
                                style: const TextStyle(
                                  fontSize: 36,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                  fontFamily: 'ComicNeue',
                                  shadows: [
                                    Shadow(
                                      offset: Offset(2, 2),
                                      blurRadius: 4,
                                      color: Colors.black26,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          if (showSad && sadMessage != null)
            Positioned(
              left: 0,
              top: 0,
              right: 0,
              bottom: 0,
              child: Container(
                color: Colors.red.shade400.withOpacity(0.95),
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(24),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.15),
                              blurRadius: 12,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        padding: const EdgeInsets.all(12),
                        child: Image.asset(
                          _mayaSadImage,
                          width: 380,
                          height: 380,
                          fit: BoxFit.contain,
                        ),
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
                          shadows: [
                            Shadow(
                              offset: Offset(2, 2),
                              blurRadius: 4,
                              color: Colors.black26,
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
    );
  }
}

class _TownStage {
  final String titleKey;
  final String promptKey;
  final String introKey;
  final String? introImage;
  final List<Map<String, dynamic>> items;
  final _TownQuestion? question;
  final String? followUpStoryKey;

  const _TownStage({
    required this.titleKey,
    required this.promptKey,
    required this.introKey,
    required this.introImage,
    required this.items,
    required this.question,
    required this.followUpStoryKey,
  });
}

class _TownQuestion {
  final String questionKey;
  final List<String> optionsKeys;
  final int correctIndex;
  final String correctMessageKey;
  final String wrongMessageKey;

  const _TownQuestion({
    required this.questionKey,
    required this.optionsKeys,
    required this.correctIndex,
    required this.correctMessageKey,
    required this.wrongMessageKey,
  });
}
