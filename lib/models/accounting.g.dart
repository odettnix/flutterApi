// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'accounting.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_Accounting _$$_AccountingFromJson(Map<String, dynamic> json) =>
    _$_Accounting(
      numberOperation: json['numberOperation'] as int?,
      nameOperation: json['nameOperation'] as String?,
      description: json['description'] as String?,
      category: json['category'] as String?,
      dateOfOperation: json['dateOfOperation'] as String?,
      transactionAmount: json['transactionAmount'] as int?,
      deleted: json['deleted'] as bool?,
    );

Map<String, dynamic> _$$_AccountingToJson(_$_Accounting instance) =>
    <String, dynamic>{
      'numberOperation': instance.numberOperation,
      'nameOperation': instance.nameOperation,
      'description': instance.description,
      'category': instance.category,
      'dateOfOperation': instance.dateOfOperation,
      'transactionAmount': instance.transactionAmount,
      'deleted': instance.deleted,
    };
