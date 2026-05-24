part of 'add_member_cubit.dart';

abstract class AddMemberState {}

class AddMemberInitial extends AddMemberState {}

class AddMemberLoading extends AddMemberState {}

class AddMemberSuccess extends AddMemberState {
  final AddMemberEntity result;
  AddMemberSuccess(this.result);
}

class AddMemberFailure extends AddMemberState {
  final String message;
  AddMemberFailure(this.message);
}
