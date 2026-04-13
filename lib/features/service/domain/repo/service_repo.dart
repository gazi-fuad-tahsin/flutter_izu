import 'package:izu/core/network/network_result.dart';

import '../../data/models/service_detail_model.dart';
import '../../data/models/service_model.dart';

abstract class ServiceRepository {
  NetworkResult<Map<String, List<ServiceModel>>> fetchServices();
  NetworkResult<ServiceDetailModel> fetchServiceDetail(String serviceId);
}
