// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'BuyRequestModel.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BuyRequestModel _$BuyRequestModelFromJson(Map<String, dynamic> json) =>
    BuyRequestModel(
      requesterUID: json['requesterUID'] as String,
      ownersUID: json['ownersUID'] as String,
      phoneNumber: json['phoneNumber'] as String,
      name: json['name'] as String,
      petid: json['petid'] as String,
      images:
          (json['images'] as List<dynamic>).map((e) => e as String).toList(),
    );

Map<String, dynamic> _$BuyRequestModelToJson(BuyRequestModel instance) =>
    <String, dynamic>{
      'requesterUID': instance.requesterUID,
      'ownersUID': instance.ownersUID,
      'phoneNumber': instance.phoneNumber,
      'name': instance.name,
      'petid': instance.petid,
      'images': instance.images,
    };
