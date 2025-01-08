// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'UploadDataModel.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UploadDataModel _$UploadDataModelFromJson(Map<String, dynamic> json) =>
    UploadDataModel(
      name: json['name'] as String,
      breed: json['breed'] as String,
      category: json['category'] as String,
      color: json['color'] as String,
      vaccinated: json['vaccinated'] as bool,
      price: (json['price'] as num).toInt(),
      stock: (json['stock'] as num).toInt(),
      images:
          (json['images'] as List<dynamic>).map((e) => e as String).toList(),
      verified: json['verified'] as bool,
      rejected: json['rejected'] as bool,
      checked: json['checked'] as bool,
      reason: json['reason'] as String?,
      id: json['id'] as String,
      uid: json['uid'] as String,
      date: json['date'] as String,
    );

Map<String, dynamic> _$UploadDataModelToJson(UploadDataModel instance) =>
    <String, dynamic>{
      'name': instance.name,
      'breed': instance.breed,
      'color': instance.color,
      'price': instance.price,
      'stock': instance.stock,
      'category': instance.category,
      'vaccinated': instance.vaccinated,
      'verified': instance.verified,
      'rejected': instance.rejected,
      'checked': instance.checked,
      'images': instance.images,
      'reason': instance.reason,
      'id': instance.id,
      'uid': instance.uid,
      'date': instance.date,
    };
