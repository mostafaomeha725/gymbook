import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import 'package:gymbook/core/cache/hive_boxes.dart';
import 'package:gymbook/features/payments/domain/usecases/get_payment_transaction_status_usecase.dart';
import 'package:gymbook/features/payments/domain/usecases/initialize_payment_usecase.dart';
import 'package:gymbook/features/payments/domain/usecases/init_payment_sheet_usecase.dart';
import 'package:gymbook/features/payments/domain/usecases/present_payment_sheet_usecase.dart';
import 'package:gymbook/features/payments/presentation/cubits/payment_cubit/payment_state.dart';

class PaymentCubit extends Cubit<PaymentState> {
  final InitializePaymentUseCase initializePaymentUseCase;
  final GetPaymentTransactionStatusUseCase getPaymentTransactionStatusUseCase;
  final InitPaymentSheetUseCase initPaymentSheetUseCase;
  final PresentPaymentSheetUseCase presentPaymentSheetUseCase;

  PaymentCubit({
    required this.initializePaymentUseCase,
    required this.getPaymentTransactionStatusUseCase,
    required this.initPaymentSheetUseCase,
    required this.presentPaymentSheetUseCase,
  }) : super(PaymentInitial());

  Future<void> processPayment({
    required int branchId,
    required int packageId,
  }) async {
    emit(PaymentLoading());

    // 1. Initialize Payment on Backend
    final initResult = await initializePaymentUseCase(
      branchId: branchId,
      packageId: packageId,
    );

    await initResult.fold(
      (failure) async => emit(PaymentError(failure.message)),
      (paymentIntent) async {
        // 2. Init Stripe Payment Sheet
        final sheetResult = await initPaymentSheetUseCase(
          paymentIntent.clientSecret,
        );

        await sheetResult.fold(
          (failure) async => emit(PaymentError(failure.message)),
          (_) async {
            // 3. Present Payment Sheet
            final presentResult = await presentPaymentSheetUseCase();

            await presentResult.fold(
              (failure) async => emit(PaymentError(failure.message)),
              (_) async {
                // 4. Verify Payment Status on Backend
                emit(PaymentStatusChecking());
                final statusResult = await getPaymentTransactionStatusUseCase(
                  paymentIntent.paymentTransactionId,
                );

                statusResult.fold(
                  (failure) => emit(PaymentError(failure.message)),
                  (status) {
                    if (status.status == 1) {
                      // successed
                      try {
                        // Clear cache so that SubscriptionsScreen forces a network refresh 
                        // the next time it's opened.
                        Hive.box<String>(HiveBoxes.cacheBox).clear();
                      } catch (_) {}
                      emit(PaymentStatusSuccess(status));
                    } else if (status.status == 2) {
                      // failed
                      emit(PaymentError("Payment failed"));
                    } else {
                      // pending or other
                      emit(PaymentError("Payment is pending or unconfirmed"));
                    }
                  },
                );
              },
            );
          },
        );
      },
    );
  }
}
