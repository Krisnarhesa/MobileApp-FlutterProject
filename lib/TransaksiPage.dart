// transaksi page
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
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
  List<Map<String, dynamic>> _filteredAnggotas = [];
  TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _filteredAnggotas = _anggotas;
    getListAnggota();
    _searchController.addListener(_filterAnggotas);
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
        _filteredAnggotas = _anggotas; // Update filtered list
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

  void _filterAnggotas() {
    String query = _searchController.text.toLowerCase();
    setState(() {
      if (query.isEmpty) {
        _filteredAnggotas = _anggotas;
      } else {
        _filteredAnggotas = _anggotas.where((anggota) {
          String nama = (anggota['nama'] ?? "").toLowerCase();
          return nama.contains(query);
        }).toList();
      }
    });
  }

  Future<double?> _getSaldoById(int id) async {
    try {
      final response = await _dio.get(
        '$_apiUrl/saldo/$id',
        options: Options(
          headers: {'Authorization': 'Bearer ${_storage.read('token')}'},
        ),
      );
      if (response.statusCode == 200 && response.data != null) {
        return double.tryParse(response.data['data']['saldo'].toString());
      } else {
        return null;
      }
    } catch (e) {
      print('Error fetching saldo: $e');
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
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
        ),
      ),
      body: SingleChildScrollView(
          child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(height: 30),
          Center(
            child: Text(
              'Manajemen Transaksi Anggota',
              style: TextStyle(
                color: Colors.blue.shade400,
                fontSize: 25,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 23, left: 15, right: 15),
            child: Row(
              children: [
                Flexible(
                  fit: FlexFit.tight,
                  child: Container(
                    padding: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Color(0xFFFAFAFA),
                      borderRadius: BorderRadius.circular(30),
                      border: Border.all(color: Color(0xFFE8E8E8)),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.search,
                          color: Colors.black,
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Expanded(
                          child: TextField(
                            controller: _searchController,
                            decoration: InputDecoration(
                              hintText: 'Search anggota by name',
                              border: InputBorder.none,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
          ListView.builder(
            shrinkWrap: true,
            itemCount: _filteredAnggotas.length,
            itemBuilder: (context, index) {
              final anggota = _filteredAnggotas[index];
              return Padding(
                padding: const EdgeInsets.only(left: 15, right: 15, bottom: 10),
                child: Card(
                  color: Color.fromARGB(255, 13, 122, 199),
                  elevation: 3,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                    side: BorderSide(color: Colors.grey),
                  ),
                  child: ListTile(
                    leading: FaIcon(
                      FontAwesomeIcons.user,
                      color: Colors.white,
                      size: 24,
                    ),
                    contentPadding:
                        EdgeInsets.symmetric(vertical: 5, horizontal: 15),
                    title: Text(
                      anggota['nama'] ?? "",
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    subtitle: FutureBuilder<double?>(
                      future: _getSaldoById(anggota['id']),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Text(
                            'Memuat saldo...',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.white,
                              fontWeight: FontWeight.w400,
                            ),
                          );
                        } else if (snapshot.hasError || snapshot.data == null) {
                          return Text(
                            'Gagal memuat saldo',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.white,
                              fontWeight: FontWeight.w400,
                            ),
                          );
                        } else {
                          return Text(
                            snapshot.data!.toString(),
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.white,
                              fontWeight: FontWeight.w400,
                            ),
                          );
                        }
                      },
                    ),
                    trailing: Wrap(
                      spacing: 1,
                      children: [
                        Tooltip(
                          message: 'Tabungan',
                          child: IconButton(
                            icon: FaIcon(
                              FontAwesomeIcons.wallet,
                              color: Colors.white,
                              size: 20,
                            ),
                            onPressed: () {
                              Navigator.pushNamed(
                                context,
                                '/tabungan',
                                arguments: anggota,
                              );
                            },
                          ),
                        ),
                        Tooltip(
                          message: 'Add Transaksi',
                          child: IconButton(
                            icon: FaIcon(
                              FontAwesomeIcons.moneyBillTransfer,
                              color: Colors.white,
                              size: 20,
                            ),
                            onPressed: () {
                              Navigator.pushNamed(
                                context,
                                '/addtransaksi',
                                arguments: anggota,
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      )),
    );
  }
}
