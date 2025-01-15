import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class FaqsDisplayScreen extends StatefulWidget {
  const FaqsDisplayScreen({super.key});

  @override
  State<FaqsDisplayScreen> createState() => _FaqsDisplayScreenState();
}

class _FaqsDisplayScreenState extends State<FaqsDisplayScreen> {
  int _expandedIndex = -1; // Track the currently expanded index

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: CircleAvatar(
            backgroundColor: Colors.deepPurpleAccent,
            child: IconButton(
              icon: Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ),
        ),
        title: Text(
          "FAQs",
          style: TextStyle(color: Colors.deepPurpleAccent, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('faqs').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text('No FAQs available.'));
          }

          final faqs = snapshot.data!.docs;

          return ListView.builder(
            itemCount: faqs.length,
            itemBuilder: (context, index) {
              final faq = faqs[index];
              return _FaqExpansionTile(
                index: index,
                question: faq['question'] ?? 'No question',
                answer: faq['answer'] ?? 'No answer',
                isExpanded: _expandedIndex == index,
                onExpansionChanged: (bool expanded) {
                  setState(() {
                    _expandedIndex = expanded ? index : -1;
                  });
                },
              );
            },
          );
        },
      ),
    );
  }
}

class _FaqExpansionTile extends StatelessWidget {
  final int index;
  final String question;
  final String answer;
  final bool isExpanded;
  final ValueChanged<bool> onExpansionChanged;

  const _FaqExpansionTile({
    required this.index,
    required this.question,
    required this.answer,
    required this.isExpanded,
    required this.onExpansionChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(15)),
          color: Colors.deepPurpleAccent, // Background color for the question
        ),
        child: ExpansionTile(
          backgroundColor: Colors.transparent, // Set to transparent to show question background color
          title: Container(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              question,
              style: const TextStyle(color: Colors.white),
            ),
          ),
          initiallyExpanded: isExpanded,
          onExpansionChanged: onExpansionChanged,
          children: <Widget>[
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(bottomLeft: Radius.circular(10),bottomRight: Radius.circular(10)),
                color: Colors.deepPurpleAccent[100], // Background color for the question
              ),
              child: ListTile(
                title: Text(answer,style: TextStyle(color: Colors.white),),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
