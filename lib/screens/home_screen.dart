import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'recycle_screen.dart';
import 'compost_screen.dart';
import 'landfill_screen.dart';
import '../services/progress_service.dart';

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
  
  @override
  void initState() {
    super.initState();
    _speakWelcome();
  }

  Future<void> _speakWelcome() async {
    await flutterTts.setSpeechRate(0.3); // slow
    await flutterTts.setPitch(1.3); // kid-friendly pitch (1.0–2.0 is allowed)
    await flutterTts.setLanguage("en-US");
    await flutterTts.speak("Welcome");

    await Future.delayed(const Duration(seconds: 2));

    await flutterTts.setLanguage("es-ES");
    await flutterTts.speak("Bienvenidos");
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
            title: const Text('😢 Logout?'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const CircleAvatar(
                  radius: 30,
                  backgroundImage: AssetImage('assets/images/avatar.png'),
                ),
                const SizedBox(height: 10),
                const Text(
                  'Hey Western! Are you sure you want to logout?',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(); // Close dialog
                },
                child: const Text('Cancel'),
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
                child: const Text('Logout'),
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
              category.name,
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
                  '${category.completedQuestions}/${category.totalQuestions} completed',
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
                        default:
                          return const RecycleScreen();
                      }
                    },
                  ),
                );
              },
              child: const Text(
                'Start',
                style: TextStyle(color: Colors.white),
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
        totalQuestions: ProgressService.getTotalQuestions('Recycle'),
        completedQuestions: recycleProgress,
        icon: Icons.recycling,
        color: Colors.green,
      ),
      CategoryProgress(
        name: 'Compost',
        totalQuestions: ProgressService.getTotalQuestions('Compost'),
        completedQuestions: compostProgress,
        icon: Icons.eco,
        color: Colors.brown,
      ),
      CategoryProgress(
        name: 'Landfill',
        totalQuestions: ProgressService.getTotalQuestions('Landfill'),
        completedQuestions: landfillProgress,
        icon: Icons.delete,
        color: Colors.grey,
      ),
    ];
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
              const Text(
                'Your Learning Progress',
                style: TextStyle(
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
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/HomePage.png"),
            fit: BoxFit.cover,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Avatar and stars section
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.3,
                child: Stack(
                  children: [
                    Align(
                      alignment: Alignment.center,
                      child: Transform.translate(
                        offset: const Offset(0, 5),
                        child: Container(
                          width: 150,
                          height: 150,
                          decoration: const BoxDecoration(
                            color: Color.fromARGB(255, 207, 65, 5),
                            image: DecorationImage(
                              image: AssetImage('assets/images/avatar.png'),
                              alignment: Alignment.center,
                            ),
                            shape: BoxShape.circle,
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 40,
                      left: 0,
                      right: 0,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Row(
                            children: [
                              Icon(Icons.star, color: Colors.red, size: 40),
                              Icon(Icons.star, color: Colors.orange, size: 40),
                              Icon(Icons.star, color: Colors.amber, size: 40),
                              Icon(Icons.star, color: Colors.green, size: 40),
                              Icon(Icons.star, color: Color(0xFFB2D235), size: 40),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              
              // Spacer to push buttons to bottom
              const Spacer(),
              
              // Bottom buttons container
              Padding(
                padding: const EdgeInsets.only(bottom: 110),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Play Button
                    Padding(
                      padding: const EdgeInsets.only(left: 0, right: 40),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Transform.rotate(
                          angle: -0.2,
                          child: GestureDetector(
                            onTap: () => print("Play pressed"),
                            child: Container(
                              width: MediaQuery.of(context).size.width * 0.4,
                              height: 70,
                              alignment: Alignment.center,
                              child: const Text(
                                "Play",
                                style: TextStyle(
                                  color: Color(0xFF4A3728),
                                  fontSize: 44,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'Comic Sans MS',
                                  shadows: [
                                    Shadow(
                                      offset: Offset(2.0, 2.0),
                                      blurRadius: 3.0,
                                      color: Color.fromARGB(255, 74, 55, 40),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    
                    // Learn Button
                    Padding(
                      padding: const EdgeInsets.only(left: 40, right: 0),
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: Transform.rotate(
                          angle: 0.2,
                          child: GestureDetector(
                            onTap: _showProgressDialog,
                            child: Container(
                              width: MediaQuery.of(context).size.width * 0.4,
                              height: 70,
                              alignment: Alignment.center,
                              child: const Text(
                                "Learn",
                                style: TextStyle(
                                  color: Color(0xFF4A3728),
                                  fontSize: 44,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'Comic Sans MS',
                                  shadows: [
                                    Shadow(
                                      offset: Offset(2.0, 2.0),
                                      blurRadius: 3.0,
                                      color: Color.fromARGB(255, 74, 55, 40),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGradientButton({
    required IconData icon,
    required VoidCallback onPressed,
    bool isPopupMenu = false,
  }) {
    final buttonContent = Container(
      padding: const EdgeInsets.all(12),
      child: Icon(
        icon,
        size: 35,
        color: const Color.fromARGB(255, 255, 250, 250),
      ),
    );

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
        icon: buttonContent,
        padding: EdgeInsets.zero,
      ),
    );
  }
}
