import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';

class MapPage extends StatefulWidget {
  final double customerLatitude;
  final double customerLongitude;
  const MapPage(
      {super.key,
      required this.customerLatitude,
      required this.customerLongitude});

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  // ignore: unused_field
  GoogleMapController? _mapController;
  final List<LatLng> _polylineCoordinates = [];

  LatLng _startCoordinates = const LatLng(0, 0); // User's current location
  LatLng _destinationCoordinates =
      const LatLng(0, 0); // Destination coordinates from Firebase

  @override
  void initState() {
    super.initState();
    // Call the methods to retrieve user's current location and destination coordinates
    getCurrentLocation();
    getDestinationCoordinates();
  }

  void getCurrentLocation() async {
    Position position = await Geolocator.getCurrentPosition();
    setState(() {
      _startCoordinates = LatLng(position.latitude, position.longitude);
    });
  }

  void getDestinationCoordinates() async {
    setState(() {
      _destinationCoordinates =
          LatLng(widget.customerLatitude, widget.customerLongitude);
    });
  }

  void _onMapCreated(GoogleMapController controller) {
    _mapController = controller;
    // Draw polyline on the map
    _drawPolyline();
  }

  void _drawPolyline() {
    setState(() {
      _polylineCoordinates.clear();
      _polylineCoordinates.add(_startCoordinates);
      _polylineCoordinates.add(_destinationCoordinates);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Map Route'),
      ),
      body: GoogleMap(
        onMapCreated: _onMapCreated,
        initialCameraPosition: CameraPosition(
          target: _startCoordinates,
          zoom: 12,
        ),
        polylines: {
          Polyline(
            polylineId: const PolylineId('polyline'),
            points: _polylineCoordinates,
            color: Colors.blue,
            width: 3,
          ),
        },
      ),
    );
  }
}
