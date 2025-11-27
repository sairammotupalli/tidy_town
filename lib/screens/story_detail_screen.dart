import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import '../services/translation_service.dart';

class StoryDetailScreen extends StatefulWidget {
  final String title;
  final String body;

  const StoryDetailScreen({
    super.key,
    required this.title,
    required this.body,
  });

  @override
  State<StoryDetailScreen> createState() => _StoryDetailScreenState();
}

class _StoryDetailScreenState extends State<StoryDetailScreen> {
  final FlutterTts flutterTts = FlutterTts();
  final TranslationService _translationService = TranslationService();

  Map<String, String>? tommyVoice;
  Map<String, String>? bottleVoice;

  @override
  void initState() {
    super.initState();
    _setupTts();
  }

  Future<void> _setupTts() async {
    await flutterTts.setLanguage(_translationService.isSpanish ? "es-ES" : "en-US");
    await flutterTts.setSpeechRate(0.3);
    
    try {
      final List<dynamic>? voices = await flutterTts.getVoices;
      if (voices != null && voices.isNotEmpty) {
        // Look for a deep male voice for Tommy
        final dynamic tommyVoiceData = voices.firstWhere(
          (v) {
            final name = (v is Map && v['name'] is String) ? (v['name'] as String).toLowerCase() : '';
            return name.contains('male') ||
                name.contains('man') ||
                name.contains('michael') ||
                name.contains('daniel') ||
                name.contains('david');
          },
          orElse: () => null,
        );
        if (tommyVoiceData is Map) {
          tommyVoice = {
            'name': '${tommyVoiceData['name']}',
            'locale': '${tommyVoiceData['locale']}',
          };
          await flutterTts.setPitch(0.5); // Lower pitch for deeper male voice
          await flutterTts.setSpeechRate(0.3); // Slower speech rate for clarity
        }

        // Look for a higher pitched female voice for the bottle
        final dynamic bottleVoiceData = voices.firstWhere(
          (v) {
            final name = (v is Map && v['name'] is String) ? (v['name'] as String).toLowerCase() : '';
            return name.contains('female') ||
                name.contains('woman') ||
                name.contains('samantha') ||
                name.contains('karen');
          },
          orElse: () => null,
        );
        if (bottleVoiceData is Map) {
          bottleVoice = {
            'name': '${bottleVoiceData['name']}',
            'locale': '${bottleVoiceData['locale']}',
          };
          await flutterTts.setPitch(0.5); // Higher pitch for female voice
          await flutterTts.setSpeechRate(0.3); // Slower speech rate for clarity
        }
      }
    } catch (_) {
      // Best-effort voice selection; ignore errors
    }
  }

  Future<void> _speak(String text) async {
    try {
      await flutterTts.setLanguage(_translationService.isSpanish ? "es-ES" : "en-US");
      await flutterTts.speak(text);
    } catch (_) {}
  }

  @override
  Widget build(BuildContext context) {
    final title = _translationService.translate(widget.title);
    final body = _translationService.translate(widget.body);

    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        actions: [
          IconButton(
            onPressed: () {
              setState(() {
                _translationService.toggleLanguage();
                _setupTts();
              });
            },
            icon: Icon(_translationService.isSpanish ? Icons.language : Icons.translate),
            tooltip: _translationService.isSpanish ? 'Switch to English' : 'Cambiar a Español',
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              body,
              style: const TextStyle(fontSize: 18),
            ),
            const Spacer(),
            Row(
              children: [
                ElevatedButton(
                  onPressed: () => _speak(title),
                  child: Text(_translationService.translate('Read title')),
                ),
                const SizedBox(width: 12),
                ElevatedButton(
                  onPressed: () => _speak(body),
                  child: Text(_translationService.translate('Read story')),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
} 