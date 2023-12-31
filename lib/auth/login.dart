import 'package:attendance_monitoring/auth/logout.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import '../api/Login.dart';
import '../style/style.dart';
import 'signup.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  //
  final _emailController = TextEditingController();
  final _passController = TextEditingController();
  bool _isObscure = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // backpressed
    return WillPopScope(
      onWillPop: () async {
        const purpose = "Exit";
        final value = logout(context, purpose);
        return value == true;
      },
      // unfocus
      child: GestureDetector(
        onTap: () {
          FocusScopeNode currentFocus = FocusScope.of(context);
          if (!currentFocus.hasPrimaryFocus &&
              currentFocus.focusedChild != null) {
            currentFocus.unfocus();
          }
        },
        child: Container(
          decoration: Style.login,
          child: Scaffold(
            backgroundColor: Colors.transparent,
            body: SafeArea(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 30),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ClipRRect(
                            borderRadius: Style.borderRadius,
                            child: Container(
                              color: Colors.white,
                              child: Padding(
                                padding: const EdgeInsets.all(4.0),
                                child: Image.asset(
                                  'assets/nmsct.jpg',
                                  height: 80,
                                  width: 80,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          Text("Attendance\nMonitoring", style: Style.text),
                        ],
                      ),
                    ),

                    Padding(
                      padding: Style.padding,
                      child: Column(
                        children: [
                          TextField(
                            controller: _emailController,
                            enableSuggestions: false,
                            autocorrect: false,
                            decoration:
                                Style.textdesign.copyWith(hintText: "Username"),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          TextField(
                            obscureText: _isObscure,
                            enableSuggestions: false,
                            controller: _passController,
                            decoration: Style.textdesign.copyWith(
                              hintText: "Password",
                              suffixIcon: IconButton(
                                  icon: Icon(_isObscure
                                      ? Icons.visibility_off
                                      : Icons.visibility),
                                  onPressed: () {
                                    setState(() {
                                      _isObscure = !_isObscure;
                                    });
                                  }),
                            ),
                          ),
                          Align(
                            alignment: Alignment.centerRight,
                            child: TextButton(
                              child:
                                  Text("Forgot Password ?", style: Style.link),
                              onPressed: () {},
                            ),
                          ),
                          TextButton(
                            onPressed: () async {
                              
                              final email = _emailController.text.trim();
                              final password = _passController.text.trim();
                              await login(context, email, password);
                              print("Clicked");
                            },
                            autofocus: true,
                            style: TextButton.styleFrom(
                                fixedSize: const Size.fromHeight(50),
                                backgroundColor: Style.themecolor,
                                shape: RoundedRectangleBorder(
                                    borderRadius: Style.defaultradius)),
                            child: Center(
                              child: Text(
                                'LOG IN',
                                style: Style.text,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 20),
                    Row(
                      children: [
                        Expanded(
                          child: Divider(thickness: 2, color: Colors.grey[400]),
                        ),
                        Text(
                          "Or Face Recognition Auth",
                          style: Style.subtitle,
                        ),
                        Expanded(
                          child: Divider(thickness: 2, color: Colors.grey[400]),
                        ),
                      ],
                    ),

                    // const Row(
                    //   mainAxisAlignment: MainAxisAlignment.center,
                    //   children: [
                    //     Logo(imagePath: 'assets/images/google.png'),
                    //     SizedBox(
                    //       width: 10,
                    //     ),
                    //     Logo(imagePath: 'assets/images/fb.png'),
                    //   ],
                    // ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 20.0),
                      child: GestureDetector(
                        onTap: () {
                          // Navigator.of(context).push(MaterialPageRoute(
                          //     builder: (context) => const Camera()));
                        },
                        child: Container(
                          decoration: Style.boxdecor,
                          child: Padding(
                            padding: const EdgeInsets.all(3.0),
                            child: SizedBox(
                              height: 100,
                              width: 100,
                              child: Lottie.asset('assets/scan.json'),
                            ),
                          ),
                        ),
                      ),
                    ),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        TextButton(
                          onPressed: null,
                          style: TextButton.styleFrom(textStyle: Style.link),
                          child: const Text("create new account ?"),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const Signup()),
                            );
                          },
                          style: TextButton.styleFrom(textStyle: Style.link),
                          child: const Text("Sign up"),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
