import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';

class AddTransaksiPage extends StatefulWidget {
  @override
  _AddTransaksiPageState createState() => _AddTransaksiPageState();
}

class _AddTransaksiPageState extends State<AddTransaksiPage> {
  final _storage = GetStorage();
  final _dio = Dio();
  final _apiUrl = 'https://mobileapis.manpits.xyz/api';

  late dynamic anggota;
  bool firstTransactionCompleted = false;

  String _selectedTransactionType = '1';
  TextEditingController _addTransaksiController = TextEditingController();

  double currentBalance = 0.0;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _addTransaksiController.dispose();
    super.dispose();
  }

  void _konfirmasiTransaksi() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Konfirmasi Transaksi',
            style: TextStyle(
              color: Color.fromARGB(255, 16, 110, 187),
              fontSize: 20,
              fontWeight: FontWeight.w700,
            ),
          ),
          content: Text(
            'Apakah anda yakin ingin melakukan transaksi ini?',
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
                  Text('Batal', style: TextStyle(color: Colors.red.shade600)),
            ),
            TextButton.icon(
              icon: Icon(Icons.check_circle, color: Colors.blue.shade400),
              label: Text(
                'Ya',
                style: TextStyle(color: Colors.blue.shade400),
              ),
              onPressed: () {
                goAddTransaksi();
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

  Future<void> goAddTransaksi() async {
    final trxNominal = double.tryParse(_addTransaksiController.text);
    // Validasi jika input nominal tidak valid
    if (trxNominal == null || trxNominal <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Nominal transaksi tidak valid'),
        ),
      );
      return;
    }

    // Validasi saldo awal hanya bisa dilakukan sekali dan saldo awal harus 0 saat pertama kali
    if (_selectedTransactionType == '1' && currentBalance != 0.0) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Saldo awal hanya bisa dilakukan sekali'),
        ),
      );
      return;
    }

    // Validasi penarikan tidak boleh melebihi saldo
    if (_selectedTransactionType == '3' && trxNominal > currentBalance) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Penarikan tidak boleh melebihi saldo'),
        ),
      );
      return;
    }

    // Validasi koreksi penambahan tidak boleh negatif
    if (_selectedTransactionType == '5' && trxNominal < 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Koreksi penambahan tidak boleh negatif'),
        ),
      );
      return;
    }

    // Validasi koreksi pengurangan tidak boleh negatif
    if (_selectedTransactionType == '6' && trxNominal < 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Koreksi pengurangan tidak boleh negatif'),
        ),
      );
      return;
    }

    // Validasi saldo awal harus 0 saat pertama kali
    if (!firstTransactionCompleted && _selectedTransactionType != '1') {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Saldo awal harus dilakukan terlebih dahulu'),
        ),
      );
      return;
    }

    try {
      final response = await _dio.post(
        '$_apiUrl/tabungan',
        data: {
          'anggota_id': anggota['id'],
          'trx_id': _selectedTransactionType,
          'trx_nominal': trxNominal.toString(),
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

      // Setelah saldo awal dilakukan, set firstTransactionCompleted menjadi true
      if (_selectedTransactionType == '1') {
        setState(() {
          firstTransactionCompleted = true;
        });
      }

      Navigator.pushReplacementNamed(context, '/transaksi');
    } on DioError catch (e) {
      print('Error: ${e.response?.statusCode} - ${e.response?.data}');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Transaksi Gagal: ${e.response?.statusCode}'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // Inisialisasi anggota dari arguments saat build()
    anggota = ModalRoute.of(context)?.settings.arguments ?? {};
    return Scaffold(
      appBar: AppBar(
        title: Text('Tambah Transaksi'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(height: 20),
              Center(
                child: CircleAvatar(
                  radius: 50,
                  backgroundColor: Colors.blue,
                  child: Icon(
                    Icons.account_balance_wallet,
                    size: 50,
                    color: Colors.white,
                  ),
                ),
              ),
              SizedBox(height: 20),
              TextField(
                controller: TextEditingController(text: anggota['nama'] ?? ''),
                readOnly: true,
                decoration: InputDecoration(
                  labelText: 'Nama Anggota',
                  labelStyle: TextStyle(
                    color: Colors.black,
                    fontSize: 15,
                    fontWeight: FontWeight.w400,
                  ),
                  prefixIcon: Icon(
                    Icons.person,
                    color: Colors.blue.shade400,
                    size: 20,
                  ),
                  contentPadding:
                      EdgeInsets.symmetric(vertical: 0, horizontal: 10),
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey.shade400),
                  ),
                ),
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
                  DropdownMenuItem(
                      value: '5', child: Text('Koreksi Penambahan')),
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
                controller: _addTransaksiController,
                decoration: InputDecoration(
                  labelText: 'Jumlah Transaksi',
                  labelStyle: TextStyle(
                    color: Colors.black,
                    fontSize: 15,
                    fontWeight: FontWeight.w400,
                  ),
                  prefixIcon: Icon(
                    Icons.money,
                    color: Colors.blue.shade400,
                    size: 20,
                  ),
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
                  _konfirmasiTransaksi();
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
      ),
    );
  }
}
