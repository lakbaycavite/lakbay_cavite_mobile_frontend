import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'buttons/comment_model.dart';
import 'buttons/event_tracker_screen.dart';
import 'buttons/btn_community_event_model.dart';
import 'package:sheshh/pages/backend/api.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'buttons/post_model.dart';
import 'package:sheshh/pages/chatbot_page.dart';

class CommunityPage extends StatefulWidget {
  final String? userKey;

  const CommunityPage({Key? key, this.userKey}) : super(key: key);


  @override
  _CommunityPageState createState() => _CommunityPageState();
}

class _CommunityPageState extends State<CommunityPage> with WidgetsBindingObserver {
  final List<Post> _posts = [];
  final TextEditingController _postController = TextEditingController();
  final TextEditingController _commentController = TextEditingController();
  File? _selectedImage;
  final ImagePicker _picker = ImagePicker();
  bool _isPostCreationVisible = false; // State variable to control visibility
  String? username;
  String? email;
  String? token;
  String? postId;



  bool _isCommentFieldVisibile = false;
  bool _areCommentsVisibile = false;
  List<Comment> _comments = [];

  final authService = AuthService();


  @override
  void initState() {
    super.initState();
    _loadUserData();
    _fetchPosts();
    WidgetsBinding.instance.addObserver(this);
  }


  // Add this _formatTimestamp method inside the class
  String _formatTimestamp(String timestamp) {
    DateTime postTime = DateTime.parse(timestamp);
    Duration difference = DateTime.now().difference(postTime);

    if (difference.inMinutes < 1) {
      return 'Just now';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h ago';
    } else if (difference.inDays == 1) {
      return 'Yesterday';
    } else if (difference.inDays < 7) {
      return '${difference.inDays}d ago';
    } else {
      return '${postTime.day}/${postTime.month}/${postTime.year}';
    }
  }


  // Method to toggle the visibility of the post creation section
  void _togglePostCreation() {
    setState(() {
      _isPostCreationVisible = !_isPostCreationVisible;
    });
  }


