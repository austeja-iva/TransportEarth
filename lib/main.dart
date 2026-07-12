import 'dart:convert';
import 'dart:js_interop';

import 'package:flutter/material.dart';
import 'package:transport_earth/classes/transportOptions.dart';
import 'package:transport_earth/pages/options_display.dart';

@JS('getCarInfo')
external JSPromise<JSAny?> getCarInfo(JSString origin, JSString destination);
@JS('getBikeInfo')
external JSPromise<JSAny?> getBikeInfo(JSString origin, JSString destination);
@JS('runFlightsDemo')
external JSPromise<JSAny?> runFlightsDemo();

final String font = 'Bierstadt';
void main() {
  runApp(const MyTest());
}

class MyTest extends StatelessWidget {
  const MyTest({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Transport Earth',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color.fromARGB(255, 10, 58, 5),
        ),
        useMaterial3: true,
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _startController = TextEditingController();
  final TextEditingController _destinationController = TextEditingController();

  @override
  void dispose() {
    _startController.dispose();
    _destinationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('web/icons/BG.webp'),
            fit: BoxFit.cover,
          ),
        ),
        child: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color(0x660F3D2E), Color(0x661E5F4D)],
            ),
          ),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Row(
                    children: [
                      Image.asset(
                        'web/icons/Globe.webp',
                        width: 100,
                        height: 100,
                        alignment: Alignment.topLeft,
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        'web/icons/TransportEarthLogo.webp',
                        width: 400,
                        height: 400,
                      ),
                      const SizedBox(width: 8),
                      const Column(
                        children: [
                          Text(
                            'TRANSPORT',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 75,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Bahnschrift',
                            ),
                          ),
                          Text(
                            'EARTH',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 75,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Bahnschrift',
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.12),
                          blurRadius: 12,
                          offset: const Offset(0, 6),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: TextField(
                                controller: _startController,
                                decoration: const InputDecoration(
                                  border: OutlineInputBorder(),
                                  labelText: 'Starting Location',
                                  prefixIcon: Icon(Icons.location_on),
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            const Icon(
                              Icons.arrow_forward,
                              color: Colors.black54,
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: TextField(
                                controller: _destinationController,
                                decoration: const InputDecoration(
                                  border: OutlineInputBorder(),
                                  labelText: 'Destination',
                                  prefixIcon: Icon(Icons.flag),
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            const Icon(Icons.person, color: Colors.black54),
                            const SizedBox(width: 12),
                            Expanded(
                              child: InputDatePickerFormField(
                                initialDate: DateTime.now(),
                                firstDate: DateTime.now().subtract(
                                  const Duration(days: 365),
                                ),
                                lastDate: DateTime.now().add(
                                  const Duration(days: 365),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 14),
                        SizedBox(
                          width: double.infinity,
                          child: FilledButton.icon(
                            onPressed: () async {
                              final origin = _startController.text.trim();
                              final destination = _destinationController.text.trim();

                              if (origin.isEmpty || destination.isEmpty) {
                                debugPrint('Please enter both a starting location and a destination.');
                                return;
                              }

                              try {
                                final carResult = await getCarInfo(
                                  origin.toJS,
                                  destination.toJS,
                                ).toDart;
                                final bikeResult = await getBikeInfo(
                                  origin.toJS,
                                  destination.toJS,
                                ).toDart;

                                final carData = jsonDecode(carResult.toString()) as Map<String, dynamic>;
                                final bikeData = jsonDecode(bikeResult.toString()) as Map<String, dynamic>;

                                final carDistance = carData['distance'];
                                final carDuration = carData['duration'];
                                final carCo2 = carData['co2'];

                                final bikeDistance = bikeData['distance'];
                                final bikeDuration = bikeData['duration'];
                                final bikeCo2 = bikeData['co2'];

                                List<TransportOption> options = [
                                  TransportOption(
                                    type: TransportType.car,
                                    cost: carDistance * 0.1536 * 0.000621371, // Convert meters to miles and multiply by $0.1536 per mile
                                    co2Emissions: carDistance * 0.000025, // Convert meters to miles and multiply by 0.0000055 Kg CO2 per mile
                                    time: (carDuration / 60).round(),
                                  ),
                                  TransportOption(
                                    type: TransportType.bike,
                                    cost: 0.0,
                                    co2Emissions: bikeDistance * 0.0000005, // Assuming negligible CO2 emissions for biking
                                    time: (bikeDuration / 60).round(),
                                  ),
                                ];

                                // If destination is Los Angeles, California (case-insensitive), add a flight option using test.js
                                if (destination.toLowerCase() == 'los angeles, california') {
                                  options.add(
                                    TransportOption(
                                      type: TransportType.plane,
                                      cost: 1040, // Placeholder cost for flight
                                      co2Emissions: 607, // Placeholder CO2 emissions for flight
                                      time: 305, // Placeholder time in minutes for flight
                                    ),
                                  );
                                } else if (destination.toLowerCase() == 'new york, new york') {
                                  options.add(
                                    TransportOption(
                                      type: TransportType.plane,
                                      cost: 805, // Placeholder cost for flight
                                      co2Emissions: 374, // Placeholder CO2 emissions for flight
                                      time: 226, // Placeholder time in minutes for flight
                                    ),
                                  );
                                }

                                debugPrint('Car result - distance: $carDistance, duration: $carDuration, co2: $carCo2');
                                debugPrint('Bike result - distance: $bikeDistance, duration: $bikeDuration, co2: $bikeCo2');

                                if (!context.mounted) return;

                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) => OptionsDisplayPage(options: options),
                                  ),
                                );
                              } catch (error, stackTrace) {
                                debugPrint('Route lookup failed: $error');
                                debugPrint('Stack trace: $stackTrace');
                              }
                            },
                            icon: const Icon(Icons.route),
                            label: const Text(
                              'Find the Most Eco-Friendly Route',
                            ),
                            style: FilledButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    'Enter your travel details to get the cleanest and greenest routes',
                    style: TextStyle(
                      color: Color.fromRGBO(255, 255, 255, 0.5),
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      height: 1.2,
                      fontFamily: 'Bahnschrift',
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                  const Spacer(),
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.16),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Row(
                      children: const [
                        Icon(Icons.tips_and_updates, color: Colors.white),
                        SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            'Eco-friendly routes can save time, reduce emissions, and improve your daily commute.',
                            style: TextStyle(color: Colors.white, fontSize: 14),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
