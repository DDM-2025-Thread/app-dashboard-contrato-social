import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(child: Row(
        children: [
          Expanded(
            flex: 2,
            child:
            Container(
              color: const Color.fromARGB(255, 245, 240, 240),
            ),
            ),
          Expanded( 
            flex: 7,
            child: Container(color: Colors.greenAccent),
          ),
          Expanded(
            flex:3,
            child: Container(color: Colors.blueAccent),
          ),

        ],
        )),
      );
    }
  }


