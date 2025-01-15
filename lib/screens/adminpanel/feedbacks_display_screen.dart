import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FeedbacksDisplayScreen extends StatefulWidget {
  const FeedbacksDisplayScreen({super.key});

  @override
  State<FeedbacksDisplayScreen> createState() => _FeedbacksDisplayScreenState();
}

class _FeedbacksDisplayScreenState extends State<FeedbacksDisplayScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<Map<String, dynamic>>> _fetchFeedbacksWithUsers() async {
    List<Map<String, dynamic>> feedbacksWithUsers = [];

    try {
      QuerySnapshot feedbacksSnapshot = await _firestore.collection('feedbacks').get();

      for (var feedbackDoc in feedbacksSnapshot.docs) {
        Map<String, dynamic> feedbackData = feedbackDoc.data() as Map<String, dynamic>;
        String userId = feedbackData['userid'];

        DocumentSnapshot userDoc = await _firestore.collection('users').doc(userId).get();
        Map<String, dynamic> userData = userDoc.data() as Map<String, dynamic>;

        feedbacksWithUsers.add({
          'username': userData['username'],
          'email': userData['useremail'],
          'feedback': feedbackData['feedback'],
          'avatarUrl': userData['image'],
        });
      }
    } catch (e) {
      print('Error fetching feedbacks with users: $e');
    }

    return feedbacksWithUsers;
  }

  void _showFeedbackDialog(String username, String email, String feedback) {
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
                "Feedback: ",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.deepPurpleAccent,
                ),
              ),
              Text(feedback),
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
          "See Feedbacks",
          style: TextStyle(
            color: Colors.deepPurpleAccent,
            fontSize: 22,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _fetchFeedbacksWithUsers(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No feedbacks found.'));
          }

          List<Map<String, dynamic>> feedbacksWithUsers = snapshot.data!;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: feedbacksWithUsers.map((feedback) {
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
                      backgroundImage: NetworkImage(feedback['avatarUrl']),
                      radius: 30,
                    ),
                    title: Text(
                      feedback['username'],
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
                            feedback['email'],
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.message, color: Colors.deepPurpleAccent),
                          onPressed: () {
                            _showFeedbackDialog(
                              feedback['username'],
                              feedback['email'],
                              feedback['feedback'],
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
          );
        },
      ),
    );
  }
}
