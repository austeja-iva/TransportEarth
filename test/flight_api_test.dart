import 'package:flutter_test/flutter_test.dart';
import 'package:transport_earth/flight_api.dart';

void main() {
  test('selects the cheapest, fastest, and lowest-emission flights', () {
    const response = '''
    {
      "best_flights": [
        {
          "flights": [{"airline": "Budget Air", "flight_number": "BA 10"}],
          "price": 90,
          "total_duration": 240,
          "carbon_emissions": {"this_flight": 180000}
        },
        {
          "flights": [{"airline": "Fast Air", "flight_number": "FA 20"}],
          "price": 180,
          "total_duration": 120,
          "carbon_emissions": {"this_flight": 150000}
        }
      ],
      "other_flights": [
        {
          "flights": [{"airline": "Green Air", "flight_number": "GA 30"}],
          "price": 130,
          "total_duration": 180,
          "carbon_emissions": {"this_flight": 80000}
        }
      ]
    }
    ''';

    final best = findBestFlights(response);

    expect(best.cheapest?.airline, 'Budget Air');
    expect(best.fastest?.airline, 'Fast Air');
    expect(best.lowestEmissions?.airline, 'Green Air');
    expect(best.lowestEmissions?.carbonKilograms, 80);
  });

  test('returns null for a category whose values are all missing', () {
    const response = '''
    {
      "other_flights": [
        {
          "flights": [{"airline": "Example Air"}],
          "price": 100,
          "total_duration": 150
        }
      ]
    }
    ''';

    final best = findBestFlights(response);

    expect(best.cheapest?.price, 100);
    expect(best.fastest?.durationMinutes, 150);
    expect(best.lowestEmissions, isNull);
  });
}
