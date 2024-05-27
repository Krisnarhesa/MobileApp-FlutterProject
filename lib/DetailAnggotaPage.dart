import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';

class DetailAnggotaPage extends StatefulWidget {
  @override
  _DetailAnggotaPageState createState() => _DetailAnggotaPageState();
}

class _DetailAnggotaPageState extends State<DetailAnggotaPage> {
  late dynamic anggota;
  final _storage = GetStorage();
  final _dio = Dio();
  final _apiUrl = 'https://mobileapis.manpits.xyz/api';
  late Future<String> _saldoFuture;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Get anggota data from argument
    anggota = ModalRoute.of(context)?.settings.arguments;
    _saldoFuture = getSaldoAnggota();
  }

  // Fetch saldo anggota
  Future<String> getSaldoAnggota() async {
    try {
      final response = await _dio.get(
        '$_apiUrl/saldo/${anggota['id']}',
        options: Options(
          headers: {'Authorization': 'Bearer ${_storage.read('token')}'},
        ),
      );
      if (response.statusCode == 200 && response.data != null) {
        return response.data['data']['saldo'].toString();
      } else {
        return 'Saldo tidak ditemukan';
      }
    } catch (e) {
      print('Error: $e');
      return 'Gagal mendapatkan saldo anggota';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Detail Anggota'),
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
                  Icons.person,
                  size: 50,
                  color: Colors.white,
                ),
              ),
            ),
            SizedBox(height: 15),
            DetailItem(
              label: 'Nomor Induk',
              value: anggota['nomor_induk'].toString(),
            ),
            DetailItem(
              label: 'Nama',
              value: anggota['nama'],
            ),
            DetailItem(
              label: 'Alamat',
              value: anggota['alamat'],
            ),
            DetailItem(
              label: 'Tanggal Lahir',
              value: anggota['tgl_lahir'],
            ),
            DetailItem(
              label: 'Telepon',
              value: anggota['telepon'],
            ),
            DetailItem(
              label: 'Status Aktif',
              value: anggota['status_aktif'].toString(),
            ),
            FutureBuilder<String>(
              future: _saldoFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator();
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else {
                  return DetailItem(
                    label: 'Saldo',
                    value: snapshot.data ?? 'Tidak ada data',
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}

class DetailItem extends StatelessWidget {
  final String label;
  final String value;

  DetailItem({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: TextField(
        readOnly: true,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(
            color: Colors.black,
            fontSize: 15,
            fontWeight: FontWeight.w400,
          ),
          contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 10),
          border: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.grey.shade400),
          ),
        ),
        controller: TextEditingController(text: value),
      ),
    );
  }
}
