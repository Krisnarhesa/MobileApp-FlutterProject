// transaksi page
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';

class TransaksiPage extends StatefulWidget {
  @override
  _TransaksiPageState createState() => _TransaksiPageState();
}

class _TransaksiPageState extends State<TransaksiPage> {
  final _storage = GetStorage();
  final _dio = Dio();
  final _apiUrl = 'https://mobileapis.manpits.xyz/api';
  List<Map<String, dynamic>> _anggotas = [];
  Map<String, dynamic>? _selectedAnggota;

  String _selectedTransactionType = '1';
  TextEditingController _transaksiController = TextEditingController();

  @override
  void initState() {
    super.initState();
    getListAnggota();
  }

  Future<void> getListAnggota() async {
    try {
      final response = await _dio.get(
        '$_apiUrl/anggota',
        options: Options(
          headers: {'Authorization': 'Bearer ${_storage.read('token')}'},
        ),
      );

      setState(() {
        _anggotas = List<Map<String, dynamic>>.from(
            response.data['data']['anggotas'] ?? []);
      });
    } catch (e) {
      print(e);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Gagal mendapatkan daftar anggota'),
        ),
      );
    }
  }

  @override
  void dispose() {
    _transaksiController.dispose();
    super.dispose();
  }

  Future<void> goTransaksi() async {
    if (_selectedAnggota == null || _transaksiController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Harap isi semua bidang'),
        ),
      );
      return;
    }
    try {
      final response = await _dio.post(
        '$_apiUrl/tabungan',
        data: {
          'anggota_id': _selectedAnggota!['id'],
          'trx_id': _selectedTransactionType,
          'trx_nominal': _transaksiController.text,
        },
        options: Options(
          headers: {'Authorization': 'Bearer ${_storage.read('token')}'},
        ),
      );
      print(response.data);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Transaksi Berhasil'),
        ),
      );
      Navigator.pushReplacementNamed(context, '/home');
    } on DioException catch (e) {
      print('${e.response} - ${e.response?.statusCode}');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Transaksi Gagal: ${e.response?.statusCode}'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Transaksi Anggota'),
      ),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 40),
        height: MediaQuery.of(context).size.height - 50,
        width: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(height: 20),
            DropdownButtonFormField<Map<String, dynamic>>(
              value: _selectedAnggota,
              decoration: InputDecoration(
                labelText: 'Nama Anggota',
                border: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey.shade400),
                ),
                contentPadding:
                    EdgeInsets.symmetric(vertical: 0, horizontal: 10),
              ),
              items: _anggotas.map((Map<String, dynamic> anggota) {
                return DropdownMenuItem<Map<String, dynamic>>(
                  value: anggota,
                  child: Text(anggota['nama'] ?? 'Unknown'),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _selectedAnggota = value;
                });
              },
              validator: (value) =>
                  value == null ? 'Harap pilih anggota' : null,
            ),
            SizedBox(height: 20),
            DropdownButtonFormField<String>(
              value: _selectedTransactionType,
              decoration: InputDecoration(
                labelText: 'Jenis Transaksi',
                border: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey.shade400),
                ),
                contentPadding:
                    EdgeInsets.symmetric(vertical: 0, horizontal: 10),
              ),
              items: [
                DropdownMenuItem(value: '1', child: Text('Saldo Awal')),
                DropdownMenuItem(value: '2', child: Text('Simpanan')),
                DropdownMenuItem(value: '3', child: Text('Penarikan')),
                DropdownMenuItem(value: '4', child: Text('Bunga Simpanan')),
                DropdownMenuItem(value: '5', child: Text('Koreksi Penambahan')),
                DropdownMenuItem(
                    value: '6', child: Text('Koreksi Pengurangan')),
              ],
              onChanged: (value) {
                setState(() {
                  _selectedTransactionType = value ?? '1';
                });
              },
            ),
            SizedBox(height: 20),
            TextField(
              controller: _transaksiController,
              decoration: InputDecoration(
                labelText: 'Jumlah Transaksi',
                labelStyle: TextStyle(
                  color: Colors.black,
                  fontSize: 15,
                  fontWeight: FontWeight.w400,
                ),
                prefixIcon:
                    Icon(Icons.money, color: Colors.blue.shade400, size: 20),
                contentPadding:
                    EdgeInsets.symmetric(vertical: 0, horizontal: 10),
                border: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey.shade400),
                ),
              ),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 20),
            InkWell(
              borderRadius: BorderRadius.circular(10),
              onTap: () {
                goTransaksi();
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
                    "Submit Transaksi",
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
}
