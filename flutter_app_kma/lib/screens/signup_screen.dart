import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_app/resources/auth_methods.dart';
import 'package:flutter_app/responsive/mobile_screen_layout.dart';
import 'package:flutter_app/responsive/responsive_layout.dart';
import 'package:flutter_app/responsive/web_screen_layout.dart';
import 'package:flutter_app/screens/login_screen.dart';
import 'package:flutter_app/utils/colors.dart';
import 'package:flutter_app/utils/utils.dart';
import 'package:flutter_app/widgets/text_field_input.dart';

import 'package:image_picker/image_picker.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({Key? key}) : super(key: key);

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _bioController = TextEditingController();
  bool _isLoading = false;
  Uint8List? _image;

  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _usernameController.dispose();
  }

  // void signUpUser() async {
  //   // set loading to true
  //   setState(() {
  //     _isLoading = true;
  //   });

  //   // signup user using our authmethodds
  //   String res = await AuthMethods().signUpUser(
  //       email: _emailController.text,
  //       password: _passwordController.text,
  //       username: _usernameController.text,
  //       bio: _bioController.text,
  //       file: _image!);
  //   //print(res);
  //   // if string returned is sucess, user has been created
  //   if (res == "success") {
  //     setState(() {
  //       _isLoading = false;
  //     });
  //     // navigate to the home screen
  //     if (context.mounted) {
  //       Navigator.of(context).pushReplacement(
  //         MaterialPageRoute(
  //           builder: (context) => const ResponsiveLayout(
  //             mobileScreenLayout: MobileScreenLayout(),
  //             webScreenLayout: WebScreenLayout(),
  //           ),
  //         ),
          
  //       );
  //       // setState(() {
  //       //   _isLoading = false;
  //       // });
  //     }
  //   } else {
  //     setState(() {
  //       _isLoading = false;
  //     });
  //     // show the error
  //     if (context.mounted) {
  //       showSnackBar(context, res);
  //     }
  //   }
  // }

  selectImage() async {
    Uint8List im = await pickImage(ImageSource.gallery);
    // set state because we need to display the image we selected on the circle avatar
    setState(() {
      _image = im;
    });
  }
  bool _isNotEmpty(String value) {
  return value.trim().isNotEmpty;
}
void showSnackBar(BuildContext context, String message) {
  final snackBar = SnackBar(content: Text(message));
  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}
void signUpUser() async {
  // Kiểm tra xem tất cả các trường có được nhập không
  if (!_isNotEmpty(_usernameController.text) ||
      !_isNotEmpty(_emailController.text) ||
      !_isNotEmpty(_passwordController.text) ||
      !_isNotEmpty(_bioController.text) ||
      _image == null) {
    showSnackBar(context, 'Please fill in all fields.');
    return;
  }

  // set loading to true
  setState(() {
    _isLoading = true;
  });

  // signup user using our authmethods
  String res = await AuthMethods().signUpUser(
      email: _emailController.text,
      password: _passwordController.text,
      username: _usernameController.text,
      bio: _bioController.text,
      file: _image!);
  
  // Check the response from the AuthMethods
  if (res == "success") {
    // setState(() {
    //   _isLoading = false;
    // });
    
    // navigate to the home screen
    if (context.mounted) {
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(
          builder: (context) => const ResponsiveLayout(
            mobileScreenLayout: MobileScreenLayout(),
            webScreenLayout: WebScreenLayout(),
          ),
        ),
      (route) => false);
    }
  } else {
    setState(() {
      _isLoading = false;
    });
    // show the error
    if (context.mounted) {
      showSnackBar(context, res);
    }
  }
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: Column(
            //mainAxisAlignment: MainAxisAlignment.start,
            //crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(
                height: 120,
              ),
              Image.asset(
                'assets/signature.png',
                color: primaryColor,
                height: 64,
              ),
              Stack(
                children: [
                  _image != null
                      ? CircleAvatar(
                          radius: 64,
                          backgroundImage: MemoryImage(_image!),
                          backgroundColor: Colors.red,
                        )
                      : const CircleAvatar(
                          radius: 64,
                          backgroundImage: NetworkImage(
                              'https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_960_720.png')),
                  Positioned(
                    bottom: -10,
                    left: 80,
                    child: IconButton(
                      onPressed: selectImage,
                      icon: const Icon(Icons.add_a_photo),
                    ),
                  )
                ],
              ),
              const SizedBox(
                height: 24,
              ),
              TextFieldInput(
                hintText: 'Enter your username',
                textInputType: TextInputType.text,
                textEditingController: _usernameController,
              ),
              const SizedBox(
                height: 24,
              ),
              TextFieldInput(
                hintText: 'Enter your email',
                textInputType: TextInputType.emailAddress,
                textEditingController: _emailController,
              ),
              const SizedBox(
                height: 24,
              ),
              TextFieldInput(
                hintText: 'Enter your password',
                textInputType: TextInputType.text,
                textEditingController: _passwordController,
                isPass: true,
              ),
              const SizedBox(
                height: 24,
              ),
              TextFieldInput(
                hintText: 'Enter your bio',
                textInputType: TextInputType.text,
                textEditingController: _bioController,
              ),
              const SizedBox(
                height: 24,
              ),
              InkWell(
                onTap: signUpUser,
                child: Container(
                  width: double.infinity,
                  alignment: Alignment.center,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  decoration: const ShapeDecoration(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(4)),
                    ),
                    color: blueColor,
                  ),
                  child: !_isLoading
                      ? const Text(
                          'Sign up',
                        )
                      : const CircularProgressIndicator(
                          color: primaryColor,
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: const Text(
              'Already have an account?',
            ),
          ),
          GestureDetector(
            onTap: () => Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => const LoginScreen(),
              ),
            ),
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: const Text(
                ' Login.',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
