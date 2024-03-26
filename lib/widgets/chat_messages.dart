import 'package:chat_app/widgets/message_bubble.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ChatMessages extends StatelessWidget {
  const ChatMessages({super.key});

  @override
  Widget build(BuildContext context) {
    final authenticatedUser = FirebaseAuth.instance.currentUser!;

    //on every mssage we want to show that message on the dispaly so that we have to rebuild this widget on every message tha's why we used this streambuilder
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection('chat')
          .orderBy(
            'createdAT',
            descending: true,
          )
          .snapshots(),
      builder: (ctx, chatSnapshots) {
        if (chatSnapshots.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        if (!chatSnapshots.hasData || chatSnapshots.data!.docs.isEmpty) {
          return const Center(
            child: Text('No mesages found !!'),
          );
          // return Stack(
          //   children: [
          //     // Transparent and blurred background
          //     Positioned.fill(
          //       child: BackdropFilter(
          //         filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
          //         child: Container(
          //           color: Colors.black.withOpacity(0.5), // Adjust opacity here
          //         ),
          //       ),
          //     ),
          //     Positioned.fill(
          //       child: Center(
          //         child: Column(
          //           mainAxisAlignment: MainAxisAlignment.center,
          //           children: [
          //             // Lottie animation
          //             Lottie.asset(
          //               'assets/images/profileImg.json',
          //               width: 200,
          //               height: 200,
          //             ),
          //             // Text below Lottie animation
          //             const SizedBox(height: 20),
          //             const Text(
          //               'No messages here, say hello!',
          //               style: TextStyle(
          //                 color: Colors.white,
          //                 fontSize: 16,
          //               ),
          //             ),
          //           ],
          //         ),
          //       ),
          //     ),
          //   ],
          // );
        }

        // something went wrong - check this - test case
        if (chatSnapshots.hasError) {
          return const Center(
            child: Text('Something went wrong.'),
          );
        }

        // this is to get the count of the messages in the perticualr document
        final loadedMessages = chatSnapshots.data!.docs;

        return ListView.builder(
          padding: const EdgeInsets.only(bottom: 40, left: 13, right: 13),
          reverse: true, // for displaying the messages at the bottom

          itemCount: loadedMessages.length,
          itemBuilder: (ctx, index) {
            //meta data of the message and the message it self is get from this
            final chatMessage = loadedMessages[index].data();

            final nextChatMessage = index + 1 < loadedMessages.length
                ? loadedMessages[index + 1].data()
                : null;

            final currentMessageUserId = chatMessage['userId'];
            final nextMessageUserId =
                nextChatMessage != null ? nextChatMessage['userId'] : null;
            final nextUserIsSame = nextMessageUserId == currentMessageUserId;

            if (nextUserIsSame) {
              return MessageBubble.next(
                message: chatMessage['text'],
                isMe: authenticatedUser.uid == currentMessageUserId,
              );
            } else {
              return MessageBubble.first(
                  userImage: chatMessage['userImage'],
                  username: chatMessage['username'],
                  message: chatMessage['text'],
                  isMe: authenticatedUser.uid == currentMessageUserId);
            }
          },
        );
      },
    );
  }
}
