import 'package:flutter/material.dart';

class UndefinedPage extends StatelessWidget {
  final String route;

  const UndefinedPage({super.key, required this.route});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Undefined page'),
        leading: IconButton(
          highlightColor: Colors.transparent,
          splashColor: Colors.transparent,
          onPressed: () => Navigator.of(context).pop(),
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
        ),
      ),
      body: SizedBox(
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Image(image: AssetImage('assets/images/error.png')),
            const SizedBox(height: 32.0),
            const Text(
              'Requested page does not exists!\nRequested route:',
              textAlign: TextAlign.center,
            ),
            Text(
              route,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
