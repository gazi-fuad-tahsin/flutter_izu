import 'package:flutter/material.dart';
import 'package:flutx_core/flutx_core.dart';
import 'package:get/get.dart';
import 'package:izu/features/location/presentation/screens/location_picker_screen.dart';
import 'package:izu/core/services/location_service.dart';
import 'package:izu/core/network/api_client.dart';
import 'package:izu/core/network/constants/api_constants.dart';
import 'package:izu/features/home/presentation/screens/user_home_screen.dart';

class BookingConfirmationSheet extends StatefulWidget {
  final String providerName;
  final String amount;
  final String selectedDate;
  final String selectedTime;
  final String location;
  final String? serviceId;
  final String? serviceTitle;
  final String? providerId;
  final String bookingType;

  const BookingConfirmationSheet({
    super.key,
    required this.providerName,
    required this.amount,
    required this.selectedDate,
    required this.selectedTime,
    required this.location,
    this.serviceId,
    this.serviceTitle,
    this.providerId,
    this.bookingType = 'hourly',
  });

  @override
  State<BookingConfirmationSheet> createState() =>
      _BookingConfirmationSheetState();
}

class _BookingConfirmationSheetState extends State<BookingConfirmationSheet> {
  late int _estimatedHours;
  late TextEditingController _dateController;
  late TextEditingController _timeController;
  late TextEditingController _locationController;
  double? _selectedLatitude;
  double? _selectedLongitude;
  bool _isBooking = false;

  @override
  void initState() {
    super.initState();
    _estimatedHours = 1;
    _dateController = TextEditingController(text: widget.selectedDate);
    _timeController = TextEditingController(text: widget.selectedTime);
    _locationController = TextEditingController(
      text: (widget.location == 'Choose Location' || widget.location.isEmpty)
          ? ''
          : widget.location,
    );
  }

  @override
  void dispose() {
    _dateController.dispose();
    _timeController.dispose();
    _locationController.dispose();
    super.dispose();
  }

  void _increaseHours() {
    setState(() {
      _estimatedHours++;
    });
  }

  void _decreaseHours() {
    if (_estimatedHours > 1) {
      setState(() {
        _estimatedHours--;
      });
    }
  }

  String _getEndTimeString() {
    try {
      final timeStr = _timeController.text.trim();
      final parts = timeStr.split(' ');
      final mainParts = parts[0].split(':');
      int hour = int.parse(mainParts[0]);
      int minute = mainParts.length > 1 ? int.parse(mainParts[1]) : 0;

      if (parts.length > 1) {
        final ampm = parts[1].toLowerCase();
        if (ampm.contains('pm') && hour < 12) {
          hour += 12;
        } else if (ampm.contains('am') && hour == 12) {
          hour = 0;
        }
      }

      final now = DateTime.now();
      final startTime = DateTime(now.year, now.month, now.day, hour, minute);
      final endTime = startTime.add(Duration(hours: _estimatedHours));

      final endHour24 = endTime.hour;
      final endMinute = endTime.minute;
      final endMinuteStr = endMinute.toString().padLeft(2, '0');

      String period = 'AM';
      int displayHour = endHour24;
      if (displayHour >= 12) {
        period = 'PM';
        if (displayHour > 12) {
          displayHour -= 12;
        }
      } else if (displayHour == 0) {
        displayHour = 12;
      }

      return '$displayHour:$endMinuteStr $period';
    } catch (e) {
      return _timeController.text;
    }
  }

  Future<void> _createBooking() async {
    if (_selectedLatitude == null || _selectedLongitude == null) {
      try {
        final pos = await LocationService().getCurrentPosition();
        if (pos != null) {
          _selectedLatitude = pos.latitude;
          _selectedLongitude = pos.longitude;
        }
      } catch (_) {}
    }

    final double lat = _selectedLatitude ?? 40.7484;
    final double lng = _selectedLongitude ?? -73.9857;

    DateTime? parsedDateTime;
    try {
      int year = DateTime.now().year;
      int month = DateTime.now().month;
      int day = DateTime.now().day;

      final dateStr = _dateController.text.trim();
      if (dateStr.contains('-')) {
        final parts = dateStr.split('-');
        year = int.parse(parts[0]);
        month = int.parse(parts[1]);
        day = int.parse(parts[2]);
      } else {
        final parts = dateStr.split(' ');
        if (parts.length >= 3) {
          day = int.parse(parts[0]);
          year = int.parse(parts[2]);
          month = _getMonthNumber(parts[1]);
        }
      }

      final timeStr = _timeController.text.trim();
      final timeParts = timeStr.split(' ');
      final mainParts = timeParts[0].split(':');
      int hour = int.parse(mainParts[0]);
      int minute = timeParts[0].contains(':') && mainParts.length > 1 ? int.parse(mainParts[1]) : 0;

      if (timeParts.length > 1) {
        final ampm = timeParts[1].toLowerCase();
        if (ampm.contains('pm') && hour < 12) {
          hour += 12;
        } else if (ampm.contains('am') && hour == 12) {
          hour = 0;
        }
      }

      parsedDateTime = DateTime(year, month, day, hour, minute);
    } catch (e) {
      debugPrint('Error parsing booking date/time: $e');
    }

    final bookingTimeIso = (parsedDateTime ?? DateTime.now()).toUtc().toIso8601String();

    final cleanAmountStr = widget.amount.replaceAll(RegExp(r'[^0-9.]'), '');
    final basePrice = double.tryParse(cleanAmountStr) ?? 100.0;
    
    final double totalPrice = widget.bookingType == 'hourly'
        ? basePrice * _estimatedHours
        : basePrice;
    
    final double providerAmount = totalPrice * 0.8;

    final requestBody = {
      "serviceId": widget.serviceId ?? "69db6226817d85d9d87d3714",
      "title": widget.serviceTitle ?? "House Cleaning Service rtre",
      "bookingTime": bookingTimeIso,
      "location": {
        "type": "Point",
        "coordinates": [lng, lat],
        "address": _locationController.text.isEmpty ? "Choose Location" : _locationController.text,
      },
      "totalPrice": totalPrice,
      "providerId": widget.providerId ?? "69db077756b6c6f0c3096632",
      "extraNote": "",
      "providerAmount": providerAmount,
      "bookingType": widget.bookingType,
      "estimatedHours": _estimatedHours,
    };

    setState(() {
      _isBooking = true;
    });

    final result = await ApiClient().post<Map<String, dynamic>>(
      ApiConstants.booking.createBooking,
      data: requestBody,
      fromJsonT: (json) => json as Map<String, dynamic>,
    );

    setState(() {
      _isBooking = false;
    });

    result.fold(
      (failure) {
        Get.snackbar(
          'Booking Failed',
          failure.message,
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red.withOpacity(0.8),
          colorText: Colors.white,
        );
      },
      (success) {
        Get.snackbar(
          'Success',
          'Booking confirmed successfully!',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green.withOpacity(0.8),
          colorText: Colors.white,
        );
        Get.offAll(() => const UserHomeScreen());
      },
    );
  }

