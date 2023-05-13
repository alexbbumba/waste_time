import 'package:flutter/material.dart';
import 'package:waste_time/pages/maps.dart';

class ServiceProviders extends StatefulWidget {
  const ServiceProviders({super.key});

  @override
  State<ServiceProviders> createState() => _ServiceProvidersState();
}

class _ServiceProvidersState extends State<ServiceProviders> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [],
        title: Text('Service Providers'),
        elevation: 0,
      ),
      body: Padding(
        padding: EdgeInsets.fromLTRB(10, 50, 10, 0),
        child: Container(
          child: Column(
            children: [
              InkWell(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const MapSample(),
                      ));
                },
                child: Container(
                  padding: EdgeInsets.all(20.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.0),
                    color: Colors.blueGrey,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'shedule collector with KCCA',
                        style: TextStyle(
                          fontSize: 18.0,
                          fontStyle: FontStyle.italic,
                          color: Colors.white,
                        ),
                      ),
                      Icon(Icons.person),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 15.0,
              ),
              Container(
                padding: EdgeInsets.all(20.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.0),
                  color: Colors.blueGrey,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'shedule collector with CITY DWELLERS',
                      style: TextStyle(
                        fontSize: 15.0,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                    Icon(Icons.person),
                  ],
                ),
              ),
              SizedBox(
                height: 15.0,
              ),
              Container(
                padding: EdgeInsets.all(20.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.0),
                  color: Colors.blueGrey,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'shedule collector with THEE DUST',
                      style: TextStyle(
                        fontSize: 15.0,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                    Icon(Icons.person),
                  ],
                ),
              ),
              SizedBox(
                height: 15.0,
              ),
              Text(
                'Select Your Service provider',
                style: TextStyle(
                  fontSize: 30.0,
                  fontStyle: FontStyle.italic,
                ),
              ),
              Text(
                'Select Your Service provider',
                style: TextStyle(
                  fontSize: 30.0,
                  fontStyle: FontStyle.italic,
                ),
              ),
              Text(
                'Select Your Service provider',
                style: TextStyle(
                  fontSize: 30.0,
                  fontStyle: FontStyle.italic,
                ),
              ),
              Text(
                'Select Your Service provider',
                style: TextStyle(
                  fontSize: 30.0,
                  fontStyle: FontStyle.italic,
                ),
              ),
              Text(
                'Select Your Service provider',
                style: TextStyle(
                  fontSize: 30.0,
                  fontStyle: FontStyle.italic,
                ),
              ),
              Text(
                'Select Your Service provider',
                style: TextStyle(
                  fontSize: 30.0,
                  fontStyle: FontStyle.italic,
                ),
              ),
              Text(
                'Select Your Service provider',
                style: TextStyle(
                  fontSize: 30.0,
                  fontStyle: FontStyle.italic,
                ),
              ),
              Text(
                'Select Your Service provider',
                style: TextStyle(
                  fontSize: 30.0,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
