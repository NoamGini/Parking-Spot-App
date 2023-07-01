class DirectionModelDistance {

  double? lat;
  double? lng;

  DirectionModelDistance({
    this.lat,
    this.lng,
  });
  DirectionModelDistance.fromJson(Map<String, dynamic> json) {
    lat = json['lat']?.toDouble();
    lng = json['lng']?.toDouble();
  }
  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['lat'] = lat;
    data['lng'] = lng;
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
    instructions = json['instructions']?.toString();
    distance = (json['distance'] != null) ? DirectionModelDistance.fromJson(json['distance']) : null;
  }
  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['instructions'] = instructions;
    if (distance != null) {
      data['distance'] = distance!.toJson();
    }
    return data;
  }
}