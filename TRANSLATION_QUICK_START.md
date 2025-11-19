# Translation System - Quick Start Guide

## 🎯 How to Use Translations in Your Code

### 1️⃣ Import the Translation Service
```dart
import '../../services/translation_service.dart';

class MyWidget extends StatefulWidget {
  // ...
}

class _MyWidgetState extends State<MyWidget> {
  final TranslationService _translationService = TranslationService();
  
  // ... rest of your code
}
```

### 2️⃣ Translate Static Text
```dart
// Before (hardcoded):
Text('Hello, World!')

// After (translatable):
Text(_translationService.translate('Hello, World!'))
```

### 3️⃣ Translate Dynamic Text
```dart
// Before:
Text('Score: $score')

// After:
Text('${_translationService.translate('Score: ')}$score')
```

### 4️⃣ Translate List Items
```dart
// Define base items with keys
final List<Map<String, dynamic>> _baseItems = [
  {
    'nameKey': 'Apple',
    'descriptionKey': 'A red fruit',
  },
  {
    'nameKey': 'Banana',
    'descriptionKey': 'A yellow fruit',
  },
];

// Create getter that returns translated items
List<Map<String, dynamic>> get items {
  return _baseItems.map((item) => {
    'name': _translationService.translate(item['nameKey']),
    'description': _translationService.translate(item['descriptionKey']),
  }).toList();
}

// Use in your UI
Text(items[0]['name'])  // Will show "Apple" or "Manzana"
```

### 5️⃣ Add Language Toggle Button
```dart
IconButton(
  onPressed: () {
    setState(() {
      _translationService.toggleLanguage();
    });
  },
  icon: Icon(
    _translationService.isSpanish ? Icons.language : Icons.translate,
  ),
)
```

### 6️⃣ Check Current Language
```dart
if (_translationService.isSpanish) {
  // Do something specific for Spanish
} else {
  // Do something for English
}
```

## 📝 Adding New Translations

### Step 1: Add to Dictionary
Open `lib/services/translation_service.dart` and add your translation:

```dart
final Map<String, String> _translations = {
  // ... existing translations ...
  
  // Your new translations
  "New Text Here": "Nuevo Texto Aquí",
  "Another Text": "Otro Texto",
};
```

### Step 2: Use in Your Code
```dart
Text(_translationService.translate('New Text Here'))
```

### Step 3: Test
1. Run the app
2. Click the translation button
3. Verify your text changes to Spanish

## 🎨 Common Patterns

### Pattern 1: Button Text
```dart
ElevatedButton(
  onPressed: () {},
  child: Text(_translationService.translate('Click Me')),
)
```

### Pattern 2: Dialog Messages
```dart
showDialog(
  context: context,
  builder: (context) => AlertDialog(
    title: Text(_translationService.translate('Warning')),
    content: Text(_translationService.translate('Are you sure?')),
    actions: [
      TextButton(
        onPressed: () => Navigator.pop(context),
        child: Text(_translationService.translate('Cancel')),
      ),
      TextButton(
        onPressed: () {},
        child: Text(_translationService.translate('OK')),
      ),
    ],
  ),
)
```

### Pattern 3: AppBar Title
```dart
AppBar(
  title: Text(_translationService.translate('My App')),
  actions: [
    IconButton(
      icon: Icon(
        _translationService.isSpanish ? Icons.language : Icons.translate,
      ),
      onPressed: () {
        setState(() {
          _translationService.toggleLanguage();
        });
      },
    ),
  ],
)
```

### Pattern 4: Conditional Text
```dart
Text(
  _translationService.translate(
    isCorrect ? 'Correct!' : 'Wrong!'
  )
)
```

## 🔧 Text-to-Speech (TTS) Integration

### Setup TTS with Language Support
```dart
FlutterTts _tts = FlutterTts();

Future<void> _initializeTts() async {
  await _tts.setLanguage(
    _translationService.isSpanish ? 'es-ES' : 'en-US'
  );
  await _tts.setSpeechRate(0.5);
  await _tts.setPitch(1.0);
}

Future<void> _speakText(String text) async {
  await _tts.setLanguage(
    _translationService.isSpanish ? 'es-ES' : 'en-US'
  );
  await _tts.speak(text);
}

// Use it
_speakText(_translationService.translate('Hello!'));
```

## ⚠️ Important Notes

### DO:
- ✅ Always use exact English text as the key
- ✅ Add translations before using them
- ✅ Call `setState()` after toggling language
- ✅ Test both languages

### DON'T:
- ❌ Don't modify translation keys (breaks existing code)
- ❌ Don't use abbreviations as keys
- ❌ Don't forget to add TTS language support
- ❌ Don't hardcode text anymore

## 🐛 Troubleshooting

### Problem: Text not translating
**Solution:** Check that the English text exists in `_translations` map with the exact same spelling, punctuation, and spacing.

```dart
// Wrong (won't translate):
_translationService.translate('hello')  // lowercase
// Translation key is: "Hello" (capitalized)

// Correct:
_translationService.translate('Hello')
```

### Problem: UI not updating after toggle
**Solution:** Make sure you call `setState()`:

```dart
// Wrong:
_translationService.toggleLanguage();  // UI won't update

// Correct:
setState(() {
  _translationService.toggleLanguage();
});
```

### Problem: TTS speaking wrong language
**Solution:** Set TTS language before speaking:

```dart
Future<void> _speakText(String text) async {
  await _tts.setLanguage(
    _translationService.isSpanish ? 'es-ES' : 'en-US'
  );
  await _tts.speak(text);
}
```

## 📱 Example: Complete Widget

Here's a complete example showing all patterns:

```dart
import 'package:flutter/material.dart';
import '../../services/translation_service.dart';

class ExampleScreen extends StatefulWidget {
  const ExampleScreen({super.key});

  @override
  State<ExampleScreen> createState() => _ExampleScreenState();
}

class _ExampleScreenState extends State<ExampleScreen> {
  final TranslationService _translationService = TranslationService();
  int score = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_translationService.translate('My Game')),
        actions: [
          IconButton(
            icon: Icon(
              _translationService.isSpanish 
                ? Icons.language 
                : Icons.translate,
            ),
            onPressed: () {
              setState(() {
                _translationService.toggleLanguage();
              });
            },
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              _translationService.translate('Welcome!'),
              style: const TextStyle(fontSize: 24),
            ),
            const SizedBox(height: 20),
            Text(
              '${_translationService.translate('Score: ')}$score',
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  score++;
                });
              },
              child: Text(_translationService.translate('Add Point')),
            ),
          ],
        ),
      ),
    );
  }
}
```

## 🎓 Key Concepts

1. **Singleton Service**: One instance shared across the app
2. **Key-Value Pairs**: English text is the key, Spanish is the value
3. **Reactive Updates**: Use `setState()` to update UI
4. **Fallback**: Returns English if translation not found
5. **Type Safety**: Compile-time checking of translations

## 🚀 You're Ready!

You now have everything you need to:
- ✅ Translate any text in the app
- ✅ Add new translations
- ✅ Toggle languages
- ✅ Support TTS in multiple languages
- ✅ Debug translation issues

For more details, see:
- `TRANSLATION_SUMMARY.md` - Overview of implementation
- `TRANSLATION_IMPLEMENTATION_GUIDE.md` - Deep dive into architecture

Happy coding! 🎉

