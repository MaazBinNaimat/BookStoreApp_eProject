import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MessagesDisplayScreen extends StatefulWidget {
  const MessagesDisplayScreen({super.key});

  @override
  State<MessagesDisplayScreen> createState() => _MessagesDisplayScreenState();
}

class _MessagesDisplayScreenState extends State<MessagesDisplayScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  List<Map<String, dynamic>> _messages = [];
  Map<String, Map<String, dynamic>> _usersData = {};

  @override
  void initState() {
    super.initState();
    _fetchMessages();
  }

  Future<void> _fetchMessages() async {
    try {
      final messagesSnapshot = await _firestore.collection('messages').get();
      final messages = messagesSnapshot.docs.map((doc) => doc.data() as Map<String, dynamic>).toList();

      final userIds = messages.map((message) => message['userid'] as String).toSet();
      final usersSnapshot = await _firestore.collection('users').where('userid', whereIn: userIds.toList()).get();

      final users = usersSnapshot.docs.map((doc) => doc.data() as Map<String, dynamic>).toList();
      final usersMap = {for (var user in users) user['userid'] as String: user};

      setState(() {
        _messages = messages;
        _usersData = usersMap;
      });
    } catch (e) {
      print('Error fetching messages or users: $e');
    }
  }

  void _showMessageDialog(String username, String email, String message, String avatarUrl) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          contentPadding: const EdgeInsets.all(16.0),
          title: Text(
            "Details",
            style: TextStyle(
              color: Colors.deepPurpleAccent,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Name: ",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.deepPurpleAccent,
                ),
              ),
              Text(username),
              SizedBox(height: 8),
              Text(
                "Email: ",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.deepPurpleAccent,
                ),
              ),
              Text(email),
              SizedBox(height: 8),
              Text(
                "Message: ",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.deepPurpleAccent,
                ),
              ),
              Text(message),
              SizedBox(height: 8),
            ],
          ),
          actions: <Widget>[
            TextButton(
              child: const Text("Close"),
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
      appBar: AppBar(
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: CircleAvatar(
            backgroundColor: Colors.deepPurpleAccent,
            child: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ),
        ),
        title: const Text(
          "See Messages",
          style: TextStyle(
            color: Colors.deepPurpleAccent,
            fontSize: 22,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
      ),
      body: _messages.isEmpty
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: _messages.map((message) {
            final userId = message['userid'] as String;
            final userData = _usersData[userId] ?? {};
            final username = userData['username'] ?? 'Unknown';
            final email = userData['useremail'] ?? 'Unknown';
            final avatarUrl = userData['image'] ?? '';

            return Container(
              margin: const EdgeInsets.symmetric(vertical: 8.0),
              padding: const EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8.0),
                border: Border.all(
                  color: Colors.deepPurpleAccent,
                  width: 1.0,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 1,
                    blurRadius: 5,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              child: ListTile(
                leading: CircleAvatar(
                  backgroundImage: avatarUrl.isNotEmpty ? NetworkImage(avatarUrl) : null,
                  radius: 30,
                ),
                title: Text(
                  username,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                subtitle: Row(
                  children: [
                    Expanded(
                      child: Text(
                        email,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.mail, color: Colors.deepPurpleAccent),
                      onPressed: () {
                        _showMessageDialog(
                          username,
                          email,
                          message['message'] as String,
                          avatarUrl,
                        );
                      },
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}
