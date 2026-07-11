import 'package:flutter/material.dart';

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

class HomePage extends StatelessWidget {
  const HomePage({super.key});

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
                  Image.asset(
                    'web/icons/Globe.webp',
                    width: 100,
                    height: 100,
                    alignment: Alignment.topLeft,
                  ),
                  const SizedBox(height: 28),
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
                            onPressed: () {},
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
