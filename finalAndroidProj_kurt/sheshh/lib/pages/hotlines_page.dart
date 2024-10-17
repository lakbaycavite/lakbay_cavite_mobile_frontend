import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart'; // For reverse geocoding
import 'buttons/hotline_model.dart';

class HotlinesPage extends StatefulWidget {
  const HotlinesPage({super.key});

  @override
  _HotlinesPageState createState() => _HotlinesPageState();
}

class _HotlinesPageState extends State<HotlinesPage> {
  final List<Hotline> hotlines = [
    Hotline(name: 'IMUS BFP', phoneNumber: '0915-528-3256', icon: Icons.local_fire_department),
    Hotline(name: 'IMUS PNP', phoneNumber: '0906-595-4801', icon: Icons.local_police),
    Hotline(name: 'Ambulance', phoneNumber: '112', icon: Icons.medical_services),
    Hotline(name: 'Imus City Hall', phoneNumber: '+6346-471-3243', icon: Icons.account_balance),
    Hotline(name: 'IMUS CDRRMO', phoneNumber: '0919-069-1703', icon: Icons.local_hospital),
  ];

  String? barangayName;
  String? barangayContact;

  // Mocked data for barangay contact numbers
  final Map<String, String> barangayContacts = {
    "Barangay Alapan": "0912-345-6789",
    "Barangay Bucandala": "0911-223-3344",
    "Barangay Carsadang bago I": "0931-725-5677",
    // Add more barangays and contact numbers as needed
  };

  @override
  void initState() {
    super.initState();
    _fetchBarangayContact();
  }

  Future<void> _fetchBarangayContact() async {
    try {
      Position position = await _getUserLocation();
      List<Placemark> placemarks = await placemarkFromCoordinates(position.latitude, position.longitude);
      if (placemarks.isNotEmpty) {
        debugPrint('Placemark details: ${placemarks[3]}');
        String? barangay = placemarks[3].name;
        if (barangay != null && barangayContacts.containsKey(barangay)) {
          setState(() {
            barangayName = barangay;
            barangayContact = barangayContacts[barangay];
          });
        } else {
          setState(() {
            barangayName = barangay ?? 'Unknown';
            barangayContact = barangay != null ? ' 0931-725-5677':'';
          });
        }
      } else {
        setState(() {
          barangayContact = 'No contact info available';
        });
      }
    } catch (e) {
      setState(() {
        barangayContact = 'Error fetching contact info: ${e.toString()}';
      });
    }
  }

  Future<Position> _getUserLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission != LocationPermission.whileInUse && permission != LocationPermission.always) {
        return Future.error('Location permission is denied');
      }
    }

    return await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Row(
          children: [
            Icon(
              Icons.phone,
              color: Colors.white,
              size: 30,
            ),
            SizedBox(width: 8),
            Text(
              'Emergency Hotlines',
              style: TextStyle(
                fontFamily: 'Poppins',
                fontWeight: FontWeight.bold,
                fontSize: 18,
                color: Colors.white,
              ),
            ),
          ],
        ),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF035594), Color(0xFF4286f4)],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
        ),
        elevation: 4,
        actions: [
          Padding(
            padding: const EdgeInsets.all(1.20),
            child: SizedBox(
              width: 80,
              height: 80,
              child: Image.asset('assets/lakbay_cavite_logo.png'),
            ),
          ),
        ],
      ),
      body: Stack(
        children: [
          // Background gradient
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFFF0F4F7), Color(0xFF9DC9E8)],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
          // Hotline list
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: ListView.builder(
              itemCount: hotlines.length + (barangayContact != null ? 1 : 0), // Adjust count for barangay
              itemBuilder: (context, index) {
                if (index < hotlines.length) {
                  final hotline = hotlines[index];
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: _buildHotlineCard(context, hotline),
                  );
                } else {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: _buildBarangayHotlineCard(),
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHotlineCard(BuildContext context, Hotline hotline) {
    return InkWell(
      onTap: () => _makePhoneCallWithFeedback(context, hotline.phoneNumber),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        elevation: 6,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          padding: const EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.white, Colors.blue.shade50],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(15),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    radius: 30,
                    backgroundColor: Colors.redAccent.withOpacity(0.2),
                    child: Icon(hotline.icon, color: Colors.redAccent, size: 30),
                  ),
                  const SizedBox(width: 20),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        hotline.name,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      Text(
                        hotline.phoneNumber,
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              IconButton(
                icon: const Icon(Icons.call, color: Colors.green, size: 30),
                onPressed: () => _makePhoneCallWithFeedback(context, hotline.phoneNumber),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBarangayHotlineCard() {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      elevation: 6,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.white, Colors.blue.shade50],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(15),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundColor: Colors.greenAccent.withOpacity(0.2),
                  child: const Icon(Icons.home, color: Colors.green, size: 30),
                ),
                const SizedBox(width: 20),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      barangayName ?? 'Barangay',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    Text(
                      barangayContact ?? 'No contact info',
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            IconButton(
              icon: const Icon(Icons.call, color: Colors.green, size: 30),
              onPressed: () {
                if (barangayContact != null) {
                  _makePhoneCallWithFeedback(context, barangayContact!);
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _makePhoneCallWithFeedback(BuildContext context, String phoneNumber) async {
    final Uri launchUri = Uri(
      scheme: 'tel',
      path: phoneNumber,
    );
    if (await canLaunchUrl(launchUri)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Calling $phoneNumber...'),
          duration: const Duration(seconds: 2),
        ),
      );
      await launchUrl(launchUri);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Could not place call to $phoneNumber.'),
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }
}
