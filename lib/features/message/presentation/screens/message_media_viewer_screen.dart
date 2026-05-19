import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class MessageMediaViewerScreen extends StatefulWidget {
  final String mediaUrl;
  final String mediaType;
  final String? title;

  const MessageMediaViewerScreen({
    super.key,
    required this.mediaUrl,
    required this.mediaType,
    this.title,
  });

  @override
  State<MessageMediaViewerScreen> createState() => _MessageMediaViewerScreenState();
}

class _MessageMediaViewerScreenState extends State<MessageMediaViewerScreen> {
  VideoPlayerController? _videoController;
  Future<void>? _initializeVideoFuture;
  bool _showControls = true;

  @override
  void initState() {
    super.initState();
    if (_isVideo) {
      _videoController = VideoPlayerController.networkUrl(
        Uri.parse(widget.mediaUrl),
      );
      _initializeVideoFuture = _videoController!.initialize().then((_) {
        if (!mounted) return;
        setState(() {});
        _videoController!.play();
      });
      _videoController!.addListener(_onVideoStateChanged);
    }
  }

  bool get _isImage => widget.mediaType == 'image';
  bool get _isVideo => widget.mediaType == 'video';

  void _onVideoStateChanged() {
    if (!mounted || _videoController == null) return;
    setState(() {});
  }

  @override
  void dispose() {
    _videoController?.removeListener(_onVideoStateChanged);
    _videoController?.dispose();
    super.dispose();
  }

  void _toggleVideo() {
    if (_videoController == null) return;
    setState(() {
      if (_videoController!.value.isPlaying) {
        _videoController!.pause();
      } else {
        _videoController!.play();
      }
      _showControls = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        elevation: 0,
        title: Text(widget.title ?? 'Media'),
      ),
      body: SafeArea(
        child: Center(
          child: _isImage
              ? InteractiveViewer(
                  minScale: 0.8,
                  maxScale: 4,
                  child: Image.network(
                    widget.mediaUrl,
                    fit: BoxFit.contain,
                    width: double.infinity,
                    height: double.infinity,
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return const Center(
                        child: CircularProgressIndicator(color: Colors.white),
                      );
                    },
                    errorBuilder: (_, __, ___) => const Center(
                      child: Text(
                        'Unable to load image',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                )
              : _isVideo
                  ? FutureBuilder<void>(
                      future: _initializeVideoFuture,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return const Center(
                            child: CircularProgressIndicator(
                              color: Colors.white,
                            ),
                          );
                        }

                        if (_videoController == null ||
                            !_videoController!.value.isInitialized) {
                          return const Center(
                            child: Text(
                              'Unable to load video',
                              style: TextStyle(color: Colors.white),
                            ),
                          );
                        }

                        return GestureDetector(
                          onTap: _toggleVideo,
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              AspectRatio(
                                aspectRatio:
                                    _videoController!.value.aspectRatio,
                                child: VideoPlayer(_videoController!),
                              ),
                              if (_showControls || !_videoController!.value.isPlaying)
                                Container(
                                  decoration: BoxDecoration(
                                    color: Colors.black.withOpacity(0.25),
                                    shape: BoxShape.circle,
                                  ),
                                  padding: const EdgeInsets.all(14),
                                  child: Icon(
                                    _videoController!.value.isPlaying
                                        ? Icons.pause
                                        : Icons.play_arrow,
                                    color: Colors.white,
                                    size: 40,
                                  ),
                                ),
                              Positioned(
                                bottom: 16,
                                left: 16,
                                right: 16,
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    VideoProgressIndicator(
                                      _videoController!,
                                      allowScrubbing: true,
                                      colors: const VideoProgressColors(
                                        playedColor: Colors.white,
                                        bufferedColor: Colors.white54,
                                        backgroundColor: Colors.white24,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          _videoController!.value.position
                                              .toString()
                                              .split('.')
                                              .first,
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 12,
                                          ),
                                        ),
                                        Text(
                                          _videoController!.value.duration
                                              .toString()
                                              .split('.')
                                              .first,
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 12,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    )
                  : Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.insert_drive_file_outlined,
                          color: Colors.white,
                          size: 72,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          widget.title ?? 'File',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'Preview is not available for this file type.',
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.white70),
                        ),
                      ],
                    ),
        ),
      ),
    );
  }
}
