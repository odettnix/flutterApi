import 'package:bloc/bloc.dart';
import 'package:flitter_api/models/accounting.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'accounting_state.dart';

class AccountingCubit extends Cubit<AccountingState> {
  AccountingCubit() : super(AccountingInitial());

  List<Accounting> accounting = [];

  void setAccounting(List<Accounting> accounting){
    this.accounting = accounting;
    
    emit(UpdateAccounting(accounting));
  }

  void updateAccounting(Accounting accountings){
    accounting.add(accountings);
    emit(UpdateAccounting(accounting));
  }

  void deleteAccounting(int index){
    accounting.remove(index);
    emit(UpdateAccounting(accounting));
  }

  void clearAccounting(){
    accounting.clear();
    emit(ClearAccounting(accounting));
  }
}
