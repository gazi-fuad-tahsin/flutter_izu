import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../booking/data/repository/rating_repository.dart';

class ReviewGivingSheet extends StatefulWidget {
  final String bookingId;
  final String serviceId;
  final String providerId;

  const ReviewGivingSheet({
    super.key,
    required this.bookingId,
    required this.serviceId,
    required this.providerId,
  });

  @override
  State<ReviewGivingSheet> createState() => _ReviewGivingSheetState();
}

class _ReviewGivingSheetState extends State<ReviewGivingSheet> {
  int _rating = 0;
  final _commentController = TextEditingController();
  bool _isLoading = false;
  final _ratingRepository = RatingRepository();

  Future<void> _submitReview() async {
    if (_rating == 0) {
      Get.snackbar(
        'Rating Required',
        'Please select a rating star before submitting.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.orange,
        colorText: Colors.white,
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    final success = await _ratingRepository.submitBookingReview(
      bookingId: widget.bookingId,
      serviceId: widget.serviceId,
      rating: _rating.toDouble(),
      message: _commentController.text.trim(),
    );

    setState(() {
      _isLoading = false;
    });

    if (success) {
      Get.snackbar(
        'Success',
        'Review successfully submitted',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
      if (mounted) {
        Navigator.of(context).pop();
      }
    } else {
      Get.snackbar(
        'Error',
        'Failed to submit review. Please try again.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // To accommodate keyboard overlap
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;

    return Container(
      padding: EdgeInsets.only(
        left: 24,
        right: 24,
        top: 16,
        bottom: 24 + bottomInset,
      ),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Close button at top right
            Align(
              alignment: Alignment.topRight,
              child: IconButton(
                onPressed: () => Navigator.of(context).pop(),
                icon: const Icon(
                  Icons.close,
                  color: Colors.grey,
                  size: 24,
                ),
              ),
            ),

            // Party Popper / Celebration Icon
            Center(
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: const BoxDecoration(
                  color: Color(0xFFFFF7EE),
                  shape: BoxShape.circle,
                ),
                child: const Text(
                  '🎉',
                  style: TextStyle(fontSize: 48),
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Congratulations!
            const Text(
              'Congratulations!',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),

            // Your service is completed. Thank you!
            const Text(
              'Your service is completed. Thank you!',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),

            // How was your service?
            const Text(
              'How was your service?',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),

            // 5-Star Row
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(5, (index) {
                final starIndex = index + 1;
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      _rating = starIndex;
                    });
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: Icon(
                      starIndex <= _rating ? Icons.star : Icons.star_border,
                      color: starIndex <= _rating ? const Color(0xFFFFC107) : Colors.grey.shade300,
                      size: 32,
                    ),
                  ),
                );
              }),
            ),
            const SizedBox(height: 24),

            // Message Label
            const Text(
              'Message',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Colors.black54,
              ),
            ),
            const SizedBox(height: 8),

            // Textbox: Share your experience
            TextField(
              controller: _commentController,
              minLines: 3,
              maxLines: 5,
              decoration: InputDecoration(
                hintText: 'Share your experience',
                hintStyle: TextStyle(
                  color: Colors.grey.shade400,
                  fontSize: 14,
                ),
                contentPadding: const EdgeInsets.all(16),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(
                    color: Colors.grey.shade300,
                    width: 1,
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(
                    color: Colors.grey.shade300,
                    width: 1,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(
                    color: Color(0xFF2870BC),
                    width: 1.5,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Submit Button
            ElevatedButton(
              onPressed: _isLoading ? null : _submitReview,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF2870BC),
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(28),
                ),
                elevation: 0,
              ),
              child: _isLoading
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    )
                  : const Text(
                      'Submit',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
