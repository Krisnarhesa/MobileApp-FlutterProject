import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class HomePage extends StatefulWidget {
  HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
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
              children: [
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(100),
                  ),
                  child: Text(
                    'Beranda',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.blue.shade400,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                SizedBox(width: 10),
                ...['Promo', 'Pesanan', 'Chat'].map(
                  (title) => Flexible(
                    fit: FlexFit.loose,
                    child: Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                      child: Center(
                        child: Text(
                          title,
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
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
                          Text(
                            'Cari layanan, produk, & tujuan',
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 15,
                  ),
                  SizedBox(
                    width: 35,
                    height: 35,
                    child: Stack(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(35 / 2),
                          ),
                          clipBehavior: Clip.hardEdge,
                          child: Image.asset('assets/avatar.jpg'),
                        ),
                        Positioned(
                          right: 0,
                          bottom: 0,
                          child: Container(
                            width: 16,
                            height: 16,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(35 / 2),
                              color: Color(0xFFD1E7EE),
                            ),
                            clipBehavior: Clip.hardEdge,
                            child: Icon(
                              Icons.notifications,
                              color: Color(0xFF0095FF),
                              size: 12,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.only(
                left: 15,
                right: 15,
                top: 15,
              ),
              child: Container(
                height: 96,
                decoration: BoxDecoration(
                  color: Color.fromARGB(255, 16, 110, 187),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(left: 10, right: 8),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            width: 2,
                            height: 8,
                            decoration: BoxDecoration(
                              color: Color(0xFFBBBBBB),
                              borderRadius: BorderRadius.circular(1),
                            ),
                          ),
                          SizedBox(
                            height: 4,
                          ),
                          Container(
                            width: 2,
                            height: 8,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(1),
                            ),
                          )
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 8),
                      child: Column(
                        children: [
                          Container(
                            height: 11,
                            width: 118,
                            decoration: BoxDecoration(
                              color: Color(0xFF9CCDDB),
                              borderRadius: BorderRadius.vertical(
                                bottom: Radius.circular(8),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Container(
                            height: 68,
                            width: 127,
                            padding: EdgeInsets.symmetric(
                              horizontal: 6,
                              vertical: 8,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Saldo Anda',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w900,
                                  ),
                                ),
                                Text(
                                  'Rp22.073',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 15,
                                    fontWeight: FontWeight.w900,
                                  ),
                                ),
                                Text(
                                  'Klik & cek riwayat',
                                  style: TextStyle(
                                    color: Color(0xff0095FF),
                                    fontSize: 10,
                                    fontWeight: FontWeight.w900,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(),
                    Flexible(
                      fit: FlexFit.tight,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  width: 24,
                                  height: 24,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Icon(
                                    Icons.arrow_upward,
                                    color: Color(0xFF0095FF),
                                  ),
                                ),
                                SizedBox(height: 5),
                                Text(
                                  'Bayar',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(width: 20),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  width: 24,
                                  height: 24,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Icon(
                                    Icons.add,
                                    color: Color(0xFF0095FF),
                                  ),
                                ),
                                SizedBox(height: 5),
                                Text(
                                  'Top Up',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(width: 20),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  width: 24,
                                  height: 24,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Icon(
                                    Icons.explore,
                                    color: Color(0xFF0095FF),
                                  ),
                                ),
                                SizedBox(height: 5),
                                Text(
                                  'Explore',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 27, right: 27, top: 32),
              child: SizedBox(
                height: 157,
                child: GridView.count(
                  crossAxisCount: 4,
                  mainAxisSpacing: 8,
                  children: [
                    {'icon': 'goclub', 'title': 'Go Club'},
                    {'icon': 'gofood', 'title': 'Go Food'},
                    {'icon': 'goride', 'title': 'Go Ride'},
                    {'icon': 'gocar', 'title': 'Go Car'},
                    {'icon': 'gopulsa', 'title': 'Go Pulsa'},
                    {'icon': 'gomart', 'title': 'Go Mart'},
                    {'icon': 'gosend', 'title': 'Go Send'},
                    {'icon': 'other', 'title': 'Other'},
                  ]
                      .map((icon) => Column(
                            children: [
                              Container(
                                width: 40,
                                height: 40,
                                decoration: BoxDecoration(
                                  color: Colors.grey.shade200,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: SvgPicture.asset(
                                  'assets/icons/${icon['icon']}.svg',
                                  color: Colors.blue.shade400,
                                  width: 24,
                                ),
                              ),
                              const SizedBox(height: 9),
                              Text(
                                icon['title']!,
                                style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.w500),
                              ),
                            ],
                          ))
                      .toList(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
