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
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          onPressed: () {
            if (Navigator.canPop(context)) {
              Navigator.pop(context);
            }
          },
          icon: Image.asset(
            'web/icons/Globe.webp',
            width: 50,
            height: 50,
          ),
        ),
      ),
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
              padding: const EdgeInsets.fromLTRB(8.0, 80.0, 8.0, 8.0),
              child: GridView.builder(
                itemCount: widget.options.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 8,
                  mainAxisSpacing: 8,
                  childAspectRatio: 3.0,
                ),
                itemBuilder: (context, index) {
                  final option = widget.options[index];
                  return TransportCard(option: option);
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}