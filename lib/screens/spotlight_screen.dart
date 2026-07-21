import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:chewie/chewie.dart';
import '../utils/theme.dart';
import '../services/api_service.dart';

class SpotlightScreen extends StatefulWidget {
  const SpotlightScreen({super.key});

  @override
  State<SpotlightScreen> createState() => _SpotlightScreenState();
}

class _SpotlightScreenState extends State<SpotlightScreen> {
  List<Map<String, dynamic>> _videos = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadVideos();
  }

  Future<void> _loadVideos() async {
    try {
      final api = ApiService();
      final response = await api.get('spotlight-feed.php');
      if (response['success'] == true) {
        setState(() {
          _videos = List<Map<String, dynamic>>.from(response['videos'] ?? []);
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: StaffelTheme.background,
      appBar: AppBar(
        title: const Text('Spotlight'),
        backgroundColor: Colors.transparent,
        foregroundColor: StaffelTheme.text,
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              // TODO: Upload spotlight video
            },
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _videos.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.play_circle_outline,
                        size: 80,
                        color: Colors.white.withOpacity(0.1),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'No spotlight videos yet',
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.2),
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Upload your first video',
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.1),
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(8),
                  itemCount: _videos.length,
                  itemBuilder: (context, index) {
                    final video = _videos[index];
                    return Container(
                      margin: const EdgeInsets.only(bottom: 16),
                      decoration: BoxDecoration(
                        color: StaffelTheme.card,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: StaffelTheme.border),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ClipRRect(
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(12),
                              topRight: Radius.circular(12),
                            ),
                            child: Container(
                              height: 200,
                              color: Colors.black,
                              child: Center(
                                child: Icon(
                                  Icons.play_circle_outline,
                                  size: 50,
                                  color: Colors.white.withOpacity(0.5),
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(12),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    CircleAvatar(
                                      radius: 16,
                                      backgroundColor: StaffelTheme.accent.withOpacity(0.2),
                                      child: Text(
                                        (video['display_name'] ?? 'U')[0].toUpperCase(),
                                        style: const TextStyle(
                                          color: StaffelTheme.accent,
                                          fontSize: 12,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      video['display_name'] ?? 'Unknown',
                                      style: const TextStyle(
                                        color: StaffelTheme.text,
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    const Spacer(),
                                    Icon(
                                      Icons.visibility,
                                      size: 16,
                                      color: Colors.white.withOpacity(0.3),
                                    ),
                                    const SizedBox(width: 4),
                                    Text(
                                      '${video['views'] ?? 0}',
                                      style: TextStyle(
                                        color: Colors.white.withOpacity(0.3),
                                        fontSize: 12,
                                      ),
                                    ),
                                  ],
                                ),
                                if (video['caption'] != null && video['caption'].isNotEmpty)
                                  Padding(
                                    padding: const EdgeInsets.only(top: 6),
                                    child: Text(
                                      video['caption'],
                                      style: TextStyle(
                                        color: Colors.white.withOpacity(0.7),
                                        fontSize: 14,
                                      ),
                                    ),
                                  ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 8),
                                  child: Row(
                                    children: [
                                      IconButton(
                                        icon: const Icon(Icons.favorite_border),
                                        color: Colors.white.withOpacity(0.3),
                                        onPressed: () {},
                                      ),
                                      IconButton(
                                        icon: const Icon(Icons.repeat),
                                        color: Colors.white.withOpacity(0.3),
                                        onPressed: () {},
                                      ),
                                      IconButton(
                                        icon: const Icon(Icons.share),
                                        color: Colors.white.withOpacity(0.3),
                                        onPressed: () {},
                                      ),
                                    ],
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
    );
  }
}
