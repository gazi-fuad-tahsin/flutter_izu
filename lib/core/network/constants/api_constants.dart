class ApiConstants {
  // static const String baseDomain = 'http://187.77.187.56:5005';
  static const String baseDomain = "http://10.10.5.67:5008";

  static const String baseUrl = '$baseDomain/api/v1'; 


  static Map<String, String> get defaultHeaders => {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };

  static Map<String, String> authHeaders(String token) => {
    ...defaultHeaders,
    'Authorization': 'Bearer $token',
  };

  static Map<String, String> get multipartHeaders => {
    'Accept': 'application/json',
    // Content-Type will be set automatically for multipart
  };

  /// [Endpoint Groups]
  static AuthEndpoints get auth => AuthEndpoints();

  static UserEndpoints get user => UserEndpoints();
  static VehicleEndpoints get vehicle => VehicleEndpoints();
  static NotificationEndpoints get notification => NotificationEndpoints();

  static TeamEndpointcs get team => TeamEndpointcs();
  static LeagueEndpoints get league => LeagueEndpoints();
  static LoadEndpoints get load => LoadEndpoints();

  static GetProfile get getProfile => GetProfile();

  static PlanEndpoints get plan => PlanEndpoints();

  static SubscriptionEndpoints get subscription => SubscriptionEndpoints();

  static PaymentEndpoints get payment => PaymentEndpoints();

  static EventsEndpoints get events => EventsEndpoints();
  static EventEndpoints get event => EventEndpoints();
  static ApplicationsEndpoints get applications => ApplicationsEndpoints();

  static CampaignEndpoints get campaign => CampaignEndpoints();

  static BarberEndpoints get barber => BarberEndpoints();

  static AdminEndpoints get admin => AdminEndpoints();

  static ServiceEndpoints get service => ServiceEndpoints();
  
  static CategoryEndpoints get category => CategoryEndpoints();
  
  static WasherEndpoints get washer => WasherEndpoints();

  static BookingEndpoints get booking => BookingEndpoints();
  
  static RatingEndpoints get rating => RatingEndpoints();

  static ProviderEndpoints get provider => ProviderEndpoints();
}

/// [Authentication Endpoints]
class AuthEndpoints {
  static const String _base = '${ApiConstants.baseUrl}/auth';

  final String login = '$_base/login';

  final String register = '$_base/register';
  final String signup = '$_base/signup';
  final String forgotPass = '$_base/forgot-password';
  final String resrtPass = '$_base/reset-password';
  final String verifyMailOtp = '$_base/verify-otp';

  final String refreshToken = '$_base/refresh-token';

  final String setNewPass = '$_base/reset-password';

  final String changePass = '$_base/change-password';
  
  final String logout = '$_base/logout';
}

class GetProfile {
  static const String _baseUrl = ApiConstants.baseUrl;

  // Single endpoint for all roles - backend handles role-based logic
  String fetchProfileByRole(String role) {
    return '$_baseUrl/user/profile';
  }

  String updateProfileByRole(String role) {
    return '$_baseUrl/user/update-profile';
  }

  // Legacy endpoints for backward compatibility
  final String fetchProfile = '$_baseUrl/user/profile';
  final String updateProfile =
      '$_baseUrl/user/profile'; // Use same endpoint as GET with PUT method
  
  // Auth user profile endpoint - used after login to get current user details
  final String getAuthUserProfile = '$_baseUrl/profile';
}

class UserEndpoints {
  static const String _base = '${ApiConstants.baseUrl}/user';
  final String updateProfile =
      '$_base/profile'; // Use same endpoint as GET with PUT method
  final String getUserProfile = '$_base/profile';
  final String getMyActivities = '$_base/my-activities';
  final String uploadPhoto = '$_base/photo'; // Upload profile photo
  final String updateIdentity = '$_base/identity'; // Update identity verification
  final String updateBank = '$_base/bank'; // Update bank details
  final String getActivityWashers = '$_base/activity'; // Get washers for activity

  // final String create = '$_base/create';
}

class VehicleEndpoints {
  static const String _base = '${ApiConstants.baseUrl}/vehicle';

  final String vehicle = _base; // Used for POST and GET
  String deleteVehicle(String id) => '$_base/$id';
}

class NotificationEndpoints {
  static const String _base = '${ApiConstants.baseUrl}/notifications';

  final String getNotifications = _base;
  String getNotificationsWithPage(int page, int limit) =>
      '$_base?page=$page&limit=$limit';
  String markAsRead(String notificationId) => '$_base/$notificationId/read';
  final String markAllAsRead = '$_base/read-all';
}

class TeamEndpointcs {
  static const String _base = '${ApiConstants.baseUrl}/team';

  final String create = '$_base/create';
}

class LeagueEndpoints {
  static const String _base = '${ApiConstants.baseUrl}/league';

  final String getAllLeagues = '$_base/all-league';
}

class LoadEndpoints {
  static const String _base = '${ApiConstants.baseUrl}/load';

  final String getLoads = _base;
  String getById(String id) => '$_base/$id';
  String priceAction(String id) => '$_base/$id/price-action';
  String askPrice(String id) => '$_base/$id/ask-price';
}

class PlanEndpoints {
  static const String _base = '${ApiConstants.baseUrl}/plan';

  final String getPlans = _base;
}

class PaymentEndpoints {
  static const String _base = '${ApiConstants.baseUrl}/payment';

  final String createPayment = '$_base/create-payment';
  final String confirmPayment = '$_base/confirm-payment';
  final String createPaymentEvent = '$_base/event';
  final String confirmPaymentEvent = '$_base/event/confirm';
}

