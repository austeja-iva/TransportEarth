import 'package:flutter/material.dart';
import 'package:transport_earth/classes/transportOptions.dart';

class TransportCard extends StatefulWidget {
  final TransportOption option;

  const TransportCard({super.key, required this.option});

  @override
  State<TransportCard> createState() => _TransportCardState();
}

class _TransportCardState extends State<TransportCard> {
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.option.type.toString(),
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text('Cost: ${widget.option.cost}'),
            Text('CO2 Emissions: ${widget.option.co2Emissions}'),
            Text('Time: ${widget.option.time}'),
          ],
        ),
      ),
    );
  }
}