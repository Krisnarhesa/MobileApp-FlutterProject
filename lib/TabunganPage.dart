import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';

class TabunganPage extends StatefulWidget {
  @override
  _TabunganPageState createState() => _TabunganPageState();
}

class _TabunganPageState extends State<TabunganPage> {
  dynamic anggota;
  List<Map<String, dynamic>> _historiTransaksi = [];

  final _storage = GetStorage();
  final _dio = Dio();
  final _apiUrl = 'https://mobileapis.manpits.xyz/api';

  final _nomerIndukController = TextEditingController();
  final _namaController = TextEditingController();

  final Map<int, String> transaksiTypes = {
    1: 'Saldo Awal',
    2: 'Simpanan',
    3: 'Penarikan',
    4: 'Bunga Simpanan',
    5: 'Koreksi Penambahan',
    6: 'Koreksi Pengurangan',
  };

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args = ModalRoute.of(context)?.settings.arguments;
    if (args != null && args is Map<String, dynamic>) {
      setState(() {
        anggota = args;
        _nomerIndukController.text = anggota['nomor_induk'].toString();
        _namaController.text = anggota['nama'];
      });
      getTabunganAnggota();
    } else {
      print('Error: Anggota is null or arguments are not valid');
    }
  }

  // Method untuk mendapatkan data id anggota dan histori transaksi
  void getTabunganAnggota() async {
    final token = _storage.read('token');
    final idAnggota = anggota['id'];

    try {
      final response = await _dio.get(
        '$_apiUrl/tabungan/$idAnggota',
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      if (response.statusCode == 200) {
        print('Response Data: ${response.data}');
        final data = response.data['data'];
        final tabungan = data['tabungan'];
        if (tabungan is List) {
          setState(() {
            _historiTransaksi = List<Map<String, dynamic>>.from(tabungan);
          });
        } else {
          print('Error: Data format is not correct');
        }
      } else {
        print('Error: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

// Fungsi untuk memformat nilai menjadi format rupiah
  String formatRupiah(double value) {
    final formatCurrency =
        NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0);
    return formatCurrency.format(value);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tabungan Anggota'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 40),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(height: 20),
            TextField(
              controller: _nomerIndukController,
              decoration: InputDecoration(
                labelText: 'Nomor Induk',
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
              enabled: false,
            ),
            SizedBox(height: 10),
            TextField(
              controller: _namaController,
              decoration: InputDecoration(
                labelText: 'Nama',
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
              enabled: false,
            ),
            SizedBox(height: 20),
            Text('Histori Transaksi',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(height: 10),
            _historiTransaksi.isEmpty
                ? Center(
                    child:
                        CircularProgressIndicator()) // Menampilkan loading indicator selama memuat data
                : ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: _historiTransaksi.length,
                    itemBuilder: (context, index) {
                      final transaksi = _historiTransaksi[
                          _historiTransaksi.length - 1 - index];
                      final trxType = transaksiTypes[transaksi['trx_id']] ??
                          'Tipe Transaksi Tidak Tersedia';
                      final trxNominal = transaksi['trx_nominal'].toString();
                      final trxTanggal = transaksi['trx_tanggal'] ??
                          'Tanggal Transaksi Tidak Tersedia';

                      Color textColor;
                      IconData iconData;
                      if (trxType == 'Saldo Awal' || trxType == 'Simpanan') {
                        textColor = Colors.green;
                        iconData = Icons
                            .arrow_upward; // Icon panah ke atas untuk simpanan dan saldo awal
                      } else if (trxType == 'Penarikan') {
                        textColor = Colors.red;
                        iconData = Icons
                            .arrow_downward; // Icon panah ke bawah untuk penarikan
                      } else {
                        textColor = Colors.black;
                        iconData = Icons
                            .help; // Default icon jika tidak ada jenis transaksi yang cocok
                      }

                      return ListTile(
                        leading: Icon(
                          iconData,
                          color: textColor,
                        ),
                        title: Text(
                          trxType,
                          style: TextStyle(color: textColor),
                        ),
                        subtitle: Text(
                          formatRupiah(double.parse(trxNominal)),
                          style: TextStyle(color: textColor),
                        ),
                        trailing: Text(
                          trxTanggal,
                          style: TextStyle(color: textColor),
                        ),
                      );
                    },
                  ),
          ],
        ),
      ),
    );
  }
}
