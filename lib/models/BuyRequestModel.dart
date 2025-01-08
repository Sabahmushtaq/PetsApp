import 'package:json_annotation/json_annotation.dart';

part 'BuyRequestModel.g.dart';

@JsonSerializable()
class BuyRequestModel {
  final String requesterUID;
  final String ownersUID;
  final String phoneNumber;
  final String name;
  final String petid;
  List<String> images;
  BuyRequestModel({
    required this.requesterUID,
    required this.ownersUID,
    required this.phoneNumber,
    required this.name,
    required this.petid,
    required this.images,
  });

  factory BuyRequestModel.fromJson(Map<String, dynamic> json) =>
      _$BuyRequestModelFromJson(json);

  Map<String, dynamic> toJson() => _$BuyRequestModelToJson(this);
}
