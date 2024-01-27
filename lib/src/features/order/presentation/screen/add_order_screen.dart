import 'package:flutter/material.dart';

class AddOrderScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Order'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Text('Add Order'),
          ],
        ),
      ),
    );
  }

}