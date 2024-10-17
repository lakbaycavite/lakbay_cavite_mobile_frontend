import 'dart:convert';
import 'package:flutter/material.dart';
//import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:flutter_tts/flutter_tts.dart';
import 'package:permission_handler/permission_handler.dart';

class ChatBotPage extends StatefulWidget {
  const ChatBotPage({super.key});
  @override
  _ChatBotPageState createState() => _ChatBotPageState();
}

class _ChatBotPageState extends State<ChatBotPage> {
  final List<Map<String, String>> messages = [];
  final TextEditingController _controller = TextEditingController();
  late stt.SpeechToText _speechToText;
  bool _isListening = false;
  String _voiceInput = '';
  final FlutterTts flutterTts = FlutterTts();
  bool _speakDirections = false;//track if the user wants directions spoken aloud
  bool _isTyping = false;

  @override
  void initState(){
    super.initState();
    _speechToText = stt.SpeechToText();
    _initializeTts();
    _getAvailableVoices();

  }

  void _initializeTts() async{
    await flutterTts.setLanguage('en-US');
    await flutterTts.setVoice({"name": "en-PH-Wavenet-C", "locale": "en-PH"}); // Voice selection
    await flutterTts.setPitch(1.1);//pitch of voice
    await flutterTts.setVolume(1.0); //volume
    await flutterTts.setSpeechRate(0.5);
  }

  Future<void> _speak(String message) async {
    await flutterTts.speak(message);
  }

  Future<void> _getAvailableVoices() async {
    List<dynamic> voices = await flutterTts.getVoices;
    voices.forEach((voice) {
      print('Voice Name: ${voice['name']}, Locale: ${voice['locale']}');
    });
  }

  void _sendMessage(String message) {
    setState(() {
      messages.add({"user": message});
      _controller.clear();
      _getBotResponse(message);

    });
  }

  // Send message to backend and get response
  Future<void> _getBotResponse(String userMessage) async {
    setState(() {
      _isTyping = true;
    });

    if (userMessage.toLowerCase().contains("dorothy what is the route to")) {
      final origin = "Imus"; // Placeholder, or you can extract from userMessage
      final destination = userMessage.split("route to")[1].trim(); // Extract destination

      try {
        final response = await http.get(
          Uri.parse('http://192.168.1.13:4000/directions/getDirect?origin=$origin&destination=$destination'),
        );

        if (response.statusCode == 200) {
          final data = json.decode(response.body);

          String botMessage = "Here are the directions:\n";
          botMessage += "From: ${data['start_address']}\n";
          botMessage += "To: ${data['end_address']}\n";
          botMessage += "Distance: ${data['distance']}\n";
          botMessage += "Duration: ${data['duration']}\n\n";
          botMessage += "Steps:\n";

          for (var step in data['steps']) {
            botMessage += "- $step\n";
          }

          setState(() {
            messages.add({"bot": botMessage});
          });

          // Check if directions should be spoken aloud
          if (_speakDirections) {
            await _speak(botMessage);
          }

        } else {
          setState(() {
            messages.add({"bot": "Sorry, I couldn't find the directions."});
          });
        }
      } catch (error) {
        setState(() {
          messages.add({"bot": "Error: Unable to fetch directions."});
        });
      }
    } else {
      setState(() {
        messages.add({"bot": "Sorry, I didn’t understand that."});
      });
    }
  }


  Future<void> _startListening() async {
    // Request microphone permission
    var status = await Permission.microphone.status;

    if (status.isDenied) {
      // Request permission
      if (await Permission.microphone.request().isGranted) {
        // Permission granted, start listening
        _initializeSpeechToText();
      } else {
        // Handle permission denied
        print("Microphone permission denied");
      }
    } else if (status.isGranted) {
      // Permission already granted, start listening
      _initializeSpeechToText();
    }
  }

  void _initializeSpeechToText() async {
    bool available = await _speechToText.initialize();
    if (available) {
      setState(() {
        _isListening = true;
      });
      _speechToText.listen(onResult: (result) {
        setState(() {
          _voiceInput = result.recognizedWords;
          _controller.text = _voiceInput;
        });
      });
    }
  }


  void _stopListening(){
    setState(() {
      _isListening = false;
    });
    _speechToText.stop();
    if (_controller.text.isNotEmpty){
      _sendMessage(_controller.text);
    }
  }

  Future<void> _speakText(String text) async{
    await flutterTts.speak(text);
  }



  String _generateBotResponse(String message) {
    // Handle non-direction questions or simple bot responses
    if (message.toLowerCase().contains("hello dorothy")) {
      return "Hello! How can I assist you today?";
    }
    return "Sorry, I didn’t understand that.";
  }




  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Row(
          children: [
            Icon(Icons.adb, color: Colors.white, size: 30),
            SizedBox(width: 8),
            Text('CHAT-BOT', style: TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.bold, fontSize: 24, color: Colors.white)),
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
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: messages.length,
              itemBuilder: (context, index) {
                final message = messages[index];
                final isUserMessage = message.containsKey('user');

                return Align(
                  alignment: isUserMessage ? Alignment.centerRight : Alignment.centerLeft,
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 1000),
                    curve: Curves.easeInOut,
                    padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
                    margin: EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0),
                    decoration: BoxDecoration(
                      color: isUserMessage ? Color(0xFF035594) : Colors.green,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(isUserMessage ? 15 : 0),
                        topRight: Radius.circular(isUserMessage ? 0 : 15),
                        bottomLeft: Radius.circular(15),
                        bottomRight: Radius.circular(15),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 6.0,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: isUserMessage ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                      children: [
                        Text(
                          isUserMessage ? 'You' : 'Dorothy-bot',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Poppins',
                            color: Colors.white70,
                          ),
                        ),
                        Text(
                          message.values.first,
                          style: const TextStyle(
                            color: Colors.white,
                            fontFamily: 'Poppins',
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          // Display Google Map when directions are ready


          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,  // Background for the text input
                      borderRadius: BorderRadius.circular(30.0),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 5.0,
                          offset: Offset(0, 3),  // Creates a shadow effect under the input field
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15.0),
                      child: TextField(
                        controller: _controller,
                        decoration: InputDecoration(
                          hintText: "Type a message...",
                          border: InputBorder.none,  // Removes default border
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),  // Space between input and icons
                Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: _isListening ? Colors.redAccent : Colors.green,
                  ),
                  child: IconButton(
                    icon: Icon(
                      _isListening ? Icons.mic_off : Icons.mic,
                      color: Colors.white,
                    ),
                    onPressed: () {
                      if (_isListening) {
                        _stopListening();
                      } else {
                        _startListening();
                      }
                    },
                  ),
                ),
                const SizedBox(width: 10),  // Space between the icons
                Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.green,
                  ),
                  child: IconButton(
                    icon: const Icon(Icons.send_rounded, color: Colors.white),
                    onPressed: () {
                      if (_controller.text.isNotEmpty) {
                        _sendMessage(_controller.text);
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  "Speak Directions:",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.black54,
                      fontFamily: 'Poppins'
                  ),
                ),
                const SizedBox(width: 10),
                Transform.scale(
                  scale: 1.2,  // Increase the size of the switch for easier toggling
                  child: Switch(
                    value: _speakDirections,
                    activeColor: Colors.green,
                    onChanged: (value) {
                      setState(() {
                        _speakDirections = value;
                      });
                    },
                  ),
                ),
              ],
            ),
          ),

        ],
      ),
    );
  }
}