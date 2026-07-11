import 'package:flutter/material.dart';
import 'package:transport_earth/classes/transportOptions.dart';
import 'package:transport_earth/widgets/transportCard.dart';

class OptionsDisplayPage extends StatefulWidget {
  final List<TransportOption> options;

  const OptionsDisplayPage({super.key, required this.options});

  @override
  State<OptionsDisplayPage> createState() => _OptionsDisplayPageState();
}

class _OptionsDisplayPageState extends State<OptionsDisplayPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Transport Options'),
      ),
      body: ListView.builder(
        itemCount: widget.options.length,
        itemBuilder: (context, index) {
          final option = widget.options[index];
          return TransportCard(option: option);
        },
      ),
    );
  }
}