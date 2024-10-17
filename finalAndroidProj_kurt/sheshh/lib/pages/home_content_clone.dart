import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:sheshh/pages/community_page.dart';
import 'package:sheshh/pages/maps_page.dart';
import 'package:sheshh/pages/terminals_page.dart';
import 'package:sheshh/pages/hospitals_page.dart';
import 'package:sheshh/pages/gasstation_page.dart';
import 'package:sheshh/pages/login.dart';
import 'package:sheshh/pages/register.dart';

class HomeContentClone extends StatefulWidget {
  const HomeContentClone({Key? key}) : super(key: key);

  @override
  _HomeContentCloneState createState() => _HomeContentCloneState();
}

class _HomeContentCloneState extends State<HomeContentClone> {
  int? _longPressedButtonIndex; // Track which button is long-pressed

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(2.0),
      child: Card(
        elevation: 15,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
        ),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(5.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                buildModernButton(
                  context,
                  'assets/image1.jpg',
                  'Maps',
                  const MapPage(),
                  Icons.map,
                  0,
                  isNavigating: true,
                ),
                buildModernButton(
                  context,
                  'assets/image2.jpg',
                  'Community',
                  const CommunityPage(),
                  Icons.people,
                  1,
                ),
                buildModernButton(
                  context,
                  'assets/image3.jpg',
                  'Terminals',
                  const TricycleTerminalsPage(),
                  Icons.directions_bus,
                  2,
                ),
                buildModernButton(
                  context,
                  'assets/image4.jpg',
                  'Hospitals',
                  const HospitalsPage(),
                  Icons.local_hospital,
                  3,
                ),
                buildModernButton(
                  context,
                  'assets/image5.jpg',
                  'Gas Stations',
                  const GasStationsPage(),
                  Icons.local_gas_station,
                  4,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildModernButton(
      BuildContext context,
      String imagePath,
      String label,
      Widget destination,
      IconData icon,
      int index, {
        bool isNavigating = false, // Flag to indicate if navigation is allowed
      }) {
    bool isPressed = _longPressedButtonIndex == index;

    return GestureDetector(
      onLongPressStart: (_) {
        setState(() => _longPressedButtonIndex = index);
      },
      onLongPressEnd: (_) {
        setState(() => _longPressedButtonIndex = null);
      },
      onTap: () {
        if (isNavigating) {
          // Navigate to the MapPage directly
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => destination),
          );
        } else {
          // Show login dialog for other buttons
          _showLoginDialog(context);
        }
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        margin: const EdgeInsets.symmetric(vertical: 10),
        height: 150,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15.0),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.shade400,
              offset: const Offset(0, 6),
              blurRadius: 10,
            ),
          ],
        ),
        child: Stack(
          children: [
            // Background image
            ClipRRect(
              borderRadius: BorderRadius.circular(15.0),
              child: Image.asset(
                imagePath,
                height: 150,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
            // Blue background
            Container(
              height: 150,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15.0),
                gradient: LinearGradient(
                  colors: [
                Colors.blue.withOpacity(0.8), // Retaining the blue background
                  Colors.transparent,
                  ],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                ),
              ),
            ),
            // Blue blur background only for the long-pressed button
            if (isPressed)
              BackdropFilter(
                filter: ImageFilter.blur(
                  sigmaX: 8,
                  sigmaY: 8,
                ),
                child: Container(
                  height: 150,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15.0),
                    color: Colors.blue.withOpacity(0.4), // Slightly transparent blue
                  ),
                ),
              ),
            // Icon and text animation
            AnimatedAlign(
              duration: const Duration(milliseconds: 300),
              alignment: isPressed ? Alignment.center : Alignment.centerLeft,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15.0),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Icon(icon, size: 30, color: Colors.white),
                    const SizedBox(width: 10),
                    Text(
                      label,
                      style: const TextStyle(
                        fontSize: 20,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showLoginDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
          backgroundColor: Colors.transparent,
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: const Color(0xFF035594), // Background color
              borderRadius: BorderRadius.circular(20.0),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Access Restricted',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Poppins',
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  'You need to sign up or log in to use this feature.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 16,
                    fontFamily: 'Poppins',
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    // Login Button
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white, // Button background color
                        foregroundColor: const Color(0xFF035594), // Button text color
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                      ),
                      onPressed: () {
                        Navigator.of(context).pop(); // Close the dialog
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const LoginPage()),
                        ); // Navigate to the Login Page
                      },
                      child: const Text(
                        'Login',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Poppins',
                        ),
                      ),
                    ),

                    // Register Button
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white, // Button background color
                        foregroundColor: const Color(0xFF035594), // Button text color
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                      ),
                      onPressed: () {
                        Navigator.of(context).pop(); // Close the dialog
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const RegisterPage()),
                        ); // Navigate to the Register Page
                      },
                      child: const Text(
                        'Register',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Poppins',
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(); // Close the dialog
                  },
                  child: const Text(
                    'Cancel',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontFamily: 'Poppins',
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}