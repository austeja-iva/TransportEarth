import 'package:flutter/material.dart';
import 'package:transport_earth/classes/transportOptions.dart';

class TransportCard extends StatefulWidget {
  final TransportOption option;

  const TransportCard({super.key, required this.option});

  @override
  State<TransportCard> createState() => _TransportCardState();
}

class _TransportCardState extends State<TransportCard> {
  String _assetNameForType(TransportType type) {
    switch (type) {
      case TransportType.car:
        return 'web/icons/Car.webp';
      case TransportType.bike:
        return 'web/icons/Bike.webp';
      case TransportType.plane:
        return 'web/icons/Plane.webp';
    }
  }

  String _formatTime(int minutes) {
    final hours = minutes ~/ 60;
    final mins = minutes % 60;

    if (hours > 0 && mins > 0) {
      return '${hours}h ${mins}m';
    }
    if (hours > 0) {
      return '${hours}h';
    }
    return '${mins}m';
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset(
              _assetNameForType(widget.option.type),
              width: 150,
              height: 150,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    widget.option.type.name.toUpperCase(),
                    style: const TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 6),
                  Text('Cost: \$${widget.option.cost.round()}', style: const TextStyle(fontSize: 18, color: Colors.black54)),
                  Text('CO2 Emissions: ${widget.option.co2Emissions.round()} Kg Co2', style: const TextStyle(fontSize: 18, color: Colors.black54)),
                  Text('Time: ${_formatTime(widget.option.time)}', style: const TextStyle(fontSize: 18, color: Colors.black54)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}