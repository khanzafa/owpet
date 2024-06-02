import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:owpet/src/models/article.dart';
import 'package:owpet/src/models/user.dart';
import 'package:owpet/src/services/article_service.dart';
import 'detail_article_screen.dart';

class ArtikelPage extends StatefulWidget {
  final User user;

  ArtikelPage({required this.user});

  @override
  _ArtikelPageState createState() => _ArtikelPageState();
}

class _ArtikelPageState extends State<ArtikelPage> {
  // List<Artikel> artikelList = List.generate(
  //   20,
  //   (index) => Artikel(
  //     imageUrl: 'https://i.pinimg.com/736x/22/d1/9d/22d19d00a4868397cbc09f6e3f763bfd.jpg',
  //     title: 'Kucing Anda Sedang Berahi:',
  //     author: 'Yang Perlu Anda Ketahui',
  //     description: 'Jika kucing Anda sedang kepanasan, Anda pasti akan melupakan lolongannya dan permintaan perhatian yang terus-menerus. Jika kucing Anda tidak bisa kawin, panasnya akan menjadi sesuatu yang membuat Anda berdua frustasi dan tidak nyaman. Jika kucing Anda bisa kawin, Anda harus bersiap menghadapi kemungkinan melahirkan dua anak kucing dalam setahun Kecuali jika Anda berencana untuk beternak, perawatan kucing terbaik adalah menadulkannya. Ini akan lebih mudah bagi Anda dan juga lebih mudah bagi Anda. Saat kucing Anda sedang "berahi", ia berada dalam masa subur dalam siklus reproduksinya dan sedang mencari pasangan. Seekor kucing biasanya akan mengalami berahi pada musim semi dan musim gugur dan panas ini dapat berlangsung dari beberapa hari hingga beberapa minggu. Seekor kucing biasanya mengalami panas pertama pada usia sekitar 6 bulan, tetapi ada juga yang mengalami panas pertama pada usia 4 bulan. Saat cuaca panas, kucing Anda mungkin lebih penuh kasih sayang, bergesekan dengan furnitur, dinding, dan orang-orang favoritnya. Dia mungkin akan bergesekan dengan bagian belakang tubuhnya dan sering kali mencoba menempatkan posisi kawin dengan bagian belakangnya dan ekor terangkat. Bagian yang paling bermasalah dari panas bagi pemiliknya adalah vokalisasi dan permintaan. Kucing yang sedang berahi akan melolong keras dan terus-menerus serta mencoba menarik perhatian kucing jantan dengan segala cara. Ini dapat menjadi sangat mengganggu, terutama di malam hari. Cara terbaik untuk mengatasi situasi ini adalah dengan memberikan perhatian ekstra kepada kucing Anda dan mengalihkan perhatiannya dengan mainan atau aktivitas lain.',
  //     category: 'Healty',
  //   ),
  // );
  final ArticleService articleService = ArticleService();
  List<Artikel> artikelList = [];
  List<Artikel> filteredArtikelList = [];
  List<bool> isFavorite = List.generate(20, (index) => false);
  String searchQuery = '';

  @override
  void initState() {
    super.initState();
    filteredArtikelList = artikelList;
    fetchArtikel();
  }

  Future<void> fetchArtikel() async {
    final articles = await articleService.getArticles();
    setState(() {
      artikelList = articles;
      filteredArtikelList = artikelList;
    });
  }

