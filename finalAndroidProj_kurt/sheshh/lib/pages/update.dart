import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sheshh/pages/backend/api.dart';
import 'package:sheshh/pages/home_screen.dart';

class UpdateProfileScreen extends StatefulWidget {
  final String userKey;
  const UpdateProfileScreen({Key? key, required this.userKey}) : super(key: key);

  @override
  _UpdateProfileScreenState createState() => _UpdateProfileScreenState();
}

class _UpdateProfileScreenState extends State<UpdateProfileScreen> {
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController ageController = TextEditingController();
  final TextEditingController usernameController = TextEditingController();

  String? username = '';
  String? email = '';
  String? gender = 'Male';
  String _selectedAvatar = '';
  File? _imageFile;
  final AuthService _authService = AuthService();
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _loadUserProfile();
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

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
        _selectedAvatar = '';
      });
    }
  }

  void _selectAvatar(String avatar) {
    setState(() {
      _selectedAvatar = avatar;
      _imageFile = null;
    });
  }

  Future<void> _updateProfile() async {
    final result = await _authService.updateUserProfile(
      token: widget.userKey,
      firstName: firstNameController.text.isEmpty ? null : firstNameController.text,
      lastName: lastNameController.text.isEmpty ? null : lastNameController.text,
      age: ageController.text.isEmpty ? null : int.tryParse(ageController.text),
      gender: gender,
      username: usernameController.text.isEmpty ? null : usernameController.text,
      image: _selectedAvatar.isNotEmpty
          ? _selectedAvatar
          : _imageFile != null
          ? _imageFile!.path
          : '',
    );

    print('Response from API: $result');

    if (result['success'] == true) {

      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString('firstName', firstNameController.text);
      prefs.setString('lastName', lastNameController.text);
      prefs.setString('username', usernameController.text);
      prefs.setInt('age', int.parse(ageController.text));
      prefs.setString('gender', gender ?? 'Male');
      prefs.setString('image',
          _selectedAvatar.isNotEmpty ? _selectedAvatar : _imageFile?.path ?? '');


      await _loadUserProfile();


      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Profile Updated Successfully')),
      );

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => HomePage(userKey: widget.userKey),
        ),
      );
    } else {

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to update profile')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
              'UPDATE PROFILE',
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
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              const SizedBox(height: 10),
              TextField(
                controller: firstNameController,
                decoration: InputDecoration(labelText: 'First Name'),
              ),
              TextField(
                controller: lastNameController,
                decoration: InputDecoration(labelText: 'Last Name'),
              ),
              TextField(
                controller: usernameController,
                decoration: InputDecoration(labelText: 'Username'),
              ),
              TextField(
                controller: ageController,
                decoration: InputDecoration(labelText: 'Age'),
                keyboardType: TextInputType.number,
              ),
              // Continue with the rest of your fields and widgets...

              Row(
                children: [
                  Expanded(
                    child: RadioListTile<String>(
                      title: Text('Male'),
                      value: 'Male',
                      groupValue: gender,
                      onChanged: (value) {
                        setState(() {
                          gender = value!;
                        });
                      },
                    ),
                  ),
                  Expanded(
                    child: RadioListTile<String>(
                      title: Text('Female'),
                      value: 'Female',
                      groupValue: gender,
                      onChanged: (value) {
                        setState(() {
                          gender = value!;
                        });
                      },
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 20),

              // Center the profile image
              Center(
                child: _buildProfileImage(),
              ),

              const SizedBox(height: 20),

              // Center the Upload Image button
              Center(
                child: ElevatedButton(
                  onPressed: _pickImage,
                  child: Text('Upload Image'),
                ),
              ),

              const SizedBox(height: 20),
              Text('Choose a Default Avatar'),
              Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: () => _selectAvatar('assets/avatar1.png'),
                      child: CircleAvatar(
                        radius: 30,
                        backgroundImage: AssetImage('assets/avatar1.png'),
                      ),
                    ),
                    const SizedBox(width: 10), // Add space between avatars
                    GestureDetector(
                      onTap: () => _selectAvatar('assets/avatar2.png'),
                      child: CircleAvatar(
                        radius: 30,
                        backgroundImage: AssetImage('assets/avatar2.png'),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // Center the Update Profile button
              Center(
                child: ElevatedButton(
                  onPressed: _updateProfile,
                  child: Text('Update Profile'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProfileImage() {
    if (_imageFile != null) {
      try {
        return CircleAvatar(
          radius: 50,
          backgroundImage: FileImage(
              _imageFile!),
        );
      } catch (e) {
        print("Error loading image: $e");
        return CircleAvatar(
          radius: 50,
          child: Icon(Icons.error),
        );
      }
    } else if (_selectedAvatar.isNotEmpty) {
      return CircleAvatar(
        radius: 50,
        backgroundImage: AssetImage(
            _selectedAvatar),
      );
    } else {
      return CircleAvatar(
        radius: 50,
        child: Icon(Icons.person),
      );
    }
  }
}
