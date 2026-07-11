import 'dart:convert';

/// The parts of a SerpApi Google Flights result used by our comparison page.
class FlightOption {
  const FlightOption({
    required this.airline,
    required this.flightNumber,
    required this.price,
    required this.durationMinutes,
    required this.carbonGrams,
  });

  final String airline;
  final String flightNumber;
  final int? price;
  final int? durationMinutes;
  final int? carbonGrams;

  double? get carbonKilograms =>
      carbonGrams == null ? null : carbonGrams! / 1000;

  factory FlightOption.fromJson(Map<String, dynamic> json) {
    final segments = (json['flights'] as List<dynamic>? ?? const [])
        .whereType<Map<String, dynamic>>()
        .toList();
    final firstSegment = segments.isEmpty ? null : segments.first;
    final emissions = json['carbon_emissions'] as Map<String, dynamic>?;

    return FlightOption(
      airline: firstSegment?['airline'] as String? ?? 'Unknown airline',
      flightNumber:
          firstSegment?['flight_number'] as String? ?? 'Unknown flight',
      price: (json['price'] as num?)?.toInt(),
      durationMinutes: (json['total_duration'] as num?)?.toInt(),
      carbonGrams: (emissions?['this_flight'] as num?)?.toInt(),
    );
  }
}

/// The cheapest, fastest, and lowest-emission results.
///
/// The same flight may be the winner of more than one category.
class BestFlightOptions {
  const BestFlightOptions({
    required this.cheapest,
    required this.fastest,
    required this.lowestEmissions,
  });

  final FlightOption? cheapest;
  final FlightOption? fastest;
  final FlightOption? lowestEmissions;
}

/// Parses a complete SerpApi response and selects the three category winners.
BestFlightOptions findBestFlights(String jsonText) {
  final decoded = jsonDecode(jsonText);
  if (decoded is! Map<String, dynamic>) {
    throw const FormatException('Expected a JSON object from SerpApi.');
  }

  final rawFlights = <dynamic>[
    ...?decoded['best_flights'] as List<dynamic>?,
    ...?decoded['other_flights'] as List<dynamic>?,
  ];

  final flights = rawFlights
      .whereType<Map<String, dynamic>>()
      .map(FlightOption.fromJson)
      .toList();

  return BestFlightOptions(
    cheapest: _minimumBy(flights, (flight) => flight.price),
    fastest: _minimumBy(flights, (flight) => flight.durationMinutes),
    lowestEmissions: _minimumBy(flights, (flight) => flight.carbonGrams),
  );
}

FlightOption? _minimumBy(
  List<FlightOption> flights,
  int? Function(FlightOption flight) valueOf,
) {
  FlightOption? winner;
  int? winningValue;

  for (final flight in flights) {
    final value = valueOf(flight);
    if (value != null && (winningValue == null || value < winningValue)) {
      winner = flight;
      winningValue = value;
    }
  }

  return winner;
}
