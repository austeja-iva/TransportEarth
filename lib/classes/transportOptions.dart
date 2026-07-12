enum TransportType {
  plane,
  car,
  bike,
}

class TransportOption {
  final TransportType type;
  final double cost;
  final double co2Emissions;
  final int time;

  TransportOption({
    required this.type,
    required this.cost,
    required this.co2Emissions,
    required this.time,
  });

}