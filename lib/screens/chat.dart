import 'package:chat_app/widgets/chat_messages.dart';
import 'package:chat_app/widgets/new_message.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  // we have to make this class as a helper class as initstate method should not return future and we want teh await for pushing the notification
  void setupPushNotifications() async {
    // this class is used to push permission by firebase
    final fcm = FirebaseMessaging.instance;

    // asking user for the notififcation permission
    await fcm.requestPermission();

    //address of the device in which we want to send the notification
    final token = await fcm.getToken();
    // we can use this token and send this via http or firestore sdk to a backend.
    print(token);

    fcm.subscribeToTopic('chat');
  }

  @override
  void initState() {
    super.initState();

    //callinng this helper class from initState
    setupPushNotifications();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 216, 14, 64),
        centerTitle: true,
        title: const Text(
          'Flutter chat',
          style: TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              // Show logout confirmation dialog
              showLogoutDialog(context);
            },
            icon: const Icon(
              Icons.exit_to_app,
              color: Colors.white,
            ),
          ),
        ],
      ),
      body: Stack(
        children: [
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: const AssetImage('assets/images/chatscreen.jpeg'),
                  fit: BoxFit.cover,
                  colorFilter: ColorFilter.mode(
                    Colors.black54.withOpacity(0.6),
                    BlendMode.saturation,
                  ),
                ),
              ),
            ),
          ),
          const Column(
            children: [
              Expanded(
                child: ChatMessages(),
              ),
              NewMessage(),
            ],
          ),
        ],
      ),
    );
  }

  void showLogoutDialog(BuildContext context) {
    showCupertinoDialog(
      context: context,
      builder: (context) {
        return Material(
          type: MaterialType.transparency,
          child: CupertinoAlertDialog(
            title: const Text('Signout'),
            content: const Text(
                'Are you sure you want to log out from the chat app?'),
            actions: [
              CupertinoDialogAction(
                onPressed: () {
                  Navigator.pop(context); // Close the dialog
                },
                child: const Text('Cancel'),
              ),
              CupertinoDialogAction(
                onPressed: () {
                  FirebaseAuth.instance.signOut(); // Sign out
                  Navigator.pop(context); // Close the dialog
                },
                child: const Text('Yes'),
              ),
            ],
          ),
        );
      },
    );
  }
}

// import 'package:chat_app/widgets/chat_messages.dart';
// import 'package:chat_app/widgets/new_message.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';

// class ChatScreen extends StatelessWidget {
//   const ChatScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         centerTitle: true,
//         title: const Text(
//           'Flutter chat',
//           style: TextStyle(
//             color: Colors.black,
//             fontSize: 24,
//             fontWeight: FontWeight.bold,
//           ),
//         ),
//         actions: [
//           IconButton(
//             onPressed: () {
//               //it will clear the token and signout
//               FirebaseAuth.instance.signOut();
//             },
//             icon: const Icon(
//               Icons.exit_to_app,
//               color: Colors.black,
//             ),
//           ),
//         ],
//       ),
//       body: const Column(
//         children: [
//           Expanded(
//             child: ChatMessages(),
//           ),
//           NewMessage(),
//         ],
//       ),
//     );
//   }
// }
