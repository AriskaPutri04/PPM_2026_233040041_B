import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: Scaffold(
      body: Column(
        children: [
          const Expanded(
            child: Center(
              child: Text(
                'Menu Navigasi',
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.w900),
              ),
            ),
          ),

          Container(
            padding: const EdgeInsets.symmetric(vertical: 20),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withValues(alpha: 0.2),
                  blurRadius: 15,
                  offset: const Offset(0, -5),
                ),
              ],
            ),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Icon(Icons.favorite, size: 48, color: Colors.red),
                Icon(Icons.chat_bubble, size: 64, color: Colors.green),
                Icon(Icons.settings, size: 24, color: Colors.purple),
                Icon(Icons.person, size: 32, color: Colors.grey),
              ],
            ),
          ),
        ],
      ),
    ),
  ));
}