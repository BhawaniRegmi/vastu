import 'package:flutter/material.dart';
class Rider {
  final String name;
  final String id;
  final double latitude;
  final double longitude;
  final String status;
  final String vehicle;

  Rider({
    required this.name,
    required this.id,
    required this.latitude,
    required this.longitude,
    required this.status,
    required this.vehicle,
  });
}

class RiderDetailsScreen extends StatelessWidget {
  final Rider rider = Rider(
    name: "John Doe",
    id: "R12345",
    latitude: 37.7749,
    longitude: -122.4194,
    status: "On Trip",
    vehicle: "Scooter",
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Rider Tracking'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              'Rider Information',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            Text(
              'Name: ${rider.name}',
              style: TextStyle(fontSize: 18),
            ),
            Text(
              'ID: ${rider.id}',
              style: TextStyle(fontSize: 18),
            ),
            Text(
              'Vehicle: ${rider.vehicle}',
              style: TextStyle(fontSize: 18),
            ),
            Text(
              'Status: ${rider.status}',
              style: TextStyle(fontSize: 18),
            ),
            Text(
              'Location: Lat: ${rider.latitude}, Long: ${rider.longitude}',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Handle tracking update logic
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: Text("Tracking Updated"),
                    content: Text("The rider's details have been updated."),
                    actions: <Widget>[
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: Text("OK"),
                      ),
                    ],
                  ),
                );
              },
              child: Text('Update Rider Location'),
            ),
          ],
        ),
      ),
    );
  }
}
