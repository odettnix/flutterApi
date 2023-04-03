part of 'accounting_cubit.dart';

@immutable
abstract class AccountingState {}

class AccountingInitial extends AccountingState {}

class UpdateAccounting extends AccountingState {
  final List<Accounting> accounting;

  UpdateAccounting(this.accounting);
}

class ClearAccounting extends AccountingState {
  final List<Accounting> accounting;

  ClearAccounting(this.accounting);
}
