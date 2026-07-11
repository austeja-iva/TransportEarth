enum TransportType {
  plane,
  car,
  bike,
}

class TransportOption {
  final TransportType type;
  final int cost;
  final int co2Emissions;
  final int time;

  TransportOption({
    required this.type,
    required this.cost,
    required this.co2Emissions,
    required this.time,
  });

}