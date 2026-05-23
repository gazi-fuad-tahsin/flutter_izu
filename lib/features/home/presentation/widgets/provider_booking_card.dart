import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../../../core/common/constants/texts.dart';
import '../../../location/data/model/location_model.dart';
import '../../../location/presentation/screens/location_screen.dart';
import '../../../message/data/repository/message_repository.dart';
import '../../../message/presentation/screens/message_detail_screen.dart';
import '../../data/model/provider_booking_model.dart';
import '../../data/repository/provider_booking_repository.dart';
import '../controllers/provider_booking_controller.dart';
import 'ready_confirmation_dialog.dart';

class ProviderBookingCard extends StatefulWidget {
  final ProviderBooking booking;
  final String filterType; // live, next, completed, cancelled

  const ProviderBookingCard({
    super.key,
    required this.booking,
    required this.filterType,
  });

  @override
  State<ProviderBookingCard> createState() => _ProviderBookingCardState();
}

class _ProviderBookingCardState extends State<ProviderBookingCard> {
  bool _isStarting = false;
  bool _isContactingLoading = false;
  bool _isCompletingLoading = false;

  Widget _buildClientImage(String imagePath) {
    if (imagePath.startsWith('http://') || imagePath.startsWith('https://')) {
      return CircleAvatar(
        radius: 24,
        backgroundImage: NetworkImage(imagePath),
        onBackgroundImageError: (exception, stackTrace) {},
      );
    } else {
      return CircleAvatar(
        radius: 24,
        backgroundImage: AssetImage(imagePath),
      );
    }
  }

  Future<void> _handleStartService() async {
    setState(() {
      _isStarting = true;
    });

    final repository = ProviderBookingRepository();
    final success = await repository.startService(widget.booking.id);

    setState(() {
      _isStarting = false;
    });

    if (success) {
      Get.snackbar(
        'Success',
        'Service started!',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
        duration: const Duration(seconds: 2),
      );

      if (Get.isRegistered<ProviderBookingController>()) {
        final controller = Get.find<ProviderBookingController>();
        controller.fetchBookingsByStatus('live');
      }
    } else {
      Get.snackbar(
        'Error',
        'Failed to start service',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        duration: const Duration(seconds: 2),
      );
    }
  }

  Future<void> _handleContact() async {
    setState(() {
      _isContactingLoading = true;
    });

    final messageRepository = MessageRepository();
    final result = await messageRepository.createConversation(widget.booking.clientId);

    setState(() {
      _isContactingLoading = false;
    });

    result.fold(
      (failure) {
        Get.snackbar(
          'Error',
          'Failed to start conversation',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
          duration: const Duration(seconds: 2),
        );
      },
      (conversation) {
        Get.to(() => MessageDetailScreen(conversation: conversation));
      },
    );
  }

