import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'DB.dart';
import 'story.dart';
import 'story_details.dart';

class AudioManager {
  final AudioPlayer _player = AudioPlayer();

  Future<void> playClickSound() async {
    try {
      await _player.play(AssetSource('mixkit-casino-bling-achievement-2067.wav'));
    } catch (e) {
      debugPrint('Error playing sound: $e');
    }
  }

  void dispose() {
    _player.dispose();
  }
}


class StoryRepository {
  Future<List<Story>> fetchStories() async {
    final data = await DatabaseHelper().getAllStories();
    return data.map((s) => Story.fromMap(s)).toList();
  }
}

class StoriesScreen extends StatefulWidget {
  const StoriesScreen({super.key});

  @override
  State<StoriesScreen> createState() => _StoriesScreenState();
}

class _StoriesScreenState extends State<StoriesScreen> {
  late Future<List<Story>> _storiesFuture;
  late final AudioManager _audioManager;
  late final StoryRepository _storyRepository;

  @override
  void initState() {
    super.initState();
    _audioManager = AudioManager();
    _storyRepository = StoryRepository();
    _storiesFuture = _storyRepository.fetchStories();
  }

  @override
  void dispose() {
    _audioManager.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.teal.shade50, Colors.teal.shade100],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
                alignment: Alignment.center,
                child: const Text(
                  'القصص المتاحة',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.teal,
                    shadows: [
                      Shadow(
                        offset: Offset(0, 1),
                        blurRadius: 3,
                        color: Colors.black26,
                      )
                    ],
                  ),
                ),
              ),
              Expanded(
                child: FutureBuilder<List<Story>>(
                  future: _storiesFuture,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return Center(child: Text('حدث خطأ: ${snapshot.error}'));
                    } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return const Center(child: Text('لا توجد قصص حالياً.'));
                    }

                    final stories = snapshot.data!;

                    return GridView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 16,
                        mainAxisSpacing: 16,
                        childAspectRatio: 0.75,
                      ),
                      itemCount: stories.length,
                      itemBuilder: (context, index) {
                        final story = stories[index];

                        return InkWell(
                          borderRadius: BorderRadius.circular(16),
                          onTap: () async {
                            await _audioManager.playClickSound();
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => StoryDetails(story: story),
                              ),
                            );
                          },
                          splashColor: Colors.teal.withOpacity(0.3),
                          child: Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            elevation: 8,
                            shadowColor: const Color.fromARGB(255, 26, 224, 204).withOpacity(0.3),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                Expanded(
                                  child: ClipRRect(
                                    borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                                    child: Image.asset(
                                      story.image,
                                      fit: BoxFit.cover,
                                      errorBuilder: (context, error, stackTrace) =>
                                          const Icon(Icons.broken_image, size: 60, color: Colors.grey),
                                    ),
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
                                  decoration: BoxDecoration(
                                    color: Colors.teal.shade50,
                                    borderRadius: const BorderRadius.vertical(bottom: Radius.circular(16)),
                                  ),
                                  child: Text(
                                    story.title,
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.teal,
                                    ),
                                    textAlign: TextAlign.center,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
