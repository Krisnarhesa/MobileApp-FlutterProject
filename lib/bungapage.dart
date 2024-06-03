import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get_storage/get_storage.dart';

class BungaPage extends StatefulWidget {
  @override
  _BungaPageState createState() => _BungaPageState();
}

class _BungaPageState extends State<BungaPage> {
  final _storage = GetStorage();
  final _dio = Dio();
  final _apiUrl = 'https://mobileapis.manpits.xyz/api';
  List<dynamic> _bungas = [];
  String id = '';
  String persen = '';
  String isaktif = '';
  TextEditingController persenController = TextEditingController();
  String dropdownValue = 'Aktif'; // Default value for dropdown

  @override
  void initState() {
    super.initState();
    GetListBunga();
  }

  @override
  void dispose() {
    persenController.dispose();
    super.dispose();
  }

  void AddBunga(context, persen, isaktif) async {
    print('createAnggota');
    print('Persen Bunga: ${persen}');
    print('Status Aktif: ${isaktif}');
    try {
      final _response = await _dio.post(
        '${_apiUrl}/addsettingbunga',
        data: {
          'persen': persen,
          'isaktif': isaktif,
        },
        options: Options(
          headers: {'Authorization': 'Bearer ${_storage.read('token')}'},
        ),
      );
      print(_response.data);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Bunga Berhasil Ditambahkan'),
        ),
      );
      Navigator.pop(context);
      Navigator.pushNamed(context, '/bunga');
    } on DioException catch (e) {
      print('${e.response} - ${e.response?.statusCode}');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Gagal menambahkan bunga'),
        ),
      );
    }
  }

  Future<void> GetListBunga() async {
    try {
      final _response = await _dio.get(
        '${_apiUrl}/settingbunga',
        options: Options(
          headers: {'Authorization': 'Bearer ${_storage.read('token')}'},
        ),
      );
      setState(() {
        _bungas = _response.data['data']['settingbungas'] ?? [];
      });

      print(_response.data);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Berhasil Mendapat List Bunga'),
        ),
      );
    } on DioException catch (e) {
      print('${e.response} - ${e.response?.statusCode}');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Gagal mendapatkan list bunga'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('List bunga & Tambah Bunga'),
      ),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 40),
        height: MediaQuery.of(context).size.height - 50,
        width: double.infinity,
        child: Column(
          children: [
            SizedBox(height: 15),
            Center(
              child: CircleAvatar(
                radius: 50,
                backgroundColor: Colors.blue,
                child: FaIcon(
                  FontAwesomeIcons.coins,
                  size: 50,
                  color: Colors.white,
                ),
              ),
            ),
            SizedBox(height: 15),
            TextField(
              controller: persenController,
              decoration: InputDecoration(
                labelText: 'Persen Bunga',
                hintText: 'Enter your persen bunga',
                hintStyle: TextStyle(
                  color: Colors.grey,
                  fontSize: 14.0,
                ),
                labelStyle: TextStyle(
                    color: Colors.black,
                    fontSize: 15,
                    fontWeight: FontWeight.w400),
                prefixIcon:
                    Icon(Icons.money, color: Colors.blue.shade400, size: 20),
                contentPadding:
                    EdgeInsets.symmetric(vertical: 0, horizontal: 10),
                border: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey.shade400),
                ),
              ),
              onChanged: (value) {
                setState(() {
                  persen = value;
                });
              },
            ),
            SizedBox(height: 15),
            DropdownButtonFormField<String>(
              value: dropdownValue,
              decoration: InputDecoration(
                labelText: 'Status Aktif',
                hintStyle: TextStyle(
                  color: Colors.grey,
                  fontSize: 14.0,
                ),
                labelStyle: TextStyle(
                    color: Colors.black,
                    fontSize: 15,
                    fontWeight: FontWeight.w400),
                prefixIcon: Icon(Icons.check_circle,
                    color: Colors.blue.shade400, size: 20),
                contentPadding:
                    EdgeInsets.symmetric(vertical: 0, horizontal: 10),
                border: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey.shade400),
                ),
              ),
              items: <String>['Aktif', 'Tidak Aktif']
                  .map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  dropdownValue = newValue!;
                  isaktif = newValue == 'Aktif'
                      ? '1'
                      : '0'; // Convert to desired value
                });
              },
            ),
            SizedBox(height: 20),
            InkWell(
              borderRadius: BorderRadius.circular(10),
              onTap: () {
                AddBunga(
                  context,
                  persenController.text,
                  isaktif,
                );
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
                    "Simpan Bunga",
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 18,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 20),
            Row(
              children: [
                Text(
                  'List Bunga',
                  style: TextStyle(
                    color: Color(0xff0095FF),
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(width: 5),
                InkWell(
                  onTap: () {},
                  child: Icon(
                    FontAwesomeIcons.coins,
                    color: Colors.blue.shade400,
                    size: 20,
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            // List Bunga
            Expanded(
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: _bungas.length,
                itemBuilder: (context, index) {
                  final bunga = _bungas[index];
                  // title list bunga
                  return Card(
                    color: Color(0xff0095FF),
                    elevation: 3,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                      side: BorderSide(color: Colors.grey),
                    ),
                    child: ListTile(
                      title: Text(
                        'Persen Bunga: ${bunga['persen']}%',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      trailing: Text(
                        bunga['isaktif'] == 1 ? 'Aktif' : 'Tidak Aktif',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
