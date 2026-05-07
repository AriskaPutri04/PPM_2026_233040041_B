import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(   
              'Latihan 3 Row & CrossAxisAlignment',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center, // Sumbu tegak lurus
              children: [
                Icon(Icons.star, color: Colors.red, size: 80),
                Icon(Icons.star, color: Colors.green, size: 60),
                Icon(Icons.star, color: Colors.blue, size: 40), //
              ],
            ),
            const SizedBox(height: 40),
            const Text(
              'Latihan3 Column Center',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(width: 100, height: 50, color: Colors.amber),
                const SizedBox(height: 10),
                Container(width: 100, height: 50, color: Colors.orange),
                const SizedBox(height: 10),
                Container(width: 100, height: 50, color: Colors.deepOrange),
              ],
            ),
          ],
        ),
      ),
    ),
  ));
}