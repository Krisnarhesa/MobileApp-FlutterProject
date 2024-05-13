import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}
  class _ProfilePageState extends State<ProfilePage> {
  final _storage = GetStorage();
  final _dio = Dio();
  final _apiUrl = 'https://mobileapis.manpits.xyz/api';

  void goLogout() async {
    try {
      final _response = await _dio.get(
        '${_apiUrl}/logout',
        options: Options(
          headers: {'Authorization': 'Bearer ${_storage.read('token')}'},
        ),
      );
      print(_response.data);
      _storage.erase();
      Navigator.pushReplacementNamed(context, '/');
    } on DioException catch (e) {
      print('${e.response} - ${e.response?.statusCode}');
    }
  }

  @override
  Widget build(BuildContext context) {
    String _name = _storage.read('name') ?? '';
    String _email = _storage.read('email') ?? '';
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: goLogout,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Center(
              child: CircleAvatar(
                radius: 50,
                backgroundColor:
                    Colors.blue, // Ubah warna latar belakang sesuai kebutuhan
                child: Text(
                  _name.isNotEmpty ? _name[0].toUpperCase() : '',
                  style: TextStyle(
                      fontSize: 32,
                      color: Colors.white), // Ubah warna teks sesuai kebutuhan
                ),
              ),
            ),
            SizedBox(height: 20),
            Text(
              'Name:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Text(
              _name,
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 10),
            Text(
              'Email:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Text(
              _email,
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}

