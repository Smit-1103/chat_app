import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class NewMessage extends StatefulWidget {
  const NewMessage({super.key});

  @override
  State<NewMessage> createState() => _NewMessageState();
}

class _NewMessageState extends State<NewMessage> {
  final _messageController = TextEditingController();

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }
void _submitMessage() async {
  final enteredMessage = _messageController.text;

  if (enteredMessage.trim().isEmpty) {
    return;
  }

  // Close the keyboard after sending the message
  FocusScope.of(context).unfocus();

  // Clear the text field after sending the message
  _messageController.clear();

  // Get the currently logged-in user
  final user = FirebaseAuth.instance.currentUser!;
  
  // Get user data from Firestore
  final userData = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();

  if (userData.exists) {
    // Send message to Firebase
    FirebaseFirestore.instance.collection('chat').add({
      'text': enteredMessage,
      'createdAT': Timestamp.now(),
      'userId': user.uid,
      'username': userData.data()!['username'],
      'userImage': userData.data()!['image_url'],
    });
  } else {
    print('User data does not exist');
    // Handle the case where user data does not exist
    // For example, you can display an error message to the user
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('User Data Not Found'),
        content: Text('Your user data is not available. Please try again later.'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text('OK'),
          ),
        ],
      ),
    );
  }
}


  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 1,
          color: Colors.grey,
        ),
        const SizedBox(height: 8),
        Container(
          color: Colors.white,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(
                    Icons.emoji_emotions_outlined,
                  ),
                  onPressed: () {},
                ),
                const SizedBox(
                  width: 5,
                ),
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      color: Colors.grey[300],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 19),
                      child: TextField(
                        controller: _messageController,
                        textCapitalization: TextCapitalization.sentences,
                        autocorrect: true,
                        enableSuggestions: true,
                        minLines: 1,
                        maxLines: null,
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          hintText: 'Send message...',
                          hintStyle: TextStyle(color: Colors.grey),
                        ),
                      ),
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send_rounded),
                  onPressed: _submitMessage,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 8),
      ],
    );
  }
}
