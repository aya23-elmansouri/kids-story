import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'stories_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'قصص الأطفال',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'Cairo',
        scaffoldBackgroundColor: const Color.fromARGB(255, 224, 249, 243),
        primaryColor: const Color.fromARGB(255, 0, 138, 138),
        textTheme: const TextTheme(
          bodyLarge: TextStyle(fontSize: 22, color: Color(0xFF004D4D)),
          titleLarge: TextStyle(fontSize: 30, fontWeight: FontWeight.bold, color: Color(0xFF004D4D)),
        ),
      ),
      home: const StartScreen(),
    );
  }
}

class StartScreen extends StatefulWidget {
  const StartScreen({Key? key}) : super(key: key);

  @override
  State<StartScreen> createState() => _StartScreenState();
}

class _StartScreenState extends State<StartScreen> {
  late final AudioPlayer _audioPlayer;

  @override
  void initState() {
    super.initState();
    _audioPlayer = AudioPlayer();
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  Future<void> _playSoundAndNavigate() async {
    try {
      await _audioPlayer.play(AssetSource('mixkit-happy-child-laughing-2265.wav'));
    } catch (e) {
      debugPrint('حدث خطأ أثناء تشغيل الصوت: $e');
    }

    if (!mounted) return;
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const StoriesScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const WelcomeText(),
            const SizedBox(height: 40),
            const StoryImage(),
            const SizedBox(height: 50),
            StartButton(onPressed: _playSoundAndNavigate),
          ],
        ),
      ),
    );
  }
}

class WelcomeText extends StatelessWidget {
  const WelcomeText({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      'مرحبًا بك في عالم القصص الجميلة',
      style: Theme.of(context).textTheme.titleLarge?.copyWith(
            shadows: const [
              Shadow(
                blurRadius: 4,
                color: Colors.black26,
                offset: Offset(2, 2),
              ),
            ],
          ),
      textAlign: TextAlign.center,
    );
  }
}

class StoryImage extends StatelessWidget {
  const StoryImage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        height: 230,
        width: 230,
        decoration: BoxDecoration(
          color: Colors.teal.shade100.withOpacity(0.3),
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: Colors.teal.shade300.withOpacity(0.4),
              blurRadius: 12,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(24),
          child: Image.asset(
            'images/M.jpg',
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}

class StartButton extends StatelessWidget {
  final VoidCallback onPressed;

  const StartButton({required this.onPressed, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      icon: const Icon(Icons.play_arrow, size: 26, color: Colors.white),
      label: const Text(
        'ابدأ',
        style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white),
      ),
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 18),
        backgroundColor: Colors.teal.shade300,
        elevation: 10,
        shadowColor: Colors.teal.shade300,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
      ),
    );
  }
}

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: const Text('قصص الأطفال'),
      centerTitle: true,
      backgroundColor: Colors.teal.shade300, 
      elevation: 6,
      shadowColor: Colors.teal.shade300,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
