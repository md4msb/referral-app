import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:referral/view/screens/auth/auth_state.dart';

import '../../../constants/colors.dart';
import '../../widgets/custom_textfield.dart';

class AuthView extends StatelessWidget {
  const AuthView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final state = Provider.of<AuthState>(context);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (state.signInState == SignInState.signup)
                  Column(
                    children: const [
                      SizedBox(
                        height: 60,
                      ),
                      Text(
                        "Sign Up",
                        style: TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 1,
                        ),
                      ),
                      SizedBox(
                        height: 50,
                      ),
                    ],
                  ),
                if (state.signInState == SignInState.login)
                  Column(
                    children: const [
                      SizedBox(
                        height: 50,
                      ),
                      Text(
                        "Welcome Back!",
                        style: TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 1,
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        "Login To Continue",
                        style: TextStyle(
                          fontSize: 18,
                          color: Color(0xFFBBBBBB),
                        ),
                      ),
                      SizedBox(
                        height: 100,
                      ),
                    ],
                  ),
                if (state.signInState == SignInState.signup)
                  CustomTextField(
                    label: "Enter Your Name",
                    controller: state.nameController,
                  ),
                CustomTextField(
                  label: "Email",
                  controller: state.emailController,
                ),
                CustomTextField(
                  label: "Password",
                  controller: state.passwordController,
                ),
                const SizedBox(
                  height: 45,
                ),
                state.isLoading
                    ? const Center(
                        child: CircularProgressIndicator(),
                      )
                    : GestureDetector(
                        onTap: () {
                          state.signUpLogin();
                        },
                        child: Container(
                          width: 268,
                          height: 52,
                          decoration: const BoxDecoration(
                            borderRadius:
                                BorderRadius.all(Radius.circular(100)),
                            color: Color(myBlue),
                            boxShadow: <BoxShadow>[
                              BoxShadow(
                                color: Color(shadowBlue),
                                blurRadius: 20,
                              ),
                            ],
                          ),
                          child: Center(
                            child: Text(
                              state.signInState == SignInState.signup
                                  ? "Create Account"
                                  : "Login",
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 17,
                                letterSpacing: .5,
                              ),
                            ),
                          ),
                        ),
                      ),
                const SizedBox(
                  height: 85,
                ),
                GestureDetector(
                  onTap: () {
                    if (state.signInState == SignInState.login) {
                      state.changeState = SignInState.signup;
                    } else {
                      state.changeState = SignInState.login;
                    }
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        state.signInState != SignInState.signup
                            ? "dont have an account? "
                            : "Already Have an Account? ",
                        style: const TextStyle(
                          fontSize: 14,
                          color: Color(0xFF898989),
                        ),
                      ),
                      Text(
                        state.signInState != SignInState.signup
                            ? "Register"
                            : "Login",
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Color(myBlue),
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class AuthWidget extends StatelessWidget {
  const AuthWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final state = AuthState();
    return ChangeNotifierProvider.value(
      value: state,
      child: const AuthView(),
    );
  }
}
