import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sheshh/pages/update.dart';
import 'package:crypto/crypto.dart';
import 'dart:convert';
import 'dart:io';
import 'package:sheshh/pages/backend/api.dart';

class ProfilePage extends StatefulWidget {
  final String? userKey;

  ProfilePage({Key? key, required this.userKey}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  TextEditingController usernameController = TextEditingController();
  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController ageController = TextEditingController();
  String email = '';
  String gender = 'Male';
  String _selectedAvatar = '';
  final authService = AuthService();
  List<dynamic> bookmarks = [];
  int? _tappedIndex;
  @override
  void initState() {
    super.initState();
    _loadUserProfile();
    _loadBookmarks();
  }

  Future<void> _loadBookmarks() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString(
        'token');

    print('Loaded token: $token');

    if (token != null) {
      try {
        List<dynamic> fetchedBookmarks = await authService.getBookmarks(token);
        print(
            'Fetched bookmarks: $fetchedBookmarks');
        setState(() {
          bookmarks = fetchedBookmarks;
        });
      } catch (error) {
        print('Error fetching bookmarks: $error');
      }
    } else {
      print('No token found');
    }
  }

  Future<void> _deleteBookmark(String bookmarkId, int index) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    if (token != null) {
      print('Deleting bookmark with ID: $bookmarkId');
      try {

        setState(() {
          bookmarks.removeAt(index);
        });


        await authService.deleteBookmark(token, bookmarkId);


        await _loadBookmarks();

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Bookmark deleted successfully!')),
        );
      } catch (error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to delete bookmark: $error')),
        );
      }
    }
  }
  Future<void> _loadUserProfile() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    setState(() {
      usernameController.text = prefs.getString('username') ?? '';
      email = prefs.getString('email') ?? '';
      firstNameController.text = prefs.getString('firstName') ?? '';
      lastNameController.text = prefs.getString('lastName') ?? '';
      ageController.text = prefs.getInt('age')?.toString() ?? '';
      gender = prefs.getString('gender') ?? 'Male';
      _selectedAvatar = prefs.getString('image') ?? '';
    });
  }

  void _navigateToUpdateProfile(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => UpdateProfileScreen(userKey: widget.userKey!),
      ),
    );
  }


  String _hashEmail(String email) {
    // Split email into parts
    List<String> parts = email.split('@');
    if (parts.length < 2)
      return email;

    String localPart = parts[0];
    String domainPart = parts[1];

    // Hash the middle part (e.g., "localPart[1:-1]")
    String hashedLocalPart = localPart[0] +
        '*' * (localPart.length - 2) +
        localPart[localPart.length - 1];

    return '$hashedLocalPart@$domainPart';
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          title: const Row(
            children: [
              Icon(Icons.person, color: Colors.white, size: 30),
              SizedBox(width: 8),
              Text(
                'PROFILE',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.bold,
                  fontSize: 24,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          flexibleSpace: FlexibleSpaceBar(
            background: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFF4286f4), Color(0xFF035594)],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
            ),
          ),
          centerTitle: true,
          elevation: 4,
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              _buildProfileCard(),
              const SizedBox(height: 20),
              _buildBookmarks(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProfileCard() {
    String fullName = '${firstNameController.text} ${lastNameController.text}';
    String hashedEmail = _hashEmail(email);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            CircleAvatar(
              radius: 30,
              backgroundImage: _selectedAvatar.isNotEmpty
                  ? NetworkImage(_selectedAvatar)
                  : AssetImage(
                   'assets/avatar1.png') as ImageProvider,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    usernameController.text,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  Text(
                    fullName,
                    style: const TextStyle(fontSize: 12),
                  ),
                  Text(
                    hashedEmail,
                    style: const TextStyle(fontSize: 12),
                  ),
                ],
              ),
            ),
        Column(
          mainAxisAlignment: MainAxisAlignment.center, // Center vertically
          children: [
            Icon(
              gender == 'Male' ? Icons.male : Icons.female,
              size: 32, // Gender icon
            ),
            const SizedBox(height: 8), // Add spacing between the icon and button
            IconButton(
              icon: const Icon(Icons.edit, color: Colors.green), // Customize color
              onPressed: () {
                _navigateToUpdateProfile(context);
              },
            ),
          ],
        ),
        ],
      ),
      ),
    );

  }


  Widget _buildBookmarks() {
    print('Building bookmarks UI with ${bookmarks.length} bookmarks');
    return bookmarks.isEmpty
        ? const Center(child: Text('No bookmarks found'))
        : ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: bookmarks.length,
      itemBuilder: (context, index) {
        final bookmark = bookmarks[index];

        final profileName = bookmark['profileName'] ?? 'Unknown User';
        final imageUrl = bookmark['imageUrl']; // can be null
        final content = bookmark['content'] ?? 'No Content';
        final createdAt = bookmark['createdAt'];

        DateTime? dateTime;
        String? formattedDate;
        if (createdAt != null) {
          dateTime = DateTime.tryParse(createdAt);
          if (dateTime != null) {
            formattedDate = "${dateTime.day.toString().padLeft(2, '0')}/"
                "${dateTime.month.toString().padLeft(2, '0')}/"
                "${dateTime.year} ${dateTime.hour.toString().padLeft(2, '0')}:"
                "${dateTime.minute.toString().padLeft(2, '0')}";
          }
        }

        // Determine background color based on tapped state
        final isTapped = _tappedIndex == index;

        return Card(
          margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
          child: ListTile(
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  profileName,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                if (imageUrl != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 4.0),
                    child: Image.network(
                      imageUrl,
                      width: 50,
                      height: 50,
                      fit: BoxFit.cover,
                    ),
                  ),
              ],
            ),
            subtitle: GestureDetector(
              onTap: () async {
                setState(() {
                  _tappedIndex = isTapped ? null : index; // Toggle tapped state
                });

                // Show the full content dialog
                await _showFullContentDialog(context, content, bookmark['comments'] ?? []);

                // Reset the tapped index when dialog is closed
                setState(() {
                  _tappedIndex = null; // Reset the background color
                });
              },
              child: Container(
                color: isTapped ? Colors.grey[300] : Colors.transparent, // Change background color
                padding: const EdgeInsets.all(8.0), // Add some padding
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 4.0),
                      child: Text(
                        content.length > 15 ? '${content.substring(0, 15)}...' : content,
                        style: const TextStyle(color: Colors.black),
                      ),
                    ),
                    const SizedBox(height: 4),
                    if (formattedDate != null)
                      Text(
                        '$formattedDate',
                        style: const TextStyle(color: Colors.grey),
                      ),
                  ],
                ),
              ),
            ),
            trailing: InkWell(
              onTap: () {
                _showDeleteDialog(context, bookmark['_id'], index);
              },
              customBorder: const CircleBorder(),
              child: Ink(
                decoration: const ShapeDecoration(
                  shape: CircleBorder(),
                ),
                child: const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Icon(Icons.delete, color: Colors.green),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Future<void> _showFullContentDialog(BuildContext context, String content, List comments) {
    return showDialog(
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
                  'Content of the Post',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Poppins',
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  content,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 16,
                    fontFamily: 'Poppins',
                  ),
                ),
                const SizedBox(height: 20),
                // Add a comments section if needed
                if (comments.isNotEmpty) ...[
                  const Text(
                    'Comments:',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  ...comments.map((comment) => Padding(
                    padding: const EdgeInsets.only(bottom: 5.0),
                    child: Text(
                      comment,
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 14,
                        fontFamily: 'Poppins',
                      ),
                    ),
                  )).toList(),
                  const SizedBox(height: 20),
                ],
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(); // Close the dialog
                  },
                  child: const Text(
                    'Close',
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
  void _showDeleteDialog(BuildContext context, String bookmarkId, int index) {
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
                  'DELETE',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Poppins',
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  'Are you sure you want to delete your saved guide from the community?',
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
                    // No Button
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
                      },
                      child: const Text(
                        'No',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Poppins',
                        ),
                      ),
                    ),

                    // Yes Button
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white, // Button background color
                        foregroundColor: const Color(0xFF035594), // Button text color
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                      ),
                      onPressed: () async {
                        Navigator.of(context).pop(); // Close the dialog
                        await _deleteBookmark(bookmarkId, index); // Perform delete action
                      },
                      child: const Text(
                        'Yes',
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

              ],
            ),
          ),
        );
      },
    );
  }

}


