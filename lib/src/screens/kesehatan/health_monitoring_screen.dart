import 'package:flutter/material.dart';
import 'package:owpet/src/services/health_service.dart';
import 'package:owpet/src/widgets/monitoring_item.dart';
import 'package:flutter_calendar_carousel/flutter_calendar_carousel.dart';

class HealthMonitoringScreen extends StatefulWidget {
  final String petId;

  HealthMonitoringScreen({required this.petId});

  @override
  _HealthMonitoringScreenState createState() => _HealthMonitoringScreenState();
}

class _HealthMonitoringScreenState extends State<HealthMonitoringScreen> {
  List<bool> _taskStatus = [];
  List<String> _tasks = [];
  DateTime _selectedDate = DateTime.now();
  Map<DateTime, int> _completedTasksPerDate = {};

  static const List<String> _descriptions = [
    //Deskripsi perawatan mata
    '''
Mata Kucing memiliki ciri-ciri yang unik dan spesial, di mana setiap ras dapat memiliki warna yang berbeda.

Mata hewan yang sehat umumnya tampak jernih dan cerah, memungkinkannya untuk waspada terhadap lingkungan sekitarnya.

Bagian putih mata harus terlihat bersih tanpa adanya kekuningan atau kemerahan yang mengindikasikan masalah kesehatan.

Kucing seringkali menyipitkan mata atau mengedipkan satu mata bisa menjadi tanda adanya cedera pada mata, seperti benda asing atau goresan.

Kemerahan pada selaput merah muda yang melapisi kelopak mata dapat menandakan adanya konjungtivitis, yang seringkali sulit diobati.

Bila terdapat masalah dengan mata kucing, disarankan untuk segera berkonsultasi dengan dokter hewan untuk diagnosis dan penanganan yang tepat.
    ''',
    //Deskripsi perawatan telinga
    '''
• Perlangkapan yang Diperlukan:
    a. Bantalan tapis.
    b. Cairan pembersih telinga khusus kucing.
    c. Handuk atau selimut untuk membungkus kucing jika perlu.

• Langkah-langkah Perawatan:
    a. Persiapan:
      • Gendong kucing dengan lembut di pangkuan.
      • Gunakan handuk atau selimut untuk membungkus kucing jika aman.

    b. Pemeriksaan Awal:
      • Periksa telinga kucing untuk kotoran, bintitan, atau bau busuk.
      • Jika terdapat tanda infeksi atau masalah, segera hubungi dokter hewan.
    
    c. Pembersihan:
      • Jika telinga kucing sehat, tarik telinganya dengan hati-hati.
      • Teteskan beberapa tetes cairan pembersih ke dalam telinga.
    
    d. Pijatan Lembut:
      • Pijat perlahan bagian luar telinga, terutama bagian pangkal, untuk menyebarkan cairan pembersih ke seluruh bagian dalam telinga.

    e. Reaksi Kucing:
      • Kucing mungkin akan menggelengkan kepala, yang bisa menyebabkan cairan pembersih terciprat ke bulu. Ini normal dan tidak berbahaya.

    f. Membersihkan Kotoran:
      • Gunakan kapas untuk membersihkan kotoran dari telinga kucing.
      • Jangan memasukkan apapun ke dalam liang telinga.
    ''',
    //Deskripsi perawatan gigi
    '''
1. Kenalkan Pasta Gigi:
  • Biarkan kucing mencicipi pasta gigi.
  • Oleskan pasta gigi pada sikat dan gosokkan ke gigi serta gusi kucing.

2. Alternatif Sikat Gigi:
  • Jika kucing tidak nyaman dengan sikat gigi, gunakan kain kasa yang dililitkan di jari telunjuk untuk menggosok.

3. Jangan Paksa Mulut Kucing:
  • Angkat bibir kucing perlahan dan gosok gigi menggunakan sikat gigi atau kain kasa.

4. Gerakan Melingkar:
  • Gosok gigi kucing perlahan dengan gerakan melingkar.

5. Perhatikan Kenyamanan Kucing:
  • Jika kucing tidak nyaman dan menghindar, hentikan dan lanjutkan keesokan harinya.
    ''',
    //Deskripsi perawatan kulit dan bulu
    '''
• Rutin Menyikat atau Menyisir Bulu Kucing

• Menyikat secara teratur membantu menghilangkan bulu mati dan mendorong pertumbuhan bulu baru.

• Beberapa kucing membutuhkan lebih banyak perawatan daripada yang lain, tergantung pada jenis bulu.
• Kebutuhan Nutrisi untuk Kucing
  a. Protein
    • Penting untuk pertumbuhan bulu kucing yang lebat.
  b. Mineral
    • Zinc adalah mineral penting untuk pertumbuhan bulu.
  c. Vitamin
    • Kekurangan vitamin dapat menyebabkan alopecia (rambut rontok) dan gangguan pada sistem kekebalan tubuh kucing.
    ''',
    //Deskripsi perawatan kuku
    '''
• Bersihkan kaki kucing setiap hari dengan kain basah.
• Periksa sela-sela jari untuk kotoran atau benda asing.
• Bersihkan segera jika kucing menginjak zat berbahaya.
• Periksa apakah ada luka, goresan, atau benda asing.
• Cuci luka kecil dengan sabun lembut.
• Bawa ke dokter hewan jika ada cedera serius.
• Sediakan berbagai permukaan untuk menggaruk.
• Gunakan penggaruk yang dibeli atau buatan sendiri.
• Sediakan minimal satu penggaruk per kucing, plus satu ekstra.

• Potong Kuku Kucing Secara Teratur
• Potong kuku setiap beberapa minggu.
• Gunakan pemotong kuku tajam, hindari bagian merah (quick).
• Potong kuku dalam beberapa sesi jika perlu.

• Potong Bulu di Antara Jari Kucing
• Untuk kucing berbulu panjang, potong bulu di antara jari jika mengganggu dengan gunting berujung bulat.

• Lindungi Bantalan Kaki
• Hindari permukaan yang panas, dingin, atau korosif.
• Periksa keberadaan pecahan kaca atau benda tajam.
• Pastikan lingkungan berjalan yang aman.
    ''',
    //Deskripsi mandi
    '''
Cara Memandikan Kucing yang Benar

1. Pilih Waktu Mandi yang Tepat
  • Pastikan kucing dalam keadaan sehat dan mood yang baik.
  • Berikan makanan atau ajak bermain terlebih dahulu agar kucing lebih rileks.

2. Potong Kuku Kucing Sebelum Mandi
  • Potong kuku kucing saat mereka tenang untuk menghindari cakaran.
  • Berikan belaian agar kucing merasa nyaman, lalu potong kuku dengan lembut.
  • Hindari memotong terlalu pendek untuk mencegah pendarahan dan rasa sakit.

3. Siapkan Peralatan Mandi
  • Siapkan sampo khusus kucing, handuk, dan sikat bulu yang lembut.

4. Basahi Tubuh Kucing dengan Air Hangat
  • Bawa kucing ke tempat mandi dan basahi tubuhnya dengan air hangat.
  • Hindari mengarahkan semprotan atau shower ke mata, telinga, dan hidung kucing.

5. Gunakan Sampo Khusus Kucing
  • Usapkan sampo ke seluruh tubuh kucing, mulai dari kaki hingga leher.
  • Pastikan sampo tidak mengenai mata kucing.
    ''',
  ];

