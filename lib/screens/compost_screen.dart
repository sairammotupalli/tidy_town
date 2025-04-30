import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';

class CompostScreen extends StatefulWidget {
  const CompostScreen({super.key});

  @override
  State<CompostScreen> createState() => _CompostScreenState();
}

class _CompostScreenState extends State<CompostScreen> {
  final FlutterTts flutterTts = FlutterTts();

  final List<CompostItem> items = [
    CompostItem(
      name: 'Fruit and Vegetable Scraps',
      image: 'assets/images/1.png',
      description: 'All fruit and vegetable waste can be composted',
    ),
    CompostItem(
      name: 'Coffee Grounds',
      image: 'assets/images/1.png',
      description: 'Coffee grounds and filters are great for composting',
    ),
    CompostItem(
      name: 'Yard Trimmings',
      image: 'assets/images/1.png',
      description: 'Grass clippings, leaves, and small twigs',
    ),
    CompostItem(
      name: 'Eggshells',
      image: 'assets/images/1.png',
      description: 'Crushed eggshells add calcium to your compost',
    ),
  ];

  Future<void> _speakText(String text) async {
    await flutterTts.setLanguage('en-US');
    await flutterTts.setPitch(0.5);
    await flutterTts.setSpeechRate(0.4);
    await flutterTts.speak(text);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Composting 🌱',
          style: TextStyle(
            fontFamily: 'ComicNeue',
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.green.shade100,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.green.shade50, Colors.white],
          ),
        ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Text(
                    'Learn about compostable items!',
                    style: TextStyle(
                      fontSize: 24,
                      fontFamily: 'ComicNeue',
                      fontWeight: FontWeight.bold,
                      color: Colors.green.shade700,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Card(
                    elevation: 4,
                    color: Colors.green.shade50,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                          const Text(
                            "Composting is nature's way of recycling! It's when we take food scraps and plant materials and turn them into super food for plants. It's like making a yummy smoothie for our garden! 🌱🍎",
                            style: TextStyle(
                              fontSize: 18,
                              fontFamily: 'ComicNeue',
                            ),
                            textAlign: TextAlign.center,
                          ),
                          IconButton(
                            icon: const Icon(Icons.volume_up),
                            onPressed: () => _speakText("Composting is nature's way of recycling! It's when we take food scraps and plant materials and turn them into super food for plants. It's like making a yummy smoothie for our garden!"),
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
                                items[index].name,
                                style: const TextStyle(
                                  fontSize: 22,
                                  fontFamily: 'ComicNeue',
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                items[index].description,
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

class CompostItem {
  final String name;
  final String image;
  final String description;

  CompostItem({
    required this.name,
    required this.image,
    required this.description,
  });
} 