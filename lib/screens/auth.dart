import 'dart:io';

import 'package:chat_app/widgets/user_image_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

//give access to fiebase object
final _firebase = FirebaseAuth.instance;

enum SelectedSegment { login, signup }

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() {
    return _AuthScreenState();
  }
}

class _AuthScreenState extends State<AuthScreen>
    with SingleTickerProviderStateMixin {
  SelectedSegment currentSegment = SelectedSegment.signup;
  late AnimationController _controller;
  late Animation<double> _animation;
  final _signupForm = GlobalKey<FormState>();
  final _loginForm = GlobalKey<FormState>();

  bool _isLoading = false;
  bool _isSingupLoading = false;

  bool _isObscure = true;

  var _enteredEmail = '';
  var _enteredPassword = '';
  File? _selectedImage;
  var _enteredUsername = '';

  void _toggleObscure() {
    setState(() {
      _isObscure = !_isObscure;
    });
  }

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    );
    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    );
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _login() async {
    setState(() {
      _isLoading = true;
    });

    final isValid = _loginForm.currentState!.validate();

    if (isValid) {
      _loginForm.currentState!.save();

      // Simulating login process
      Future.delayed(const Duration(seconds: 1), () {
        // After login process completes
        setState(() {
          _isLoading = false;
        });
      });
    } else {
      // If validation fails, stop loading and return from the method
      setState(() {
        _isLoading = false;
      });

      return;
    }

    // Login process
    try {
      final userCredentials = await _firebase.signInWithEmailAndPassword(
          email: _enteredEmail, password: _enteredPassword);

      // If login successful, userCredentials will not be null
      // Perform actions after successful login
      print(userCredentials);
        } on FirebaseAuthException catch (e) {
      String errorMessage = 'Login Failed. Kindly recheck your credentials.';
      if (e.code == 'wrong-password' || e.code == 'user-not-found') {
        errorMessage = 'Invalid email or password. Please try again.';
      }
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(errorMessage),
        ),
      );
    }
  }

  void _signUp() async {
    setState(() {
      _isSingupLoading = true;
    });

    final isValid = _signupForm.currentState!.validate();

    if (isValid && _selectedImage != null) {
      Future.delayed(const Duration(seconds: 1), () {
        _signupForm.currentState!.save();
        // After sign-up process completes
        setState(() {
          _isSingupLoading = false;
        });
      });
    } else {
      // If validation fails, stop loading and return from the method
      setState(() {
        _isSingupLoading = false;
      });
      if (_selectedImage == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Please select an image.'),
          ),
        );
      }
      return;
    }

    //user sign in in firebase
    try {
      final userCredentials = await _firebase.createUserWithEmailAndPassword(
          email: _enteredEmail, password: _enteredPassword);

      //uploading image  to firebase
      //storing the image on the firebase storage instance and in that the directory is created to store the image with dynamic name
      final storageRef = FirebaseStorage.instance
          .ref()
          .child('user_images')
          .child('${userCredentials.user!.uid}.jpg');

      // waiting for the image to be stored in the storage
      await storageRef.putFile(_selectedImage!);

      // getting the image ur for future use to display the img.
      final imgUrl = await storageRef.getDownloadURL();
      print(imgUrl);

// firestore package to communicat with firestore database feature - mandatory to make sure that it works with ''collections''
// this code will make new document in users collection.
      await FirebaseFirestore.instance
          .collection('users')
          .doc(userCredentials.user!.uid)
          .set({
        'username': _enteredUsername,
        'email': _enteredEmail,
        'image_url': imgUrl,
      });
    } on FirebaseAuthException catch (e) {
      if (e.code == 'email-already-in-uer') {
        //error message
      }
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.message ?? 'Authentication Failed.'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    String appBarText = currentSegment == SelectedSegment.login
        ? 'Welcome Back'
        : 'Welcome to Signup';

    return Container(
      color: Colors.white,
      child: SafeArea(
        left: false,
        right: false,
        bottom: false,
        child: Scaffold(
          backgroundColor: Theme.of(context).backgroundColor,
          body: SafeArea(
            bottom: false,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Static app bar
                  Container(
                    color: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: Text(
                      appBarText,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  // Segmented control and content
                  Center(
                    child: Column(
                      children: <Widget>[
                        Container(
                          margin: const EdgeInsets.only(top: 30),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey),
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child:
                              CupertinoSlidingSegmentedControl<SelectedSegment>(
                            thumbColor: const Color.fromARGB(255, 228, 14, 68),
                            backgroundColor: Colors.white,
                            children: {
                              SelectedSegment.login: Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 40,
                                  vertical: 8,
                                ),
                                child: Text(
                                  'Login',
                                  style: TextStyle(
                                    color:
                                        currentSegment == SelectedSegment.login
                                            ? Colors.white
                                            : Colors.grey,
                                    fontSize: 15,
                                  ),
                                ),
                              ),
                              SelectedSegment.signup: Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 40,
                                  vertical: 8,
                                ),
                                child: Text(
                                  'Signup',
                                  style: TextStyle(
                                    color:
                                        currentSegment == SelectedSegment.signup
                                            ? Colors.white
                                            : Colors.grey,
                                    fontSize: 15,
                                  ),
                                ),
                              ),
                            },
                            onValueChanged: (value) {
                              setState(() {
                                currentSegment = value!;
                              });
                            },
                            groupValue: currentSegment,
                          ),
                        ),
                        // Content based on selected segment
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: _buildContent(),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildContent() {
    return FadeTransition(
      opacity: _animation,
      child: _buildContentBasedOnSegment(),
    );
  }

  Widget _buildContentBasedOnSegment() {
    switch (currentSegment) {
      case SelectedSegment.login:
        return _buildLoginContent();
      case SelectedSegment.signup:
        return _buildSignupContent();
    }
  }

  Widget _buildLoginContent() {
    return Form(
      key: _loginForm, // assuming you have defined _loginForm in your state
      child: Column(
        children: [
          const SizedBox(height: 20),
          SizedBox(
            height: 230,
            child: Lottie.asset(
              'assets/images/chatApp.json',
              fit: BoxFit.contain,
            ),
          ),
          const SizedBox(height: 20),
          FadeTransition(
            opacity: _animation,
            child: TextFormField(
              decoration: InputDecoration(
                labelText: 'Email',
                prefixIcon: const Icon(Icons.email),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(
                    color: Color.fromARGB(255, 39, 39, 39),
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(
                    color: Color.fromARGB(255, 39, 39, 39),
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(
                    color: Color.fromARGB(255, 55, 90, 100),
                  ),
                ),
              ),
              keyboardType: TextInputType.emailAddress,
              autocorrect: false,
              textCapitalization: TextCapitalization.none,
              validator: (value) {
                if (value == null ||
                    value.trim().isEmpty ||
                    !value.contains('@')) {
                  return 'Please enter a valid email';
                }
                return null;
              },
              onSaved: (value) {
                _enteredEmail = value!;
              },
            ),
          ),
          const SizedBox(height: 20),
          FadeTransition(
            opacity: _animation,
            child: TextFormField(
              decoration: InputDecoration(
                labelText: 'Password',
                prefixIcon: const Icon(Icons.password),
                suffixIcon: IconButton(
                  icon: Icon(
                    _isObscure ? Icons.visibility_off : Icons.visibility,
                  ),
                  onPressed: _toggleObscure,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(
                    color: Color.fromARGB(255, 39, 39, 39),
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(
                    color: Color.fromARGB(255, 39, 39, 39),
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(
                    color: Color.fromARGB(255, 55, 90, 100),
                  ),
                ),
              ),
              obscureText: _isObscure,
              validator: (value) {
                if (value == null || value.trim().length < 6) {
                  return 'Password must be at least 6 characters long.';
                }
                return null;
              },
              onSaved: (value) {
                _enteredPassword = value!;
              },
            ),
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            child: FadeTransition(
              opacity: _animation,
              child: ElevatedButton(
                onPressed: _isLoading ? null : _login,
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: Color.fromARGB(255, 216, 14, 64),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: _isLoading
                    ? const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'logging in...',
                            style: TextStyle(
                              color: Color.fromARGB(255, 216, 14, 64),
                              fontSize: 18,
                            ),
                          ),
                          SizedBox(width: 8),
                          SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation<Color>(
                                Color.fromARGB(255, 216, 14, 64),
                              ),
                            ),
                          ),
                        ],
                      )
                    : const Text(
                        'Login',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                        ),
                      ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSignupContent() {
    return Form(
      key: _signupForm,
      child: Column(
        children: [
          const SizedBox(height: 20),
          FadeTransition(
            opacity: _animation,
            child: UserImagePicker(
              onPickImage: (pickedImage) {
                _selectedImage = pickedImage;
              },
            ),
          ),
          const SizedBox(height: 20),
          FadeTransition(
            opacity: _animation,
            child: TextFormField(
              decoration: InputDecoration(
                labelText: 'Username',
                prefixIcon: const Icon(Icons.assignment_ind_outlined),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(
                    color: Color.fromARGB(255, 39, 39, 39),
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(
                    color: Color.fromARGB(255, 39, 39, 39),
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(
                    color: Color.fromARGB(255, 55, 90, 100),
                  ),
                ),
              ),
              autocorrect: false,
              enableSuggestions: false,
              textCapitalization: TextCapitalization.none,
              validator: (value) {
                if (value == null || value.isEmpty || value.trim().length < 4) {
                  return 'Please enter at least 4 characters.';
                }
                return null;
              },
              onSaved: (value) {
                _enteredUsername = value!;
              },
            ),
          ),
          const SizedBox(height: 20),
          FadeTransition(
            opacity: _animation,
            child: TextFormField(
              decoration: InputDecoration(
                labelText: 'Email',
                prefixIcon: const Icon(Icons.email),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(
                    color: Color.fromARGB(255, 39, 39, 39),
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(
                    color: Color.fromARGB(255, 39, 39, 39),
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(
                    color: Color.fromARGB(255, 55, 90, 100),
                  ),
                ),
              ),
              keyboardType: TextInputType.emailAddress,
              autocorrect: false,
              textCapitalization: TextCapitalization.none,
              validator: (value) {
                if (value == null ||
                    value.trim().isEmpty ||
                    !value.contains('@')) {
                  return 'Please enter a valid email';
                }
                return null;
              },
              onSaved: (value) {
                _enteredEmail = value!;
              },
            ),
          ),
          const SizedBox(height: 20),
          FadeTransition(
            opacity: _animation,
            child: TextFormField(
              decoration: InputDecoration(
                labelText: 'Password',
                prefixIcon: const Icon(Icons.password),
                suffixIcon: IconButton(
                  icon: Icon(
                    _isObscure ? Icons.visibility_off : Icons.visibility,
                  ),
                  onPressed: _toggleObscure,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(
                    color: Color.fromARGB(255, 39, 39, 39),
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(
                    color: Color.fromARGB(255, 39, 39, 39),
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(
                    color: Color.fromARGB(255, 55, 90, 100),
                  ),
                ),
              ),
              obscureText: _isObscure,
              validator: (value) {
                if (value == null || value.trim().length < 6) {
                  return 'Password must be at least 6 characters long.';
                }
                return null;
              },
              onSaved: (value) {
                _enteredPassword = value!;
              },
            ),
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            child: FadeTransition(
              opacity: _animation,
              child: ElevatedButton(
                onPressed: _isSingupLoading ? null : _signUp,
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: Color.fromARGB(255, 216, 14, 64),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: _isSingupLoading
                    ? const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Signing up...',
                            style: TextStyle(
                              color: Color.fromARGB(255, 216, 14, 64),
                              fontSize: 18,
                            ),
                          ),
                          SizedBox(width: 8),
                          SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation<Color>(
                                Color.fromARGB(255, 216, 14, 64),
                              ),
                            ),
                          ),
                        ],
                      )
                    : const Text(
                        'Signup',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                        ),
                      ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
