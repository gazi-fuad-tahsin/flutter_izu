import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

// ─── Base building blocks ─────────────────────────────────────────────────────

class _SkeletonBox extends StatelessWidget {
  final double? width;
  final double height;
  final double radius;

  const _SkeletonBox({this.width, required this.height, this.radius = 8});

  @override
  Widget build(BuildContext context) => Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(radius),
        ),
      );
}

class _SkeletonCircle extends StatelessWidget {
  final double size;
  const _SkeletonCircle(this.size);

  @override
  Widget build(BuildContext context) => Container(
        width: size,
        height: size,
        decoration: const BoxDecoration(shape: BoxShape.circle, color: Colors.white),
      );
}

Widget _shimmer(Widget child) => Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      child: child,
    );

// ─── Conversation tile skeleton (MessageScreen) ───────────────────────────────

class ConversationTileSkeleton extends StatelessWidget {
  const ConversationTileSkeleton({super.key});

  @override
  Widget build(BuildContext context) => _shimmer(
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          child: Row(
            children: [
              _SkeletonCircle(56),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _SkeletonBox(width: 140, height: 14, radius: 6),
                    const SizedBox(height: 8),
                    _SkeletonBox(height: 12, radius: 6),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  _SkeletonBox(width: 40, height: 10, radius: 4),
                  const SizedBox(height: 8),
                  _SkeletonCircle(20),
                ],
              ),
            ],
          ),
        ),
      );
}

// ─── Notification item skeleton (NotificationsScreen) ────────────────────────

class NotificationItemSkeleton extends StatelessWidget {
  const NotificationItemSkeleton({super.key});

  @override
  Widget build(BuildContext context) => _shimmer(
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _SkeletonBox(width: 40, height: 40, radius: 8),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _SkeletonBox(height: 13, radius: 6),
                    const SizedBox(height: 6),
                    _SkeletonBox(width: 180, height: 11, radius: 6),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              _SkeletonBox(width: 36, height: 10, radius: 4),
            ],
          ),
        ),
      );
}

// ─── Booking card skeleton (BookingListScreen & ProviderBookingScreen) ─────────

class BookingCardSkeleton extends StatelessWidget {
  const BookingCardSkeleton({super.key});

  @override
  Widget build(BuildContext context) => _shimmer(
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.grey.shade200),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header — avatar + name + badge
              Row(
                children: [
                  _SkeletonCircle(48),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _SkeletonBox(width: 130, height: 14, radius: 6),
                        const SizedBox(height: 6),
                        _SkeletonBox(width: 90, height: 11, radius: 6),
                      ],
                    ),
                  ),
                  _SkeletonBox(width: 60, height: 24, radius: 12),
                ],
              ),
              const SizedBox(height: 16),
              // Detail rows
              ...List.generate(3, (_) => Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Row(
                  children: [
                    _SkeletonBox(width: 16, height: 16, radius: 4),
                    const SizedBox(width: 8),
                    _SkeletonBox(width: 160, height: 12, radius: 6),
                  ],
                ),
              )),
              const SizedBox(height: 8),
              // Buttons
              Row(
                children: [
                  Expanded(child: _SkeletonBox(height: 40, radius: 20)),
                  const SizedBox(width: 12),
                  Expanded(child: _SkeletonBox(height: 40, radius: 20)),
                ],
              ),
            ],
          ),
        ),
      );
}

// ─── Service card skeleton (YourServicesScreen) ──────────────────────────────

class ServiceCardSkeleton extends StatelessWidget {
  const ServiceCardSkeleton({super.key});

  @override
  Widget build(BuildContext context) => _shimmer(
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.grey.shade200),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Image placeholder
              _SkeletonBox(width: double.infinity, height: 200, radius: 0),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Provider row
                    Row(
                      children: [
                        _SkeletonCircle(48),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _SkeletonBox(width: 120, height: 13, radius: 6),
                              const SizedBox(height: 6),
                              _SkeletonBox(width: 80, height: 11, radius: 6),
                            ],
                          ),
                        ),
                        _SkeletonBox(width: 50, height: 13, radius: 6),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(child: _SkeletonBox(height: 12, radius: 6)),
                        const SizedBox(width: 16),
                        Expanded(child: _SkeletonBox(height: 12, radius: 6)),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(child: _SkeletonBox(height: 42, radius: 21)),
                        const SizedBox(width: 12),
                        Expanded(child: _SkeletonBox(height: 42, radius: 21)),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
}

