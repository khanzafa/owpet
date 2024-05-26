import 'package:flutter/material.dart';
import 'list_article_screen.dart';

class DetailArtikelPage extends StatefulWidget {
  final Artikel artikel;
  final bool isFavorite;
  final VoidCallback onFavoritePressed;

  DetailArtikelPage({
    required this.artikel,
    required this.isFavorite,
    required this.onFavoritePressed,
  });

  @override
  _DetailArtikelPageState createState() => _DetailArtikelPageState();
}

class _DetailArtikelPageState extends State<DetailArtikelPage> {
  bool isFavorite = false;

  @override
  void initState() {
    super.initState();
    isFavorite = widget.isFavorite;
  }

  void toggleFavorite() {
    setState(() {
      isFavorite = !isFavorite;
    });
    widget.onFavoritePressed();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text('Detail Artikel', style: TextStyle(fontFamily: 'Poppins', fontSize: 32)),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.artikel.title,
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              Text(
                widget.artikel.subtitle,
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
              ),
              Container(
                margin: EdgeInsets.only(top: 8, bottom: 16),
                height: 1,
                color: Colors.grey,
                width: 397,
              ),
              Row(
                children: [
                  Text('by: Bryanka', style: TextStyle(fontSize: 14)),
                  Spacer(),
                  AnimatedSwitcher(
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
                      onPressed: toggleFavorite,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 8),
              ClipRRect(
                borderRadius: BorderRadius.circular(10), // BorderRadius pada gambar
                child: Image.network(
                  widget.artikel.imageUrl,
                  width: 389, // Lebar gambar pada halaman DetailArtikelPage
                  height: 180, // Tinggi gambar pada halaman DetailArtikelPage
                  fit: BoxFit.cover,
                ),
              ),
              SizedBox(height: 16),
              Text(
                widget.artikel.description,
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 16),
              Text(
                'Jika kucing Anda sedang kepanasan, Anda pasti akan melupakan lolongannya dan permintaan perhatian yang terus-menerus. Jika kucing Anda tidak bisa kawin, panasnya akan menjadi sesuatu yang membuat Anda berdua frustasi dan tidak nyaman. Jika kucing Anda bisa kawin, Anda harus bersiap menghadapi kemungkinan melahirkan dua anak kucing dalam setahun Kecuali jika Anda berencana untuk beternak, perawatan kucing terbaik adalah menadulkannya. Ini akan lebih mudah bagi Anda dan juga lebih mudah bagi Anda. Saat kucing Anda sedang "berahi", ia berada dalam masa subur dalam siklus reproduksinya dan sedang mencari pasangan. Seekor kucing biasanya akan mengalami berahi pada musim semi dan musim gugur dan panas ini dapat berlangsung dari beberapa hari hingga beberapa minggu. Seekor kucing biasanya mengalami panas pertama pada usia sekitar 6 bulan, tetapi ada juga yang mengalami panas pertama pada usia 4 bulan. Saat cuaca panas, kucing Anda mungkin lebih penuh kasih sayang, bergesekan dengan furnitur, dinding, dan orang-orang favoritnya. Dia mungkin akan bergesekan dengan bagian belakang tubuhnya dan sering kali mencoba menempatkan posisi kawin dengan bagian belakangnya dan ekor terangkat. Bagian yang paling bermasalah dari panas bagi pemiliknya adalah vokalisasi dan permintaan. Kucing yang sedang berahi akan melolong keras dan terus-menerus serta mencoba menarik perhatian kucing jantan dengan segala cara. Ini dapat menjadi sangat mengganggu, terutama di malam hari. Cara terbaik untuk mengatasi situasi ini adalah dengan memberikan perhatian ekstra kepada kucing Anda dan mengalihkan perhatiannya dengan mainan atau aktivitas lain.',
                style: TextStyle(fontSize: 16),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
