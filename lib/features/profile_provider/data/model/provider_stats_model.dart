class ProviderStatsModel {
  final int totalWorkCompletion;
  final double providerEarnings;

  const ProviderStatsModel({
    required this.totalWorkCompletion,
    required this.providerEarnings,
  });

  factory ProviderStatsModel.fromJson(Map<String, dynamic> json) {
    return ProviderStatsModel(
      totalWorkCompletion: (json['totalWorkCompletion'] as num?)?.toInt() ?? 0,
      providerEarnings: (json['providerEarnings'] as num?)?.toDouble() ?? 0,
    );
  }
}