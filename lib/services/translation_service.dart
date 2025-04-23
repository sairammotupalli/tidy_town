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
    "Cancel": "Cancelar",
    "😢 Logout?": "😢 ¿Cerrar sesión?",
    "Hey Western! Are you sure you want to logout?": "¡Hola Western! ¿Estás seguro de que quieres cerrar sesión?",
    "Recycling ♻️": "Reciclaje ♻️",

    // Recycle Screen Titles and Subtitles
    "What is Recycling?": "¿Qué es el Reciclaje?",
    "Learn about recycling in a fun way! 🌟": "¡Aprende sobre el reciclaje de una manera divertida! 🌟",
    "What Can Be Recycled?": "¿Qué se Puede Reciclar?",
    "Discover recyclable items! 🔍": "¡Descubre los artículos reciclables! 🔍",
    "Why Should We Recycle?": "¿Por Qué Debemos Reciclar?",
    "Meet Tommy the Turtle! 🐢": "¡Conoce a Tommy la Tortuga! 🐢",
    "Recycle Quiz": "Cuestionario de Reciclaje",
    "Test your knowledge! 🎯": "¡Pon a prueba tus conocimientos! 🎯",

    // Captain Recycle's Message
    "Hi! I'm Captain Recycle! Recycling is like giving trash super powers! We take old things like bottles and paper and turn them into new things. It's like magic that helps keep our Earth clean and happy! 🌍✨": 
    "¡Hola! ¡Soy el Capitán Reciclaje! ¡Reciclar es como darle superpoderes a la basura! Tomamos cosas viejas como botellas y papel y las convertimos en cosas nuevas. ¡Es como magia que ayuda a mantener nuestra Tierra limpia y feliz! 🌍✨",

    // Tommy's Message
    "Meet Tommy the Turtle! He wants to tell you why recycling is important:\n\n🌊 It keeps our oceans clean for sea animals\n🌳 Saves trees and forests\n⚡ Helps save energy\n🌍 Makes Earth happy and healthy!":
    "¡Conoce a Tommy la Tortuga! Quiere contarte por qué es importante reciclar:\n\n🌊 Mantiene nuestros océanos limpios para los animales marinos\n🌳 Salva árboles y bosques\n⚡ Ayuda a ahorrar energía\n🌍 ¡Hace que la Tierra esté feliz y saludable!",

    // Quiz Content
    "Tap the items that can be recycled!": "¡Toca los artículos que se pueden reciclar!",
    "Yes! This can be recycled! ⭐": "¡Sí! ¡Esto se puede reciclar! ⭐",
    "Oops! This cannot be recycled. Try again! 💫": "¡Ups! Esto no se puede reciclar. ¡Inténtalo de nuevo! 💫",

    // Common items
    "Paper and Cardboard": "Papel y Cartón",
    "Plastic Bottles": "Botellas de Plástico",
    "Glass Containers": "Envases de Vidrio",
    "Metal Cans": "Latas de Metal",
    "Pizza Box (with grease)": "Caja de Pizza (con grasa)",
    "Banana Peel": "Cáscara de Plátano",
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
    "Why is it Important?": "¿Por qué es Importante?",
    "Gives trash a second life": "Dale una segunda vida a la basura",
    "Helps plants and animals": "Ayuda a las plantas y animales",
    "Makes our planet happy": "Hace feliz a nuestro planeta",
    "Keeps our home clean": "Mantiene limpio nuestro hogar",
    "Listen to the Story": "Escuchar la Historia",

    // Story Titles
    "Tommy and the Talking Bottle": "Tommy y la Botella Parlante",
    "Luna the Leaf's Big Idea": "La Gran Idea de Luna la Hoja",
    
    // Navigation
    "Previous": "Anterior",
    "Next": "Siguiente",
    "Listen": "Escuchar",
    "Stop": "Detener",

    // Tommy's Story
    "Tommy the Turtle: \"Whoa! What's that shiny thing in the sand?\"": 
    "Tommy la Tortuga: \"¡Guau! ¿Qué es esa cosa brillante en la arena?\"",
    
    "Plastic Bottle: \"Hi Tommy! I'm a lonely bottle. I got thrown away and ended up here!\"":
    "Botella de Plástico: \"¡Hola Tommy! Soy una botella solitaria. ¡Me tiraron y terminé aquí!\"",
    
    "Tommy the Turtle: \"Oh no! Aren't you supposed to go in the recycling bin?\"":
    "Tommy la Tortuga: \"¡Oh no! ¿No deberías estar en el contenedor de reciclaje?\"",
    
    "Plastic Bottle: \"Yes! If someone had recycled me, I could've become a toy or even a t-shirt!\"":
    "Botella de Plástico: \"¡Sí! Si alguien me hubiera reciclado, ¡podría haberme convertido en un juguete o incluso en una camiseta!\"",
    
    "Tommy the Turtle: \"Kids, did you hear that? Recycling helps me keep the beach clean!\"":
    "Tommy la Tortuga: \"Niños, ¿escucharon eso? ¡El reciclaje me ayuda a mantener la playa limpia!\"",
    
    "Plastic Bottle: \"And it gives me a chance to be useful again! Let's all recycle!\"":
    "Botella de Plástico: \"¡Y me da la oportunidad de ser útil de nuevo! ¡Vamos todos a reciclar!\"",
    
    "Narrator: \"Tommy and the bottle high-fived (well, sort of), and off they went to find the recycling bin!\"":
    "Narrador: \"Tommy y la botella chocaron los cinco (bueno, más o menos), ¡y se fueron a buscar el contenedor de reciclaje!\"",

    // Luna's Story
    "Luna the Leaf: \"Hi friends! I'm Luna. I live in a big, happy forest.\"":
    "Luna la Hoja: \"¡Hola amigos! Soy Luna. Vivo en un bosque grande y feliz.\"",
    
    "Luna the Leaf: \"But my forest friends are in danger because too many trees are being cut down.\"":
    "Luna la Hoja: \"Pero mis amigos del bosque están en peligro porque están cortando demasiados árboles.\"",
    
    "Bobby the Bin: \"Hey Luna! If kids recycle paper, we don't need to cut so many trees!\"":
    "Bobby el Contenedor: \"¡Hola Luna! Si los niños reciclan papel, ¡no necesitamos cortar tantos árboles!\"",
    
    "Luna the Leaf: \"That's right! Recycling paper saves homes for birds, bugs, and bears too!\"":
    "Luna la Hoja: \"¡Así es! ¡Reciclar papel salva hogares para pájaros, insectos y osos también!\"",
    
    "Bobby the Bin: \"Plus, it saves energy and keeps our Earth cool and clean.\"":
    "Bobby el Contenedor: \"Además, ahorra energía y mantiene nuestra Tierra fresca y limpia.\"",
    
    "Luna the Leaf: \"Let's be Earth heroes and recycle every day!\"":
    "Luna la Hoja: \"¡Seamos héroes de la Tierra y reciclemos todos los días!\"",

    // Story Selection
    "Choose a story to learn why recycling is important!": "¡Elige una historia para aprender por qué es importante reciclar!",
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