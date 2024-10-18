import 'package:flutter/material.dart';

class Index extends StatelessWidget {
  const Index({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Index'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Index'),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/image-picker');
              },
              child: Text('Image Picker'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/google-maps');
              },
              child: Text('Google Maps'),
            ),
          ],
        ),
      ),
    );
  }
}
