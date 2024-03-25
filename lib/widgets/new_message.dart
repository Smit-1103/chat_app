import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class NewMessage extends StatefulWidget {
  const NewMessage({super.key});

  @override
  State<NewMessage> createState() => _NewMessageState();
}

class _NewMessageState extends State<NewMessage> {
  var _messageController = TextEditingController();
  FocusNode _messageFocusNode = FocusNode();

  @override
  void dispose() {
    _messageController.dispose();
    _messageFocusNode.dispose();
    super.dispose();
  }

  void _openKeyboard() {
     // Focus the text field
    _messageFocusNode.requestFocus();

    // Open the native emoji keyboard
    Future.delayed(Duration(milliseconds: 100), () {
      if (Theme.of(context).platform == TargetPlatform.iOS) {
        // For iOS devices, use the system method to show the keyboard
        SystemChannels.textInput.invokeMethod('TextInput.show');
      } else if (Theme.of(context).platform == TargetPlatform.android) {
        // For Android devices, use the system method to show the emoji keyboard
        SystemChannels.textInput.invokeMethod('TextInput.showInputMethodPicker');
      }
    });
  }

  void _submitMessage() {
    final enteredMessage = _messageController.text;

    if (enteredMessage.trim().isEmpty) {
      return;
    }

    // Send to firebase
    // ...

    // Clear the textfield after sending the message
    _messageController.clear();
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
                    onPressed: _openKeyboard,
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
                        focusNode: _messageFocusNode,
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