  @override
  void initState() {
    super.initState();
    _loadTasks();
    _fetchCompletedTasks();
  }

  Future<void> _loadTasks() async {
    try {
      print('Loading tasks...');
      List<String> tasks = await HealthProgressService().getTasks(widget.petId);
      List<bool> taskStatus = await HealthProgressService()
          .getTaskProgress(widget.petId, _selectedDate);
      if (taskStatus.length != tasks.length) {
        taskStatus = List.filled(tasks.length, false);
      }
      setState(() {
        _tasks = tasks;
        _taskStatus = taskStatus;
      });
    } catch (e) {
      print('Error loading tasks: $e');
      // Or handle the error appropriately
    }
  }

  void _saveHealthProgress(int index, bool value) async {
    try {
      // Update nilai progres pada indeks yang sesuai dalam _taskStatus
      setState(() {
        _taskStatus[index] = value;
      });

      // Hitung jumlah task yang diselesaikan pada tanggal _selectedDate
      int completedTasks = _getCompletedTasksForDate(_selectedDate);

      // Update _completedTasksPerDate dengan jumlah task yang diselesaikan pada _selectedDate
      setState(() {
        _completedTasksPerDate[_selectedDate] = completedTasks;
      });

      // Simpan progres ke Firestore
      await HealthProgressService()
          .updateTaskProgress(widget.petId, _selectedDate, index, value);
    } catch (e) {
      print('Error saving progress: $e');
    }
  }

  int _getCompletedTasksForDate(DateTime date) {
    int completedTasks = 0;

    // Iterasi melalui _taskStatus dan hitung jumlah nilai true pada tanggal yang sesuai
    for (int i = 0; i < _taskStatus.length; i++) {
      if (_taskStatus[i]) {
        completedTasks++;
      }
    }

    return completedTasks;
  }

  Future<void> _fetchCompletedTasks() async {
    try {
      // Ambil data task yang diselesaikan dari Firestore
      Map<DateTime, int> completedTasks =
          await HealthProgressService().getCompletedTasks(widget.petId);

      // Inisialisasi _completedTasksPerDate dengan data yang diambil
      setState(() {
        _completedTasksPerDate = completedTasks;
      });
    } catch (e) {
      print('Error fetching completed tasks: $e');
    }
  }

