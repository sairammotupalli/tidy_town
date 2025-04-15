import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';

class LandfillScreen extends StatefulWidget {
  const LandfillScreen({super.key});

  @override
  State<LandfillScreen> createState() => _LandfillScreenState();
}

class _LandfillScreenState extends State<LandfillScreen> {
  final FlutterTts flutterTts = FlutterTts();

  final List<LandfillItem> items = [
    LandfillItem(
      name: 'Broken Ceramics',
      image: 'assets/images/1.png',
      description: 'Broken plates, cups, and other ceramics cannot be recycled',
    ),
    LandfillItem(
      name: 'Used Tissues',
      image: 'assets/images/1.png',
      description: 'Used tissues and paper towels are not recyclable',
    ),
    LandfillItem(
      name: 'Styrofoam',
      image: 'assets/images/1.png',
      description: 'Most places cannot recycle styrofoam packaging',
    ),
    LandfillItem(
      name: 'Plastic Bags',
      image: 'assets/images/1.png',
      description: 'Regular plastic bags cannot be recycled in normal bins',
    ),
  ];

  Future<void> _speakText(String text) async {
    await flutterTts.setLanguage('en-US');
    await flutterTts.setPitch(1.3);
    await flutterTts.setSpeechRate(0.4);
    await flutterTts.speak(text);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Landfill 🗑️',
          style: TextStyle(
            fontFamily: 'ComicNeue',
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.grey.shade200,
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
            colors: [Colors.grey.shade100, Colors.white],
          ),
        ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Text(
                    'Learn about landfill items!',
                    style: TextStyle(
                      fontSize: 24,
                      fontFamily: 'ComicNeue',
                      fontWeight: FontWeight.bold,
                      color: Colors.grey.shade700,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Card(
                    elevation: 4,
                    color: Colors.grey.shade50,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                          const Text(
                            "A landfill is like Earth's storage box where we put things we can't recycle or compost. It's important to put as little as possible here because it takes a very long time for these things to break down. That's why we try to recycle and compost first! 🗑️💭",
                            style: TextStyle(
                              fontSize: 18,
                              fontFamily: 'ComicNeue',
                            ),
                            textAlign: TextAlign.center,
                          ),
                          IconButton(
                            icon: const Icon(Icons.volume_up),
                            onPressed: () => _speakText("A landfill is like Earth's storage box where we put things we can't recycle or compost. It's important to put as little as possible here because it takes a very long time for these things to break down. That's why we try to recycle and compost first!"),
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

class LandfillItem {
  final String name;
  final String image;
  final String description;

  LandfillItem({
    required this.name,
    required this.image,
    required this.description,
  });
} 