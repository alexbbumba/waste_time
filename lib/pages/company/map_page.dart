import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
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

  LatLng _startCoordinates = const LatLng(0, 0); // User's current location
  LatLng _destinationCoordinates =
      const LatLng(0, 0); // Destination coordinates from Firebase

  PolylinePoints polylinePoints = PolylinePoints();

  String googleAPiKey = "AIzaSyCN36hKY6ze8vC3QpCQWV8qpQ1zLHoAQs0";

  Map<PolylineId, Polyline> polylines = {};

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

  // void _onMapCreated(GoogleMapController controller) {
  //   _mapController = controller;
  //   // Draw polyline on the map
  // }

  getDirections() async {
    List<LatLng> polylineCoordinates = [];

    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
      googleAPiKey,
      PointLatLng(_startCoordinates.latitude, _startCoordinates.longitude),
      PointLatLng(
          _destinationCoordinates.latitude, _destinationCoordinates.longitude),
      travelMode: TravelMode.driving,
    );
    debugPrint("polyline result${result.toString()}");

    if (result.points.isNotEmpty) {
      for (var point in result.points) {
        polylineCoordinates.add(LatLng(point.latitude, point.longitude));
      }
    } else {
      debugPrint(result.errorMessage);
    }
    addPolyLine(polylineCoordinates);
  }

  addPolyLine(List<LatLng> polylineCoordinates) {
    PolylineId id = const PolylineId("poly");
    Polyline polyline = Polyline(
      polylineId: id,
      color: Colors.deepPurpleAccent,
      points: polylineCoordinates,
      width: 8,
    );
    polylines[id] = polyline;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Map Route'),
      ),
      body: GoogleMap(
        initialCameraPosition: CameraPosition(
          target: _startCoordinates,
          zoom: 12,
        ),
        polylines: Set<Polyline>.of(polylines.values), //polylines
        mapType: MapType.normal, //map type
        onMapCreated: (controller) {
          //method called when map is created
          setState(() {
            _mapController = controller;
          });
        },
      ),
    );
  }
}
