class LocationModel {
  String name;
  String type;
  String locality;
  int matchQuality;
  bool isBest;
  List<dynamic> coordinates;
  List<Stop> assignedStops;

  LocationModel({required this.name, required this.type, required this.locality, required this.matchQuality, required this.isBest, required this.coordinates, this.assignedStops = const []});
}

class Stop {
  String name;
  double distance;
  double duration;

  Stop({required this.name, this.distance = 0.0, this.duration = 0.0});
}
