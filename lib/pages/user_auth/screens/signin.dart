import 'dart:math';

import 'package:easypos/common/widgets/email_textfield.dart';
import 'package:easypos/common/widgets/password_textfield.dart';
import 'package:easypos/core/failure.dart';
import 'package:easypos/data/datasources/firebase/firebase_auth_repo_impl.dart';
import 'package:easypos/models/auth_model.dart';
import 'package:easypos/pages/user_auth/screens/signup.dart';
import 'package:easypos/pages/user_dashboard/screens/user_dashboard.dart';
import 'package:easypos/utils/app_colors.dart';
import 'package:easypos/utils/app_textstyles.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';


class SignInView extends StatefulWidget {
   const SignInView({super.key});

  @override
  State<SignInView> createState() => _SignInViewState();
}

class _SignInViewState extends State<SignInView> {
  final _signInFormKey = GlobalKey<FormState>();

  final TextEditingController _userEmailController = TextEditingController();

  final TextEditingController _passwordController = TextEditingController();

  //final TextEditingController _confirmPasswordController = TextEditingController();

  // focusnodes
  // late FocusNode _emailFocusNode, _passwordFocusNode, _confirmPasswordFocusNode;

  @override
  void initState() {
    // TODO: implement initState
    // _emailFocusNode = FocusNode();
    // _passwordFocusNode = FocusNode();
    // _confirmPasswordFocusNode = FocusNode();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder:(context,constraints) => GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Scaffold(
          backgroundColor: AppColors().appBackgroundColor(context: context),
          body: Center(
            child: SingleChildScrollView(
              keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
              padding: const EdgeInsets.all(16),
              child: Form(
                key: _signInFormKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  //crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    ShaderMask(
                      shaderCallback: (Rect bounds) {
                        return const LinearGradient(
                          colors: [Colors.orange, Colors.yellow],
                        ).createShader(bounds);
                      },
                      blendMode: BlendMode.srcATop,
                      child: Text("EasyPos", style: AppTextStyle().boldHeader(context: context),)
                    ),
                    const SizedBox(height: 60),
                    Container(
                      height: 75,
                      width: min(550, constraints.maxWidth),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10)
                      ),
                      child: EmailTextfield(
                        maxLines: 1,
                        controller: _userEmailController,
                        hintText: "your@example.com",
                        labelText: "Email",
                        onChanged: (value) {},
                        validationCheck: (text) {
                          
                        },
                    )),
                    const SizedBox(height: 12),
                    Container(
                      height: 75,
                      width: min(550, constraints.maxWidth),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10)
                      ),
                      child: PasswordTextfield(
                        maxLines: 1,
                        controller: _passwordController,
                        hintText: "453dftaker44@",
                        labelText: "Password",
                        onChanged: (value) {},
                        validationCheck: (text) {
                          
                        },
                    ),
                    ),
                    const SizedBox(height: 20),
                    InkWell(
                      onTap: () async{
                        if(_signInFormKey.currentState!.validate()) {
                          await signIn();
                        }
                      },
                      child: Container(
                        width: min(300, constraints.maxWidth),
                        decoration: BoxDecoration(
                          color: AppColors().appButtonBackgroundColor(context: context),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        height: 48,
                        child: Center(child:  Text('Login',style: TextStyle(color: AppColors().appButtonContentColor(context: context), fontWeight: FontWeight.bold,fontSize: 20),)),
                      )
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).push(MaterialPageRoute(builder: (context)=>const SignUpView()));
                      },
                      child: const Center(child: Text('Dont have an account? SignUp here.')),
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

  Future<void> signIn() async{
    AuthModel authModel = AuthModel(email: _userEmailController.text.trim(), emailVerified: false, password: _passwordController.text.trim());
    final result = await FirebaseAuthRepoImpl().signIn(authModel: authModel);
    result.fold(
      (dataFailure) {
        if(dataFailure.failure == Failure.socketFailure) {
          Fluttertoast.showToast(msg: "You are offline. Check your internet connection");
        }
        if(dataFailure.failure == Failure.severFailure) {
          Fluttertoast.showToast(msg: "Failure: Server failed.");
        } else {
          Fluttertoast.showToast(msg: dataFailure.message);
        }
      } ,
      (success) {
        Fluttertoast.showToast(msg: "Welcome back.");
        Future.delayed(const Duration(seconds: 2));
        Navigator.of(context)
          .pushAndRemoveUntil(MaterialPageRoute(builder: (context)=>const UserDashboard()), (route) => false);
      }
    );
  }
}