
class DirectionModelDistance {
/*
{
  "lat": 51.1797473,
  "lng": 6.8273933
} 
*/

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
/*
{instructions: At the roundabout, take the <b>1st</b> exit onto <b>Yosef Levi St</b>,
 distance: {lat: 32.0653435, lng: 34.7649243}}
} 
*/

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