  int _getMonthNumber(String monthName) {
    const months = [
      'january', 'february', 'march', 'april', 'may', 'june',
      'july', 'august', 'september', 'october', 'november', 'december'
    ];
    final index = months.indexOf(monthName.toLowerCase());
    return index != -1 ? index + 1 : DateTime.now().month;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
      ),
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            // Total Amount Box
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    const Color(0xFF2870BC),
                    Colors.blue.shade800,
                  ],
                ),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Total amount',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Colors.white70,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    widget.amount,
                    style: const TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),

            // Select Booking Time & Date
            const Text(
              'Select Booking Time & Date',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () async {
                      final DateTime? pickedDate = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime.now(),
                        lastDate: DateTime.now().add(const Duration(days: 365)),
                      );
                      if (pickedDate != null) {
                        setState(() {
                          _dateController.text =
                              '${pickedDate.day} ${_getMonthName(pickedDate.month)} ${pickedDate.year}';
                        });
                      }
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: const Color(0xFF2870BC),
                          width: 1.5,
                        ),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.calendar_today,
                            color: Color(0xFF2870BC),
                            size: 18,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            _dateController.text,
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: GestureDetector(
                    onTap: () async {
                      final TimeOfDay? pickedTime = await showTimePicker(
                        context: context,
                        initialTime: TimeOfDay.now(),
                      );
                      if (pickedTime != null) {
                        setState(() {
                          _timeController.text = pickedTime.format(context);
                        });
                      }
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: const Color(0xFF2870BC),
                          width: 1.5,
                        ),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.access_time,
                            color: Color(0xFF2870BC),
                            size: 18,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            _timeController.text,
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Set Your Location
            const Text(
              'Set Your Location',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 12),
            GestureDetector(
              onTap: () async {
                final result = await Get.to(() => const LocationPickerScreen());
                if (result != null && result is Map<String, dynamic>) {
                  final address = result['address'] as String?;
                  if (address != null) {
                    setState(() {
                      _locationController.text = address;
                      _selectedLatitude = result['latitude'] as double?;
                      _selectedLongitude = result['longitude'] as double?;
                    });
                  }
                }
              },
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  color: Colors.blue.shade50,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: Colors.blue.shade200,
                    width: 1.5,
                  ),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.location_on,
                      color: Color(0xFF2870BC),
                      size: 20,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        _locationController.text.isEmpty ? 'Choose Location' : _locationController.text,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: _locationController.text.isEmpty ? Colors.grey : Colors.black,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Select Estimated Hour
            const Text(
              'Select Estimated Hour',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(
                        color: Colors.grey.shade300,
                        width: 1,
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        GestureDetector(
                          onTap: _decreaseHours,
                          child: Container(
                            width: 48,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            decoration: const BoxDecoration(
                              color: Color(0xFFFCA048),
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(12),
                                bottomLeft: Radius.circular(12),
                              ),
                            ),
                            child: const Center(
                              child: Icon(
                                Icons.remove,
                                color: Colors.white,
                                size: 20,
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: Center(
                            child: Text(
                              _estimatedHours.toString(),
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: _increaseHours,
                          child: Container(
                            width: 48,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            decoration: const BoxDecoration(
                              color: Color(0xFFFCA048),
                              borderRadius: BorderRadius.only(
                                topRight: Radius.circular(12),
                                bottomRight: Radius.circular(12),
                              ),
                            ),
                            child: const Center(
                              child: Icon(
                                Icons.add,
                                color: Colors.white,
                                size: 20,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFCA048),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.access_time,
                          color: Colors.white,
                          size: 18,
                        ),
                        const SizedBox(width: 8),
                        Flexible(
                          child: Text(
                            '${_timeController.text} + $_estimatedHours hr',
                            style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Book Now Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _isBooking ? null : () => _createBooking(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF2870BC),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(28),
                  ),
                ),
                child: _isBooking
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                        ),
                      )
                    : const Text(
                        'Book Now',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
              ),
            ),
            const SizedBox(height: 12),

            // Cancel Booking Button
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: () => Navigator.pop(context),
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(
                    color: Color(0xFFFCA048),
                    width: 2,
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(28),
                  ),
                ),
                child: const Text(
                  'Cancel Booking',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFFFCA048),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _getMonthName(int month) {
    const months = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December'
    ];
    return months[month - 1];
  }
}
