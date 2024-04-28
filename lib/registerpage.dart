import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get_storage/get_storage.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _storage = GetStorage();
  final _dio = Dio();
  final _apiUrl = 'https://mobileapis.manpits.xyz/api';

  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _passwordController;
  late TextEditingController _confirmPasswordController;
  bool _isPasswordVisible = false;
  bool _isCheckPasswordVisible = false;
  bool _isEmailValid = false;
  bool _isPasswordValid = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
    _confirmPasswordController = TextEditingController();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void goRegister() async {
    if (!_emailController.text.contains("@gmail.com") ||
        _emailController.text.isEmpty ||
        _passwordController.text.isEmpty ||
        _passwordController.text.length < 6 ||
        _passwordController.text != _confirmPasswordController.text) {
      setState(() {
        _isEmailValid = !_emailController.text.contains("@gmail.com") ||
            _emailController.text.isEmpty;
        _isPasswordValid = _passwordController.text.isEmpty ||
            _passwordController.text.length < 6 ||
            _passwordController.text != _confirmPasswordController.text;
      });
    } else {
      try {
        final _register = await _dio.post(
          '${_apiUrl}/register',
          data: {
            'name': _nameController.text,
            'email': _emailController.text,
            'password': _passwordController.text
          },
        );
        final _login = await _dio.post(
          '${_apiUrl}/login',
          data: {
            'email': _emailController.text,
            'password': _passwordController.text
          },
        );
        _storage.write('token', _login.data['data']['token']);
        print(_register.data);
        print(_login.data);
        final _userInfo = await _dio.get(
          '${_apiUrl}/user',
          options: Options(
            headers: {'Authorization': 'Bearer ${_storage.read('token')}'},
          ),
        );
        _storage.write('id', _userInfo.data['data']['user']['id']);
        _storage.write('email', _userInfo.data['data']['user']['email']);
        _storage.write('name', _userInfo.data['data']['user']['name']);
        print(_storage.read('id'));
        print(_storage.read('email'));
        print(_storage.read('name'));
        Navigator.pushReplacementNamed(context, '/home');
      } on DioException catch (e) {
        print('Error response: ${e.response}');
        print('Error code: ${e.response?.statusCode}');
        print('Error message: ${e.message}');
        print('${e.response} - ${e.response?.statusCode}');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(
            Icons.arrow_back_ios,
            size: 20,
            color: Colors.black,
          ),
        ),
        systemOverlayStyle: SystemUiOverlayStyle.dark,
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 40),
          height: MediaQuery.of(context).size.height - 50,
          width: double.infinity,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Column(
                  children: <Widget>[
                    Text(
                      "Sign up",
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Text(
                      "Create an account, It's free ",
                      style: TextStyle(fontSize: 15, color: Colors.grey[700]),
                    )
                  ],
                ),
                SizedBox(height: 10),
                Column(
                  children: <Widget>[
                    TextField(
                      controller: _nameController,
                      decoration: InputDecoration(
                        labelText: "Username",
                        hintText: "Enter your username",
                        hintStyle: TextStyle(
                          color: Colors.grey,
                          fontSize: 14.0,
                        ),
                        labelStyle: TextStyle(
                            color: Colors.black,
                            fontSize: 15,
                            fontWeight: FontWeight.w400),
                        prefixIcon: Icon(Icons.person,
                            color: Colors.blue.shade400, size: 20),
                        contentPadding:
                            EdgeInsets.symmetric(vertical: 0, horizontal: 10),
                        border: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey.shade400),
                        ),
                      ),
                      onChanged: (value) {
                        print(_nameController.text);
                      },
                    ),
                    SizedBox(height: 15),
                    TextField(
                      controller: _emailController,
                      decoration: InputDecoration(
                        labelText: "Email",
                        hintText: "Example@gmail.com",
                        hintStyle: TextStyle(
                          color: Colors.grey,
                          fontSize: 14.0,
                        ),
                        labelStyle: TextStyle(
                            color: Colors.black,
                            fontSize: 15,
                            fontWeight: FontWeight.w400),
                        prefixIcon: Icon(Icons.email,
                            color: Colors.blue.shade400, size: 20),
                        errorText:
                            _isEmailValid ? "Please enter a valid email" : null,
                        errorStyle: TextStyle(
                          fontSize: 12.0,
                        ),
                        contentPadding:
                            EdgeInsets.symmetric(vertical: 0, horizontal: 10),
                        border: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey.shade400),
                        ),
                      ),
                      onChanged: (value) {
                        print(_emailController.text);
                      },
                    ),
                    SizedBox(height: 15),
                    TextField(
                      controller: _passwordController,
                      decoration: InputDecoration(
                        labelText: "Password",
                        hintText: "Enter your password",
                        hintStyle: TextStyle(
                          color: Colors.grey,
                          fontSize: 14.0,
                        ),
                        labelStyle: TextStyle(
                            color: Colors.black,
                            fontSize: 15,
                            fontWeight: FontWeight.w400),
                        prefixIcon: Icon(Icons.key,
                            color: Colors.blue.shade400, size: 20),
                        errorText:
                            _isPasswordValid ? "Passwords do not match" : null,
                        errorStyle: TextStyle(
                          fontSize: 12.0,
                        ),
                        contentPadding:
                            EdgeInsets.symmetric(vertical: 0, horizontal: 10),
                        border: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey.shade400),
                        ),
                        suffixIcon: InkWell(
                          onTap: () {
                            setState(() {
                              _isPasswordVisible = !_isPasswordVisible;
                            });
                          },
                          child: Icon(
                            _isPasswordVisible
                                ? Icons.visibility
                                : Icons.visibility_off,
                            color: Colors.grey,
                          ),
                        ),
                      ),
                      obscureText: !_isPasswordVisible,
                    ),
                    SizedBox(height: 15),
                    TextField(
                      controller: _confirmPasswordController,
                      decoration: InputDecoration(
                        labelText: "Confirm Password",
                        hintText: "Re-enter your password",
                        hintStyle: TextStyle(
                          color: Colors.grey,
                          fontSize: 14.0,
                        ),
                        labelStyle: TextStyle(
                            color: Colors.black,
                            fontSize: 15,
                            fontWeight: FontWeight.w400),
                        prefixIcon: Icon(Icons.key,
                            color: Colors.blue.shade400, size: 20),
                        errorText:
                            _isPasswordValid ? "Passwords do not match" : null,
                        errorStyle: TextStyle(
                          fontSize: 12.0,
                        ),
                        contentPadding:
                            EdgeInsets.symmetric(vertical: 0, horizontal: 10),
                        border: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey.shade400),
                        ),
                        suffixIcon: InkWell(
                          onTap: () {
                            setState(() {
                              _isCheckPasswordVisible =
                                  !_isCheckPasswordVisible;
                            });
                          },
                          child: Icon(
                            _isCheckPasswordVisible
                                ? Icons.visibility
                                : Icons.visibility_off,
                            color: Colors.grey,
                          ),
                        ),
                      ),
                      obscureText: !_isCheckPasswordVisible,
                    ),
                  ],
                ),
                SizedBox(height: 10),
                InkWell(
                  borderRadius: BorderRadius.circular(50),
                  onTap: () {
                    goRegister();
                  },
                  child: Ink(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(50),
                      border: Border.all(color: Colors.black),
                      color: Color(0xff0095FF),
                    ),
                    child: Container(
                      width: double.infinity,
                      height: 60,
                      alignment: Alignment.center,
                      child: Text(
                        "Sign up",
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 18,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                        child: Container(
                      width: double.maxFinite,
                      height: 1,
                      color: Colors.blue.shade400,
                    )),
                    Text(
                      "  OR  ",
                      style: TextStyle(
                        color: Colors.blue.shade400,
                        fontWeight: FontWeight.w600,
                        fontSize: 18,
                      ),
                    ),
                    Expanded(
                      child: Container(
                        width: double.maxFinite,
                        height: 1,
                        color: Colors.blue.shade400,
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    GestureDetector(
                      child: Container(
                        width: 50,
                        height: 50,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(
                            color: Colors.grey.withOpacity(0.5),
                            width: 1,
                          ),
                        ),
                        child: Image(
                          image: AssetImage("assets/google.png"),
                          width: 30,
                          height: 30,
                        ),
                      ),
                    ),
                    SizedBox(width: 20),
                    GestureDetector(
                      child: Container(
                        width: 50,
                        height: 50,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(
                            color: Colors.grey.withOpacity(0.5),
                            width: 1,
                          ),
                        ),
                        child: IconButton(
                          onPressed: () {},
                          icon: FaIcon(FontAwesomeIcons.facebook),
                          iconSize: 30,
                          color: Colors.blue.shade800,
                        ),
                      ),
                    ),
                    SizedBox(width: 20),
                    GestureDetector(
                      child: Container(
                        width: 50,
                        height: 50,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(
                            color: Colors.grey.withOpacity(0.5),
                            width: 1,
                          ),
                        ),
                        child: IconButton(
                          onPressed: () {},
                          icon: FaIcon(FontAwesomeIcons.github),
                          iconSize: 30,
                          color: Colors.black,
                        ),
                      ),
                    ),
                    SizedBox(width: 20),
                    GestureDetector(
                      onTap: () {},
                      child: Container(
                        width: 50,
                        height: 50,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(
                            color: Colors.grey.withOpacity(0.5),
                            width: 1,
                          ),
                        ),
                        child: Image(
                          image: AssetImage("assets/twitter.png"),
                          width: 30,
                          height: 30,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text("Already have an account? "),
                    InkWell(
                      onTap: () {
                        Navigator.pushNamed(context, '/login');
                      },
                      child: Text(
                        "Login",
                        style: TextStyle(
                          color: Color.fromARGB(255, 42, 165, 226),
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
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