  void _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime.now().subtract(Duration(days: 7)),
      lastDate: DateTime.now(),
    );
    if (pickedDate != null && pickedDate != _selectedDate) {
      setState(() {
        _selectedDate = pickedDate;
        _loadTasks();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(236, 234, 255, 1.0),
        centerTitle: true,
        title: const Text(
          'Kesehatan',
          style: TextStyle(fontSize: 32),
        ),
      ),
      body: _tasks.isNotEmpty && _taskStatus.isNotEmpty
          ? Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 28.0),
                  child: ElevatedButton(
                    onPressed: () => _selectDate(context),
                    child: Text(
                        'Select Date: ${_selectedDate.toString().split(' ')[0]}'),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(28.0),
                  child: Container(
                    height: 360, // Tinggi tetap
                    decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          color: Color(0x000000).withOpacity(1),
                          offset: Offset(0, 7),
                          blurRadius: 15,
                          spreadRadius: -10,
                        )
                      ],
                      borderRadius: BorderRadius.circular(15.0),
                      color: const Color.fromRGBO(
                          236, 234, 255, 1.0), // Latar belakang
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ListView.builder(
                        itemCount: _tasks.length,
                        itemBuilder: (context, index) {
                          return Column(
                            children: [
                              MonitoringItem(
                                title: _tasks[index],
                                isChecked: _taskStatus[index],
                                onChanged: (status) {
                                  _saveHealthProgress(index, status);
                                },
                                index: index,
                              ),
                              if (index < _tasks.length - 1)
                                const SizedBox(
                                  height: 1.0,
                                  child: Divider(
                                    color: Colors.black,
                                    thickness: 1.0,
                                    indent: 10,
                                    endIndent: 10,
                                  ),
                                ),
                            ],
                          );
                        },
                      ),
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: CalendarCarousel(
                    onDayPressed: (DateTime date, List events) {
                      DateTime now = DateTime.now();
                      bool isAfterToday = date.isAfter(now);

                      if (isAfterToday) {
                        return;
                      }

                      setState(() {
                        _selectedDate = date;
                        _loadTasks();
                      });
                    },
                    weekendTextStyle: const TextStyle(
                      color: Colors.red,
                    ),
                    pageSnapping: true,
                    selectedDayBorderColor: Colors.transparent,
                    selectedDayButtonColor: Colors.blue.shade300,
                    selectedDayTextStyle: const TextStyle(color: Colors.white),
                    todayButtonColor: const Color.fromRGBO(49, 50, 54, 1.0),
                    todayBorderColor: Colors.transparent,
                    todayTextStyle: const TextStyle(color: Colors.white),
                    customDayBuilder: (
                      bool isSelectable,
                      int index,
                      bool isSelectedDay,
                      bool isToday,
                      bool isPrevMonthDay,
                      TextStyle textStyle,
                      bool isNextMonthDay,
                      bool isThisMonthDay,
                      DateTime day,
                    ) {
                      int completedTasks = _completedTasksPerDate[day] ?? 0;
                      int totalTasks = 6;

                      DateTime now = DateTime.now();

                      bool isAfterToday = day.isAfter(now);

                      if (isPrevMonthDay || isNextMonthDay || isAfterToday) {
                        return SizedBox(
                          height: 50,
                          width: 50,
                          child: Center(
                            child: Text(
                              day.day.toString(),
                              style: textStyle.copyWith(
                                color: textStyle.color?.withOpacity(0.5),
                                decoration:
                                    isAfterToday ? TextDecoration.none : null,
                              ),
                            ),
                          ),
                        );
                      }

                      double progress =
                          totalTasks > 0 ? (completedTasks / totalTasks) : 0.0;

                      if (isPrevMonthDay || isNextMonthDay) {
                        return SizedBox(
                          height: 50,
                          width: 50,
                          child: Center(
                            child: Text(
                              day.day.toString(),
                              style: textStyle.copyWith(
                                  color: textStyle.color?.withOpacity(0.5)),
                            ),
                          ),
                        );
                      }

                      return SizedBox(
                        height: 50,
                        width: 50,
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            SizedBox(
                              height: 200.0,
                              width: 200.0,
                              child: CircularProgressIndicator(
                                backgroundColor: Colors.grey[300],
                                strokeWidth: 5.0,
                                value: progress,
                                valueColor: const AlwaysStoppedAnimation<Color>(
                                    Color.fromRGBO(139, 128, 255, 1.0)),
                              ),
                            ),
                            Text(
                              day.day.toString(),
                              style: textStyle,
                            ),
                          ],
                        ),
                      );
                    },
                    weekFormat: false,
                    height: 300.0,
                    selectedDateTime: _selectedDate,
                    daysHaveCircularBorder: true,
                  ),
                ),
              ],
            )
          : const Center(
              child: Text('No tasks found. Please add tasks.'),
            ),
    );
  }
}
