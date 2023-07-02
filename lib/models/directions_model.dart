import '../constants.dart';

class DirectionModelDistance {

  double? lat;
  double? lng;

  DirectionModelDistance({
    this.lat,
    this.lng,
  });
  DirectionModelDistance.fromJson(Map<String, dynamic> json) {
    lat = json[Constants.lat]?.toDouble();
    lng = json[Constants.lng]?.toDouble();
  }
  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data[Constants.lat] = lat;
    data[Constants.lng] = lng;
    return data;
  }
}

class DirectionModel {

  String? instructions;
  DirectionModelDistance? distance;

  DirectionModel({
    this.instructions,
    this.distance,
  });
  DirectionModel.fromJson(Map<String, dynamic> json) {
    instructions = json[Constants.instructions]?.toString();
    distance = (json[Constants.distance] != null) ? DirectionModelDistance.fromJson(json[Constants.distance]) : null;
  }
  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data[Constants.instructions] = instructions;
    if (distance != null) {
      data[Constants.distance] = distance!.toJson();
    }
    return data;
  }
}