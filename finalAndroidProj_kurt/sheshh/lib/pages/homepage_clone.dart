// home_pageClone.dart
import 'package:flutter/material.dart';
import 'package:sheshh/pages/home_content_clone.dart';
import 'community_page.dart';
import 'settings_screen.dart';
import 'logout_sample.dart';
import 'buttons/event_tracker_screen.dart';
import 'package:sheshh/pages/hotlines_page.dart';
import 'package:sheshh/pages/profile_page.dart';
import 'package:sheshh/pages/login.dart';
import 'package:sheshh/pages/register.dart';


class HomepageClone extends StatefulWidget {
  const HomepageClone({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomepageClone> {
  int _selectedIndex = 1;
  bool _isUnderlined = false; // Variable to track if text should be underlined
  static const List<Widget> _pages = <Widget>[
    LoginPage(),
    HomeContentClone(),
    SettingsPage(),

  ];

  void _onItemTapped(int index) {
    setState(() {
      if (index == 0) { // Assuming index 0 is for LoginPage
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const LoginPage()),
        );
      } else {
        _selectedIndex = index; // Update the index for HomeContent and Settings
      }
    });
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
                  'CLICK TO REDIRECT TO LOGIN AND REGISTER',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Poppins',
                  ),
                ),
                const SizedBox(height: 10),

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
    ).then((_) {
      // After dialog is dismissed, remove underline
      setState(() {
        _isUnderlined = false;
      });
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Scrollbar(
        thumbVisibility: false,
        trackVisibility: false,
        thickness: 10.0,
        radius: const Radius.circular(10.0),
        scrollbarOrientation: ScrollbarOrientation.right,
        child: Theme(
          data: Theme.of(context).copyWith(
            scrollbarTheme: ScrollbarThemeData(
              thumbColor: MaterialStateProperty.all(Colors.lightGreen),
              trackColor: MaterialStateProperty.all(Colors.lightGreen),
              radius: const Radius.circular(10.0),
            ),
          ),
          child: CustomScrollView(
            slivers: <Widget>[
              SliverAppBar(
                expandedHeight: 150.0, // Adjust height to fit the search bar
                pinned: true,
                flexibleSpace: FlexibleSpaceBar(
                  background: Container(
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Color(0xFF035594), Color(0xFF4286f4)],
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          'KUMUSTA!',
                          style: TextStyle(
                            fontSize: 19,
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 10),
                        const Text(
                          'Welcome to our community!',
                          style: TextStyle(
                            fontSize: 16,
                            fontFamily: 'Poppins',
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 10), // Space between text and search bar
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(30.0),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.1),
                                  blurRadius: 10,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: const TextField(
                              decoration: InputDecoration(
                                hintText: 'Search...',
                                border: InputBorder.none,
                                contentPadding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 15.0),
                                suffixIcon: Icon(Icons.search, color: Colors.grey),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                // actions: [
                //   InkWell(
                //     onTap: () {
                //       Navigator.push(
                //         context,
                //         MaterialPageRoute(builder: (context) => const ProfilePage()),
                //       );
                //     },
                //     child: const CircleAvatar(
                //       radius:25,
                //       backgroundImage: NetworkImage(
                //         'https://hasitleaked.com/wp-content/uploads/2024/09/Screenshot-2024-09-13-at-12.24.56-316x320.png',
                //       ),
                //     ),
                //   ),
                //   const SizedBox(width:9),
                // ],
              ),

              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(1.0),
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Colors.blueAccent, Colors.lightBlue],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(30.0),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(10.5),
                  child: Text(
                    'Menu',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Poppins',
                      color: Colors.blueGrey[800],
                    ),
                  ),
                ),
              ),
              SliverFillRemaining(
                child: _selectedIndex == 0 ? const LoginPage() : _pages[_selectedIndex],
              ),
            ],
          ),
        ),
      ),
      drawer: Drawer(
        child: Stack(
          children: [
            Positioned.fill(
              child: Align(
                alignment: Alignment.topCenter,
                child: Container(
                  height: 150, // Adjust the height for better visibility
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('assets/mahal.jpg'),
                      fit: BoxFit.cover,
                      colorFilter: ColorFilter.mode(
                        Colors.black.withOpacity(0.5),
                        BlendMode.darken,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            ListView(
              padding: EdgeInsets.zero,
              children: <Widget>[
                DrawerHeader( // Removed const
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Color(0xFF035594), Colors.lightBlueAccent],
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                    ),
                  ),
                  child: Row(
                    children: [
                      const CircleAvatar(
                        backgroundImage: AssetImage('assets/profile_picture.jpg'),
                        radius: 40,
                      ),
                      const SizedBox(width: 20),
                    ],
                  ),
                ),
                // Adding the Text with GestureDetector
                GestureDetector(
                  onTap: () {
                    setState(() {
                      _isUnderlined = !_isUnderlined; // Toggle underline on tap
                    });
                    _showLoginDialog(context); // Call your dialog function here
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      'LOGIN OR SIGNUP TO ACCESS',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.blue,
                        decoration:
                        _isUnderlined ? TextDecoration.underline : TextDecoration.none, // Apply underline
                      ),
                    ),
                  ),
                ),
                // You can add other ListTiles for navigation below
              ],
            ),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.only(bottom: 0.0),
        child: ClipRRect(
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(30.0),
            topRight: Radius.circular(30.0),
            bottomLeft: Radius.circular(1.0),
            bottomRight: Radius.circular(1.0),
          ),
          child: Container(
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF035594), Color(0xFF4286f4)],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 8,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: NavigationBarTheme(
              data: NavigationBarThemeData(
                backgroundColor: Colors.transparent,
                indicatorColor: Colors.transparent,
                labelTextStyle: WidgetStateProperty.resolveWith<TextStyle?>((
                    Set<WidgetState> states) {
                  if (states.contains(WidgetState.selected)) {
                    return const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                      fontFamily: 'Poppins',
                    );
                  }
                  return const TextStyle(
                    color: Colors.white70,
                    fontSize: 12,
                  );
                }),
              ),
              child: NavigationBar(
                selectedIndex: _selectedIndex,
                onDestinationSelected: _onItemTapped,
                destinations: <NavigationDestination>[
                  NavigationDestination(
                    icon: Image.asset(
                      'assets/logout.png',
                      width: 24,
                      height: 24,
                      color: Colors.white,
                    ),
                    label: 'LOGIN',
                  ),
                  NavigationDestination(
                    icon: Image.asset(
                      'assets/lakbay_cavite_logo.png',
                      width: 40,
                      height: 40,
                    ),
                    label: 'Home',
                  ),
                  NavigationDestination(
                    icon: Image.asset(
                      'assets/setting.png',
                      width: 24,
                      height: 24,
                      color: Colors.white,
                    ),
                    label: 'Settings',
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      floatingActionButton: TweenAnimationBuilder<double>(
        tween: Tween<double>(begin: 1.0, end: 1.2),
        duration: const Duration(milliseconds: 600),
        curve: Curves.slowMiddle,
        builder: (context, scale, child) {
          return Transform.scale(
            scale: scale,
            child: FloatingActionButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const HotlinesPage()),
                );
              },
              backgroundColor: Colors.redAccent,
              child: const Icon(Icons.call, color: Colors.white),
            ),
          );
        },
      ),
    );
  }
}
