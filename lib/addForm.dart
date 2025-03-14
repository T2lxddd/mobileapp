import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class addForm extends StatefulWidget {
  @override
  State<addForm> createState() => _addFormState();
}

class _addFormState extends State<addForm> {
  final cityController = TextEditingController();
  final temperatureController = TextEditingController();
  final humidityController = TextEditingController();

  CollectionReference weatherCollection =
      FirebaseFirestore.instance.collection('Weather');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(99, 136, 137, 1),
        title: Center(
          child: Text(
            'Example',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Form(
            child: Column(
              children: [
                Text(
                  'New Weather Data',
                  style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 20),
                TextFormField(
                  controller: cityController,
                  autofocus: true,
                  decoration: InputDecoration(
                    hintText: 'Add a city',
                    icon: Icon(Icons.location_city),
                  ),
                ),
                SizedBox(height: 10),
                TextFormField(
                  controller: temperatureController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    hintText: 'Add temperature (C)',
                    icon: Icon(Icons.thermostat),
                  ),
                ),
                SizedBox(height: 10),
                TextFormField(
                  controller: humidityController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    hintText: 'Add humidity (%)',
                    icon: Icon(Icons.water_drop),
                    suffixText: '%',
                  ),
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    weatherCollection.add({
                      'city': cityController.text,
                      'temperature': double.parse(temperatureController.text),
                      'humidity': double.parse(humidityController.text),
                      'timestamp': FieldValue.serverTimestamp(),
                    });
                    Navigator.pop(context);
                  },
                  child: Text('Add Weather Data'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
