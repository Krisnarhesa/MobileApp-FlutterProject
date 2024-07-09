import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get_storage/get_storage.dart';

class HomePage extends StatefulWidget {
  HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _storage = GetStorage();
  final _dio = Dio();
  final _apiUrl = 'https://mobileapis.manpits.xyz/api';
  final TextEditingController _searchController = TextEditingController();

  List<dynamic> _anggotas = [];
  List<dynamic> _filteredAnggotas = [];

  @override
  void initState() {
    super.initState();
    getListAnggota();
    _searchController.addListener(_filterAnggotas);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
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
        _anggotas = response.data['data']['anggotas'] ?? [];
        _filteredAnggotas = _anggotas;
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
          String telepon = (anggota['telepon'] ?? "");
          return nama.contains(query) || telepon.contains(query);
        }).toList();
      }
    });
  }

  void _showDeleteConfirmationDialog(BuildContext context, int id) async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Konfirmasi Hapus',
            style: TextStyle(
              color: Color.fromARGB(255, 16, 110, 187),
              fontSize: 20,
              fontWeight: FontWeight.w700,
            ),
          ),
          content: Text(
            'Apakah anda yakin ingin menghapus anggota ini?',
            style: TextStyle(
              fontSize: 16,
              color: Color.fromARGB(255, 16, 110, 187),
              fontWeight: FontWeight.w500,
            ),
          ),
          actions: <Widget>[
            TextButton(
              child:
                  Text('Batal', style: TextStyle(color: Colors.blue.shade400)),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton.icon(
              icon: Icon(Icons.delete, color: Colors.red.shade600),
              label: Text(
                'Hapus',
                style: TextStyle(color: Colors.red.shade600),
              ),
              onPressed: () async {
                Navigator.of(context).pop();
                await deleteAnggota(id);
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

  Future<void> deleteAnggota(int id) async {
    try {
      await _dio.delete(
        '$_apiUrl/anggota/$id',
        options: Options(
          headers: {'Authorization': 'Bearer ${_storage.read('token')}'},
        ),
      );
      // Refresh the list after delete
      await getListAnggota();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Anggota berhasil dihapus'),
        ),
      );
    } catch (e) {
      print(e);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Gagal menghapus anggota'),
        ),
      );
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
                'Manajemen Data Anggota',
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
                                hintText:
                                    'Search anggota by name or phone number',
                                border: InputBorder.none,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  // SizedBox(
                  //   width: 15,
                  // ),
                  // GestureDetector(
                  //   onTap: () {
                  //     Navigator.pushNamed(context, '/profile');
                  //   },
                  //   child: SizedBox(
                  //     width: 35,
                  //     height: 35,
                  //     child: Stack(
                  //       children: [
                  //         Container(
                  //           decoration: BoxDecoration(
                  //             borderRadius: BorderRadius.circular(35 / 2),
                  //           ),
                  //           clipBehavior: Clip.hardEdge,
                  //           child: Image.asset('assets/avatar.jpg'),
                  //         ),
                  //         Positioned(
                  //           right: 0,
                  //           bottom: 0,
                  //           child: Container(
                  //             width: 16,
                  //             height: 16,
                  //             decoration: BoxDecoration(
                  //               borderRadius: BorderRadius.circular(35 / 2),
                  //               color: Color(0xFFD1E7EE),
                  //             ),
                  //             clipBehavior: Clip.hardEdge,
                  //             child: Icon(
                  //               Icons.notifications,
                  //               color: Color(0xFF0095FF),
                  //               size: 12,
                  //             ),
                  //           ),
                  //         ),
                  //       ],
                  //     ),
                  //   ),
                  // ),
                ],
              ),
            ),
            SizedBox(height: 15),
            ListView.builder(
              shrinkWrap: true,
              itemCount: _filteredAnggotas.length,
              itemBuilder: (context, index) {
                final anggota = _filteredAnggotas[index];
                return Padding(
                  padding:
                      const EdgeInsets.only(left: 15, right: 15, bottom: 10),
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
                      subtitle: Text(
                        anggota['telepon'] ?? "",
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.white,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      trailing: Wrap(
                        spacing: 1,
                        children: [
                          Tooltip(
                            message: 'Detail Anggota',
                            child: IconButton(
                              icon: Icon(Icons.info,
                                  color: Colors.white, size: 20),
                              onPressed: () {
                                Navigator.pushNamed(
                                  context,
                                  '/detailanggota',
                                  arguments: anggota,
                                );
                              },
                            ),
                          ),
                          Tooltip(
                            message: 'Edit Anggota',
                            child: IconButton(
                              icon: Icon(Icons.edit,
                                  color: Colors.white, size: 20),
                              onPressed: () {
                                Navigator.pushNamed(
                                  context,
                                  '/editanggota',
                                  arguments: anggota,
                                ).then((_) {
                                  getListAnggota();
                                });
                              },
                            ),
                          ),
                          Tooltip(
                            message: 'Hapus Anggota',
                            child: IconButton(
                              icon: Icon(Icons.delete,
                                  color: Colors.white, size: 20),
                              onPressed: () {
                                _showDeleteConfirmationDialog(
                                  context,
                                  anggota['id'],
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
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, '/addanggota').then((_) {
            getListAnggota();
          });
        },
        backgroundColor: Colors.blue,
        child: Icon(
          Icons.add,
          color: Colors.white,
          size: 30,
        ),
        tooltip: 'Tambah Anggota',
      ),
    );
  }
}
