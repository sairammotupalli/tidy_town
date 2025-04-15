import 'package:flutter_tts/flutter_tts.dart';

class TranslationService {
  static final TranslationService _instance = TranslationService._internal();
  factory TranslationService() => _instance;
  TranslationService._internal();

  final FlutterTts flutterTts = FlutterTts();
  bool _isSpanish = false;

  bool get isSpanish => _isSpanish;

  final Map<String, String> _translations = {
    // Home Screen
    "Let's play": "Vamos a jugar",
    "Recycle": "Reciclar",
    "Compost": "Compostar",
    "Landfill": "Vertedero",
    "Settings": "Ajustes",
    "Logout": "Cerrar sesión",

    // Recycle Screen
    "Learn about recyclable items!": "¡Aprende sobre los artículos reciclables!",
    "Recycling is like giving trash a super power! It's when we turn used things like bottles and paper into new things instead of throwing them away. It's like magic that helps keep our Earth clean!": 
    "¡Reciclar es como darle un superpoder a la basura! Es cuando convertimos cosas usadas como botellas y papel en cosas nuevas en lugar de tirarlas. ¡Es como magia que ayuda a mantener limpia nuestra Tierra!",
    
    // Compost Screen
    "Learn about compostable items!": "¡Aprende sobre los artículos compostables!",
    "Composting is nature's way of recycling! It's when we take food scraps and plant materials and turn them into super food for plants. It's like making a yummy smoothie for our garden!":
    "¡El compostaje es la forma en que la naturaleza recicla! Es cuando tomamos restos de comida y materiales de plantas y los convertimos en superalimentos para las plantas. ¡Es como hacer un batido delicioso para nuestro jardín!",
    
    // Landfill Screen
    "Learn about landfill items!": "¡Aprende sobre los artículos de vertedero!",
    "A landfill is like Earth's storage box where we put things we can't recycle or compost. It's important to put as little as possible here because it takes a very long time for these things to break down. That's why we try to recycle and compost first!":
    "Un vertedero es como la caja de almacenamiento de la Tierra donde ponemos las cosas que no podemos reciclar o compostar. Es importante poner lo menos posible aquí porque estas cosas tardan mucho tiempo en descomponerse. ¡Por eso intentamos reciclar y compostar primero!",

    // Common items
    "Paper and Cardboard": "Papel y Cartón",
    "Plastic Bottles": "Botellas de Plástico",
    "Glass Containers": "Envases de Vidrio",
    "Metal Cans": "Latas de Metal",
    "Fruit and Vegetable Scraps": "Restos de Frutas y Verduras",
    "Coffee Grounds": "Café Molido",
    "Yard Trimmings": "Recortes de Jardín",
    "Eggshells": "Cáscaras de Huevo",
    "Broken Ceramics": "Cerámicas Rotas",
    "Used Tissues": "Pañuelos Usados",
    "Styrofoam": "Poliestireno",
    "Plastic Bags": "Bolsas de Plástico",

    // Item descriptions
    "Flatten cardboard boxes and keep paper clean and dry": "Aplana las cajas de cartón y mantén el papel limpio y seco",
    "Rinse bottles and remove caps before recycling": "Enjuaga las botellas y quita las tapas antes de reciclar",
    "Clean and empty glass bottles and jars": "Limpia y vacía botellas y frascos de vidrio",
    "Rinse cans and crush if possible to save space": "Enjuaga las latas y aplástalas si es posible para ahorrar espacio",
    "All fruit and vegetable waste can be composted": "Todos los residuos de frutas y verduras se pueden compostar",
    "Coffee grounds and filters are great for composting": "El café molido y los filtros son excelentes para el compostaje",
    "Grass clippings, leaves, and small twigs": "Recortes de césped, hojas y ramitas pequeñas",
    "Crushed eggshells add calcium to your compost": "Las cáscaras de huevo trituradas agregan calcio a tu compost",
    "Broken plates, cups, and other ceramics cannot be recycled": "Los platos, tazas y otras cerámicas rotas no se pueden reciclar",
    "Used tissues and paper towels are not recyclable": "Los pañuelos y toallas de papel usados no son reciclables",
    "Most places cannot recycle styrofoam packaging": "La mayoría de los lugares no pueden reciclar el empaque de poliestireno",
    "Regular plastic bags cannot be recycled in normal bins": "Las bolsas de plástico normales no se pueden reciclar en contenedores normales",
  };

  String translate(String text) {
    if (!_isSpanish) return text;
    return _translations[text] ?? text;
  }

  Future<void> speak(String text) async {
    await flutterTts.setLanguage(_isSpanish ? "es-ES" : "en-US");
    await flutterTts.setPitch(1.3);
    await flutterTts.setSpeechRate(0.4);
    await flutterTts.speak(text);
  }

  void toggleLanguage() {
    _isSpanish = !_isSpanish;
  }
} 