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

  TextEditingController nomerIndukController = TextEditingController();
  TextEditingController teleponController = TextEditingController();
  TextEditingController namaController = TextEditingController();
  TextEditingController alamatController = TextEditingController();
  TextEditingController tglLahirController = TextEditingController();
  TextEditingController statusController = TextEditingController();

  @override
  void dispose() {
    nomerIndukController.dispose();
    teleponController.dispose();
    namaController.dispose();
    alamatController.dispose();
    tglLahirController.dispose();
    statusController.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Get anggota data from argument
    anggota = ModalRoute.of(context)?.settings.arguments;
    // Set anggota data to text controller
    nomerIndukController.text = anggota['nomor_induk'].toString();
    teleponController.text = anggota['telepon'];
    namaController.text = anggota['nama'];
    alamatController.text = anggota['alamat'];
    tglLahirController.text = anggota['tgl_lahir'];
    statusController.text = anggota['status_aktif'].toString();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Anggota'),
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
            TextField(
              controller: nomerIndukController,
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
            ),
            SizedBox(height: 15),
            TextField(
              controller: namaController,
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
            ),
            SizedBox(height: 15),
            TextField(
              controller: alamatController,
              decoration: InputDecoration(
                labelText: 'Alamat',
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
            ),
            SizedBox(height: 15),
            TextField(
              readOnly: true,
              controller: tglLahirController,
              decoration: InputDecoration(
                labelText: 'Tanggal Lahir',
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
            ),
            SizedBox(height: 20),
            TextField(
              controller: statusController,
              decoration: InputDecoration(
                labelText: 'Status Aktif',
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
            ),
            SizedBox(height: 20),
            InkWell(
              borderRadius: BorderRadius.circular(10),
              onTap: () {
                editAnggota(
                  anggota['id'],
                  nomerIndukController.text,
                  teleponController.text,
                  namaController.text,
                  alamatController.text,
                  tglLahirController.text,
                  statusController.text,
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
                    "Simpan Perubahan",
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

  Future<void> editAnggota(
    int id,
    String nomerInduk,
    String telepon,
    String nama,
    String alamat,
    String tglLahir,
    String statusAktif,
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
          'status_aktif': statusAktif,
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

  void _showDatePicker() {
    showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    ).then((value) {
      if (value != null) {
        setState(() {
          tglLahirController.text = value.toString().split(' ')[0];
        });
      }
    });
  }
}