  void updateSearchQuery(String query) {
    setState(() {
      searchQuery = query;
      filteredArtikelList = artikelList
          .where((artikel) =>
              artikel.title.toLowerCase().contains(query.toLowerCase()) ||
              artikel.author.toLowerCase().contains(query.toLowerCase()) ||
              artikel.description.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Image.asset(
            'assets/images/icon-park-solid_back.png',
            height: 24, // Set height according to your needs
            width: 24, // Set width according to your needs
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Artikel',
          style: GoogleFonts.jua(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),        
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 16.0),
            child: CircleAvatar(
              backgroundImage: Image.network(
                widget.user.photo??'https://source.unsplash.com/random/?person',
              ).image,
            
            ),
          )
        ],
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(48.0), // Mengubah tinggi search bar
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: SizedBox(
              height: 36.0, // Menyesuaikan tinggi search bar
              child: TextField(
                onChanged: updateSearchQuery,
                decoration: InputDecoration(
                  hintText: 'Cari artikel...',
                  hintStyle: TextStyle(height: 1), // Memusatkan teks placeholder
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  filled: true,
                  fillColor: Colors.white,
                  prefixIcon: Icon(Icons.search),
                ),
              ),
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          TabBarWidget(),
          Expanded(
            child: ListView.builder(
              itemCount: filteredArtikelList.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      PageRouteBuilder(
                        pageBuilder: (context, animation, secondaryAnimation) => DetailArtikelPage(
                          artikel: filteredArtikelList[index],
                          isFavorite: isFavorite[index],
                          onFavoritePressed: () {
                            setState(() {
                              isFavorite[index] = !isFavorite[index];
                            });
                          },
                        ),
                        transitionsBuilder: (context, animation, secondaryAnimation, child) {
                          const begin = Offset(1.0, 0.0);
                          const end = Offset.zero;
                          const curve = Curves.ease;

                          var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

                          return SlideTransition(
                            position: animation.drive(tween),
                            child: child,
                          );
                        },
                      ),
                    );
                  },
                  child: ArtikelCard(
                    artikel: filteredArtikelList[index],
                    isFavorite: isFavorite[index],
                    onFavoritePressed: () {
                      setState(() {
                        isFavorite[index] = !isFavorite[index];
                      });
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class TabBarWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: TabBar(
        tabs: [
          Tab(text: 'General'),
          Tab(text: 'Favorite'),
          Tab(text: 'Healty'),
          Tab(text: 'Treatment'),
        ],
        labelColor: Colors.black,
        unselectedLabelColor: Colors.grey,
      ),
    );
  }
}

class ArtikelCard extends StatelessWidget {
  final Artikel artikel;
  final bool isFavorite;
  final VoidCallback onFavoritePressed;

  ArtikelCard({
    required this.artikel,
    required this.isFavorite,
    required this.onFavoritePressed,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(8.0),
      child: Stack(
        children: [
          Row(
            children: [
              Padding(
                padding: EdgeInsets.all(8.0),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10), // BorderRadius pada gambar
                  child: artikel.imageUrl != null || artikel.imageUrl != ''
                   ? Image.network(
                    artikel.imageUrl??'https://source.unsplash.com/random/?pet',
                    width: 187, 
                    height: 236, 
                    fit: BoxFit.cover,
                  )
                  : Image.network(
                    'https://source.unsplash.com/random/?pet',
                    width: 187, 
                    height: 236, 
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 8), // Memberi ruang untuk ikon love
                    Text(
                      artikel.title,
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      artikel.author,
                      style: TextStyle(fontSize: 14),
                    ),
                    SizedBox(height: 4),
                    Text(
                      artikel.description.length > 100
                          ? artikel.description.substring(0, 100) + '...'
                          : artikel.description,
                      style: TextStyle(fontSize: 12),
                    ),
                  ],
                ),
              ),
            ],
          ),
          Positioned(
            right: 8,
            top: 8,
            child: AnimatedSwitcher(
              duration: Duration(milliseconds: 300),
              transitionBuilder: (Widget child, Animation<double> animation) {
                return ScaleTransition(scale: animation, child: child);
              },
              child: IconButton(
                key: ValueKey<bool>(isFavorite),
                icon: Icon(
                  isFavorite ? Icons.favorite : Icons.favorite_border,
                  color: isFavorite ? Colors.red : Colors.grey,
                ),
                onPressed: onFavoritePressed,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
