import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_location_marker/flutter_map_location_marker.dart';
import "package:latlong2/latlong.dart";
import "package:geolocator/geolocator.dart";
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:ecoquest/models/PuntVerd_Model.dart';

class MapPage extends StatefulWidget {
  const MapPage({super.key});

  @override
  _MapPageState createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  LatLng _currentPosition = LatLng(51.509364, -0.128928);
  bool _loading = true;
  List<PuntVerd> _puntsVerds = [];
  

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
    getPuntsVerds();
  }

  Future<void> _getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;



    // Verifica si los servicios de ubicación están habilitados
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Los servicios de ubicación no están habilitados, no continúes
      return;
    }

    // Verifica si se tienen permisos de ubicación
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Los permisos están denegados, no continúes
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Los permisos están denegados para siempre, no continúes
      return;
    }

    // Obtén la posición actual del dispositivo
    Position position = await Geolocator.getCurrentPosition();
    setState(() {
      _currentPosition = LatLng(position.latitude, position.longitude);
      _loading = false;
    });
  }

  Future<void> getPuntsVerds() async {
    final result = await Supabase.instance.client
        .from('punts_verds')
        .select('name, x, y')
        .execute();

    if (result.data != null) {
      List<PuntVerd> puntsVerds = (result.data as List)
          .map((e) => PuntVerd.fromMap(e))
          .toList();

      setState(() {
        _puntsVerds = puntsVerds;
      }
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: const Text(
          'EcoQuest',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true
      ),
      body: _loading
          ? Center(child: CircularProgressIndicator())
          : Stack(
            children: [
              FlutterMap(
                options: MapOptions(
                  initialCenter: _currentPosition,
                  initialZoom: 13,
                ),
                children: [
                  TileLayer(
                    urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                    userAgentPackageName: 'com.example.app',
                  ),
                  CurrentLocationLayer(),
                  MarkerLayer(markers:
                    _puntsVerds
                        .map((puntVerd) => Marker(
                              point: LatLng(puntVerd.x, puntVerd.y),
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.green,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Icon(Icons.recycling, color: Colors.white),
                              ),
                            ))
                        .toList(),
                  ),
                ],
              ),
            ],
          ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.green,
        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.black54,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.star),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.map),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: '',
          ),
        ],
      ),
    );
  }
}

