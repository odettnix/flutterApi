import 'package:freezed_annotation/freezed_annotation.dart';
part 'accounting.g.dart';
part 'accounting.freezed.dart';

@freezed
class Accounting with _$Accounting {
  const factory Accounting({
 
    int? numberOperation, 
    String? nameOperation, 
    String? description, 
    String? category, 
    String? dateOfOperation, 
    int? transactionAmount, 
    bool? deleted, 
    }) = _Accounting;

  factory Accounting.fromJson(Map<String, dynamic> json) => _$AccountingFromJson(json);
}