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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tambah Anggota'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView(
          children: [
            TextField(
              decoration: InputDecoration(labelText: 'Nomor Induk'),
              controller: nomorIndukController,
              onChanged: (value) {
                setState(() {
                  nomer_induk = value;
                });
              },
            ),
            TextField(
              decoration: InputDecoration(labelText: 'Nama'),
              controller: namaController,
              onChanged: (value) {
                setState(() {
                  nama = value;
                });
              },
            ),
            TextField(
              decoration: InputDecoration(labelText: 'Alamat'),
              controller: alamatController,
              onChanged: (value) {
                setState(() {
                  alamat = value;
                });
              },
            ),
            TextField(
              decoration: InputDecoration(labelText: 'Tanggal Lahir'),
              controller: tanggalLahirController,
              onChanged: (value) {
                setState(() {
                  tgl_lahir = value;
                });
              },
            ),
            TextField(
              decoration: InputDecoration(labelText: 'Telepon'),
              controller: teleponController,
              onChanged: (value) {
                setState(() {
                  telepon = value;
                });
              },
            ),
            ElevatedButton(
              onPressed: () {
                AddAnggota(
                  context,
                  nomorIndukController.text,
                  teleponController.text,
                  namaController.text,
                  alamatController.text,
                  tanggalLahirController.text,
                );
              },
              child: Text('Simpan'),
            ),
          ],
        ),
      ),
    );
  }
}
