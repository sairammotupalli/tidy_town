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

    // === TOWN GAME (ITEM NAMES USED IN town_waste_sorting_game.dart) ===
    "Plastic Water Bottle": "Botella de Agua de Plástico",
    "Candy Wrapper": "Envoltura de Dulce",
    "Paper Napkin": "Servilleta de Papel",
    "Plastic Straw": "Pajita de Plástico",
    "Vegetable Scraps": "Restos de Verduras",
    "Fruit Peels": "Cáscaras de Fruta",
    "Cardboard Box": "Caja de Cartón",
    "Glass Bottle": "Botella de Vidrio",
    "Plastic Carry Bag": "Bolsa de Plástico",

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
    "Wally the Water Bottle's Second Chance": "La Segunda Oportunidad de Wally la Botella de Agua",
    "Rocky the Robot's Recycling Adventure": "La Aventura de Reciclaje del Robot Rocky",
    
    // Rocky's Story
    "Hi kids! I'm Rocky, a recycling robot from the future! 🤖": 
    "¡Hola niños! ¡Soy Rocky, un robot reciclador del futuro! 🤖",
    
    "In my time, we learned how important recycling is for our planet.":
    "En mi tiempo, aprendimos lo importante que es reciclar para nuestro planeta.",
    
    "Did you know? Every item you recycle helps save energy and resources!":
    "¿Sabías que? ¡Cada artículo que reciclas ayuda a ahorrar energía y recursos!",
    
    "When we recycle one aluminum can, we save enough energy to power a TV for 3 hours!":
    "¡Cuando reciclamos una lata de aluminio, ahorramos suficiente energía para alimentar un televisor durante 3 horas!",
    
    "And when we recycle paper, we save trees that help clean our air!":
    "¡Y cuando reciclamos papel, salvamos árboles que ayudan a limpiar nuestro aire!",
    
    "In the future, we have special recycling machines everywhere!":
    "¡En el futuro, tenemos máquinas especiales de reciclaje en todas partes!",
    
    "But we need YOUR help today to make that future possible!":
    "¡Pero necesitamos TU ayuda hoy para hacer posible ese futuro!",
    
    "Remember: Every time you recycle, you're a hero for our planet! 🌍✨":
    "Recuerda: ¡Cada vez que reciclas, eres un héroe para nuestro planeta! 🌍✨",
    
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

    // Wally's Story
    "I was once shiny and full of fresh water. But now? I lay crumpled under a park bench, forgotten.":
    "Una vez fui brillante y lleno de agua fresca. ¿Pero ahora? Estoy arrugado bajo un banco del parque, olvidado.",

    "I wish I had a purpose again...":
    "Desearía tener un propósito de nuevo...",

    "Suddenly, a little girl named Maya picked me up!":
    "¡De repente, una niña llamada Maya me recogió!",

    "Don't worry, Wally! You're going in the recycling bin!":
    "¡No te preocupes, Wally! ¡Vas al contenedor de reciclaje!",

    "I was nervous... What's going to happen to me?":
    "Estaba nervioso... ¿Qué me va a pasar?",

    "You'll see—it's the beginning of something amazing!":
    "Ya verás, ¡es el comienzo de algo increíble!",

    "At the recycling center, I met tons of new friends—Cans, newspapers, yogurt cups, even a cereal box!":
    "En el centro de reciclaje, conocí a muchos nuevos amigos: latas, periódicos, vasos de yogur, ¡incluso una caja de cereal!",

    "We were all getting sorted on loud conveyor belts.":
    "Todos estábamos siendo clasificados en ruidosas cintas transportadoras.",

    "Plastic over here! called a robotic arm, scooping me up.":
    "¡Plástico por aquí! gritó un brazo robótico, recogiéndome.",

    "I got cleaned, squished, melted, and stretched! At first, it tickled.":
    "¡Me limpiaron, aplastaron, derritieron y estiraron! Al principio, me hacía cosquillas.",

    "I felt different. I'm... I'm not a bottle anymore!":
    "Me sentía diferente. ¡Ya... ya no soy una botella!",

    "I had become a part of a shiny new backpack!":
    "¡Me había convertido en parte de una nueva mochila brillante!",

    "Maya wore the new backpack to school proudly.":
    "Maya llevó la nueva mochila a la escuela con orgullo.",

    "Recycling gives things like Wally a second chance, I told my class.":
    "El reciclaje le da una segunda oportunidad a cosas como Wally, le dije a mi clase.",

    "And I? I beamed with joy. I'm back in the world—better and braver than ever!":
    "¿Y yo? Brillé de alegría. ¡Estoy de vuelta en el mundo, mejor y más valiente que nunca!",

    // Wally's Story Moral
    "Even the smallest items we recycle can become something awesome again!":
    "¡Incluso los objetos más pequeños que reciclamos pueden convertirse en algo increíble de nuevo!",

    "Recycling gives second chances—to the Earth and everything on it":
    "El reciclaje da segundas oportunidades, a la Tierra y a todo lo que hay en ella",

    // Tommy's Story Lines
    "Whoa! What's that shiny thing in the sand?":
    "¡Vaya! ¿Qué es esa cosa brillante en la arena?",

    "Hi Tommy! I'm a lonely bottle. I got thrown away and ended up here!":
    "¡Hola Tommy! Soy una botella solitaria. ¡Me tiraron y terminé aquí!",

    "Oh no! Aren't you supposed to go in the recycling bin?":
    "¡Oh no! ¿No deberías estar en el contenedor de reciclaje?",

    "Yes! If someone had recycled me, I could've become a toy or even a t-shirt!":
    "¡Sí! Si alguien me hubiera reciclado, ¡podría haberme convertido en un juguete o incluso en una camiseta!",

    "Kids, did you hear that? Recycling helps me keep the beach clean!":
    "Niños, ¿escucharon eso? ¡El reciclaje me ayuda a mantener la playa limpia!",

    "And it gives me a chance to be useful again! Let's all recycle!":
    "¡Y me da la oportunidad de ser útil de nuevo! ¡Vamos todos a reciclar!",

    "Bye! Have a good day kids! 👋":
    "¡Adiós! ¡Que tengan un buen día niños! 👋",

    // Luna's Story Lines
    "Hi friends! I'm Luna. I live in a big, happy forest.":
    "¡Hola amigos! Soy Luna. Vivo en un bosque grande y feliz.",

    "But my forest friends are in danger because too many trees are being cut down.":
    "Pero mis amigos del bosque están en peligro porque están cortando demasiados árboles.",

    "Hey Luna! If kids recycle paper, we don't need to cut so many trees!":
    "¡Hola Luna! Si los niños reciclan papel, ¡no necesitamos cortar tantos árboles!",

    "That's right! Recycling paper saves homes for birds, bugs, and bears too!":
    "¡Así es! ¡Reciclar papel salva hogares para pájaros, insectos y osos también!",

    "Plus, it saves energy and keeps our Earth cool and clean.":
    "Además, ahorra energía y mantiene nuestra Tierra fresca y limpia.",

    "Let's be Earth heroes and recycle every day!":
    "¡Seamos héroes de la Tierra y reciclemos todos los días!",

    // Additional Story UI Elements
    "Moral of the Story": "Moraleja de la Historia",
    "Tap to hear my story!": "¡Toca para escuchar mi historia!",
    "Stop Story": "Detener Historia",

    // Game Selection Screen
    "Choose Your Adventure 🌍": "Elige Tu Aventura 🌍",
    "Select a theme for your waste sorting adventure!": "¡Selecciona un tema para tu aventura de clasificación de residuos!",
    "Waste Sorting Game": "Juego de Clasificación de Residuos",
    "Learn to sort waste into the right bins!": "¡Aprende a clasificar los residuos en los contenedores correctos!",
    "Village Adventure": "Aventura en la Aldea",
    "Help Farmer Sam keep the peaceful village clean!": "¡Ayuda al Granjero Sam a mantener limpia la aldea pacífica!",
    "Town Explorer": "Explorador de la Ciudad",
    "Help Maya sort waste in the busy town center!": "¡Ayuda a Maya a clasificar los residuos en el centro de la ciudad!",
    "Space Mission": "Misión Espacial",
    "Help Captain Luna clean up space debris!": "¡Ayuda a la Capitana Luna a limpiar los desechos espaciales!",
    "Beach Cleanup with Alex": "Limpieza de Playa con Alex",
    "Help Ocean Alex save marine life and discover beach waste!": "¡Ayuda a Alex del Océano a salvar la vida marina y descubrir los residuos de la playa!",

    // Beach Game - General UI
    "Score: ": "Puntuación: ",
    "🏖️ Beach Cleanup Complete!": "🏖️ ¡Limpieza de Playa Completa!",
    "Amazing! You helped Alex clean up the beach!": "¡Increíble! ¡Ayudaste a Alex a limpiar la playa!",
    "Play Again": "Jugar de Nuevo",
    "Back to Games": "Volver a los Juegos",

    // Beach Game - Instructions & Feedback
    "Guess this one! Help me sort this item I found on the beach!": "¡Adivina este! ¡Ayúdame a clasificar este artículo que encontré en la playa!",
    "Hurray right! That's exactly where it belongs!": "¡Hurra correcto! ¡Exactamente donde pertenece!",
    "Sorry it is wrong! But don't worry, let's try the next one!": "¡Lo siento, está mal! Pero no te preocupes, ¡probemos con el siguiente!",
    "Hurray right!": "¡Hurra correcto!",
    "Oops wrong!!": "¡Ups, incorrecto!!",
    "That's right!": "¡Así es!",
    "Oops wrong!": "¡Ups, incorrecto!",

    // Beach Game - Item Names
    "Fresh Seaweed": "Algas Frescas",
    "Driftwood": "Madera a la Deriva",
    "Coconut Shells": "Cáscaras de Coco",
    "Ocean Plastic Bottles": "Botellas de Plástico del Océano",
    "Beach Cans": "Latas de Playa",
    "Glass Bottles": "Botellas de Vidrio",
    "Dangerous Plastic Bags": "Bolsas de Plástico Peligrosas",
    "Waterlogged Papers": "Papeles Empapados",
    "Styrofoam Containers": "Contenedores de Espuma de Poliestireno",
    "Broken Flip Flops": "Chanclas Rotas",

    // Beach Game - Item Descriptions
    "I'm natural seaweed that washed ashore! Alex knows I can decompose naturally and become rich soil for plants.": 
    "¡Soy algas naturales que llegaron a la orilla! Alex sabe que puedo descomponerme naturalmente y convertirme en tierra rica para las plantas.",
    
    "I'm natural driftwood that floated to the beach! Alex picked me up because I can break down and enrich the earth.": 
    "¡Soy madera natural que flotó hasta la playa! Alex me recogió porque puedo descomponerme y enriquecer la tierra.",
    
    "I'm coconut shells that fell naturally on the beach! Alex knows I can decompose and feed the soil with nutrients.": 
    "¡Soy cáscaras de coco que cayeron naturalmente en la playa! Alex sabe que puedo descomponerme y alimentar el suelo con nutrientes.",
    
    "Alex rescued me from the ocean waves! I was threatening sea turtles who might mistake me for food. I can be made into new products!": 
    "¡Alex me rescató de las olas del océano! Estaba amenazando a las tortugas marinas que podrían confundirme con comida. ¡Puedo convertirme en nuevos productos!",
    
    "I'm aluminum cans left by beach visitors! Alex picked me up because I can be recycled into new cans forever.": 
    "¡Soy latas de aluminio dejadas por visitantes de la playa! Alex me recogió porque puedo reciclarse en nuevas latas para siempre.",
    
    "Alex found me buried in the beach sand! I'm glass bottles that can be melted down and made into new glass products.": 
    "¡Alex me encontró enterrado en la arena de la playa! Soy botellas de vidrio que pueden derretirse y convertirse en nuevos productos de vidrio.",
    
    "I'm torn plastic bags that could harm sea turtles who mistake me for jellyfish! Alex wants to dispose of me safely.": 
    "¡Soy bolsas de plástico rotas que podrían dañar a las tortugas marinas que me confunden con medusas! Alex quiere deshacerse de mí de manera segura.",
    
    "I'm papers that got soaked by seawater! Alex knows I'm too damaged to recycle and need special disposal.": 
    "¡Soy papeles que se empaparon con agua de mar! Alex sabe que estoy demasiado dañado para reciclar y necesito una eliminación especial.",
    
    "I'm styrofoam food containers left by beachgoers! Alex picked me up because I don't break down naturally.": 
    "¡Soy contenedores de comida de espuma dejados por los bañistas! Alex me recogió porque no me descompongo naturalmente.",
    
    "I'm old flip flops that washed up on shore! Alex found me and knows I need to go to landfill safely.": 
    "¡Soy chanclas viejas que llegaron a la orilla! Alex me encontró y sabe que necesito ir al vertedero de manera segura.",

    // Common Game Elements
    "Score": "Puntuación",

    // Original Waste Sorting Game Items (names already defined above, adding new ones)
    "Plastic Bottle": "Botella de Plástico",
    "Apple Core": "Corazón de Manzana",
    "Newspaper": "Periódico",
    "Broken Glass": "Vidrio Roto",
    "Aluminum Can": "Lata de Aluminio",

    // Original Game Item Descriptions
    "I am a Plastic Bottle!": "¡Soy una Botella de Plástico!",
    "hey! I am an apple core!": "¡Hola! ¡Soy un corazón de manzana!",
    "I am a Newspaper!": "¡Soy un Periódico!",
    "I am a broken glass!": "¡Soy vidrio roto!",
    "I am a Banana Peel!": "¡Soy una Cáscara de Plátano!",
    "I am a Plastic Bag! where do i go?": "¡Soy una Bolsa de Plástico! ¿a dónde voy?",
    "I am an Aluminum Can!": "¡Soy una Lata de Aluminio!",
    "I am a Coffee Grounds!": "¡Soy Café Molido!",

    // === VILLAGE GAME ===
    "Village Adventure 🏘️": "Aventura en la Aldea 🏘️",
    "Meet Farmer Sam! He loves keeping the village clean and green. Help him sort the waste items he finds while tending to the village gardens!":
      "¡Conoce al Granjero Sam! Le encanta mantener la aldea limpia y verde. ¡Ayúdalo a clasificar los residuos que encuentra mientras cuida los jardines de la aldea!",
    
    // Village Items
    "Banana Peels": "Cáscaras de Plátano",
    "Animal Waste": "Residuos de Animales",
    "Orchard Apple Cores": "Corazones de Manzana del Huerto",
    "Café Coffee Grounds": "Café Molido del Café",
    "Village Newsletter": "Boletín de la Aldea",
    "Grandma's Jam Jars": "Frascos de Mermelada de la Abuela",
    "Delivery Cardboard": "Cartón de Entregas",
    "Metal Farm Tools": "Herramientas de Granja de Metal",
    "Store Plastic Bags": "Bolsas de Plástico de la Tienda",
    "Workshop Pottery Shards": "Fragmentos de Cerámica del Taller",
    "Old Paint Cans": "Latas de Pintura Viejas",
    "Worn Out Rubber Boots": "Botas de Goma Desgastadas",
    
    // Village Item Descriptions
    "I'm banana peels from the village market! Farmer Sam knows I can enrich the soil for vegetables!":
      "¡Soy cáscaras de plátano del mercado de la aldea! ¡El Granjero Sam sabe que puedo enriquecer el suelo para las verduras!",
    "I'm animal manure from the village farm! Farmer Sam uses me as natural fertilizer for the crops!":
      "¡Soy estiércol animal de la granja de la aldea! ¡El Granjero Sam me usa como fertilizante natural para los cultivos!",
    "Farmer Sam found me under the old apple tree! I can help grow more fruit in the village garden!":
      "¡El Granjero Sam me encontró bajo el viejo manzano! ¡Puedo ayudar a cultivar más fruta en el jardín de la aldea!",
    "I'm coffee grounds from the village café! Farmer Sam uses me to help his tomatoes grow big and strong!":
      "¡Soy café molido del café de la aldea! ¡El Granjero Sam me usa para ayudar a que sus tomates crezcan grandes y fuertes!",
    "I'm the weekly village newsletter Sam collected from mailboxes! I can become new paper for the community!":
      "¡Soy el boletín semanal de la aldea que Sam recogió de los buzones! ¡Puedo convertirme en papel nuevo para la comunidad!",
    "I'm empty jam jars from Grandma's kitchen! Sam can recycle me into new containers for the village!":
      "¡Soy frascos de mermelada vacíos de la cocina de la Abuela! ¡Sam puede reciclarme en nuevos recipientes para la aldea!",
    "I'm cardboard boxes from village deliveries! Farmer Sam can recycle me into new packaging!":
      "¡Soy cajas de cartón de las entregas de la aldea! ¡El Granjero Sam puede reciclarme en nuevos empaques!",
    "I'm old metal tools from the farm! Sam can recycle me into new farming equipment for the village!":
      "¡Soy herramientas de metal viejas de la granja! ¡Sam puede reciclarme en nuevos equipos agrícolas para la aldea!",
    "I'm plastic bags that blew away from the village store! Sam knows I need special disposal to protect animals!":
      "¡Soy bolsas de plástico que volaron de la tienda de la aldea! ¡Sam sabe que necesito eliminación especial para proteger a los animales!",
    "I'm broken pottery from the village craft workshop! I'm too sharp to recycle, so I need safe disposal!":
      "¡Soy cerámica rota del taller de artesanía de la aldea! ¡Soy demasiado afilado para reciclar, así que necesito eliminación segura!",
    "I'm old paint cans from village house repairs! I contain toxic chemicals that need hazardous waste disposal!":
      "¡Soy latas de pintura viejas de las reparaciones de casas de la aldea! ¡Contengo químicos tóxicos que necesitan eliminación de residuos peligrosos!",
    "I'm old rubber boots from farm work! I'm too worn and mixed materials to recycle properly!":
      "¡Soy botas de goma viejas del trabajo de granja! ¡Estoy demasiado desgastado y materiales mixtos para reciclar correctamente!",

    // === TOWN GAME ===
    "Town Explorer 🏙️": "Explorador de la Ciudad 🏙️",
    "Meet Maya the Urban Explorer! She's passionate about keeping the town clean and sustainable. Help her sort the waste items she discovers around the busy streets!":
      "¡Conoce a Maya la Exploradora Urbana! Le apasiona mantener la ciudad limpia y sostenible. ¡Ayúdala a clasificar los residuos que descubre en las calles concurridas!",

    // === TOWN GAME (NEW STORY + QUIZ UI) ===
    "Story": "Historia",
    "Question": "Pregunta",
    "(Tap anywhere to continue)": "(Toca la pantalla para continuar)",
    "Let's clean the park first!": "¡Primero limpiemos el parque!",
    "Let's clean the park first!\nDrag each item into the right bin.":
      "¡Primero limpiemos el parque!\nArrastra cada objeto al contenedor correcto.",

    "People wait here every day.\nLet's keep the bus stand clean!":
      "La gente espera aquí todos los días.\n¡Mantengamos limpia la parada de autobús!",

    "Great job so far!\nLet's finish strong!":
      "¡Buen trabajo hasta ahora!\n¡Terminemos con fuerza!",

    // Town story slides
    "Hi kids! 👋\nI’m Maya.\n\nTap the screen to start our town adventure! ✨":
      "¡Hola niños! 👋\nSoy Maya.\n\n¡Toca la pantalla para empezar nuestra aventura en la ciudad! ✨",

    "School is over, and I’m walking back home through my town.\n\nCome along with me… let’s keep our town clean and happy! ✨":
      "La escuela terminó y voy caminando a casa por mi ciudad.\n\nVen conmigo… ¡mantengamos nuestra ciudad limpia y feliz! ✨",
    "Hi! I’m Maya 👋\nSchool is over, and I’m walking back home through my town.\n\nCome along with me… let’s travel to my home together and keep our town clean and happy! ✨":
      "¡Hola! Soy Maya 👋\nLa escuela terminó y voy caminando a casa por mi ciudad.\n\nVen conmigo… ¡vamos a mi casa y mantengamos nuestra ciudad limpia y feliz! ✨",
    "I love passing through the park… it’s my favorite place in town! 🌳":
      "Me encanta pasar por el parque… ¡es mi lugar favorito de la ciudad! 🌳",
    "This is the park we have in our town.\nIt’s famous for its big green trees, colorful flowers, and a fun play area.\n\nOn holidays and weekends, kids gather here to laugh, run, and play together!":
      "Este es el parque de nuestra ciudad.\nEs famoso por sus árboles grandes y verdes, flores de colores y un área divertida para jugar.\n\nEn días libres y fines de semana, los niños vienen aquí a reír, correr y jugar juntos.",
    "Oh no! Look… there’s some waste on the ground.\n\nSo sad to see trash in such a beautiful place.":
      "¡Oh no! Mira… hay basura en el suelo.\n\nQué tristeza ver basura en un lugar tan bonito.",
    "But don’t worry — we can help!\n\nLet’s sort these items into the correct bins. Ready? ✅":
      "Pero no te preocupes — ¡podemos ayudar!\n\nClasifiquemos estos objetos en los contenedores correctos. ¿Listos? ✅",

    "Next stop… the bus stand! 🚏\n\nPeople wait here every day to go to school, work, and visit friends.":
      "Siguiente parada… ¡la parada de autobús! 🚏\n\nLa gente espera aquí todos los días para ir a la escuela, al trabajo y a visitar amigos.",
    "Next stop… the bus stand! 🚏\n\nLots of people wait here for the bus.":
      "Siguiente parada… ¡la parada de autobús! 🚏\n\nMucha gente espera aquí el autobús.",
    "I see trash near the bus stop bench and signboard.\n\nOh no… it looks messy.":
      "Veo basura cerca del banco y el letrero.\n\nOh no… se ve desordenado.",
    "Trash can make this place dirty and unsafe.\n\nLet’s help keep the bus stand clean!":
      "La basura puede ensuciar este lugar y hacerlo peligroso.\n\n¡Ayudemos a mantener limpia la parada de autobús!",
    "People wait here every day.\nLet’s keep it clean!\n\nSort each item into the right bin ✅":
      "La gente espera aquí todos los días.\n¡Mantengámoslo limpio!\n\nClasifica cada objeto en el contenedor correcto ✅",
    "Let’s keep this place clean!\n\nSort each item into the right bin ✅":
      "¡Mantengamos este lugar limpio!\n\nClasifica cada objeto en el contenedor correcto ✅",

    "Meow! 🐱\nA small cat walks up.":
      "¡Miau! 🐱\nUn gatito se acerca.",
    "Hi kitty! I’ll call you Coco 🐱\n\nCoco is my friend.\nCoco wants a clean town too! 💛":
      "¡Hola gatito! Te llamaré Coco 🐱\n\nCoco es mi amigo.\n¡Coco también quiere una ciudad limpia! 💛",
    "Hi kitty! I’ll call you Coco 🐱\n\nCoco is my friend.\nLet’s go together! 💛":
      "¡Hola gatito! Te llamaré Coco 🐱\n\nCoco es mi amigo.\n¡Vamos juntos! 💛",
    "Now Maya and Coco reach the grocery store. 🏪\n\nThis is the last place to clean!":
      "Ahora Maya y Coco llegan a la tienda. 🏪\n\n¡Este es el último lugar para limpiar!",
    "Now we reach the grocery store. 🏪\n\nThis is our last stop!":
      "Ahora llegamos a la tienda. 🏪\n\n¡Esta es nuestra última parada!",
    "Oh no… there is more waste near the entrance.\n\nLet’s help and make it clean!":
      "Oh no… hay más basura cerca de la entrada.\n\n¡Ayudemos y dejémoslo limpio!",
    "Oh no… more waste near the entrance.\n\nLet’s put it in the right bin!":
      "Oh no… más basura cerca de la entrada.\n\n¡Pongámosla en el contenedor correcto!",
    "Uh oh… more waste near the entrance.\n\nLet’s put it in the right bin!":
      "Uy… más basura cerca de la entrada.\n\n¡Pongámosla en el contenedor correcto!",
    "Great job so far!\nLet’s finish strong!\n\nSort the final items ✅":
      "¡Buen trabajo hasta ahora!\n¡Vamos a terminar con fuerza!\n\nClasifica los últimos objetos ✅",
    "Great job!\nLet’s finish strong!\n\nSort the last items ✅":
      "¡Buen trabajo!\n¡Vamos a terminar con fuerza!\n\nClasifica los últimos objetos ✅",

    // Town questions + feedback
    "🌱 Which of these can turn into soil and help plants grow?":
      "🌱 ¿Cuál de estos puede convertirse en tierra y ayudar a las plantas a crecer?",
    "Plastic bottle": "Botella de plástico",
    "Banana peel": "Cáscara de plátano",
    "Candy wrapper": "Envoltura de dulce",
    "🎉 Awesome!\nBanana peels are food waste. They can turn into compost and help plants grow.":
      "🎉 ¡Genial!\nLas cáscaras de plátano son restos de comida.\nPueden convertirse en composta y ayudar a las plantas a crecer.",
    "❌ Oops!\nThe correct answer is banana peel 🍌\nFood waste breaks down naturally and becomes compost for plants.":
      "❌ ¡Ups!\nLa respuesta correcta es cáscara de plátano 🍌\nLos restos de comida se descomponen y se vuelven composta para las plantas.",

    "♻️ Why should we recycle bottles and cans?":
      "♻️ ¿Por qué debemos reciclar botellas y latas?",
    "To make the trash heavier": "Para hacer la basura más pesada",
    "To reuse materials and save resources": "Para reutilizar materiales y ahorrar recursos",
    "To throw them on the road": "Para tirarlos en la calle",
    "🌟 Correct!\nRecycling helps reuse materials and saves energy and natural resources.":
      "🌟 ¡Correcto!\nReciclar ayuda a reutilizar materiales y ahorra energía y recursos naturales.",
    "❌ Sorry!\nThe correct answer is: to reuse materials and save resources.\nRecycling protects our planet 🌍":
      "❌ Lo siento.\nLa respuesta correcta es: reutilizar materiales y ahorrar recursos.\nReciclar protege nuestro planeta 🌍",

    // Town questions (extra pool)
    "🧻 Where does a paper napkin go?": "🧻 ¿Dónde va una servilleta de papel?",
    "✅ Correct!\nPaper napkins can go in compost.": "✅ ¡Correcto!\nLas servilletas de papel pueden ir al compost.",
    "❌ Not this one.\nPaper napkins go in compost.": "❌ No es esta.\nLas servilletas de papel van al compost.",

    "🍬 Where does a candy wrapper go?": "🍬 ¿Dónde va una envoltura de dulce?",
    "✅ Correct!\nCandy wrappers go to landfill.": "✅ ¡Correcto!\nLas envolturas van al vertedero.",
    "❌ Not this one.\nCandy wrappers go to landfill.": "❌ No es esta.\nLas envolturas van al vertedero.",

    "🍾 Where does a glass bottle go?": "🍾 ¿Dónde va una botella de vidrio?",
    "✅ Correct!\nGlass bottles go in recycle.": "✅ ¡Correcto!\nLas botellas de vidrio van al reciclaje.",
    "❌ Not this one.\nGlass bottles go in recycle.": "❌ No es esta.\nLas botellas de vidrio van al reciclaje.",

    "🛍️ Where does a plastic carry bag go?": "🛍️ ¿Dónde va una bolsa de plástico?",
    "✅ Correct!\nPlastic carry bags go to landfill.": "✅ ¡Correcto!\nLas bolsas de plástico van al vertedero.",
    "❌ Not this one.\nPlastic carry bags go to landfill.": "❌ No es esta.\nLas bolsas de plástico van al vertedero.",
    
    // Town Items
    "Restaurant Food Scraps": "Restos de Comida de Restaurante",
    "Market Vegetable Peels": "Cáscaras de Verduras del Mercado",
    "Coffee Shop Grounds": "Café Molido de la Cafetería",
    "Park Fallen Leaves": "Hojas Caídas del Parque",
    // "Plastic Bottles" already defined above (line 51)
    "Bus Stop Soda Can": "Lata de Refresco de la Parada de Autobús",
    "Town Hall Documents": "Documentos del Ayuntamiento",
    "Chocolate Covers": "Envolturas de Chocolate",
    "Broken Phone": "Teléfono Roto",
    "Disposable Coffee Cups": "Tazas de Café Desechables",
    "Cigarette Butts": "Colillas de Cigarrillos",
    
    // Town Item Descriptions
    "I'm leftover food from the busy town restaurant! Maya knows I can become rich soil for urban gardens!":
      "¡Soy sobras de comida del ajetreado restaurante de la ciudad! ¡Maya sabe que puedo convertirme en tierra rica para jardines urbanos!",
    "I'm vegetable peels from the farmers market! Maya can compost me to support urban agriculture!":
      "¡Soy cáscaras de verduras del mercado de agricultores! ¡Maya puede compostarme para apoyar la agricultura urbana!",
    "I'm used coffee grounds from the town café! Maya can compost me to enrich urban garden soil!":
      "¡Soy café molido usado de la cafetería de la ciudad! ¡Maya puede compostarme para enriquecer el suelo del jardín urbano!",
    "I'm fallen leaves from the town park! Maya can compost me to create natural fertilizer for city plants!":
      "¡Soy hojas caídas del parque de la ciudad! ¡Maya puede compostarme para crear fertilizante natural para las plantas de la ciudad!",
    "I'm plastic bottles Maya found around town! I can be recycled into new bottles for the community!":
      "¡Soy botellas de plástico que Maya encontró por la ciudad! ¡Puedo reciclarse en nuevas botellas para la comunidad!",
    "I'm an aluminum can Maya spotted at the bus stop! I can be recycled endlessly into new cans!":
      "¡Soy una lata de aluminio que Maya vio en la parada de autobús! ¡Puedo reciclarse infinitamente en nuevas latas!",
    "I'm old office paper from the town hall! Maya collected me to become new paper for city planning!":
      "¡Soy papel viejo de oficina del ayuntamiento! ¡Maya me recogió para convertirme en papel nuevo para la planificación de la ciudad!",
    "I'm glass bottles from town restaurants! Maya can recycle me into new glass containers!":
      "¡Soy botellas de vidrio de restaurantes de la ciudad! ¡Maya puede reciclarme en nuevos recipientes de vidrio!",
    "I'm chocolate wrappers Maya found on the street! I'm made of mixed materials that can't be recycled!":
      "¡Soy envolturas de chocolate que Maya encontró en la calle! ¡Estoy hecho de materiales mixtos que no se pueden reciclar!",
    "I'm a broken phone from the electronics district! Maya knows I need special e-waste disposal!":
      "¡Soy un teléfono roto del distrito de electrónica! ¡Maya sabe que necesito eliminación especial de residuos electrónicos!",
    "I'm disposable cups from the town café! Maya wishes I was compostable, but I have plastic lining!":
      "¡Soy tazas desechables de la cafetería de la ciudad! ¡Maya desearía que fuera compostable, pero tengo revestimiento de plástico!",
    "I'm cigarette butts Maya found on busy streets! I contain toxic chemicals that need proper disposal!":
      "¡Soy colillas de cigarrillos que Maya encontró en calles concurridas! ¡Contengo químicos tóxicos que necesitan eliminación adecuada!",

    // === SPACE GAME ===
    "Space Mission 🚀": "Misión Espacial 🚀",
    "Meet Captain Luna! She's on a mission to clean up space debris around Earth. Help her sort the items she finds during her cosmic journey!":
      "¡Conoce a la Capitana Luna! Está en una misión para limpiar los desechos espaciales alrededor de la Tierra. ¡Ayúdala a clasificar los artículos que encuentra durante su viaje cósmico!",
    
    // Space Items
    "Space Garden Scraps": "Restos del Jardín Espacial",
    "Astronaut Food Waste": "Residuos de Comida de Astronauta",
    "Space Coffee Grounds": "Café Molido Espacial",
    "Hydroponic Plant Waste": "Residuos de Plantas Hidropónicas",
    "Satellite Metal Piece": "Pieza de Metal de Satélite",
    "Fuel Container": "Contenedor de Combustible",
    "Mission Reports": "Informes de Misión",
    "Space Station Metal Scraps": "Chatarra de Metal de la Estación Espacial",
    "Rocket Waste": "Residuos de Cohete",
    "Space Jet Waste": "Residuos de Jet Espacial",
    "Damaged Solar Panel": "Panel Solar Dañado",
    "Contaminated Lab Equipment": "Equipo de Laboratorio Contaminado",
    
    // Space Item Descriptions
    "I'm leftover food from the space station garden! Captain Luna can compost me to grow more plants in space!":
      "¡Soy sobras de comida del jardín de la estación espacial! ¡La Capitana Luna puede compostarme para cultivar más plantas en el espacio!",
    "I'm food scraps from Captain Luna's space meals! I can become soil for space farming!":
      "¡Soy restos de comida de las comidas espaciales de la Capitana Luna! ¡Puedo convertirme en tierra para la agricultura espacial!",
    "I'm coffee grounds from Captain Luna's morning brew! I can help grow plants in the space garden!":
      "¡Soy café molido del café matutino de la Capitana Luna! ¡Puedo ayudar a cultivar plantas en el jardín espacial!",
    "I'm old plant matter from the space station's hydroponic farm! Captain Luna can compost me for new crops!":
      "¡Soy materia vegetal vieja de la granja hidropónica de la estación espacial! ¡La Capitana Luna puede compostarme para nuevos cultivos!",
    "Captain Luna found me floating from an old satellite! I can be recycled into new space equipment!":
      "¡La Capitana Luna me encontró flotando de un satélite viejo! ¡Puedo reciclarse en nuevo equipo espacial!",
    "Captain Luna discovered me drifting near the space station! I held rocket fuel and can be recycled!":
      "¡La Capitana Luna me descubrió a la deriva cerca de la estación espacial! ¡Contenía combustible de cohete y puedo reciclarse!",
    "I'm old space mission documents Captain Luna collected! I can be recycled into new paper!":
      "¡Soy documentos viejos de misión espacial que la Capitana Luna recopiló! ¡Puedo reciclarse en papel nuevo!",
    "I'm metal pieces from space station maintenance! Captain Luna can recycle me into new parts!":
      "¡Soy piezas de metal del mantenimiento de la estación espacial! ¡La Capitana Luna puede reciclarme en nuevas piezas!",
    "I'm damaged rocket components Captain Luna found! I'm too contaminated with fuel to recycle safely!":
      "¡Soy componentes de cohete dañados que la Capitana Luna encontró! ¡Estoy demasiado contaminado con combustible para reciclar de manera segura!",
    "I'm debris from old space jets! Captain Luna knows I contain hazardous materials that need special disposal!":
      "¡Soy escombros de viejos jets espaciales! ¡La Capitana Luna sabe que contengo materiales peligrosos que necesitan eliminación especial!",
    "I'm a broken solar panel Captain Luna found! I'm too damaged and contain toxic materials for safe recycling!":
      "¡Soy un panel solar roto que la Capitana Luna encontró! ¡Estoy demasiado dañado y contengo materiales tóxicos para el reciclaje seguro!",
    "I'm lab equipment from space experiments! Captain Luna knows I'm contaminated and need hazardous waste disposal!":
      "¡Soy equipo de laboratorio de experimentos espaciales! ¡La Capitana Luna sabe que estoy contaminado y necesito eliminación de residuos peligrosos!",

    // Common Game UI
    "Correct!": "¡Correcto!",
    "Oops, try again!": "¡Ups, inténtalo de nuevo!",
    "🎉 Congratulations! 🎉": "🎉 ¡Felicitaciones! 🎉",
    "You've successfully sorted all the waste items!": "¡Has clasificado exitosamente todos los residuos!",
    "Back to Home": "Volver al Inicio",

    // Home Screen
    "Tidy Town": "Ciudad Limpia",
    "Welcome": "Bienvenidos",
    "PLAY": "JUGAR",
    "LEARN": "APRENDER",
    "Your Learning Progress": "Tu Progreso de Aprendizaje",
    "completed": "completados",
    "Start": "Comenzar",
    "🎮 Choose a Game 🎮": "🎮 Elige un Juego 🎮",
    "Waste Sorting\nGame": "Juego de\nClasificación",
    "Memory Match\nGame": "Juego de\nMemoria",
    "Reset": "Reiniciar",

    // Compost Screen Cards
    "What is Composting?": "¿Qué es el Compostaje?",
    "Learn about composting in a fun way! 🌟": "¡Aprende sobre el compostaje de manera divertida! 🌟",
    "What Can Be Composted?": "¿Qué se Puede Compostar?",
    "Discover compostable items! 🔍": "¡Descubre artículos compostables! 🔍",
    "Why Should We Compost?": "¿Por Qué Debemos Compostar?",
    "Meet Wally the Worm! 🐛": "¡Conoce a Wally el Gusano! 🐛",
    "Compost Quiz": "Cuestionario de Compostaje",
    // "Test your knowledge! 🎯" already defined at line 34
    "Composting 🌱": "Compostaje 🌱",

    // Landfill Screen Cards
    "Landfill Education 🏭": "Educación sobre Vertederos 🏭",
    "What is a Landfill?": "¿Qué es un Vertedero?",
    "Learn about landfills! 🌟": "¡Aprende sobre los vertederos! 🌟",
    "What Goes to Landfill?": "¿Qué Va al Vertedero?",
    // "Discover landfill items! 🔍" - similar to compost
    "Why Reduce Landfill?": "¿Por Qué Reducir el Vertedero?",
    "Meet Larry the Landfill! 🏭": "¡Conoce a Larry el Vertedero! 🏭",
    "Landfill Quiz": "Cuestionario de Vertedero",

    // Compost Story Titles
    "Mira the Apple Core's Magic": "La Magia de Mira el Corazón de Manzana",
    "Wally the Worm's Adventure": "La Aventura de Wally el Gusano",
    "The Magic Garden": "El Jardín Mágico",
    "Choose a story to learn why composting is important!": "¡Elige una historia para aprender por qué el compostaje es importante!",

    // Mira Story Content
    "Once upon a time, in a cozy kitchen, lived a little apple core named Mira. She had just been munched by a kid and was about to be thrown in the trash.":
      "Había una vez, en una acogedora cocina, vivía un pequeño corazón de manzana llamado Mira. Acababa de ser mordido por un niño y estaba a punto de ser tirado a la basura.",
    
    "But wait! \"I can still help the Earth!":
      "¡Pero espera! \"¡Todavía puedo ayudar a la Tierra!",
    
    "If we go into the trash, we'll be stuck in a stinky bin forever!":
      "¡Si vamos a la basura, estaremos atrapados en un contenedor apestoso para siempre!",
    
    "Hello there! Don't be sad… Come with me and I'll turn you into magic soil!":
      "¡Hola! No estés triste... ¡Ven conmigo y te convertiré en tierra mágica!",
    
    "Magic soil? Really?":
      "¿Tierra mágica? ¿De verdad?",
    
    "Yes! You'll help flowers grow and make the Earth happy again!":
      "¡Sí! ¡Ayudarás a que crezcan las flores y harás feliz a la Tierra de nuevo!",
    
    "Mira and her friends turned into rich, dark compost—superfood for plants!":
      "¡Mira y sus amigos se convirtieron en composta rica y oscura, superalimento para las plantas!",

    // Wally Worm Story Content
    "Deep under the garden, in a cozy pile of leaves and peels, lived a wiggly little worm named Wally. Wally wasn't just any worm—he was a Compost Explorer!":
      "Profundo bajo el jardín, en un acogedor montón de hojas y cáscaras, vivía un pequeño gusano llamado Wally. ¡Wally no era un gusano cualquiera, era un Explorador de Composta!",
    
    "Oh no! So much yummy food is being thrown away into the trash!":
      "¡Oh no! ¡Tanta comida deliciosa está siendo tirada a la basura!",
    
    "He wiggled and wriggled his way toward the kitchen window and saw a banana peel, carrot tops, and a sad slice of bread all being dumped in the garbage bin.":
      "Se movió y retorció hacia la ventana de la cocina y vio una cáscara de plátano, puntas de zanahoria y una triste rebanada de pan siendo tiradas al cubo de basura.",
    
    "\"They don't belong there,\" said Wally. \"They could join our compost party and become soil superheroes!\"":
      "\"No pertenecen allí\", dijo Wally. \"¡Podrían unirse a nuestra fiesta de composta y convertirse en superhéroes del suelo!\"",
    
    "🪱💬 Wally shouted, \"Hey friends! Want to help flowers grow? Follow me!\"":
      "🪱💬 Wally gritó, \"¡Oigan amigos! ¿Quieren ayudar a que crezcan las flores? ¡Síganme!\"",
    
    "The banana peel blinked. \"We can help plants grow?\"":
      "La cáscara de plátano parpadeó. \"¿Podemos ayudar a que crezcan las plantas?\"",
    
    "Wally nodded. \"Absolutely! When we compost together, we turn into magic soil that makes gardens bloom!\"":
      "Wally asintió. \"¡Absolutamente! Cuando hacemos composta juntos, ¡nos convertimos en tierra mágica que hace florecer los jardines!\"",
    
    "So one by one, the food scraps jumped out of the trash and followed Wally into the compost pile. It was warm, squishy, and full of other friendly worms.":
      "Así que uno por uno, los restos de comida saltaron de la basura y siguieron a Wally al montón de composta. Era cálido, blando y lleno de otros gusanos amigables.",
    
    "Wally led them on a journey deep into the pile, where they met dancing microbes and giggling bugs working together to turn everything into dark, rich compost.":
      "Wally los guió en un viaje profundo en el montón, donde conocieron microbios bailarines e insectos risueños trabajando juntos para convertir todo en composta oscura y rica.",
    
    "After a few days of wiggling, munching, and mixing…":
      "Después de unos días de moverse, masticar y mezclar...",
    
    "✨POOF!✨ The banana peel and all her new friends had transformed into super soil!":
      "✨¡POOF!✨ ¡La cáscara de plátano y todos sus nuevos amigos se habían transformado en súper tierra!",
    
    "🌼 They were spread across a garden, helping sunflowers grow tall, strawberries turn sweet, and trees grow strong.":
      "🌼 Se extendieron por un jardín, ayudando a los girasoles a crecer altos, a las fresas a volverse dulces y a los árboles a fortalecerse.",
    
    "Wally smiled proudly. \"Another compost mission complete!\"":
      "Wally sonrió orgulloso. \"¡Otra misión de composta completada!\"",
    
    "And off he went, ready for his next big adventure…":
      "Y se fue, listo para su próxima gran aventura...",
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
