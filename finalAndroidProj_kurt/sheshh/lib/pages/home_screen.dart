// home_page.dart
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:sheshh/main.dart';
import 'package:sheshh/pages/home_content.dart';
import 'community_page.dart';
import 'login.dart';
import 'settings_screen.dart';
import 'logout_sample.dart';
import 'buttons/event_tracker_screen.dart';
import 'package:sheshh/pages/hotlines_page.dart';
import 'package:sheshh/pages/profile_page.dart';
import 'package:sheshh/pages/homepage_clone.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';
import 'package:sheshh/pages/buttons/theme_provider.dart';


class HomePage extends StatefulWidget {
  final String userKey;
  HomePage({Key? key, required this.userKey}) : super(key: key);


  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 1;
  bool isDarkMode = false;
  bool isNotificationsEnabled = true;
  String selectedLanguage = 'English';
  String? username;
  String? email;
  String? image;
  late List<Widget> _pages;

  @override
  void initState() {
    super.initState();
    _loadUserData();

    // Load user data when the widget initializes
    _pages = <Widget>[
      HomepageClone(),
      HomeContent(userKey: widget.userKey), // Accessing userKey from the widget
      SettingsPage(),
    ];
  }

  Future<void> _loadUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      username = prefs.getString('username');
      email = prefs.getString('email');
      image = prefs.getString('image') ?? ''; // Default to an empty string if not found
    });

    // Print the token


    // Optionally check for the default behavior if the image URL is empty
    if (image == null || image!.isEmpty) {
      // Handle the case when image is not found
      print("No image found, using default image.");
    }
  }

  void _onItemTapped(int index) {
    if (index == 0) { // Logout action
      _confirmLogout();
    } else if (index == 1) { // Home action
      setState(() {
        _selectedIndex = index; // Set to Home
      });
    } else if (index == 2) { // Profile action
      // Navigate to the Profile Page
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => ProfilePage(userKey: widget.userKey)),
      );
    }
  }

  void _confirmLogout() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Logout"),
          content: const Text("Are you sure you want to logout?"),
          actions: <Widget>[
            TextButton(
              child: const Text("Cancel"),
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
            ),
            TextButton(
              child: const Text("Logout"),
              onPressed: () {
                // Implement your logout logic here
                Navigator.of(context).pop(); // Close the dialog
                _navigatetoLoginScreenclone();
              },
            ),
          ],
        );
      },
    );
  }

  void _navigatetoLoginScreenclone() {
    // Clear user data on logout
    SharedPreferences.getInstance().then((prefs) {
      prefs.remove('userKey');

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomepageClone()),
      );// Remove the userKey from SharedPreferences
    });
  }

  Future<void> _selectLanguage(BuildContext context) async {
    final List<String> languages = ['English', 'Filipino', 'Spanish'];
    final String? result = await showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        return SimpleDialog(
          title: Text('Select Language'),
          children: languages.map((String language) {
            return SimpleDialogOption(
              onPressed: () {
                Navigator.pop(context, language);
              },
              child: Text(language),
            );
          }).toList(),
        );
      },
    );
    if (result != null && result != selectedLanguage) {
      setState(() {
        selectedLanguage = result;
      });
    }
  }

  void _showPrivacyPolicy() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            'Privacy Policy',
            style: TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.bold),
          ),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                SizedBox(height: 10),
                Text(
                  'Effective/Updated Date: October 01, 2024',
                  style: TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 10),
                Text(
                  'Lakbay Cavite (“we,” “our,” or “us”) respects your privacy and is committed to protecting your data. This Privacy Policy explains how we collect, use, and disclose information when you use the Lakbay Cavite mobile application (“App”).',
                  style: TextStyle(fontFamily: 'Poppins'),
                ),
                SizedBox(height: 20),
                Text(
                  'Information We Collect',
                  style: TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 5),
                Text(
                  'a. Personal Information\n-Account Data: When you sign up for an account, we collect your name, username, email address, and any other information you provide during registration.\n-User-Generated Content: When you post comments, routes, or recommendations, the content you share will be publicly visible along with your username.',
                  style: TextStyle(fontFamily: 'Poppins'),
                ),
                SizedBox(height: 10),
                Text(
                  'b. Non-Personal Information\n-Location Data: If you allow location tracking, we may collect your real-time location data to suggest nearby routes or services.\n-Usage Data: We collect information on how you interact with the App, including the features you use, pages you visit, and actions you take within the App.',
                  style: TextStyle(fontFamily: 'Poppins'),
                ),
                SizedBox(height: 10),
                Text(
                  'c. Device Information\n-We may collect information about the device you are using, including device type, operating system, and app performance data to improve user experience.',
                  style: TextStyle(fontFamily: 'Poppins'),
                ),
                SizedBox(height: 20),
                Text(
                  'How We Use Your Information',
                  style: TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 5),
                Text(
                  'We use the information we collect for the following purposes:\n-To Provide Services: Use your location to suggest relevant routes and transportation options.\n-To Personalize User Experience: Display personalized content based on your preferences and interactions.\n-To Communicate with You: Send updates, and notifications, or respond to your inquiries.\n-To Improve the App: Analyze usage data and feedback to enhance the functionality and user experience of the App.',
                  style: TextStyle(fontFamily: 'Poppins'),
                ),
                SizedBox(height: 20),
                Text(
                  'Sharing Your Information',
                  style: TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 5),
                Text(
                  'We do not sell your data. However, we may share information in the following situations:\n-Publicly Shared Content: Comments and recommendations you post, along with your username, will be visible to all users.\n-With Service Providers: We may share your data with third-party service providers who assist in operating the App under strict confidentiality agreements.\n-As Required by Law: If legally required, we may disclose your information to comply with legal processes or to protect the rights, property, and safety of Lakbay Cavite and its users.',
                  style: TextStyle(fontFamily: 'Poppins'),
                ),
                SizedBox(height: 20),
                Text(
                  'Your Choices',
                  style: TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 5),
                Text(
                  'You have control over your information and can exercise the following rights:\n-Account Settings: You can update your personal information or delete your account through the settings menu.\n-Location Sharing: You can enable or disable location services at any time in your device’s settings.\n-Deleting Data: You may request the deletion of your data by contacting us at lakbaycavite@gmail.com.',
                  style: TextStyle(fontFamily: 'Poppins'),
                ),
                SizedBox(height: 20),
                Text(
                  'Data Security',
                  style: TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 5),
                Text(
                  'We take reasonable measures to protect your information from unauthorized access, use, or disclosure. However, no security measures are entirely foolproof, and we cannot guarantee the absolute security of your data.',
                  style: TextStyle(fontFamily: 'Poppins'),
                ),
                SizedBox(height: 20),
                Text(
                  'Data Retention',
                  style: TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 5),
                Text(
                  'We will retain your data for as long as your account is active or as necessary to provide you with services. We may also retain data to comply with legal obligations, resolve disputes, or enforce agreements.',
                  style: TextStyle(fontFamily: 'Poppins'),
                ),
                SizedBox(height: 20),
                Text(
                  'Children’s Privacy',
                  style: TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 5),
                Text(
                  'Lakbay Cavite is not intended for children under the age of 16. We do not knowingly collect personal information from children. If we become aware that we have inadvertently collected data from a child, we will take steps to delete such information.',
                  style: TextStyle(fontFamily: 'Poppins'),
                ),
                SizedBox(height: 20),
                Text(
                  'Changes to this Policy',
                  style: TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 5),
                Text(
                  'We may update this Privacy Policy from time to time. Any changes will be communicated to you through the App or by other means. Continued use of the App following any modifications signifies your acceptance of the updated terms.',
                  style: TextStyle(fontFamily: 'Poppins'),
                ),
                SizedBox(height: 20),
                Text(
                  'Contact Us',
                  style: TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 5),
                Text(
                  'If you have any questions or concerns about this Privacy Policy or your data, please contact us at:\nEmail: lakbaycavite@gmail.com\nPhone: 09661834946',
                  style: TextStyle(fontFamily: 'Poppins'),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              child: const Text('Close', style: TextStyle(fontFamily: 'Poppins')),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _showTermsAndConditions() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            'Terms and Conditions',
            style: TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.bold),
          ),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                SizedBox(height: 10),
                Text(
                  'Acceptance of Terms',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 5),
                Text(
                  'By using Lakbay Cavite, you agree to comply with these terms and conditions.',
                  style: TextStyle(fontFamily: 'Poppins'),
                ),
                SizedBox(height: 15),
                Text(
                  'User Responsibility',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 5),
                Text(
                  'Users must exercise caution while using the app. Please don\'t rely solely on the navigation application, and always stay aware of your surroundings. Lakbay Cavite is a tool for guidance and not a replacement for real-time navigation tools or human judgment.',
                  style: TextStyle(fontFamily: 'Poppins'),
                ),
                SizedBox(height: 15),
                Text(
                  'Comments and Recommendations',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 5),
                Text(
                  'Users can post comments recommending routes and transportation options. By posting, you agree that your username will be publicly displayed alongside your comments.',
                  style: TextStyle(fontFamily: 'Poppins'),
                ),
                SizedBox(height: 15),
                Text(
                  'User Conduct',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 5),
                Text(
                  'Comments must be respectful and relevant. Any offensive or inappropriate content may lead to filtering or removal and potential account suspension.',
                  style: TextStyle(fontFamily: 'Poppins'),
                ),
                SizedBox(height: 15),
                Text(
                  'Liability Disclaimer',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 5),
                Text(
                  'Lakbay Cavite is not responsible for any consequences arising from the use of suggested routes or user information.',
                  style: TextStyle(fontFamily: 'Poppins'),
                ),
                SizedBox(height: 15),
                Text(
                  'Modifications',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 5),
                Text(
                  'We reserve the right to modify these terms at any time. Continued use of the application signifies acceptance of any changes.',
                  style: TextStyle(fontFamily: 'Poppins'),
                ),
                SizedBox(height: 15),
                Text(
                  'Governing Law',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 5),
                Text(
                  'These terms shall be governed by the laws of Imus, Cavite.',
                  style: TextStyle(fontFamily: 'Poppins'),
                ),
                SizedBox(height: 15),
                Text(
                  'Contact Information',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 5),
                Text(
                  'For more information, please contact us at @09661834946 @lakbaycavite.gmail',
                  style: TextStyle(fontFamily: 'Poppins'),
                ),
                SizedBox(height: 15),
                Text(
                  'By using this application, you confirm your understanding and acceptance of these terms.',
                  style: TextStyle(fontFamily: 'Poppins'),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              child: const Text('Close', style: TextStyle(fontFamily: 'Poppins')),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
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
                        Text(
                          'KAMUSTA ${username ?? "Guest"}!',
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
                child: _pages[_selectedIndex],
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
                  height: 20,
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
              children: [
                 DrawerHeader(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Color(0xFF035594), Colors.lightBlueAccent],
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                    ),
                  ),
                  child: Row(
                    children: [
                      CircleAvatar(
                        backgroundImage: (image != null && image!.isNotEmpty)
                            ? AssetImage(image!) // Use your image variable
                            : AssetImage('assets/avatar2.png'), // Provide a default image
                        radius: 40,
                      ),
                      SizedBox(width: 20),
                      Text(
                        '${username ?? "Guest"}',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                // Enable Dark Mode Toggle
                SwitchListTile(
                  title: const Text('Enable Dark Mode'),
                  value: Provider.of<ThemeProvider>(context).isDarkMode, // Use the ThemeProvider
                  onChanged: (bool value) {
                    Provider.of<ThemeProvider>(context, listen: false).toggleTheme(); // Toggle theme
                  },
                  secondary: Icon(isDarkMode ? Icons.dark_mode : Icons.light_mode),
                ),
                const Divider(),

                // Enable Notifications Toggle
                SwitchListTile(
                  title: const Text('Enable Notifications'),
                  value: isNotificationsEnabled, // Set this variable in your state
                  onChanged: (bool value) {
                    setState(() {
                      isNotificationsEnabled = value;
                      // Add your logic for notifications
                    });
                  },
                  secondary: Icon(isNotificationsEnabled ? Icons.notifications : Icons.notifications_off),
                ),
                const Divider(),

                // Language Setting
                ListTile(
                  title: const Text('Language'),
                  subtitle: const Text('English'), // Replace with selected language
                  leading: const Icon(Icons.language),
                  onTap: () {
                    _selectLanguage(context); // Function to open language selection dialog
                  },
                ),
                const Divider(),

                // Privacy Policy
                ListTile(
                  title: const Text('Privacy Policy'),
                  leading: const Icon(Icons.privacy_tip),
                  onTap: () {
                    _showPrivacyPolicy(); // Function to show privacy policy dialog
                  },
                ),
                const Divider(),

                // Terms and Conditions
                ListTile(
                  title: const Text('Terms and Conditions'),
                  leading: const Icon(Icons.description),
                  onTap: () {
                    _showTermsAndConditions(); // Function to show terms dialog
                  },
                ),
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

                    label: 'Logout',

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
                      icon: CircleAvatar(
                        radius: 17,
                        backgroundImage: (image != null && image!.isNotEmpty)
                            ? (image!.startsWith('http://') || image!.startsWith('https://'))
                            ? NetworkImage(image!) // Load from network
                            : FileImage(File(image!)) // Load from file if it's a local path
                            : AssetImage('assets/avatar2.png') as ImageProvider, // Default image if not set
                      ),

                    label: 'Profile',
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
