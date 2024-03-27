import 'package:flutter/material.dart';

// A MessageBubble for showing a single chat message on the ChatScreen.
class MessageBubble extends StatefulWidget {
  // Create a message bubble which is meant to be the first in the sequence.
  const MessageBubble.first({
    super.key,
    required this.userImage,
    required this.username,
    required this.message,
    required this.isMe,
  }) : isFirstInSequence = true;

  // Create a amessage bubble that continues the sequence.
  const MessageBubble.next({
    super.key,
    required this.message,
    required this.isMe,
  })  : isFirstInSequence = false,
        userImage = null,
        username = null;

  // Whether or not this message bubble is the first in a sequence of messages
  // from the same user.
  // Modifies the message bubble slightly for these different cases - only
  // shows user image for the first message from the same user, and changes
  // the shape of the bubble for messages thereafter.
  final bool isFirstInSequence;

  // Image of the user to be displayed next to the bubble.
  // Not required if the message is not the first in a sequence.
  final String? userImage;

  // Username of the user.
  // Not required if the message is not the first in a sequence.
  final String? username;
  final String message;

  // Controls how the MessageBubble will be aligned.
  final bool isMe;

  @override
  State<MessageBubble> createState() => _MessageBubbleState();
}

class _MessageBubbleState extends State<MessageBubble> {
  List<String> emojis = ['😊', '😂', '😍', '😎', '👍'];

  bool showEmojiContainer = false;
  String? selectedEmoji;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return GestureDetector(
      onTap: () {
        setState(() {
          showEmojiContainer = false;
        });
      },
      child: Stack(
        children: [
          if (widget.userImage != null)
            Positioned(
              top: 15,
              right: widget.isMe ? 0 : null,
              child: CircleAvatar(
                backgroundImage: NetworkImage(
                  widget.userImage!,
                ),
                backgroundColor: theme.colorScheme.primary.withAlpha(180),
                radius: 23,
              ),
            ),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 46),
            child: Row(
              mainAxisAlignment:
                  widget.isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
              children: [
                Column(
                  crossAxisAlignment: widget.isMe
                      ? CrossAxisAlignment.end
                      : CrossAxisAlignment.start,
                  children: [
                    if (widget.isFirstInSequence) const SizedBox(height: 18),
                    if (widget.username != null)
                      Padding(
                        padding: const EdgeInsets.only(
                          left: 13,
                          right: 13,
                        ),
                        child: Text(
                          widget.username!,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                      ),
                    GestureDetector(
                      onLongPress: () {
                        setState(() {
                          showEmojiContainer = !showEmojiContainer;
                        });
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: widget.isMe
                              ? Colors.white
                              : const Color.fromARGB(240, 216, 14, 65),
                          borderRadius: BorderRadius.only(
                            topLeft: !widget.isMe && widget.isFirstInSequence
                                ? Radius.zero
                                : const Radius.circular(12),
                            topRight: widget.isMe && widget.isFirstInSequence
                                ? Radius.zero
                                : const Radius.circular(12),
                            bottomLeft: const Radius.circular(12),
                            bottomRight: const Radius.circular(12),
                          ),
                        ),
                        constraints: const BoxConstraints(maxWidth: 200),
                        padding: const EdgeInsets.symmetric(
                          vertical: 10,
                          horizontal: 14,
                        ),
                        margin: const EdgeInsets.symmetric(
                          vertical: 4,
                          horizontal: 12,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.message,
                              style: TextStyle(
                                height: 1.3,
                                color: widget.isMe
                                    ? Colors.black87
                                    : theme.colorScheme.onSecondary,
                              ),
                              softWrap: true,
                            ),
                            if (selectedEmoji != null)
                              Container(
                                decoration: BoxDecoration(
                                  color: Colors.grey[200],
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                padding: const EdgeInsets.all(2),
                                margin: const EdgeInsets.only(top: 2),
                                child: Text(
                                  selectedEmoji!,
                                  style: const TextStyle(fontSize: 14),
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          if (showEmojiContainer)
            Positioned(
              bottom: 0,
              left: widget.isMe ? null : 0,
              right: widget.isMe ? 0 : null,
              child: Container(
                width: MediaQuery.of(context).size.width * 0.5,
                height: 50,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 1,
                      blurRadius: 5,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: emojis
                      .map(
                        (emoji) => GestureDetector(
                          onTap: () {
                            setState(() {
                              selectedEmoji = emoji;
                              showEmojiContainer = false;
                            });
                          },
                          child: Text(
                            emoji,
                            style: const TextStyle(fontSize: 20),
                          ),
                        ),
                      )
                      .toList(),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
