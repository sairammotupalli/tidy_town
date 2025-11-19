import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'recycle_screen.dart';
import 'compost_screen.dart';
import 'landfill_screen.dart';
import 'waste_sorting_game_selection.dart';
import 'memory_match_game.dart';
import '../services/progress_service.dart';
import '../services/translation_service.dart';
import 'package:lottie/lottie.dart';

class CategoryProgress {
  final String name;
  final int totalQuestions;
  final int completedQuestions;
  final IconData icon;
  final Color color;

  CategoryProgress({
    required this.name,
    required this.totalQuestions,
    required this.completedQuestions,
    required this.icon,
    required this.color,
  });

  double get progress => completedQuestions / totalQuestions;
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final FlutterTts flutterTts = FlutterTts();
  final TranslationService _translationService = TranslationService();
  
  @override
  void initState() {
    super.initState();
    _speakWelcome();
  }

  Future<void> _speakWelcome() async {
    await flutterTts.setSpeechRate(0.3); // slow
    await flutterTts.setPitch(1.3); // kid-friendly pitch (1.0–2.0 is allowed)
    await flutterTts.setLanguage(_translationService.isSpanish ? "es-ES" : "en-US");
    await flutterTts.speak(_translationService.translate("Welcome"));
  }

  void _showLogoutDialog(BuildContext context) {
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
      pageBuilder: (_, __, ___) => const SizedBox(),
      transitionDuration: const Duration(milliseconds: 300),
      transitionBuilder: (context, animation, secondaryAnimation, child) {
        return ScaleTransition(
          scale: CurvedAnimation(
            parent: animation,
            curve: Curves.easeInOutBack,
          ),
          child: AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            title: Text(_translationService.translate('😢 Logout?')),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const CircleAvatar(
                  radius: 30,
                  backgroundImage: AssetImage('assets/images/avatar.png'),
                ),
                const SizedBox(height: 10),
                Text(
                  _translationService.translate('Hey Western! Are you sure you want to logout?'),
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 16),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(); // Close dialog
                },
                child: Text(_translationService.translate('Cancel')),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.redAccent,
                ),
                onPressed: () {
                  Navigator.of(context).pop(); // Close dialog
                  Navigator.pushReplacementNamed(
                    context,
                    '/',
                  ); // Back to welcome
                },
                child: Text(_translationService.translate('Logout')),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildProgressIndicator(CategoryProgress category) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: Column(
        children: [
          ListTile(
            leading: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: category.color.withOpacity(0.2),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(category.icon, color: category.color),
            ),
            title: Text(
              _translationService.translate(category.name),
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 8),
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: LinearProgressIndicator(
                    value: category.progress,
                    backgroundColor: Colors.grey[300],
                    valueColor: AlwaysStoppedAnimation<Color>(category.color),
                    minHeight: 8,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${category.completedQuestions}/${category.totalQuestions} ${_translationService.translate('completed')}',
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 12,
                  ),
                ),
              ],
            ),
            trailing: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: category.color,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              onPressed: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) {
                      switch (category.name) {
                        case 'Recycle':
                          return const RecycleScreen();
                        case 'Compost':
                          return const CompostScreen();
                        case 'Landfill':
                          return const LandfillScreen();
                        case 'Waste Sorting Game':
                          return const WasteSortingGameSelection();
                        default:
                          return const RecycleScreen();
                      }
                    },
                  ),
                );
              },
              child: Text(
                _translationService.translate('Start'),
                style: const TextStyle(color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<List<CategoryProgress>> _buildCategories() async {
    final recycleProgress = await ProgressService.getProgress('Recycle');
    final compostProgress = await ProgressService.getProgress('Compost');
    final landfillProgress = await ProgressService.getProgress('Landfill');
    
    return [
      CategoryProgress(
        name: 'Recycle',
        totalQuestions: 6,
        completedQuestions: recycleProgress,
        icon: Icons.recycling,
        color: Colors.blue,
      ),
      CategoryProgress(
        name: 'Compost',
        totalQuestions: 6,
        completedQuestions: compostProgress,
        icon: Icons.eco,
        color: Colors.green,
      ),
      CategoryProgress(
        name: 'Landfill',
        totalQuestions: 6,
        completedQuestions: landfillProgress,
        icon: Icons.delete_outline,
        color: Colors.grey,
      ),
    ];
  }

  void _showGamesDialog() {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        child: Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                _translationService.translate('🎮 Choose a Game 🎮'),
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF4A3728),
                ),
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const WasteSortingGameSelection(),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        padding: const EdgeInsets.symmetric(vertical: 20),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        elevation: 5,
                      ),
                      child: Text(
                        _translationService.translate('Waste Sorting\nGame'),
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'ComicNeue',
                          color: Colors.white,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                  const SizedBox(width: 15),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const MemoryMatchGame(),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.purple,
                        padding: const EdgeInsets.symmetric(vertical: 20),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        elevation: 5,
                      ),
                      child: Text(
                        _translationService.translate('Memory Match\nGame'),
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'ComicNeue',
                          color: Colors.white,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }

  void _showProgressDialog() async {
    final categories = await _buildCategories();
    
    if (!mounted) return;
    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        child: Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                _translationService.translate('Your Learning Progress'),
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF4A3728),
                ),
              ),
              const SizedBox(height: 20),
              ...categories.map((category) => _buildProgressIndicator(category)),
              const SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text(
          _translationService.translate('Tidy Town'),
          style: const TextStyle(
            fontFamily: 'ComicNeue',
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.green.shade100,
        actions: [
          IconButton(
            icon: Icon(
              _translationService.isSpanish ? Icons.language : Icons.translate,
              color: Colors.green.shade900,
            ),
            onPressed: () {
              setState(() {
                _translationService.toggleLanguage();
              });
            },
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => _showLogoutDialog(context),
          ),
        ],
      ),
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/images/home_back.png',
              fit: BoxFit.fill,
            ),
          ),
          Container(
            width: double.infinity,
            height: double.infinity,
            color: Colors.green.shade50.withOpacity(0.1),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: MediaQuery.of(context).padding.top + kToolbarHeight),
                Lottie.asset(
                  'assets/animations/animal.json',
                  width: 600,
                  height: 600,
                  fit: BoxFit.contain,
                ),
                const SizedBox(height: 60),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 80),
                        child: ElevatedButton(
                          onPressed: _showGamesDialog,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.orange,
                            padding: const EdgeInsets.symmetric(vertical: 32),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(24),
                            ),
                            elevation: 8,
                          ),
                          child: Text(
                            _translationService.translate('PLAY'),
                            style: const TextStyle(
                              fontSize: 42,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'ComicNeue',
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 80),
                        child: ElevatedButton(
                          onPressed: _showProgressDialog,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.orange,
                            padding: const EdgeInsets.symmetric(vertical: 32),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(24),
                            ),
                            elevation: 8,
                          ),
                          child: Text(
                            _translationService.translate('LEARN'),
                            style: const TextStyle(
                              fontSize: 42,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'ComicNeue',
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

}
