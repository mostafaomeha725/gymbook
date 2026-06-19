import 'package:gymbook/features/customer/customer_subscriptions/domain/entities/customer_subscription_details_entity.dart';

class CustomerSubscriptionDetailsModel {
  final int branchId;
  final String branchName;
  final String address;
  final double? latitude;
  final double? longitude;
  final List<CustomerSubscriptionImageModel> images;
  final int subscriptionId;
  final int subscriptionStatus;
  final double price;
  final String activationDate;
  final String endDate;
  final int durationInDays;
  final int checkInsCount;
  final String packageName;

  const CustomerSubscriptionDetailsModel({
    required this.branchId,
    required this.branchName,
    required this.address,
    required this.latitude,
    required this.longitude,
    required this.images,
    required this.subscriptionId,
    required this.subscriptionStatus,
    required this.price,
    required this.activationDate,
    required this.endDate,
    required this.durationInDays,
    required this.checkInsCount,
    required this.packageName,
  });

  factory CustomerSubscriptionDetailsModel.fromJson(Map<String, dynamic> json) {
    final rawImages = json['images'] as List<dynamic>? ?? const [];
    return CustomerSubscriptionDetailsModel(
      branchId: (json['branchId'] as num?)?.toInt() ?? 0,
      branchName: (json['branchName'] ?? '').toString(),
      address: (json['address'] ?? '').toString(),
      latitude: (json['latitude'] as num?)?.toDouble(),
      longitude: (json['longitude'] as num?)?.toDouble(),
      images: rawImages
          .whereType<Map>()
          .map(
            (item) => CustomerSubscriptionImageModel.fromJson(
              Map<String, dynamic>.from(item),
            ),
          )
          .toList(),
      subscriptionId: (json['subscriptionId'] as num?)?.toInt() ?? 0,
      subscriptionStatus: (json['subscriptionStatus'] as num?)?.toInt() ?? 0,
      price: (json['price'] as num?)?.toDouble() ?? 0,
      activationDate: (json['activationDate'] ?? '').toString(),
      endDate: (json['endDate'] ?? '').toString(),
      durationInDays: (json['durationInDays'] as num?)?.toInt() ?? 0,
      checkInsCount: (json['checkInsCount'] as num?)?.toInt() ?? 0,
      packageName: (json['packageName'] ?? '').toString(),
    );
  }

  CustomerSubscriptionDetailsEntity toEntity() {
    return CustomerSubscriptionDetailsEntity(
      branchId: branchId,
      branchName: branchName,
      address: address,
      latitude: latitude,
      longitude: longitude,
      images: images.map((item) => item.toEntity()).toList(),
      subscriptionId: subscriptionId,
      subscriptionStatus: subscriptionStatus,
      price: price,
      activationDate: activationDate,
      endDate: endDate,
      durationInDays: durationInDays,
      checkInsCount: checkInsCount,
      packageName: packageName,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'branchId': branchId,
      'branchName': branchName,
      'address': address,
      'latitude': latitude,
      'longitude': longitude,
      'images': images.map((item) => item.toJson()).toList(),
      'subscriptionId': subscriptionId,
      'subscriptionStatus': subscriptionStatus,
      'price': price,
      'activationDate': activationDate,
      'endDate': endDate,
      'durationInDays': durationInDays,
      'checkInsCount': checkInsCount,
      'packageName': packageName,
    };
  }
}

class CustomerSubscriptionImageModel {
  final String url;

  const CustomerSubscriptionImageModel({required this.url});

  factory CustomerSubscriptionImageModel.fromJson(Map<String, dynamic> json) {
    return CustomerSubscriptionImageModel(url: (json['url'] ?? '').toString());
  }

  CustomerSubscriptionImageEntity toEntity() {
    return CustomerSubscriptionImageEntity(url: url);
  }

  Map<String, dynamic> toJson() {
    return {'url': url};
  }
}
