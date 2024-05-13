import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';

class EditAnggotaPage extends StatefulWidget {
  @override
  _EditAnggotaPageState createState() => _EditAnggotaPageState();
}

class _EditAnggotaPageState extends State<EditAnggotaPage> {
  final _storage = GetStorage();
  final _dio = Dio();
  final _apiUrl = 'https://mobileapis.manpits.xyz/api';
  late dynamic anggota;

  TextEditingController _nomerIndukController = TextEditingController();
  TextEditingController _teleponController = TextEditingController();
  TextEditingController _namaController = TextEditingController();
  TextEditingController _alamatController = TextEditingController();
  TextEditingController _tglLahirController = TextEditingController();

  @override
  void dispose() {
    _nomerIndukController.dispose();
    _teleponController.dispose();
    _namaController.dispose();
    _alamatController.dispose();
    _tglLahirController.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Get anggota data from argument
    anggota = ModalRoute.of(context)?.settings.arguments;
    // Set anggota data to text controller
    _nomerIndukController.text = anggota['nomor_induk'].toString();
    _teleponController.text = anggota['telepon'];
    _namaController.text = anggota['nama'];
    _alamatController.text = anggota['alamat'];
    _tglLahirController.text = anggota['tgl_lahir'];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Anggota'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _nomerIndukController,
              decoration: InputDecoration(labelText: 'Nomer Induk'),
            ),
            TextField(
              controller: _teleponController,
              decoration: InputDecoration(labelText: 'Telepon'),
            ),
            TextField(
              controller: _namaController,
              decoration: InputDecoration(labelText: 'Nama'),
            ),
            TextField(
              controller: _alamatController,
              decoration: InputDecoration(labelText: 'Alamat'),
            ),
            TextField(
              controller: _tglLahirController,
              decoration: InputDecoration(labelText: 'Tanggal Lahir'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                editAnggota(
                  anggota['id'],
                  _nomerIndukController.text,
                  _teleponController.text,
                  _namaController.text,
                  _alamatController.text,
                  _tglLahirController.text,
                );
              },
              child: Text('Simpan Perubahan'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> editAnggota(
    int id,
    String nomerInduk,
    String telepon,
    String nama,
    String alamat,
    String tglLahir,
  ) async {
    try {
      final _response = await _dio.put(
        '$_apiUrl/anggota/${id}',
        data: {
          'nomor_induk': nomerInduk,
          'nama': nama,
          'alamat': alamat,
          'tgl_lahir': tglLahir,
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
          content: Text('Perubahan berhasil disimpan'),
        ),
      );
      Navigator.pop(context);
      Navigator.pushReplacementNamed(context, '/home');
    } on DioException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Gagal menyimpan perubahan'),
        ),
      );
      print('${e.response} - ${e.response?.statusCode}');
    }
  }
}