class AskPriceEndpoints {
  static const String _base = '${ApiConstants.baseUrl}/load';

  String askPrice(String id) => '$_base/$id/ask-price';
}

class EventsEndpoints {
  static const String _base = '${ApiConstants.baseUrl}/events';

  final String getEvents = _base;

  String getEventsByPage(
    int page,
    int limit, {
    String sport = '',
    String type = '',
    String status = '',
  }) {
    String url = '$_base?page=$page&limit=$limit';
    if (sport.isNotEmpty) url += '&sport=$sport';
    if (type.isNotEmpty) url += '&type=$type';
    if (status.isNotEmpty) url += '&status=$status';
    return url;
  }
}

/// Events Endpoints
class EventEndpoints {
  static const String _base = '${ApiConstants.baseUrl}/events';

  final String getEvents = _base;
  final String createEvent = _base;
  final String hostDashboard = '$_base/host/dashboard';
  String getById(String id) => '$_base/$id';
}

/// Applications Endpoints
class ApplicationsEndpoints {
  static const String _base = '${ApiConstants.baseUrl}/applications';

  final String createApplication = _base;
  final String getApplicationEvents = '$_base/events';

  /// Update application status: /applications/:applicationId/status
  String updateApplicationStatus(String applicationId) =>
      '$_base/$applicationId/status';
}

/// Subscription Endpoints
class SubscriptionEndpoints {
  static const String _base = '${ApiConstants.baseUrl}/subscription';

  final String getSubscriptions = _base;
}

/// Campaign Endpoints
class CampaignEndpoints {
  static const String _base = '${ApiConstants.baseUrl}/berber/campaigns';

  final String createCampaign = _base;
  final String getCampaigns = _base;
}

/// Barber Endpoints
class BarberEndpoints {
  static const String _base = '${ApiConstants.baseUrl}/berber';

  final String profileSetup = '$_base/profile/setup';
  final String updateProfile = '$_base/profile/update';
  final String reservations = '$_base/reservations';
  String confirmReservation(String id) => '$_base/reservations/$id/confirm';

  // Loyalty
  final String addPoint = '${ApiConstants.baseUrl}/loyalty/';
  String getLoyaltyCount(String shopId) =>
      '${ApiConstants.baseUrl}/loyalty/counts/shop-wise?shopId=$shopId';
}

/// Admin Endpoints
class AdminEndpoints {
  static const String _base = '${ApiConstants.baseUrl}/admin';
  static const String _userBase = '${ApiConstants.baseUrl}/user/admin';

  final String getContests = '$_base/contests';
  String getContestDetails(String id) => '$_base/contests/$id';

  // Staff Management
  final String getStaff = '$_base/staff';
  final String addStaff = '$_base/staff';
  String deleteStaff(String id) => '$_base/staff/$id';

  // Dashboard
  final String getDashboard = '$_userBase/dashboard';
}

/// [Service Endpoints]
class ServiceEndpoints {
  static const String _base = '${ApiConstants.baseUrl}/services';

  final String getServices = _base;
}

/// [Category Endpoints]
class CategoryEndpoints {
  static const String _base = '${ApiConstants.baseUrl}/categories';

  final String fetchCategories = _base;
}

/// [Washer Endpoints]
class WasherEndpoints {
  static const String _base = '${ApiConstants.baseUrl}/washers';

  /// Get nearby washers
  /// Parameters: latitude, longitude, radius, serviceId (optional)
  String getNearbyWashers({
    required double latitude,
    required double longitude,
    required double radius,
    String? serviceId,
  }) {
    final params = <String>[];
    params.add('latitude=$latitude');
    params.add('longitude=$longitude');
    params.add('radius=$radius');
    if (serviceId != null && serviceId.isNotEmpty) {
      params.add('serviceId=$serviceId');
    }
    return '$_base/nearby?${params.join('&')}';
  }

  /// Accept or decline a booking request
  /// POST /washers/accept/:bookingId  body: { "status": "ongoing" | "cancelled" }
  String acceptBooking(String bookingId) => '$_base/accept/$bookingId';

  /// Set washer online status
  /// POST /washers/online
  String get setOnline => '$_base/online';

  /// Set washer offline status
  /// POST /washers/offline
  String get setOffline => '$_base/offline';

  /// Get washer today's income
  /// GET /washers/income/today
  String get todayIncome => '$_base/income/today';

  /// Get washer weekly income
  /// GET /washers/income/weekly
  String get weeklyIncome => '$_base/income/weekly';
}

/// [Booking Endpoints]
class BookingEndpoints {
  static const String _base = '${ApiConstants.baseUrl}/bookings';

  final String createBooking = _base;
  String getWasherBookings(String providerId) => '$_base/my-bookings?providerId=$providerId';
  String getBookingDetails(String bookingId) => '$_base/$bookingId';
  String confirmBooking(String bookingId) => '$_base/confirm/$bookingId';
  String cancelBooking(String bookingId) => '$_base/cancel/$bookingId';
}

/// [Rating Endpoints]
class RatingEndpoints {
  static const String _base = '${ApiConstants.baseUrl}/rating';

  /// Submit rating
  /// POST /rating
  final String submitRating = _base;
}

/// [Provider Endpoints]
class ProviderEndpoints {
  static const String _base = '${ApiConstants.baseUrl}/providers';

  /// Get pending requests
  /// GET /providers/pending-requests
  final String pendingRequests = '$_base/pending-requests';

  /// Accept booking request
  /// PATCH /providers/accept-request/:bookingId
  String acceptRequest(String bookingId) => '$_base/accept-request/$bookingId';
}
