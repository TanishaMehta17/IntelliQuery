import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:smart_content_recommendation_application/auth/screens/login.dart';
import 'package:smart_content_recommendation_application/auth/services/authService.dart';
import 'package:smart_content_recommendation_application/common/colors.dart';
import 'package:smart_content_recommendation_application/common/typography.dart';
import 'package:smart_content_recommendation_application/utils/CustomTextFormField.dart';

class SignUpScreen extends StatefulWidget {
  static const routeName = '/sign-up';

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}
bool _passwordVisible = false;
  bool _confirmPasswordVisible = false;
   final AuthService authService = AuthService();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();
 
 

class _SignUpScreenState extends State<SignUpScreen> {

   Future<bool> Signup(){
    return authService.register(
      context: context,
      username: nameController.text,
      email: emailController.text,
      password: passwordController.text,
      confirmpas: confirmPasswordController.text,
    );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background with image
          Container(
            height: MediaQuery.of(context).size.height * 0.5,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(
                    'assets/images/ai.jpg'), // Replace with your image
                fit: BoxFit.cover,
              ),
            ),
          ),
          // Main content
          Align(
            alignment: Alignment.bottomCenter,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(height: MediaQuery.of(context).size.height * 0.25),
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 30),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(30),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Title and Subtitle
                        Text(
                          'Welcome to AIHub!',
                          style: SCRTypography.heading,
                        ),
                        SizedBox(height: 5),
                        Text(
                          'Login to continue with AIHub',
                          style: SCRTypography.subHeading,
                        ),
                        SizedBox(height: 20),

                        // Full Name Field
                       CustomTextField(
                          controller: nameController,
                          labelText: "Name",
                          hintText: "Enter your name",
                          keyboardType: TextInputType.name,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your name';
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: 15),

                       CustomTextField(
                          controller: emailController,
                          labelText: "Email",
                          hintText: "Enter your email",
                          keyboardType: TextInputType.emailAddress,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your email';
                            } else if (!RegExp(r'^[^@]+@[^@]+\.[^@]+')
                                .hasMatch(value)) {
                              return 'Please enter a valid email address';
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: 15),

                       

                         CustomTextField(
                          controller: passwordController,
                          labelText: "Password",
                          hintText: "Enter your password",
                          keyboardType: TextInputType.text,
                          obscureText:
                              !_passwordVisible, // This controls the visibility of the text
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your password';
                            }
                            return null;
                          },
                          suffixIcon: IconButton(
                            icon: Icon(
                              _passwordVisible
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                              color: Colors.white,
                            ),
                            onPressed: () {
                              setState(() {
                                _passwordVisible = !_passwordVisible;
                              });
                            },
                          ),
                        ),
                        const SizedBox(height: 16),
                        CustomTextField(
                          controller: confirmPasswordController,
                          labelText: "Confirm Password",
                          hintText: "Re-enter your password",
                          keyboardType: TextInputType.text,
                          obscureText: !_confirmPasswordVisible,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please confirm your password';
                            } else if (value != passwordController.text) {
                              return 'Passwords do not match';
                            }
                            return null;
                          },
                          suffixIcon: IconButton(
                            icon: Icon(
                              _confirmPasswordVisible
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                              color: Colors.white,
                            ),
                            onPressed: () {
                              setState(() {
                                _confirmPasswordVisible =
                                    !_confirmPasswordVisible;
                              });
                            },
                          ),
                        ),
                        SizedBox(height: 25),

                        // Get Started Button
                        InkWell(
                          onTap: () async {
                            bool result = await Signup();
                            print(result);
                            if (result) {
                              Navigator.pushNamed(context, LoginScreen.routeName);
                            }
                          },
                          child: SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: () {},
                              style: ElevatedButton.styleFrom(
                                backgroundColor: primaryColor,
                                padding: EdgeInsets.symmetric(vertical: 15),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              child: Text(
                                'Get Started',
                                style: SCRTypography.subHeading
                                    .copyWith(color: white),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 15),

                        // Footer Text
                        Center(
                          child: RichText(
                            text: TextSpan(
                              text: 'Already have an account? ',
                              style: TextStyle(color: Colors.black),
                              children: [
                                TextSpan(
                                  text: 'Log In',
                                  style: SCRTypography.subHeading.copyWith(
                                      color: primaryColor,
                                      fontWeight: FontWeight.w700),
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = () {
                                      Navigator.pushNamed(
                                          context, LoginScreen.routeName);
                                    },
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
