import 'package:dartz/dartz.dart';
import 'package:gymbook/core/error/failure.dart';
import 'package:gymbook/core/services/stripe_service.dart';
import 'package:gymbook/features/payments/data/data_sources/payments_remote_data_source.dart';
import 'package:gymbook/features/payments/domain/entities/payment_intent_entity.dart';
import 'package:gymbook/features/payments/domain/entities/payment_transaction_status_entity.dart';
import 'package:gymbook/features/payments/domain/repositories/payments_repository.dart';

class PaymentsRepositoryImpl implements PaymentsRepository {
  final PaymentsRemoteDataSource remoteDataSource;
  final StripeService stripeService;

  PaymentsRepositoryImpl(this.remoteDataSource, this.stripeService);

  @override
  Future<Either<Failure, PaymentIntentEntity>> initializePayment({
    required int branchId,
    required int packageId,
  }) async {
    try {
      final model = await remoteDataSource.initializePayment(
        branchId: branchId,
        packageId: packageId,
      );
      return Right(model);
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }
  @override
  Future<Either<Failure, PaymentTransactionStatusEntity>> getPaymentTransactionStatus(
    int transactionId,
  ) async {
    try {
      final model = await remoteDataSource.getPaymentTransactionStatus(transactionId);
      return Right(model);
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> initPaymentSheet(String clientSecret) async {
    try {
      await stripeService.initPaymentSheet(paymentIntentClientSecret: clientSecret);
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> presentPaymentSheet() async {
    try {
      await stripeService.presentPaymentSheet();
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }
}
