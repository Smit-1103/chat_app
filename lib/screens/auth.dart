import 'package:chat_app/screens/toggle_button.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({Key? key}) : super(key: key);

  @override
  State<AuthScreen> createState() {
    return _AuthScreenState();
  }
}

class _AuthScreenState extends State<AuthScreen>
    with SingleTickerProviderStateMixin {
  final _form = GlobalKey<FormState>();

  late AnimationController _controller;
  late Animation<double> _animation;
  bool _isLoading = false;
  bool _isSingupLoading = false;

  bool _isObscure = true;

  var _enteredEmail = '';
  var _enteredPassword = '';

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

  void _login() {

    setState(() {
    _isLoading = true;
  });

  final isValid = _form.currentState!.validate();

  if (isValid) {
    _form.currentState!.save();
    print(_enteredEmail);
    print(_enteredPassword);

    // Simulating sign-up process
    Future.delayed(const Duration(seconds: 1), () {
      // After sign-up process completes
      setState(() {
        _isLoading = false;
      });
      // Navigate to ToggleButtonScreen after sign-up process completes
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => const ToggleButtonScreen(),
        ),
      );
    });
  } else {
    // If validation fails, stop loading and return from the method
    setState(() {
      _isLoading = false;
    });
    return;
  }
  }

  void _signUp() {
  setState(() {
    _isSingupLoading = true;
  });

  final isValid = _form.currentState!.validate();

  if (isValid) {
    _form.currentState!.save();
    print(_enteredEmail);
    print(_enteredPassword);

    // Simulating sign-up process
    Future.delayed(const Duration(seconds: 1), () {
      // After sign-up process completes
      setState(() {
        _isSingupLoading = false;
      });
      // Navigate to ToggleButtonScreen after sign-up process completes
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => const ToggleButtonScreen(),
        ),
      );
    });
  } else {
    // If validation fails, stop loading and return from the method
    setState(() {
      _isSingupLoading = false;
    });
    return;
  }
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          'Welcome Back',
          style: TextStyle(
            color: Colors.black,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _form,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                FadeTransition(
                  opacity: _animation,
                  child: SizedBox(
                    height: 300,
                    child: Lottie.asset(
                      'assets/images/chatApp.json',
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                FadeTransition(
                  opacity: _animation,
                  child: TextFormField(
                    decoration: InputDecoration(
                      labelText: 'Email',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(
                            color: Color.fromARGB(255, 39, 39, 39)),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(
                            color: Color.fromARGB(255, 39, 39, 39)),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(
                            color: Color.fromARGB(255, 55, 90, 100)),
                      ),
                    ),
                    keyboardType: TextInputType.emailAddress,
                    autocorrect: false,
                    textCapitalization: TextCapitalization.none,
                    validator: (value) {
                      if (value == null ||
                          value.trim().isEmpty ||
                          !value.contains('@')) {
                        return 'Please enter your email';
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
                      suffixIcon: IconButton(
                        icon: Icon(
                          _isObscure ? Icons.visibility_off : Icons.visibility,
                        ),
                        onPressed: _toggleObscure,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(
                            color: Color.fromARGB(255, 39, 39, 39)),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(
                            color: Color.fromARGB(255, 39, 39, 39)),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(
                            color: Color.fromARGB(255, 55, 90, 100)),
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Expanded(
                      child: FadeTransition(
                        opacity: _animation,
                        child: OutlinedButton(
                          onPressed: _isLoading ? null : _login,
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            side: const BorderSide(
                              color: Color.fromARGB(255, 240, 39, 89),
                            ),
                          ),
                          child: _isLoading
                              ? const Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      'Logging In...',
                                      style: TextStyle(
                                        color: Color.fromARGB(255, 240, 39, 89),
                                        fontSize: 18,
                                      ),
                                    ),
                                    SizedBox(width: 8),
                                    SizedBox(
                                      width: 20,
                                      height: 20,
                                      child: CircularProgressIndicator(
                                        valueColor:
                                            AlwaysStoppedAnimation<Color>(
                                          Color.fromARGB(255, 240, 39, 89),
                                        ),
                                      ),
                                    ),
                                  ],
                                )
                              : const Text(
                                  'Login',
                                  style: TextStyle(
                                    color: Color.fromARGB(255, 240, 39, 89),
                                    fontSize: 18,
                                  ),
                                ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Expanded(
                      child: FadeTransition(
                        opacity: _animation,
                        child: ElevatedButton(
                          onPressed: _isSingupLoading ? null : _signUp,
                          style: ElevatedButton.styleFrom(
                            foregroundColor: Colors.white,
                            backgroundColor: const Color.fromARGB(
                                255, 240, 39, 89), // Text color
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
                                        color: Color.fromARGB(255, 228, 14, 68),
                                        fontSize: 18,
                                      ),
                                    ),
                                    SizedBox(width: 8),
                                    SizedBox(
                                      width: 20,
                                      height: 20,
                                      child: CircularProgressIndicator(
                                        valueColor:
                                            AlwaysStoppedAnimation<Color>(
                                          Color.fromARGB(255, 228, 14, 68),
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}
