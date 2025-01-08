import 'package:json_annotation/json_annotation.dart';

part 'FavouriteModel.g.dart';

@JsonSerializable()
class Fmodel {

  final String value;

  Fmodel({required this.value});

  ///
  factory Fmodel.fromJson(Map<String, dynamic> json) => _$FmodelFromJson(json);

  Map<String, dynamic> toJson() => _$FmodelToJson(this);
}