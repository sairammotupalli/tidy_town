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

  final List<RecyclableItem> items = [
    RecyclableItem(
      name: 'Paper and Cardboard',
      image: 'assets/images/1.png',
      description: 'Flatten cardboard boxes and keep paper clean and dry',
    ),
    RecyclableItem(
      name: 'Plastic Bottles',
      image: 'assets/images/1.png',
      description: 'Rinse bottles and remove caps before recycling',
    ),
    RecyclableItem(
      name: 'Glass Containers',
      image: 'assets/images/1.png',
      description: 'Clean and empty glass bottles and jars',
    ),
    RecyclableItem(
      name: 'Metal Cans',
      image: 'assets/images/1.png',
      description: 'Rinse cans and crush if possible to save space',
    ),
  ];

  Future<void> _speakText(String text) async {
    await _translationService.speak(_translationService.translate(text));
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
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.blue.shade50, Colors.white],
          ),
        ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Text(
                    _translationService.translate('Learn about recyclable items!'),
                    style: TextStyle(
                      fontSize: 24,
                      fontFamily: 'ComicNeue',
                      fontWeight: FontWeight.bold,
                      color: Colors.blue.shade700,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Card(
                    elevation: 4,
                    color: Colors.blue.shade50,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                          Text(
                            _translationService.translate(
                              "Recycling is like giving trash a super power! It's when we turn used things like bottles and paper into new things instead of throwing them away. It's like magic that helps keep our Earth clean!"
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
                              "Recycling is like giving trash a super power! It's when we turn used things like bottles and paper into new things instead of throwing them away. It's like magic that helps keep our Earth clean!"
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: items.length,
                itemBuilder: (context, index) {
                  return Card(
                    elevation: 4,
                    margin: const EdgeInsets.only(bottom: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Column(
                      children: [
                        ClipRRect(
                          borderRadius: const BorderRadius.vertical(
                            top: Radius.circular(15),
                          ),
                          child: Image.asset(
                            items[index].image,
                            height: 200,
                            width: double.infinity,
                            fit: BoxFit.cover,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            children: [
                              Text(
                                _translationService.translate(items[index].name),
                                style: const TextStyle(
                                  fontSize: 22,
                                  fontFamily: 'ComicNeue',
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                _translationService.translate(items[index].description),
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontFamily: 'ComicNeue',
                                ),
                                textAlign: TextAlign.center,
                              ),
                              IconButton(
                                icon: const Icon(Icons.volume_up),
                                onPressed: () => _speakText(
                                  '${items[index].name}. ${items[index].description}',
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class RecyclableItem {
  final String name;
  final String image;
  final String description;

  RecyclableItem({
    required this.name,
    required this.image,
    required this.description,
  });
} 