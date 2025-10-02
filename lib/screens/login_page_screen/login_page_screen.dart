import 'package:assessment/bloc/auth_bloc.dart';
import 'package:assessment/bloc/auth_state.dart';
import 'package:assessment/core/utils/navigator_service.dart';
import 'package:assessment/routes/app_routes.dart';
import 'package:assessment/widgets/loading_widget.dart';

import 'bloc/login_page_bloc.dart';
import 'models/login_page_model.dart';
import 'package:assessment/core/app_export.dart';
import 'package:flutter/material.dart';

// ignore_for_file: must_be_immutable
class LoginPageScreen extends StatefulWidget {
  LoginPageScreen({Key? key}) : super(key: key);

  static Widget builder(BuildContext context) {
    return BlocProvider<LoginPageBloc>(
      create: (context) =>
          LoginPageBloc(LoginPageState())
            ..add(LoginPageInitialEvent()),
      child: LoginPageScreen(),
    );
  }

  @override
  State<LoginPageScreen> createState() => _LoginPageScreenState();
}

class _LoginPageScreenState extends State<LoginPageScreen> {
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  onForgot() {}

  onKycRegister() {

  }

  final _emailController = TextEditingController();

  final _passwordController = TextEditingController();

  final _emailRegex = RegExp(r"^[^@\s]+@[^@\s]+\.[^@\s]+$");

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _onLoginPressed() {
    setState(() {
      isLoading=true;
    });

    if (_formKey.currentState?.validate() ?? false) {
      final email = _emailController.text.trim();
      final password = _passwordController.text;
print("Email:$email");
      if(email=="flutter@gmail.com" && password=="123456"){
        PrefUtils().setLoggedInUserId("1");
        PrefUtils().setToken("fake_token_user1");
        NavigatorService.popAndPushNamed(AppRoutes.homeScreen);
      }else if(email=="flutter1@gmail.com" && password=="123456"){
        PrefUtils().setToken("fake_token_user2");
        PrefUtils().setLoggedInUserId("2");
        NavigatorService.popAndPushNamed(AppRoutes.homeScreen);
      }else{
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text("Invalid UserId/Password")));
      }
      setState(() {
        isLoading=false;
      });
    }else{
      setState(() {
        isLoading=false;
      });
    }
  }
  bool isLoading=false;

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
          automaticallyImplyLeading: false, // hides back arrow
          title: const Text('Login')),
      body:Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextFormField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(labelText: 'Email'),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) return 'Email is required';
                  if (!_emailRegex.hasMatch(value.trim())) return 'Enter a valid email';
                  return null;
                },
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _passwordController,
                obscureText: true,
                decoration: const InputDecoration(labelText: 'Password'),
                validator: (value) {
                  if (value == null || value.isEmpty) return 'Password is required';
                  if (value.length < 4) return 'Password must be at least 4 characters';
                  return null;
                },
              ),
              const SizedBox(height: 24),
             SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: isLoading ? null : _onLoginPressed,
                      child: isLoading ? const LoadingWidget() : const Text('Login'),
                    ),


              ),

            ],
          ),
        ),
      ),
    );
  }

  /// Calls the https://app.victoriaepay.com/mLogin API and triggers a [CreateMLoginEvent] event on the [LoginPageBloc] bloc.
  ///
  /// Validates the form and triggers a [CreateMLoginEvent] event on the [LoginPageBloc] bloc if the form is valid.
  /// The [BuildContext] parameter represents current [BuildContext]
  loginApiCall(BuildContext context) {
    if (_formKey.currentState!.validate()) {
      context.read<LoginPageBloc>().add(
        CreateMLoginEvent(
          onCreateMLoginEventSuccess: () {
            _onMLoginPostFunctionEventSuccess(context);
          },
          onCreateMLoginEventError: () {
            _onMLoginPostFunctionEventError(context);
          },
        ),
      );
    }
  }

  /// Navigates to the veifyLoginScreen when the action is triggered.
  void _onMLoginPostFunctionEventSuccess(BuildContext context) {
    //OTP Disbaled
    NavigatorService.pushNamedAndRemoveUntil(
      AppRoutes.homeScreen,
    );
    //OTP Enabled
    /*NavigatorService.pushNamed(
      AppRoutes.veifyLoginScreen,
    );*/
  }

  /// Displays a snackBar message when the action is triggered.
  /// The data is retrieved from the `PostMLoginPostFunctionResp` property of the
  /// `LoginPageBloc` using the `context.read` method.}
  void _onMLoginPostFunctionEventError(BuildContext context) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text("Invalid UserId/Password")));
  }
}
