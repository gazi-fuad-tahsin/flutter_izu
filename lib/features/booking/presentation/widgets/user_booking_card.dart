import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/common/constants/texts.dart';

import '../../data/model/user_booking_model.dart';

class UserBookingCard extends StatefulWidget {
  final UserBookingModel booking;
  final String filterType; // live, upcoming, completed, cancelled

  const UserBookingCard({
    super.key,
    required this.booking,
    required this.filterType,
  });

  @override
  State<UserBookingCard> createState() => _UserBookingCardState();
}

class _UserBookingCardState extends State<UserBookingCard> {
  late Duration _remainingTime;
  late DateTime _endTime;
  bool _timerStarted = false;

  @override
  void initState() {
    super.initState();
    if (widget.filterType == 'live') {
      _timerStarted = true;
      _calculateEndTime();
      _scheduleNextUpdate();
    }
  }

  void _calculateEndTime() {
    _endTime = widget.booking.bookingTime.add(Duration(hours: widget.booking.estimatedHours));
    _updateRemainingTime();
  }

  void _updateRemainingTime() {
    if (mounted) {
      setState(() {
        final now = DateTime.now();
        _remainingTime = _endTime.difference(now);

        if (_remainingTime.isNegative) {
          _remainingTime = Duration.zero;
        }
      });
    }
  }

  void _scheduleNextUpdate() {
    if (!_timerStarted || _remainingTime.inSeconds <= 0) return;

    Future.delayed(const Duration(seconds: 1), () {
      _updateRemainingTime();
      _scheduleNextUpdate();
    });
  }

  String _formatDuration(Duration duration) {
    final hours = duration.inHours;
    final minutes = duration.inMinutes.remainder(60);
    final seconds = duration.inSeconds.remainder(60);
    return '${hours.toString().padLeft(2, '0')}h ${minutes.toString().padLeft(2, '0')}m ${seconds.toString().padLeft(2, '0')}s';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(
          color: const Color(0xFF2870BC),
          width: 2,
        ),
        borderRadius: BorderRadius.circular(16),
        color: Colors.white,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with provider name and status badge
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    radius: 24,
                    backgroundImage: widget.booking.providerImage.startsWith('http')
                        ? NetworkImage(widget.booking.providerImage) as ImageProvider
                        : AssetImage(widget.booking.providerImage),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    widget.booking.providerName,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
              _buildStatusBadge(widget.filterType),
            ],
          ),
          const SizedBox(height: 16),

          // Live booking - show duration timer
          if (widget.filterType == 'live') ...[
            Text(
              _formatDuration(_remainingTime),
              style: const TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.w700,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 16),
          ],

          // Location
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(
                Icons.location_on,
                size: 20,
                color: Colors.grey,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  widget.booking.location,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.grey,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Date
          Row(
            children: [
              const Icon(
                Icons.calendar_today,
                size: 20,
                color: Colors.grey,
              ),
              const SizedBox(width: 12),
              Text(
                '${appTexts.date.tr}: ${widget.booking.formattedDate}',
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.grey,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Time
          Row(
            children: [
              const Icon(
                Icons.access_time,
                size: 20,
                color: Colors.grey,
              ),
              const SizedBox(width: 12),
              Text(
                '${appTexts.time.tr}: ${widget.booking.formattedTime}',
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.grey,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Service
          Row(
            children: [
              const Icon(
                Icons.settings,
                size: 20,
                color: Colors.grey,
              ),
              const SizedBox(width: 12),
              Text(
                '${appTexts.service.tr}: ${widget.booking.serviceName}',
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.grey,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),

          // Amount (for upcoming, completed)
          if (widget.filterType != 'live') ...[
            const SizedBox(height: 12),
            Row(
              children: [
                const Icon(
                  Icons.attach_money,
                  size: 20,
                  color: Colors.grey,
                ),
                const SizedBox(width: 12),
                Text(
                  '${appTexts.amount.tr}: \$${widget.booking.totalPrice.toStringAsFixed(2)}',
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.grey,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ],

          const SizedBox(height: 20),

          // Action Buttons based on filter type
          if (widget.filterType == 'live') ...[
            Row(
              children: [
                // Contact Button
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {},
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(
                        color: Color(0xFFFCA048),
                        width: 2,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(28),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    child: Text(
                      appTexts.contact.tr,
                      style: const TextStyle(
                        color: Color(0xFFFCA048),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                // Location Button
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.location_on, size: 18),
                    label: Text(appTexts.location.tr),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF2870BC),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(28),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                  ),
                ),
              ],
            ),
          ] else if (widget.filterType == 'upcoming') ...[
            Row(
              children: [
                // Cancel Button
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {},
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(
                        color: Color(0xFFFCA048),
                        width: 2,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(28),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.close, color: Color(0xFFFCA048), size: 18),
                        const SizedBox(width: 8),
                        Text(
                          appTexts.cancel.tr,
                          style: const TextStyle(
                            color: Color(0xFFFCA048),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                // Reschedule Button
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF2870BC),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(28),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      elevation: 0,
                    ),
                    child: Text(
                      appTexts.reschedule.tr,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildStatusBadge(String filterType) {
    if (filterType == 'live') {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: const Color(0xFF2870BC),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          appTexts.live.tr,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
            fontSize: 12,
          ),
        ),
      );
    } else if (filterType == 'completed') {
      return Row(
        children: [
          const Icon(Icons.check_circle, color: Colors.green, size: 20),
          const SizedBox(width: 4),
          Text(
            appTexts.completed.tr,
            style: const TextStyle(
              color: Colors.green,
              fontWeight: FontWeight.w600,
              fontSize: 12,
            ),
          ),
        ],
      );
    } else if (filterType == 'cancelled') {
      return Row(
        children: [
          const Icon(Icons.cancel, color: Colors.red, size: 20),
          const SizedBox(width: 4),
          Text(
            appTexts.cancelled.tr,
            style: const TextStyle(
              color: Colors.red,
              fontWeight: FontWeight.w600,
              fontSize: 12,
            ),
          ),
        ],
      );
    }
    // Default: upcoming
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xFFFCA048).withOpacity(0.1),
        border: Border.all(
          color: const Color(0xFFFCA048),
          width: 1.5,
        ),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        appTexts.upcoming.tr,
        style: const TextStyle(
          color: Color(0xFFFCA048),
          fontWeight: FontWeight.w600,
          fontSize: 12,
        ),
      ),
    );
  }
}
