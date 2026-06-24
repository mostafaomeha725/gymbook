import 'package:gymbook/core/network/endpoints.dart';
import 'package:gymbook/core/network/network_service.dart';
import 'package:gymbook/features/payments/data/models/payment_intent_model.dart';
import 'package:gymbook/features/payments/data/models/payment_transaction_status_model.dart';

abstract class PaymentsRemoteDataSource {
  Future<PaymentIntentModel> initializePayment({
    required int branchId,
    required int packageId,
  });

  Future<PaymentTransactionStatusModel> getPaymentTransactionStatus(
    int transactionId,
  );
}

class PaymentsRemoteDataSourceImpl implements PaymentsRemoteDataSource {
  final NetworkService networkService;

  PaymentsRemoteDataSourceImpl(this.networkService);

  @override
  Future<PaymentIntentModel> initializePayment({
    required int branchId,
    required int packageId,
  }) async {
    final response = await networkService.postData(
      endPoint: EndPoints.initializePayment,
      data: {'branchId': branchId, 'packageId': packageId},
    );
    return response.fold(
      (failure) => throw Exception(failure.message),
      (data) => PaymentIntentModel.fromJson(data),
    );
  }

  @override
  Future<PaymentTransactionStatusModel> getPaymentTransactionStatus(
    int transactionId,
  ) async {
    final response = await networkService.getData(
      endPoint: EndPoints.getPaymentTransactionStatus(transactionId),
    );

    return response.fold(
      (failure) => throw Exception(failure.message),
      (data) => PaymentTransactionStatusModel.fromJson(data),
    );
  }
}
