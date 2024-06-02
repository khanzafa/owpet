import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:owpet/src/models/article.dart';

class ArticleService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  Future<List<Artikel>> getArticles() async {
    var snapshot = await _db.collection('articles').get();
    if (snapshot.docs.isEmpty) {
      return [];
    }
    snapshot = await _db.collection('articles').get();
    return snapshot.docs.map((doc) {
      final data = doc.data() as Map<String, dynamic>;
      return Artikel.fromJson(data);
    }).toList();
  }

  Future<String> uploadImage(File image) async {
    final ref = _storage.ref().child('articles/${DateTime.now()}.png');
    final uploadTask = ref.putFile(image);
    final snapshot = await uploadTask.whenComplete(() => null);
    return await snapshot.ref.getDownloadURL();
  }

  Future<void> addArticle(Artikel article) async {
    await _db.collection('articles').add({
      'imageUrl': article.imageUrl,
      'title': article.title,
      'author': article.author,
      'description': article.description,
      'category': article.category,
    });
  }

  Future<void> deleteArticle(String id) async {
    await _db.collection('articles').doc(id).delete();
  }

  Future<void> updateArticle(String id, Artikel article) async {
    await _db.collection('articles').doc(id).update({
      'imageUrl': article.imageUrl,
      'title': article.title,
      'subtitle': article.author,
      'description': article.description,
      'category': article.category,
    });
  }

  // Add data dummy
  final dataDummy = [
    Artikel(
      imageUrl: 'https://source.unsplash.com/random/?pet',
      title: 'Manfaat Memelihara Kucing dari Self Healing Hingga Kesehatan',
      author: 'Irfan Fanasafa',
      description:
          'Datangnya era pandemi Covid 19 memaksa bahkan telah merubah pola kehidupan manusia secara luas. Perubahan yang kentara diantaranya pada pola kerja yang sebelumnya mengharuskan kehadiran fisik di kantor menjadi pola kerja hybrid, yaitu adanya pembagian tempat kerja antara kantor, rumah yang dikenal dengan Work From Home (WFH) atau tempat di luar kantor lainnya yang mendukung terlaksananya kegiatan/capaian kinerja yang dikenal dengan istilah Work From Anywhere (WFA).\n\nBekerja tanpa rekan kerja untuk berbagi dan berdialog secara formal maupun emosional misalnya berkeluh kesah atau dikenal dengan ‘curhat’ menjadi tantangan tersendiri bagi para pekerja kantoran maupun non kantoran dalam mengatasi kejenuhan ataupun kendala non teknis lainnya. Diantara cara mengatasi kejenuhan bekerja sendiri baik WFH maupun WFA diantaranya adalah dengan memelihara hewan. Menurut dr. Fadhli Rizal Makarim dalam sebuah tulisannya di halodoc.com memiliki hewan piaraan adalah salah satu cara yang baik untuk mengurangi kecemasan dan stres. Seekor hewan peliharaan bisa menjadi sumber kenyamanan, persahabatan, dan motivasi bagi pemiliknya. Hewan peliharaan juga dapat membantu menjalani kehidupan yang lebih sehat secara mental.\n\nDiantara hewan peliharaan yang umum dan banyak dipelihara adalah kucing. Kucing bagi para pecintanya, adalah hewan yang sangat menyenangkan bahkan menjadi ‘teman setia’ penghilang lelah dan stres setelah seharian bekerja.\n\nMemelihara kucing ternyata bukan hanya sekedar hobi ada beberapa manfaat yang bisa diperoleh, berikut diantaranya yang didapat penulis dari beberapa sumber :\n\nBisa mengurangi resiko terkena serangan jantung. Dari penelitian yang dilakukan, pemilik kucing akan memiliki resiko serangan jantung 30 persen lebih rendah dibanding mereka yang tidak memiliki kucing. Selain itu, pemilik kucing juga memiliki detak jantung yang lebih rendah, tingkat stress kecil dan tekanan darah yang lebih rendah. Menurut Dr Adnan Qureshi, penulis senior studi tersebut, mengatakan, memiliki hewan peliharaan mungkin membantu menghilangkan stres.\n\nPemilik kucing cenderung tidak menderita depresi. Studi telah menemukan bahwa pemilik kucing cenderung tidak menderita depresi, tekanan darah tinggi, trigliserida tinggi dan kadar kolesterol.\n\nDengkuran kucing dapat meningkatkan penyembuhan dan kepadatan tulang. Dengkuran kucing dikatakan sebagai terapi. Menurut penelitian yang dipublikasikan di Scientific American, kucing mendengkur dalam pola yang konsisten antara 25 dan 150 Hertz. Frekuensi ini membantu meningkatkan penyembuhan dan bahkan kepadatan tulang.\n\nKucing membantu pasien dengan berbagai penyakit dengan cara yang unik. Dari sebuah penelitian yang dilakukan, kucing juga bisa membantu pasien Alzheimer untuk lebih stabil. Sedang bagi penderita AIDS, dengan memelihara kucing kecil kemungkinan akan mengalami depresi. Bahkan orang dengan tekanan darah tinggi mampu menavigasi situasi stres dan pasien serangan jantung yang memiliki hewan peliharaan bertahan lebih lama.\n\nTerapi untuk Anak Autisme. Anak-anak yang mengalami autisme umumnya mengalami masalah sensorik. Kegiatan integrasi sensorik dirancang untuk membantu mereka terbiasa dengan sesuatu yang terasa di kulit mereka, bagaimana baunya atau suaranya. Anjing dan kucing adalah jenis hewan yang digunakan untuk tujuan ini. Hasilnya, sebagian besar anak autisme sering merasa tenang saat berkontak langsung dengan hewan. Pada banyak kasus autisme, hewan dapat mengurangi perilaku stereotip, mengurangi sensitivitas sensorik, dan meningkatkan keinginan serta kemampuan untuk terhubung secara sosial dengan orang lain. Namun, hal ini membutuhkan penelitian lebih lanjut.\n\nItulah diantaranya manfaat yang bisa didapatkan ketika Anda memelihara hewan khususnya kucing namun jangan lupa untuk tetap menjaga kesehatan dan kebersihan hewan peliharaan Anda.',
      category: 'Kesehatan',
    ),
    Artikel(
      imageUrl: 'https://source.unsplash.com/random/?pet',
      title: 'Tips dan Cara Perawatan Kucing Kampung yang Benar',
      author: 'Andrawan',
      description:
          'Cara perawatan kucing kampung\nMerawat kucing kampung pada dasarnya sama saja seperti perawatan kucing ras lainnya. Masih belum familiar dengan kucing kampung maupun prosedur perawatannya? Langsung saja, ya! Simak penjelasannya berikut ini:\n\nAjarkan kebiasaan hidup yang baik\nTingkah laku atau kebiasaan kucing kampung hampir sama dengan kucing liar, mengapa? Karena kucing kampung hidup bebas berkeliaran dari satu lingkungan ke lingkungan lainnya. Semua kucing kampung yang bebas, tidak memahami cara buang air kecil atau BAB dengan benar selayaknya anjing atau kucing peliharaan.\n\nTugas kamulah yang mengajarkan atau melatih kebiasaan hidup yang baik pada mereka. Agar prosesnya lebih mudah, kami menyarankan untuk mengadopsi kucing kampung kecil. Ajarkan pada kucing tersebut bagaimana cara buang kotoran yang benar. Bagaimana caranya? Cukup siapkan litter box di rumah. Jangan lupa pula untuk menyediakan kebutuhan lainnya termasuk tempat tidur yang bersih.\n\nRawat kebersihan dan kesehatan anggota tubuh kucing\nPerawatan kucing kampung selanjutnya adalah dengan menjaga kesehatan mereka. Bukan hanya memastikan kucing bebas dari penyakit secara visual tapi benar-benar memeriksakan kesehatannya. Apalagi kucing sangat rentan terhadap penyakit bahkan penyakit kronis seperti kanker atau jantung.\n\nSelain memandikan kucing secara rutin menggunakan sampo khusus pastikan juga untuk membersihkan mata dan telinganya. Jangan biarkan ada cairan mengeras pada mata kucing karena dikhawatirkan dapat mengakibatkan iritasi mata. Rawat juga kesehatan bulu dan kulit kucing agar terhindar dari kutu.\n\nJangan beri makan kucing dengan sayur mayur\nKucing merupakan hewan karnivora alami yang suka mengkonsumsi ikan, daging sapi atau ayam. Tahukah kamu jikalau kucing lebih menyukai makanan mentah daripada matang? Ironisnya lagi, masih banyak orang yang memberi makan kucing sembarangan seperti nasi atau sayuran, padahal mereka tidak mampu memberikan perawatan kucing kampung secara maksimal. Kedua jenis makanan tersebut mungkin baik bagi manusia, tapi tidak untuk kucing. Sistem pencernaan kucing tidak ‘disetting’ untuk mencerna sayuran sebaik daging. Untuk kesehatan dan kenyamanan kucing, baiknya siapkan daging atau makanan kering kucing sebagai camilan mereka.\n\nSikat bulu kucing\nBanyak yang bilang, perawatan kucing kampung sangat rumit dan sulit. Faktanya, merawat kucing kampung jauh lebih mudah dan praktis karena mereka bisa datang kapan saja tanpa diundang. Selain memperhatikan asupan nutrisi kucing, berikan juga treatment menyenangkan dengan menyikat bulu mereka. Belilah sisir sikat bulu kucing khusus untuk digunakan secara teratur. Namun pastikan terlebih dahulu jika kucing kampung yang ada di rumah memiliki bulu lebat. Menyikat bulu kucing membantu kucing merasa lebih nyaman. Kegiatan ini juga bagus untuk menyingkirkan kuman atau rambut mati kucing.\n\nSterilisasi dan Vaksinasi\nKucing kampung tidak suka dikekang, mereka suka sekali bermain di sekitar rumah. Demi kenyamanan kamu dan kesehatan kucing, alangkah baiknya melakukan sterilisasi pada kucing. Spaying atau Neutering, kabarnya mampu meningkatkan usia kucing. Cara ini juga bisa kamu ambil setelah puas dengan jumlah anakan kucing di rumah. Proses sterilisasi dilakukan secara profesional oleh dokter hewan.\n\nTidak hanya melakukan sterilisasi, kamu juga bisa meningkatkan kesehatan kucing dengan memberinya vaksin. Perawatan kucing kampung seperti ini mungkin tergolong mahal, namun bagus untuk meningkatkan sistem imunitas kucing.\n\nManjakan dengan mengajak kucing bermain\nCara perawatan lainnya adalah memanjakan kucing. Kucing merupakan hewan peliharaan malas yang sangat suka ketika diperhatikan. Ajaklah kucing kampung kamu bermain dengan permainan yang dibeli atau buat sendiri. Mengajak kucing bermain tidak hanya memanjakan mereka, tapi juga meningkatkan keakraban di antara kalian. Bila memungkinkan berikan latihan khusus pada kucing kampung seperti belajar mengangkat tangan atau berguling.',
      category: 'Perawatan',
    ),
    Artikel(
      imageUrl: 'https://source.unsplash.com/random/?pet',
      title:
          'Mau Adopsi Kucing? Inilah 7 Kebutuhan Kucing yang Harus Kamu Penuhi',
      author: 'Bambang Musthofa',
      description:
          'Berniat adopsi kucing, artinya kamu juga harus siap untuk memenuhi segala kebutuhan yang mereka miliki. Tidak berbeda seperti manusia, kebutuhan kucing juga sangat banyak, loh. Kucing tidak hanya membutuhkan makan saja, tapi juga fasilitas dan lingkungan yang memadai. Tertarik untuk mengadopsi kucing? Cari tahu dulu macam-macam kebutuhan kucing, mulai dari yang paling sederhana hingga rumit.\n\n7 Kebutuhan Kucing yang Harus Dipenuhi Sebagai makhluk hidup, sudah sepantasnya jika kucing juga diperlakukan dengan baik. Kamu yang berencana mengadopsi kucing, siapkanlah beberapa kebutuhan kucing berikut ini:\n\nPerlengkapan dasar kucing Memelihara kucing, tidak berarti memberikan apa yang tersedia seadanya saja di rumah. Kamu wajib ‘menabung’ untuk belanja beberapa perlengkapan dasar kucing seperti, makanan kucing, keranjang tempat tidur, mangkuk makanan dan air, dan sebagainya. Semua perlengkapan dasar kucing, sudah dijual secara online atau offline. Pastikan kamu sudah memiliki seluruh perlengkapan yang dibutuhkan sebelum kucing sampai ke rumah. Tanpa kebutuhan mendasar tersebut, akan sulit bagi kamu nantinya untuk memelihara kucing secara maksimal.\n\nPeralatan bermain Kebutuhan kucing tidak hanya menyangkut makanan atau fasilitas tempat tinggalnya saja. Mengapa? Sebagai makhluk hidup, kucing juga tertarik untuk bermain atau bermanja dengan tuan-nya, yaitu kamu. Dari banyaknya jenis mainan kucing, pilihlah mainan yang mampu merangsang kucing untuk bergerak. Terlebih jika kucing yang bakal kamu adopsi sangat gemuk, hingga menyulitkannya untuk beraktivitas. Kekucingan, merekomendasikan untuk membeli cat tree. Selain cocok sebagai aksesoris tempat tinggal kucing, jenis produk ini juga sangat berguna untuk melatih kemampuan memanjat, menggaruk, hingga bersembunyi.\n\nTempat tinggal kucing Sebelum membeli berbagai mainan, jangan lupa untuk menyisihkan uang kamu guna belanja tempat tinggal kucing. Sama halnya seperti manusia, kucing juga memiliki territory sendiri. Kamu bisa membuatkan beberapa area seperti tempat istirahatnya atau tempat pemberian makan secara berbeda. Cara ini tidak hanya efektif menciptakan territory kucing tapi juga membuat rumah kamu lebih rapi. Pastikan juga membuat area pembersihan, yakni tempat menempatkan kotak kotoran kucing tersebut. Jika memungkinkan area ini harus dibuat terpisah dengan area makan kucing.\n\nVitamin dan makanan khusus lainnya Kebutuhan kucing lainnya adalah vitamin yang baik untuk menunjang kesehatan kucing. Tahukah kamu apa saja varian nutrisi yang dibutuhkan oleh kucing? Kucing membutuhkan banyak nutrisi seperti asam amino essensial, vitamin D, hingga lemak. Kebutuhan vitamin dan makanan pendamping kucing juga berbeda-beda tergantung usianya. Anak kucing, misalnya, memiliki saluran pencernaan yang lebih sensitif. Maka sebaiknya kamu memberikannya susu khusus. Sementara kucing dewasa bisa mengkonsumsi berbagai jenis makanan dengan porsi yang mencukupi.',
      category: 'Adopsi',
    ),
    Artikel(
      imageUrl: 'https://source.unsplash.com/random/?pet',
      title: 'Kucing Makan Rumput, Masa sih? Beneran ga Ketuker sama Kambing?',
      author: 'Ratu Putri Kartika',
      description:
          'Buat sebagian paw-parents pasti masih merasa kaget dan takjub, kok bisa sih kucing makan rumput? Emang boleh? Emang aman? Emang itu beneran kucing, gak ketuker sama kambing? Tenang, paw-parents. Jangan khawatir. Kekucingan kasih sedikit penjelasan yah. Kucing makan rumput ternyata adalah hal yang sangat lumrah di alam liar. Selain kebiasaan kucing yang sering menggigit banyak hal, dari menggigit sofa sampai makan rumput juga dilakukan kucing dengan beragam alasan. Pertama, kucing menginginkan pengalaman baru. Buat paw-parents mungkin gak lazim, tapi buat kucing, semua hal yang menarik perhatiannya (termasuk rumput) bisa jadi pengalaman dan mainan baru. Seperti yang kita tahu, kucing emang senang banget bermain, kan? Kedua, ada sesuatu yang gak beres di pencernaannya. Perlu diketahui, kucing juga bisa ngerasa gak nyaman di pencernaan. Semacam begah kalau dianalogikan dengan pencernaan manusia. Bisa jadi karena anabul terlalu banyak makan, atau karena bola bulu (hairball) yang tertelan. Nah, makan rumput buat kucing atau yang sering juga disebutrumput gandum, bisa membantu melegakan masalah pencernaannya. Nah, sekarang sudah agak rela bukan, kalau kucing makan rumput? Eits, tapi jangan dikasih sembarang rumput, yah. Biar terjamin keamanannya, paw-parents harus berikan kucing kesayangan Rumput Kucing atau Rumput Gandum yang udah dijamin aman dan direkomendasikan oleh dokter hewan! Udah gitu, cara penanamannya mudah banget lagi. Dengan Paket DIY Rumput Kucing yang tersedia di Kekucingan, kamu cuma tinggal mengikuti langkah-langkahnya berikut ini: Rendam benih semalaman. Tiriskan dan biarkan terlebih dahulu. Taburkan benih di atas media tanam, lalu tutupi tipis-tipis lagi dengan media tanam. Semprot tipis-tipis benih yang sudah tertutupi media tanam setiap hari agar selalu lembab, tapi jangan sampai banjir, ya. Hari ketiga, bibit rumput gandum akan mulai tumbuh. Semprot terus setiap hari hingga dapat dipanen pada hari ke-7. Rumput Kucing ini bisa dipanen dan langsung diberikan ke anabul kesayangan HANYA dalam waktu 7 hari saja. Sangat mudah bikin kucing bebas hairball, lebih sehat, makin sayang dan manja!',
      category: 'Perilaku Kucing',
    ),
    Artikel(
      imageUrl: 'https://source.unsplash.com/random/?pet',
      title: 'Cara Merawat Bulu Kucing Yang Benar Agar Tidak Rontok',
      author: 'Bastian Khalim',
      description:
          'Kucing merupakan hewan peliharaan yang paling menarik perhatian. Entah itu karena penampilannya yang menggemaskan, tingkahnya yang menghibur, hingga kemampuannya untuk bertahan dan setiap bersama pemiliknya. Iya, Kamu!! Namun tentu saja, memelihara kucing memiliki resiko dan konsekuensi pula, salah satunya untuk menjaganya agar terhindar dari berbagai keluhan dan penyakit. Bentuk gangguan yang paling umum dialami oleh pemilik kucing adalah bulu peliharaan yang rontok dan menempel kemana-mana. Kendati ini merupakan perkara yang sangat wajar ditemui, apakah hal ini berbahaya? Jadi, bagaimana ya cara merawat bulu kucing yang benar? Pemicu rontok pada bulu kucing Seperti yang sudah dijelaskan sebelumnya, kendati fenomena kerontokan bulu pada kucing merupakan sesuatu hal yang lumrah, namun Kamu harus cermat untuk mengetahui penyebabnya dengan segera. Berikut beberapa daftar pemicu yang bikin rontok bulu kucing: Terjadi infeksi oleh jamur Percaya atau tidak, bulu kucing yang tebal, lebat dan lembut tak hanya menarik bagi manusia, namun juga bagi jamur. Yap, senyawa mikroba ini sangat nyaman berada dalam bulu yang lembab, dingin, dan jarang terkena matahari. Biasanya gejala infeksi ditunjukkan dengan munculnya bercak di bagian permukaan kulit, dan diikuti dengan kebotakan bulu di area tersebut. Jika gejala ini sudah Kamu temukan, maka segera bawa ke perawatan hewan, sebab area tersebut bisa saja meluas dalam waktu singkat. Disebabkan Tungau dan Kutu Penyebab rontok yang selanjutnya adalah adanya ‘invasi’ kutu dan tungau pada tubuh kucing. Tak hanya hidup di bagian permukaan, kutu dan tungau juga bisa masuk sampai ke lapisan dalam kulit. Tak heran memang bila hal ini mampu membuat kucing menggaruk dengan intens dan sangat keras, sampai bulu-bulunya berserakan kemana-mana. Biasanya gejala adanya kutu dan tungau ini diperlihatkan dari gelagat kucing yang terlihat tak nyaman dan terlampau sering menggaruk beberapa bagian tubuhnya. Nah, dalam kondisi seperti ini, Kamu juga harus tanggap untuk segera membawa kucing ke Vet, ya, sebelum permukaan kulitnya infeksi dan muncul koreng. Menderita alergi Perkara tak cocok dengan lingkungan dan makanannya juga bisa menjadi penyebab utama terjadinya kerontokan bulu. Kucing sangat rentan mengalami alergi terhadap konsumsi suplemen, obat, makanan, minuman, dan penggunaan produk luar yang terlalu keras. Biasanya, gejala alergi ini ditunjukkan dengan kerontokan bulu yang signifikan dan instan, setelah mengkonsumsi allergen. Karena itu, dianjurkan untuk memberikan perawatan pada kucing secara bertahap, agar bisa mengetahui mana saja produk yang sekiranya cocok dan tidak. Mal nutrisi Kekuatan bulu kucing juga dipengaruhi oleh kelengkapan nutrisinya. Tak heran bila kucing yang sehat memiliki intensitas blu rontok yang lebih rendah daripada kucing yang asupannya asal-asalan. Umumnya, kerontokan yang disebabkan oleh kurang nutrisi secara terus-menerus, kendati perilaku kucing tetap normal dan tak menunjukkan keluhan. Merasa tertekan Kucing yang merasa tertekan juga bisa menjadi penyebab terjadinya kerontokan bulu kucing, loh. Perasaan ini umumnya terjadi karena ia merasa tidak kerasan di lingkungannya. Seperti banyaknya gangguan, belum ada ikatan dengan pemilik, merasa takut dan terancam, hingga tak mendapatkan perhatian yang layak dan merasa kesepian. Gejala stress ini bisa ditunjukkan dari kebiasaan kucing yang terlalu sering menjilati tubuhnya, hingga menyebabkan kerontokan bulu. Juga dari tingkahnya yang sensitif dan mudah marah ketika diajak berinteraksi. Ketidakcocokan suhu Hal lain yang menyebabkan kerentanan pada bulu kucing adalah karena adanya ketidakcocokan suhu. Hal ini bisa dipicu oleh keadaan yang terlalu panas ataupun terlalu dingin. Keduanya diketahui bisa menyebabkan akar bulu menjadi rapuh dan gampang rontok. Untuk mengenali terjadinya ketidakcocokan suhu, Kamu bisa memperhatikan bagaimana perilaku kucing saat dibawa dari ruangan bersuhu dingin ke panas, ataupun sebaliknya. Rontok secara periodik Kerontokan bulu pada kucing tak selalu menunjukkan kelainan, sebab hal ini bisa juga disebabkan karena adanya rontok periodik. Biasanya bulu kucing akan berganti tiap 6 bulan sekali. Pada fase ini, folikel bulu yang sudah tua akan dilepaskan dan diganti dengan akar bulu baru yang lembut.',
      category: 'Perawatan Kucing',
    )
  ];

  Future<void> addDummyData() async {
    for (final data in dataDummy) {
      await addArticle(data);
    }
  }
}
