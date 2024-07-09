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
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Berhasil Logout'),
        ),
      );
      Navigator.pushReplacementNamed(context, '/');
    } on DioException catch (e) {
      print('${e.response} - ${e.response?.statusCode}');
    }
  }

  //Logout Alert Dialog
  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Konfirmasi Logout',
            style: TextStyle(
              color: Color.fromARGB(255, 16, 110, 187),
              fontSize: 20,
              fontWeight: FontWeight.w700,
            ),
          ),
          content: Text(
            'Apakah anda yakin ingin logout?',
            style: TextStyle(
              fontSize: 16,
              color: Color.fromARGB(255, 16, 110, 187),
              fontWeight: FontWeight.w500,
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child:
                  Text('Batal', style: TextStyle(color: Colors.blue.shade400)),
            ),
            TextButton.icon(
              icon: Icon(Icons.logout_outlined, color: Colors.red.shade600),
              label: Text(
                'Logout',
                style: TextStyle(color: Colors.red.shade600),
              ),
              onPressed: () {
                goLogout();
              },
            ),
          ],
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    String _name = _storage.read('name') ?? '';
    String _email = _storage.read('email') ?? '';
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(80.0),
        child: AppBar(
          backgroundColor: Colors.blue.shade400,
          automaticallyImplyLeading: false,
          elevation: 0,
          toolbarHeight: 71,
          title: Container(
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Color.fromARGB(255, 0, 134, 231),
              borderRadius: BorderRadius.circular(30),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                InkWell(
                  onTap: () {
                    Navigator.pushNamed(context, '/home');
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    decoration: BoxDecoration(
                      color: ModalRoute.of(context)?.settings.name == '/home'
                          ? Colors.white
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(100),
                    ),
                    child: Text(
                      'Anggota',
                      style: TextStyle(
                        fontSize: 14,
                        color: ModalRoute.of(context)?.settings.name == '/home'
                            ? Colors.blue.shade400
                            : Colors.white,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
                ...['Transaksi', 'Bunga', 'Profile'].map(
                  (title) {
                    return InkWell(
                      onTap: () {
                        // Navigate to different screens based on the title
                        if (title == 'Transaksi') {
                          Navigator.pushNamed(context, '/transaksi');
                        } else if (title == 'Bunga') {
                          Navigator.pushNamed(context, '/bunga');
                        } else if (title == 'Profile') {
                          Navigator.pushNamed(context, '/profile');
                        }
                      },
                      child: Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        decoration: BoxDecoration(
                          color: ModalRoute.of(context)?.settings.name ==
                                  '/${title.toLowerCase()}'
                              ? Colors.white
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(100),
                        ),
                        child: Text(
                          title,
                          style: TextStyle(
                            fontSize: 14,
                            color: ModalRoute.of(context)?.settings.name ==
                                    '/${title.toLowerCase()}'
                                ? Colors.blue.shade400
                                : Colors.white,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    );
                  },
                ).toList(),
              ],
            ),
          ),
          // actions: [
          //   IconButton(
          //     icon: Icon(Icons.logout_outlined),
          //     onPressed: () {
          //       _showLogoutDialog();
          //     },
          //   ),
          // ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 20),
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
            Card(
              elevation: 3,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              child: ListTile(
                title: Text(
                  'Name',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.blue.shade400,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                subtitle: Text(
                  _name,
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
              ),
            ),
            SizedBox(height: 10),
            Card(
              elevation: 3,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              child: ListTile(
                title: Text(
                  'Email',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.blue.shade400,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                subtitle: Text(
                  _email,
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
              ),
            ),
            SizedBox(height: 50),
            Center(
              child: InkWell(
                borderRadius: BorderRadius.circular(10),
                onTap: () {
                  _showLogoutDialog();
                },
                child: Ink(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.black),
                    color: Color(0xff0095FF),
                  ),
                  width: 150,
                  height: 50,
                  child: Center(
                    child: Text(
                      "Logout",
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 18,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
