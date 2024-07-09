import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';

class AddAnggotaPage extends StatefulWidget {
  @override
  _AddAnggotaPageState createState() => _AddAnggotaPageState();
}

final _storage = GetStorage();
final _dio = Dio();
final _apiUrl = 'https://mobileapis.manpits.xyz/api';
String nomer_induk = '';
String telepon = '';
String nama = '';
String alamat = '';
String tgl_lahir = '';

void AddAnggota(context, nomer_induk, telepon, nama, alamat, tgl_lahir) async {
  print('createAnggota');
  print('nomer_induk: ${nomer_induk}');
  print('telepon: ${telepon}');
  print('nama: ${nama}');
  print('alamat: ${alamat}');
  print('tgl_lahir: ${tgl_lahir}');
  try {
    final _response = await _dio.post(
      '${_apiUrl}/anggota',
      data: {
        'nomor_induk': nomer_induk,
        'nama': nama,
        'alamat': alamat,
        'tgl_lahir': tgl_lahir,
        'telepon': telepon,
        'status_aktif': 1,
      },
      options: Options(
        headers: {'Authorization': 'Bearer ${_storage.read('token')}'},
      ),
    );
    print(_response.data);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Anggota berhasil ditambahkan'),
        duration: Duration(seconds: 3),
      ),
    );
    Navigator.pop(context);
    Navigator.pushReplacementNamed(context, '/home');
  } on DioException catch (e) {
    print('${e.response} - ${e.response?.statusCode}');
  }
}

class _AddAnggotaPageState extends State<AddAnggotaPage> {
  TextEditingController nomorIndukController = TextEditingController();
  TextEditingController namaController = TextEditingController();
  TextEditingController alamatController = TextEditingController();
  TextEditingController tanggalLahirController = TextEditingController();
  TextEditingController teleponController = TextEditingController();

  @override
  void dispose() {
    nomorIndukController.dispose();
    namaController.dispose();
    alamatController.dispose();
    tanggalLahirController.dispose();
    teleponController.dispose();
    super.dispose();
  }

  String generateNomorInduk(String telepon, String tglLahir) {
    return telepon + tglLahir.replaceAll('-', '');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tambah Anggota'),
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
                child: Icon(
                  Icons.person_add,
                  size: 50,
                  color: Colors.white,
                ),
              ),
            ),
            SizedBox(height: 15),
            TextField(
              readOnly: true,
              controller: nomorIndukController,
              decoration: InputDecoration(
                labelText: 'Nomor Induk',
                hintText: 'Nomor Induk akan Terisi otomatis',
                hintStyle: TextStyle(
                  color: Colors.grey,
                  fontSize: 14.0,
                ),
                labelStyle: TextStyle(
                    color: Colors.black,
                    fontSize: 15,
                    fontWeight: FontWeight.w400),
                prefixIcon:
                    Icon(Icons.numbers, color: Colors.blue.shade400, size: 20),
                contentPadding:
                    EdgeInsets.symmetric(vertical: 0, horizontal: 10),
                border: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey.shade400),
                ),
              ),
            ),
            SizedBox(height: 15),
            TextField(
              controller: namaController,
              decoration: InputDecoration(
                labelText: 'Nama',
                hintText: 'Enter your nama',
                hintStyle: TextStyle(
                  color: Colors.grey,
                  fontSize: 14.0,
                ),
                labelStyle: TextStyle(
                    color: Colors.black,
                    fontSize: 15,
                    fontWeight: FontWeight.w400),
                prefixIcon:
                    Icon(Icons.person, color: Colors.blue.shade400, size: 20),
                contentPadding:
                    EdgeInsets.symmetric(vertical: 0, horizontal: 10),
                border: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey.shade400),
                ),
              ),
              onChanged: (value) {
                setState(() {
                  nama = value;
                });
              },
            ),
            SizedBox(height: 15),
            TextField(
              controller: alamatController,
              decoration: InputDecoration(
                labelText: 'Alamat',
                hintText: 'Enter your alamat',
                hintStyle: TextStyle(
                  color: Colors.grey,
                  fontSize: 14.0,
                ),
                labelStyle: TextStyle(
                    color: Colors.black,
                    fontSize: 15,
                    fontWeight: FontWeight.w400),
                prefixIcon:
                    Icon(Icons.home, color: Colors.blue.shade400, size: 20),
                contentPadding:
                    EdgeInsets.symmetric(vertical: 0, horizontal: 10),
                border: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey.shade400),
                ),
              ),
              onChanged: (value) {
                setState(() {
                  alamat = value;
                });
              },
            ),
            SizedBox(height: 15),
            TextField(
              readOnly: true,
              controller: tanggalLahirController,
              decoration: InputDecoration(
                labelText: 'Tanggal Lahir',
                hintText: 'Select your date of birth',
                hintStyle: TextStyle(
                  color: Colors.grey,
                  fontSize: 14.0,
                ),
                labelStyle: TextStyle(
                    color: Colors.black,
                    fontSize: 15,
                    fontWeight: FontWeight.w400),
                prefixIcon: Icon(Icons.date_range,
                    color: Colors.blue.shade400, size: 20),
                suffixIcon: IconButton(
                  icon: Icon(Icons.calendar_today),
                  color: Colors.blue.shade400,
                  onPressed: _showDatePicker,
                ),
                contentPadding:
                    EdgeInsets.symmetric(vertical: 0, horizontal: 10),
                border: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey.shade400),
                ),
              ),
            ),
            SizedBox(height: 15),
            TextField(
              controller: teleponController,
              decoration: InputDecoration(
                labelText: 'Telepon',
                hintText: 'Enter your telepon',
                hintStyle: TextStyle(
                  color: Colors.grey,
                  fontSize: 14.0,
                ),
                labelStyle: TextStyle(
                    color: Colors.black,
                    fontSize: 15,
                    fontWeight: FontWeight.w400),
                prefixIcon: Icon(Icons.phone_rounded,
                    color: Colors.blue.shade400, size: 20),
                contentPadding:
                    EdgeInsets.symmetric(vertical: 0, horizontal: 10),
                border: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey.shade400),
                ),
              ),
              onChanged: (value) {
                setState(() {
                  telepon = value;
                });
              },
            ),
            SizedBox(height: 20),
            InkWell(
              borderRadius: BorderRadius.circular(10),
              onTap: () {
                final generatedNomorInduk = generateNomorInduk(
                  teleponController.text,
                  tanggalLahirController.text,
                );
                AddAnggota(
                  context,
                  generatedNomorInduk,
                  teleponController.text,
                  namaController.text,
                  alamatController.text,
                  tanggalLahirController.text,
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
                    "Simpan",
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 18,
                      color: Colors.white,
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

  void _showDatePicker() {
    showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    ).then((value) {
      if (value != null) {
        setState(() {
          tanggalLahirController.text = value.toString().split(' ')[0];
        });
      }
    });
  }
}
