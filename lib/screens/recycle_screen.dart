import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import '../services/translation_service.dart';

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
        builder: (context) => RecycleDetailScreen(
          pageIndex: index,
          translationService: _translationService,
        ),
      ),
    );
  }

  Widget _buildCard(BuildContext context, {
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
              colors: [
                color.withOpacity(0.7),
                color,
              ],
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 50,
                color: Colors.white,
              ),
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
                  color: Colors.white,
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
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: Icon(
              _translationService.isSpanish ? Icons.language : Icons.translate,
              color: Colors.blue.shade900,
            ),
            onPressed: () {
              setState(() {
                _translationService.toggleLanguage();
              });
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Colors.blue.shade50, Colors.white],
                ),
              ),
              child: LayoutBuilder(
                builder: (context, constraints) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 40.0),
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
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(25),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildGradientButton(
                  icon: Icons.person,
                  onPressed: () => _showLogoutDialog(),
                ),
                _buildGradientButton(
                  icon: Icons.home,
                  onPressed: () => Navigator.pop(context),
                ),
                _buildGradientButton(
                  icon: Icons.settings,
                  onPressed: () {},
                ),
                _buildGradientButton(
                  icon: Icons.volume_up,
                  onPressed: () {},
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(_translationService.translate('😢 Logout?')),
          content: Text(_translationService.translate('Hey Western! Are you sure you want to logout?')),
          actions: <Widget>[
            TextButton(
              child: Text(_translationService.translate('Cancel')),
              onPressed: () => Navigator.of(context).pop(),
            ),
            TextButton(
              child: Text(_translationService.translate('Logout')),
              onPressed: () {
                Navigator.pushReplacementNamed(
                  context,
                  '/',
                ); // Back to welcome
              },
            ),
          ],
        );
      },
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

class _RecycleDetailScreenState extends State<RecycleDetailScreen> {
  late final TranslationService _translationService;
  final FlutterTts flutterTts = FlutterTts();
  final List<Map<String, dynamic>> recyclableItems = [
    {
      'name': 'Paper and Cardboard',
      'image': 'assets/images/recycle/paper.png',
      'isRecyclable': true,
    },
    {
      'name': 'Plastic Bottles',
      'image': 'assets/images/recycle/plastic.png',
      'isRecyclable': true,
    },
    {
      'name': 'Glass Containers',
      'image': 'assets/images/recycle/glass.png',
      'isRecyclable': true,
    },
    {
      'name': 'Metal Cans',
      'image': 'assets/images/recycle/metal.png',
      'isRecyclable': true,
    },
    {
      'name': 'Pizza',
      'image': 'assets/images/recycle/pizza.jpg',
      'isRecyclable': false,
    },
    {
      'name': 'Banana Peel',
      'image': 'assets/images/recycle/banana.jpeg',
      'isRecyclable': false,
    },
  ];

  @override
  void initState() {
    super.initState();
    _translationService = widget.translationService;
  }

  Future<void> _speakText(String text) async {
    await _translationService.speak(_translationService.translate(text));
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

  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(_translationService.translate('😢 Logout?')),
          content: Text(_translationService.translate('Hey Western! Are you sure you want to logout?')),
          actions: <Widget>[
            TextButton(
              child: Text(_translationService.translate('Cancel')),
              onPressed: () => Navigator.of(context).pop(),
            ),
            TextButton(
              child: Text(_translationService.translate('Logout')),
              onPressed: () {
                Navigator.pushReplacementNamed(context, '/');
              },
            ),
          ],
        );
      },
    );
  }

  Widget _buildWhatIsRecyclingContent() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Container(
            height: 200,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              image: const DecorationImage(
                image: AssetImage('assets/images/avatar.png'),
                fit: BoxFit.contain,
              ),
            ),
          ),
          const SizedBox(height: 20),
          Text(
            _translationService.translate(
              "Hi! I'm Captain Recycle! Recycling is like giving trash super powers! We take old things like bottles and paper and turn them into new things. It's like magic that helps keep our Earth clean and happy! 🌍✨"
            ),
            style: const TextStyle(
              fontSize: 18,
              fontFamily: 'ComicNeue',
            ),
            textAlign: TextAlign.center,
          ),
          IconButton(
            icon: const Icon(Icons.volume_up),
            onPressed: () => _speakText(
              "Hi! I'm Captain Recycle! Recycling is like giving trash super powers! We take old things like bottles and paper and turn them into new things. It's like magic that helps keep our Earth clean and happy!"
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWhatCanBeRecycledContent() {
    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.8,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
      itemCount: 4, // Show only recyclable items
      itemBuilder: (context, index) {
        return Card(
          elevation: 4,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          child: InkWell(
            onTap: () => _speakText(recyclableItems[index]['name']),
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
                    _translationService.translate(recyclableItems[index]['name']),
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
    );
  }

  Widget _buildWhyRecycleContent() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Container(
            height: 200,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              image: const DecorationImage(
                image: AssetImage('assets/images/avatar.png'),
                fit: BoxFit.contain,
              ),
            ),
          ),
          const SizedBox(height: 20),
          Text(
            _translationService.translate(
              "Meet Tommy the Turtle! He wants to tell you why recycling is important:\n\n"
              "🌊 It keeps our oceans clean for sea animals\n"
              "🌳 Saves trees and forests\n"
              "⚡ Helps save energy\n"
              "🌍 Makes Earth happy and healthy!"
            ),
            style: const TextStyle(
              fontSize: 18,
              fontFamily: 'ComicNeue',
            ),
            textAlign: TextAlign.center,
          ),
          IconButton(
            icon: const Icon(Icons.volume_up),
            onPressed: () => _speakText(
              "Meet Tommy the Turtle! He wants to tell you why recycling is important: It keeps our oceans clean for sea animals, Saves trees and forests, Helps save energy, Makes Earth happy and healthy!"
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRecycleQuizContent() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Text(
            _translationService.translate("Tap the items that can be recycled!"),
            style: const TextStyle(
              fontSize: 18,
              fontFamily: 'ComicNeue',
              fontWeight: FontWeight.bold,
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
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                child: InkWell(
                  onTap: () {
                    final isCorrect = recyclableItems[index]['isRecyclable'];
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          _translationService.translate(
                            isCorrect
                                ? "Yes! This can be recycled! ⭐"
                                : "Oops! This cannot be recycled. Try again! 💫"
                          ),
                          style: const TextStyle(fontSize: 16),
                        ),
                        backgroundColor: isCorrect ? Colors.green : Colors.orange,
                        duration: const Duration(seconds: 2),
                      ),
                    );
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
                          _translationService.translate(recyclableItems[index]['name']),
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
      appBar: AppBar(
        title: Text(
          _translationService.translate(title),
          style: const TextStyle(
            fontFamily: 'ComicNeue',
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.blue.shade100,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Colors.blue.shade50, Colors.white],
                ),
              ),
              child: content,
            ),
          ),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(25),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildGradientButton(
                  icon: Icons.person,
                  onPressed: () => _showLogoutDialog(),
                ),
                _buildGradientButton(
                  icon: Icons.home,
                  onPressed: () => Navigator.pop(context),
                ),
                _buildGradientButton(
                  icon: Icons.settings,
                  onPressed: () {},
                ),
                _buildGradientButton(
                  icon: Icons.volume_up,
                  onPressed: () {},
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
} 