import 'package:gymbook/features/payments/domain/entities/payment_intent_entity.dart';
import 'package:gymbook/features/payments/domain/entities/payment_transaction_status_entity.dart';

abstract class PaymentState {}

class PaymentInitial extends PaymentState {}

class PaymentLoading extends PaymentState {}

class PaymentSuccess extends PaymentState {
  final PaymentIntentEntity paymentIntent;

  PaymentSuccess(this.paymentIntent);
}

class PaymentError extends PaymentState {
  final String message;

  PaymentError(this.message);
}

class PaymentStatusChecking extends PaymentState {}

class PaymentStatusSuccess extends PaymentState {
  final PaymentTransactionStatusEntity status;

  PaymentStatusSuccess(this.status);
}
