import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class updateForm extends StatefulWidget {
  @override
  State<updateForm> createState() => _updateFormState();
}

class _updateFormState extends State<updateForm> {
  CollectionReference weatherCollection =
      FirebaseFirestore.instance.collection('Weather');

  @override
  Widget build(BuildContext context) {
    final weatherData = ModalRoute.of(context)!.settings.arguments as dynamic;

    final temperatureController =
        TextEditingController(text: weatherData['temperature'].toString());
    final humidityController =
        TextEditingController(text: weatherData['humidity'].toString());

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(99, 136, 137, 1),
        title: Center(
          child: Text(
            'Update Weather Data',
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
                  'Update Weather Data',
                  style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 20),
                TextFormField(
                  controller: temperatureController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    hintText: 'Update temperature (C)',
                    icon: Icon(Icons.thermostat),
                    suffixIcon: Padding(
                      padding: const EdgeInsets.only(top: 15.0),
                      child: Text('C', style: TextStyle(fontSize: 16)),
                    ),
                  ),
                ),
                SizedBox(height: 10),
                TextFormField(
                  controller: humidityController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    hintText: 'Update humidity (%)',
                    icon: Icon(Icons.water_drop),
                    suffixIcon: Padding(
                      padding: const EdgeInsets.only(top: 15.0),
                      child: Text('%', style: TextStyle(fontSize: 16)),
                    ),
                  ),
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    weatherCollection.doc(weatherData.id).update({
                      'temperature': double.parse(temperatureController.text),
                      'humidity': double.parse(humidityController.text)
                    });
                    Navigator.pop(context);
                  },
                  child: Text('Update Weather Data'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
