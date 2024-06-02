import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:owpet/src/models/article.dart';
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
          icon: Image.asset(
            'assets/images/icon-park-solid_back.png',
            height: 24, // Set height according to your needs
            width: 24, // Set width according to your needs
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Detail Artikel',
          style: GoogleFonts.jua(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),        
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.artikel.title,
                style: GoogleFonts.poppins(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              Text(
                "By: " + widget.artikel.author,
                style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w400),
              ),
              Container(
                margin: EdgeInsets.only(top: 8, bottom: 16),
                height: 1,
                color: Colors.grey,
                width: 397,
              ),
              // Row(
              //   children: [
              //     Text('by: Bryanka', style: TextStyle(fontSize: 14)),
              //     Spacer(),
              //     AnimatedSwitcher(
              //       duration: Duration(milliseconds: 300),
              //       transitionBuilder: (Widget child, Animation<double> animation) {
              //         return ScaleTransition(scale: animation, child: child);
              //       },
              //       child: IconButton(
              //         key: ValueKey<bool>(isFavorite),
              //         icon: Icon(
              //           isFavorite ? Icons.favorite : Icons.favorite_border,
              //           color: isFavorite ? Colors.red : Colors.grey,
              //         ),
              //         onPressed: toggleFavorite,
              //       ),
              //     ),
              //   ],
              // ),
              SizedBox(height: 8),
              ClipRRect(
                borderRadius: BorderRadius.circular(10), // BorderRadius pada gambar
                child: Image.network(
                  widget.artikel.imageUrl?? 'https://source.unsplash.com/random/?pet',
                  width: 389, // Lebar gambar pada halaman DetailArtikelPage
                  height: 180, // Tinggi gambar pada halaman DetailArtikelPage
                  fit: BoxFit.cover,
                ),
              ),
              SizedBox(height: 16),
              Text(
                widget.artikel.description,
                style: GoogleFonts.poppins(fontSize: 16),
              ),              
            ],
          ),
        ),
      ),
    );
  }
}
