import 'package:flutter/material.dart';
import 'package:new_project_flutter/model/dashboad_model.dart';

void main() {
  runApp(DashboadModel());
}

class Dashboard extends StatelessWidget {
  const Dashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('this is dashboard')),
      body: SafeArea(
        child: Center(
          child: Container(
            height: double.infinity,
            width: double.infinity,
            alignment: Alignment.centerRight,
            child: Container(
              width: 200,
              height: 200,
              alignment: Alignment.center,
              color: Colors.amberAccent,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.amberAccent,
                border: Border.all(color: Colors.black, width: 2),
              ),
              child: const Text("I am a container"),
            ),
          ),
        ),
      ),
    );
  }
}
