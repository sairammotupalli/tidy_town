import 'package:flutter/material.dart';
import '../widgets/lets_play_button.dart';
import '../widgets/image_button.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'recycle_screen.dart';
import 'compost_screen.dart';
import 'landfill_screen.dart';

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/home_back.png"),
            fit: BoxFit.cover,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
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
                      const SizedBox(height: 10),
                      LetsPlayButton(onPressed: () => print("Let's Play pressed")),
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          ImageButton(
                            label: "Recycle",
                            imagePath: "assets/images/recycle/recycle_ws.jpeg",
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const RecycleScreen(),
                                ),
                              );
                            },
                          ),
                          ImageButton(
                            label: "Compost",
                            imagePath: "assets/images/compost/compost_ws.png",
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const CompostScreen(),
                                ),
                              );
                            },
                          ),
                          ImageButton(
                            label: "Landfill",
                            imagePath: "assets/images/landfill/landfill_ws.jpg",
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const LandfillScreen(),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
                decoration: BoxDecoration(
                  // color: Colors.white.withOpacity(0.9),
                  borderRadius: BorderRadius.circular(25),
                  // boxShadow: [
                  //   BoxShadow(
                  //     color: Colors.black.withOpacity(0.1),
                  //     spreadRadius: 1,
                  //     blurRadius: 10,
                  //     offset: const Offset(0, -2),
                  //   ),
                  // ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildGradientButton(
                      icon: Icons.person,
                      onPressed: () => _showLogoutDialog(context),
                      isPopupMenu: true,
                    ),
                    _buildGradientButton(
                      icon: Icons.home,
                      onPressed: () {},
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
      padding: const EdgeInsets.all(16),
      child: Icon(
        icon,
        size: 55,
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
      child: isPopupMenu
          ? PopupMenuButton<String>(
              onSelected: (value) {
                if (value == 'logout') {
                  onPressed();
                }
              },
              itemBuilder: (context) => [
                const PopupMenuItem(
                  value: 'logout',
                  child: Text('Logout'),
                ),
              ],
              child: buttonContent,
            )
          : IconButton(
              onPressed: onPressed,
              icon: buttonContent,
              padding: EdgeInsets.zero,
            ),
    );
  }
}