  Future<void> _handleCompleteService() async {
    setState(() {
      _isCompletingLoading = true;
    });

    final repository = ProviderBookingRepository();
    final success = await repository.completeBooking(widget.booking.id);

    setState(() {
      _isCompletingLoading = false;
    });

    if (success) {
      Get.snackbar(
        'Success',
        'Booking completed!',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
        duration: const Duration(seconds: 2),
      );

      if (Get.isRegistered<ProviderBookingController>()) {
        final controller = Get.find<ProviderBookingController>();
        controller.fetchBookingsByStatus('live');
      }
    } else {
      Get.snackbar(
        'Error',
        'Failed to complete booking',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        duration: const Duration(seconds: 2),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final booking = widget.booking;
    final filterType = widget.filterType;

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
          Row(
            children: [
              _buildClientImage(booking.clientImage),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  booking.clientName,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: Colors.black,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              _buildStatusBadge(filterType, booking),
            ],
          ),
          const SizedBox(height: 16),

          if (filterType == 'live') ...[
            _CountdownTimer(booking: booking),
            const SizedBox(height: 16),
          ],

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
                  booking.location,
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

          Row(
            children: [
              const Icon(
                Icons.calendar_today,
                size: 20,
                color: Colors.grey,
              ),
              const SizedBox(width: 12),
              Text(
                'Date: ${booking.date}',
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.grey,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          Row(
            children: [
              const Icon(
                Icons.access_time,
                size: 20,
                color: Colors.grey,
              ),
              const SizedBox(width: 12),
              Text(
                'Time: ${booking.time}',
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.grey,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          Row(
            children: [
              const Icon(
                Icons.settings,
                size: 20,
                color: Colors.grey,
              ),
              const SizedBox(width: 12),
              Text(
                'Services: ${booking.service}',
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.grey,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),

          if (filterType != 'live') ...[
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
                  'Amount: ${booking.amount}',
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.grey,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ],

          if (filterType == 'next') ...[
            const SizedBox(height: 12),
            Row(
              children: [
                const Icon(
                  Icons.assignment,
                  size: 20,
                  color: Colors.grey,
                ),
                const SizedBox(width: 12),
                Text(
                  'Status: ${booking.paymentStatus ?? 'Pending'}',
                  style: TextStyle(
                    fontSize: 14,
                    color: booking.paymentStatus == 'Accepted'
                        ? Colors.green
                        : const Color(0xFFFCA048),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ],

          const SizedBox(height: 20),

          if (filterType == 'live') ...[
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      Get.to(() => LocationScreen(
                        bookingId: booking.id,
                        locationData: LocationData(
                          address: booking.location,
                          latitude: 0.0,
                          longitude: 0.0,
                          clientName: booking.clientName,
                          serviceType: booking.service,
                        ),
                      ));
                    },
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
                const SizedBox(width: 12),
                Expanded(
                  child: OutlinedButton(
                    onPressed: _isContactingLoading ? null : _handleContact,
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
                    child: _isContactingLoading
                        ? const SizedBox(
                            height: 18,
                            width: 18,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFFCA048)),
                            ),
                          )
                        : const Text(
                            'Contact',
                            style: TextStyle(
                              color: Color(0xFFFCA048),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            if (booking.status == 'waiting-for-start') ...
              [

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                    onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) => ReadyConfirmationDialog(
                        onAccept: () async {
                          await _handleStartService();
                        },
                        onCancel: () {
                          Get.snackbar(
                            'Cancelled',
                            'Service start cancelled',
                            snackPosition: SnackPosition.BOTTOM,
                            backgroundColor: Colors.orange,
                            colorText: Colors.white,
                            duration: Duration(seconds: 2),
                          );
                        },
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF2870BC),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(28),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    elevation: 0,
                  ),
                  child: _isStarting
                      ? const SizedBox(
                          height: 18,
                          width: 18,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                          ),
                        )
                      : const Text(
                          'Start servicing',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                ),
              ),
            ] else if (booking.status == 'ongoing') ...
              [
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _isCompletingLoading ? null : _handleCompleteService,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(28),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      elevation: 0,
                    ),
                    child: _isCompletingLoading
                        ? const SizedBox(
                            height: 18,
                            width: 18,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                            ),
                          )
                        : const Text(
                            'Complete Service',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                  ),
                ),
              ],
          ] else if (filterType == 'next') ...[
            Row(
              children: [
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
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.close, color: Color(0xFFFCA048), size: 18),
                        SizedBox(width: 8),
                        Text(
                          'Cancel',
                          style: TextStyle(
                            color: Color(0xFFFCA048),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                // const SizedBox(width: 12),
                // Expanded(
                //   child: ElevatedButton(
                //     onPressed: () {},
                //     style: ElevatedButton.styleFrom(
                //       backgroundColor: const Color(0xFF2870BC),
                //       shape: RoundedRectangleBorder(
                //         borderRadius: BorderRadius.circular(28),
                //       ),
                //       padding: const EdgeInsets.symmetric(vertical: 14),
                //       elevation: 0,
                //     ),
                //     child: const Text(
                //       'Reschedule',
                //       style: TextStyle(
                //         fontSize: 16,
                //         fontWeight: FontWeight.w600,
                //         color: Colors.white,
                //       ),
                //     ),
                //   ),
                // ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildStatusBadge(String filterType, ProviderBooking booking) {
    if (filterType == 'live') {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: const Color(0xFF2870BC),
          borderRadius: BorderRadius.circular(20),
        ),
        child: const Text(
          'Live',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
            fontSize: 12,
          ),
        ),
      );
    } else if (filterType == 'next') {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: Colors.orange.shade50,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          booking.paymentStatus ?? 'Pending',
          style: TextStyle(
            color: const Color(0xFFFCA048),
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
            'Completed',
            style: TextStyle(
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
            'Cancelled',
            style: TextStyle(
              color: Colors.red,
              fontWeight: FontWeight.w600,
              fontSize: 12,
            ),
          ),
        ],
      );
    } else {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: Colors.grey.shade100,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: const Color(0xFF2870BC), width: 1),
        ),
        child: const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.access_time, color: Color(0xFF2870BC), size: 14),
            SizedBox(width: 4),
            Text(
              'Upcoming',
              style: TextStyle(
                color: Color(0xFF2870BC),
                fontWeight: FontWeight.w600,
                fontSize: 12,
              ),
            ),
          ],
        ),
      );
    }
  }
}

class _CountdownTimer extends StatefulWidget {
  final ProviderBooking booking;

  const _CountdownTimer({required this.booking});

  @override
  State<_CountdownTimer> createState() => _CountdownTimerState();
}

class _CountdownTimerState extends State<_CountdownTimer> {
  late Stream<Duration> _countdownStream;

  @override
  void initState() {
    super.initState();
    _countdownStream = _createCountdownStream();
  }

  Stream<Duration> _createCountdownStream() {
    return Stream.periodic(const Duration(seconds: 1), (_) {
      return _calculateRemainingTime();
    }).takeWhile((_) => mounted);
  }

  Duration _calculateRemainingTime() {
    try {
      final dateFormat = DateFormat('d MMM yyyy');
      final timeFormat = DateFormat('hh:mm a');

      final bookingDate = dateFormat.parse(widget.booking.date);
      final bookingTime = timeFormat.parse(widget.booking.time);

      final bookingDateTime = DateTime(
        bookingDate.year,
        bookingDate.month,
        bookingDate.day,
        bookingTime.hour,
        bookingTime.minute,
      );

      final estimatedHours = widget.booking.estimatedHours ?? 1;
      final endDateTime = bookingDateTime.add(Duration(hours: estimatedHours));

      final now = DateTime.now();
      final remaining = endDateTime.difference(now);

      return remaining.isNegative ? Duration.zero : remaining;
    } catch (e) {
      return const Duration(hours: 1);
    }
  }

  String _formatDuration(Duration duration) {
    final hours = duration.inHours;
    final minutes = duration.inMinutes.remainder(60);
    final seconds = duration.inSeconds.remainder(60);
    return '${hours}h ${minutes}m ${seconds}s';
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<Duration>(
      stream: _countdownStream,
      initialData: _calculateRemainingTime(),
      builder: (context, snapshot) {
        final remaining = snapshot.data ?? Duration.zero;

        return Text(
          _formatDuration(remaining),
          style: const TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.w700,
            color: Colors.black,
          ),
        );
      },
    );
  }
}