  Future<void> _loadUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      token = prefs.getString('token');
      username = prefs.getString('username');
      email = prefs.getString('email');
    });

    print("Username: $username");
    print("Token: $token");// Debugging line
  }

  Future<void> _bookmarked(String postId) async {
    try {
      // Load SharedPreferences and get the token
      SharedPreferences prefs = await SharedPreferences.getInstance();
      token = prefs.getString('token');

      print("Token: $token");
      print("Post ID Bookmarking: $postId"); // Print the passed postId directly

      if (token != null && postId != null) {
        // Use the token and postId to add the bookmark
        final result = await authService.addBookmark(token!, postId);
        print('Bookmark added successfully for post ID: $postId, Result: $result');
      } else {
        print('Token or postId is missing, cannot add bookmark.');
      }
    } catch (error) {
      print('Failed to add bookmark: $error'); // Handle errors here
    }
  }
  // Method to add a post
  Future<void> _submitPost() async {
    final request = http.MultipartRequest('POST', Uri.parse('http://192.168.2.54:5000/posts'));
    request.fields['content'] = _postController.text;
    request.fields['profileName'] = '$username';  // Change to dynamic user profile

    if (_selectedImage != null) {
      request.files.add(
        await http.MultipartFile.fromPath(
          'image',
          _selectedImage!.path,
          contentType: MediaType('image', 'jpeg'), // or 'png'
        ),
      );
    }

    final response = await request.send();

    if (response.statusCode == 201) {
      final responseBody = await response.stream.bytesToString();
      print('Post created successfully: $responseBody');

      final postData = json.decode(responseBody);
      final postId = postData['id'];


      // Optionally, add the new post to your local list or state
      _posts.add(Post(
        content: postData['content'],
        profileName: postData['profileName'],
        imageUrl: postData['imageUrl'],  // Ensure this is set in the backend
        id: postId,
        comments: [],  // Initialize comments if needed
      ));

      _fetchPosts();
    } else {
      final responseBody = await response.stream.bytesToString();
      print('Failed to create post: ${response.statusCode} - $responseBody');
    }
  }

  // Method to fetch posts
  Future<void> _fetchPosts() async {
    final response = await http.get(Uri.parse('http://192.168.2.54:5000/posts'));  // Update IP if necessary

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      setState(() {
        _posts.clear();
        data.forEach((post) {
          // Parse the comments
          List<dynamic> commentsData = post['comments'] ?? [];  // Ensure comments field exists
          List<Comment> commentsList = commentsData.map((comment) {
            return Comment(
              comment: comment['comment'] ?? '',
              username: comment['username'] ?? '',
              createdAt: comment['createdAt'] ?? '', text: '',
            );
          }).toList();
          print('Post ID: ${post['id']}');
          _posts.add(Post(
            content: post['content'] ?? '',  // Provide default value if null
            imageUrl: post['imageUrl'] ?? '', // Ensure key name matches API response
            profileName: post['profileName'] ?? '',
            id: post['id'] ?? '',
            comments: commentsList,  // Add comments list here
          ));
        });
      });

    } else {
      print('Failed to fetch posts: ${response.statusCode}');
    }
  }

  // Method to add a comment
  Future<Map<String, dynamic>?> _addComment(String postId, String comment) async {
    if (comment.isNotEmpty) {
      final response = await http.post(
        Uri.parse('http://192.168.2.54:5000/posts/$postId/comments'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'comment': comment,
          'username': username,
        }),
      );

      if (response.statusCode == 201) {
        return jsonDecode(response.body); // Return the response
      } else {
        print('Failed to add comment: ${response.statusCode}');
        return null; // Return null on failure
      }
    }

    print('Comment is empty'); // For debugging
    return null; // Return null if the text field is empty
  }

  // Method to pick an image from the gallery
  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
      });
    }
  }


  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.resumed) {
      _fetchPosts(); // Fetch posts when the app comes back to the foreground
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _postController.dispose();
    _commentController.dispose();
    super.dispose();
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar(
      title: const Row(
        children: [
          Icon(Icons.chat, color: Colors.white, size: 30),
          SizedBox(width: 8),
          Text('COMMUNITY', style: TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.bold, fontSize: 24, color: Colors.white)),
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
      actions: [
        Padding(
          padding: const EdgeInsets.all(1.20),
          child: SizedBox(
            width: 90,
            height: 90,
            child: Image.asset('assets/lakbay_cavite_logo.png'),
          ),
        ),
      ],
    ),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: _posts.length,
                    itemBuilder: (context, index) {
                      final reversedIndex = _posts.length - 1 - index;
                      return Card(
                        margin: const EdgeInsets.symmetric(vertical: 10),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 2,
                        color: Colors.white,
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  CircleAvatar(
                                    radius: 20,
                                    backgroundImage: _posts[reversedIndex].profileImage != null
                                        ? NetworkImage(_posts[reversedIndex].profileImage! as String)
                                        : const AssetImage('assets/basil.jpg') as ImageProvider,
                                  ),
                                  const SizedBox(width: 10),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        _posts[reversedIndex].profileName,
                                        style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black,
                                        ),
                                      ),
                                      Text(
                                        '2 Hours ago', //replace this with the timestamp
                                        style: const TextStyle(
                                            fontSize: 12,
                                            color: Colors.grey
                                        ),
                                      )
                                    ],
                                  ),

                                ],
                              ),

                              const SizedBox(height: 10),
                              Text(
                                _posts[reversedIndex].content,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w400,
                                  color: Colors.black87,
                                ),
                              ),

                              const SizedBox(height: 10),
                              //post image
                              if (_posts[reversedIndex].imageUrl != null)
                                Container(
                                  margin: const EdgeInsets.only(bottom: 10),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(8),
                                    child: Image.network(
                                      _posts[reversedIndex].imageUrl!,
                                      height: 250,
                                      fit: BoxFit.cover,
                                      loadingBuilder: (context, child, progress) {
                                        if (progress == null) {
                                          return child;
                                        } else {
                                          return const Center(child: CircularProgressIndicator());
                                        }
                                      },
                                      errorBuilder: (context, error, stackTrace) {
                                        return const Center(
                                          child: Text('Image not available', style: TextStyle(color: Colors.grey)),
                                        );
                                      },
                                    ),
                                  ),
                                ),
                              //Like, comment icons row
                              Row(
                                children: [

                                  IconButton(
                                    icon: Icon(
                                      _posts[reversedIndex].liked ? Icons.favorite:Icons.favorite_border,
                                      color: _posts[reversedIndex].liked ? Colors.red : Colors.grey,
                                    ),
                                    onPressed: (){
                                      setState((){
                                        _posts[reversedIndex].liked = !_posts[reversedIndex].liked;
                                      });
                                    },
                                  ),
                                  IconButton(
                                    icon: Icon(Icons.comment_outlined, color: Colors.grey),
                                    onPressed: () {
                                      setState(() {
                                        _isCommentFieldVisibile = !_isCommentFieldVisibile;
                                      });
                                    },
                                  ),

                                  IconButton(
                                    icon: Icon(Icons.remove_red_eye, color: Colors.grey),
                                    onPressed: () {
                                      setState(() {
                                        _areCommentsVisibile = !_areCommentsVisibile; // Toggle visibility
                                      });
                                    },
                                  ),

                                  IconButton(
                                    icon: Icon(
                                      _posts[reversedIndex].bookmarked ? Icons.bookmark : Icons.bookmark_border,
                                      color: _posts[reversedIndex].bookmarked ? Colors.yellow : Colors.grey,
                                    ),
                                    onPressed: () async {
                                      setState(() {
                                        // Toggle the bookmarked state
                                        _posts[reversedIndex].bookmarked = !_posts[reversedIndex].bookmarked;
                                      });

                                      // Instead of saving postId to SharedPreferences, call _bookmarked directly with the post ID
                                      await _bookmarked(_posts[reversedIndex].id); // Pass the post ID directly
                                    },
                                  ),
                                ],
                              ),
                              const Divider(
                                color: Colors.white,
                                height: 2,
                                thickness: 1,
                              ),

