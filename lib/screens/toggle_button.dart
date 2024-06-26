import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

enum SelectedSegment { login, signup }

class ToggleButtonScreen extends StatefulWidget {
  const ToggleButtonScreen({super.key});

  @override
  _ToggleButtonScreenState createState() => _ToggleButtonScreenState();
}

class _ToggleButtonScreenState extends State<ToggleButtonScreen>
    with SingleTickerProviderStateMixin {
  SelectedSegment currentSegment = SelectedSegment.login;
  late AnimationController _controller;
  late Animation<double> _animation;

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

  @override
  Widget build(BuildContext context) {
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
            child: Center(
              child: Column(
                children: <Widget>[
                  Container(
                    color: Colors.white,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          margin: const EdgeInsets.only(top: 20),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey),
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: CupertinoSlidingSegmentedControl<SelectedSegment>(
                            thumbColor: Color.fromARGB(255, 228, 14, 68),
                            backgroundColor: Colors.white,
                            children: {
                              SelectedSegment.login: Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 30,
                                  vertical: 10,
                                ),
                                child: Text(
                                  'Login',
                                  style: TextStyle(
                                    color: currentSegment == SelectedSegment.login
                                        ? Colors.white
                                        : Colors.grey,
                                    fontSize: 20,
                                  ),
                                ),
                              ),
                              SelectedSegment.signup: Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 30,
                                  vertical: 10,
                                ),
                                child: Text(
                                  'Signup',
                                  style: TextStyle(
                                    color: currentSegment == SelectedSegment.signup
                                        ? Colors.white
                                        : Colors.grey,
                                    fontSize: 20,
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
                      ],
                    ),
                  ),
                  // Content based on selected segment
                  _buildContent(),
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
    return SizedBox(
      height: 300,
      child: Lottie.asset(
        'assets/images/login.json',
        fit: BoxFit.contain,
      ),
    );
  }

  Widget _buildSignupContent() {
    return SizedBox(
      height: 300,
      child: Lottie.asset(
        'assets/images/signup.json',
        fit: BoxFit.contain,
      ),
    );
  }
}
