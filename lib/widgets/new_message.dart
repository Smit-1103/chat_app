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
  // FocusNode _messageFocusNode = FocusNode();

  @override
  void dispose() {
    _messageController.dispose();
    // _messageFocusNode.dispose();
    super.dispose();
  }

  // void _openKeyboard() {
  //   // Focus the text field
  //   _messageFocusNode.requestFocus();

  //   // Open the native emoji keyboard
  //   Future.delayed(const Duration(milliseconds: 100), () {
  //     if (Theme.of(context).platform == TargetPlatform.iOS) {
  //       // For iOS devices, use the system method to show the keyboard
  //       SystemChannels.textInput.invokeMethod('TextInput.show');
  //     } else if (Theme.of(context).platform == TargetPlatform.android) {
  //       // For Android devices, use the system method to show the emoji keyboard
  //       SystemChannels.textInput
  //           .invokeMethod('TextInput.showInputMethodPicker');
  //     }
  //   });
  // }

  void _submitMessage() async {
    final enteredMessage = _messageController.text;

    if (enteredMessage.trim().isEmpty) {
      return;
    }

    // this is used to close the keyboard after sending the message
    FocusScope.of(context).unfocus();

    // Clear the textfield after sending the message
    _messageController.clear();
    // to get the name of currently logged in user we have to take name from the firebase
    final user = FirebaseAuth.instance.currentUser;
    final userData = await FirebaseFirestore.instance
        .collection('user')
        .doc(user?.uid)
        .get();

    
    print('WE ARE AFTER THEINSTANCE');

    // Send to firebase
    FirebaseFirestore.instance.collection('chat').add({
      'text': enteredMessage,
      'createdAT': Timestamp.now(),
      'userId': user?.uid,
      'username': userData.data()!['username'],
      'userImage': userData.data()!['image_url'],
    });
    print('WE ARE AFTER THE FIREBASEFIRESTORE INSTANCE');
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
                  // onPressed: _openKeyboard,
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
                        // focusNode: _messageFocusNode,
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
                  icon: const Icon(Icons.send),
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