// Comment section
                              if (_posts[reversedIndex].comments.isNotEmpty)
                                GestureDetector(
                                  onTap: () {
                                    // Add functionality to show all comments
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(vertical: 5.0),
                                    child: Text(
                                      'View all ${_posts[reversedIndex].comments.length} comments',
                                      style: const TextStyle(
                                        color: Colors.grey,
                                        fontSize: 14,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                  ),
                                ),
                              const SizedBox(height: 15),
// Add comment field
                            if(_isCommentFieldVisibile)
                              Row(
                                children: [
                                  CircleAvatar(
                                    radius: 15,
                                    backgroundImage: const AssetImage('assets/basil.jpg'), // Replace with user profile image
                                  ),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: TextField(
                                      controller: _commentController,
                                      decoration: InputDecoration(
                                        hintText: 'Add a comment...',
                                        contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 15),
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(50),
                                          borderSide: BorderSide.none,
                                        ),
                                        filled: true,
                                        fillColor: Colors.grey[200],
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  GestureDetector(
                                    onTap: () async {
                                      final String commentText = _commentController.text.trim();
                                      if (commentText.isNotEmpty) {
                                        final newComment = Comment(
                                          username: '$username' ?? '',
                                          text: commentText,
                                          createdAt: DateTime.now().toIso8601String(),
                                          comment: commentText,
                                        );

                                        final response = await _addComment(_posts[reversedIndex].id, newComment.text);

                                        if (response != null) {
                                          setState(() {
                                            _posts[reversedIndex].comments.add(newComment);
                                          });

                                          _commentController.clear();
                                        }
                                      }
                                    },
                                    child: const Padding(
                                      padding: EdgeInsets.symmetric(horizontal: 8.0),
                                      child: Text(
                                        'Post',
                                        style: TextStyle(
                                          color: Colors.blue,
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),

// Display existing comments
                              if (_areCommentsVisibile && _posts[reversedIndex].comments.isNotEmpty)
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: _posts[reversedIndex].comments.map((comment) {
                                    return Padding(
                                      padding: const EdgeInsets.symmetric(vertical: 5.0),
                                      child: Row(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          CircleAvatar(
                                            radius: 15,
                                            backgroundImage: const AssetImage('assets/user_profile.jpg'), // Replace with commenter's profile image
                                          ),
                                          const SizedBox(width: 10),
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                RichText(
                                                  text: TextSpan(
                                                    children: [
                                                      TextSpan(
                                                        text: '${comment.username} ',
                                                        style: const TextStyle(
                                                          fontWeight: FontWeight.bold,
                                                          color: Colors.black,
                                                          fontSize: 14,
                                                        ),
                                                      ),
                                                      TextSpan(
                                                        text: comment.comment,
                                                        style: const TextStyle(
                                                          color: Colors.black87,
                                                          fontSize: 14,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                const SizedBox(height: 2),
                                                Text(
                                                  _formatTimestamp(comment.createdAt), // Add your own timestamp formatting logic
                                                  style: const TextStyle(
                                                    color: Colors.grey,
                                                    fontSize: 12,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  }).toList(),
                                ),

                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            bottom: 80.0,
            left: 16.0,
            right: 16.0,
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              child: _isPostCreationVisible
                  ? Container(
                key: const ValueKey('postCreationContainer'),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.green,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.3),
                      spreadRadius: 1,
                      blurRadius: 8,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      margin: const EdgeInsets.symmetric(vertical: 10),
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: TextField(
                        controller: _postController,
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          hintText: 'What\'s on your mind?',
                        ),
                      ),
                    ),
                    if (_selectedImage != null)
                      Container(
                        margin: const EdgeInsets.only(bottom: 10),
                        child: Image.file(
                          _selectedImage!,
                          height: 150,
                          fit: BoxFit.cover,
                        ),
                      ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.photo),
                          onPressed: _pickImage,
                        ),
                        ElevatedButton(
                          onPressed: _submitPost,
                          child: const Text('Post'),
                        ),
                      ],
                    ),
                  ],
                ),
              ) : const SizedBox.shrink(),
            ),
          ),
        ],
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFF035594), Color(0xFF4286f4)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(30.0),
            topRight: Radius.circular(30.0),
            bottomLeft: Radius.circular(1.0),
            bottomRight: Radius.circular(1.0),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 8,
              offset: const Offset(0, -3),  // Shadow above the nav bar
            ),
          ],
        ),
        child: BottomNavigationBar(
          backgroundColor: Colors.transparent, // Set transparent to avoid conflicts
          type: BottomNavigationBarType.fixed,
          selectedItemColor: Colors.white,  // Color of selected icon
          unselectedItemColor: Colors.white,  // Color of unselected icons
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.event),
              label: 'Events',

            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.add_circle_outline, size: 40), // Larger icon for center
              label: 'Create',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.adb_outlined),
              label: 'Chat-Bot',
            ),
          ],
          onTap: (index) {
            switch (index) {
              case 0:
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const EventTrackerPage()),
                );
                break;
              case 1:
                _togglePostCreation(); // Center button for post creation
                break;
              case 2:
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const ChatBotPage()),
                );
                break;
            }
          },
        ),
      ),

      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}