// ─── Request card skeleton (ProviderHomeScreen pending requests) ──────────────

class RequestCardSkeleton extends StatelessWidget {
  const RequestCardSkeleton({super.key});

  @override
  Widget build(BuildContext context) => _shimmer(
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.grey.shade200),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  _SkeletonCircle(48),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _SkeletonBox(width: 140, height: 14, radius: 6),
                        const SizedBox(height: 6),
                        _SkeletonBox(width: 100, height: 11, radius: 6),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              ...List.generate(3, (_) => Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: _SkeletonBox(height: 12, radius: 6),
              )),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(child: _SkeletonBox(height: 42, radius: 21)),
                  const SizedBox(width: 12),
                  Expanded(child: _SkeletonBox(height: 42, radius: 21)),
                ],
              ),
            ],
          ),
        ),
      );
}

// ─── Home content skeleton (UserHomeScreen) ───────────────────────────────────

class HomeContentSkeleton extends StatelessWidget {
  const HomeContentSkeleton({super.key});

  @override
  Widget build(BuildContext context) => _shimmer(
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 16),
              // Section header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _SkeletonBox(width: 120, height: 16, radius: 6),
                  _SkeletonBox(width: 60, height: 14, radius: 6),
                ],
              ),
              const SizedBox(height: 16),
              // Category chips row
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                physics: const NeverScrollableScrollPhysics(),
                child: Row(
                  children: List.generate(
                    5,
                    (i) => Padding(
                      padding: EdgeInsets.only(right: i < 4 ? 12 : 0),
                      child: Column(
                        children: [
                          _SkeletonBox(width: 70, height: 70, radius: 12),
                          const SizedBox(height: 6),
                          _SkeletonBox(width: 60, height: 10, radius: 4),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 28),
              // Featured section header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _SkeletonBox(width: 140, height: 16, radius: 6),
                  _SkeletonBox(width: 60, height: 14, radius: 6),
                ],
              ),
              const SizedBox(height: 16),
              // Featured cards
              ...List.generate(2, (_) => Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: Container(
                  height: 180,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        flex: 2,
                        child: _SkeletonBox(height: 180, radius: 16),
                      ),
                      Expanded(
                        flex: 3,
                        child: Padding(
                          padding: const EdgeInsets.all(12),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              _SkeletonBox(width: 80, height: 11, radius: 4),
                              const SizedBox(height: 8),
                              _SkeletonBox(height: 14, radius: 6),
                              const SizedBox(height: 6),
                              _SkeletonBox(width: 100, height: 12, radius: 6),
                              const SizedBox(height: 12),
                              Row(children: [
                                _SkeletonBox(width: 60, height: 10, radius: 4),
                                const SizedBox(width: 8),
                                _SkeletonBox(width: 50, height: 10, radius: 4),
                              ]),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              )),
            ],
          ),
        ),
      );
}

// ─── Profile skeleton (ProviderProfileScreen) ────────────────────────────────

class ProfileSkeleton extends StatelessWidget {
  const ProfileSkeleton({super.key});

  @override
  Widget build(BuildContext context) => _shimmer(
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            children: [
              const SizedBox(height: 24),
              _SkeletonCircle(100),
              const SizedBox(height: 12),
              _SkeletonBox(width: 140, height: 16, radius: 6),
              const SizedBox(height: 8),
              _SkeletonBox(width: 180, height: 12, radius: 6),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(child: _SkeletonBox(height: 80, radius: 12)),
                  const SizedBox(width: 16),
                  Expanded(child: _SkeletonBox(height: 80, radius: 12)),
                ],
              ),
              const SizedBox(height: 24),
              ...List.generate(
                5,
                (_) => Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: Row(
                    children: [
                      _SkeletonBox(width: 24, height: 24, radius: 4),
                      const SizedBox(width: 16),
                      _SkeletonBox(width: 150, height: 14, radius: 6),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      );
}
