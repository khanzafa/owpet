// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:owpet/src/screens/Makan/meal_monitoring_screen.dart';
// import 'package:owpet/src/screens/add_profile.dart';
// import 'package:owpet/src/screens/Pets/add_pet_screen.dart';
// import 'package:owpet/src/screens/Pets/detail_pet_screen.dart';
// import 'package:owpet/src/services/pet_service.dart';
// import 'package:owpet/src/models/pet.dart';

// class MealChoicePetScreen extends StatelessWidget {
//   final String userId;
//   final PetService petService = PetService();
//   final List<String> categories = [
//     'All',
//     'Anjing',
//     'Kucing',
//     'Kelinci',
//     'Burung'
//   ];

//   MealChoicePetScreen({required this.userId});

//   void _navigateToAddPetScreen(BuildContext context) async {
//     Navigator.push(
//       context,
//       MaterialPageRoute(builder: (context) => AddPetScreen(
//         userId: userId,
//       )),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         // backgroundColor: Color(0xFF8B80FF),
//         title: Text(
//           'Owpets - Hewan Peliharaan',
//           style: GoogleFonts.jua(
//             fontSize: 24,
//             fontWeight: FontWeight.bold,
//             // color: Colors.white,
//           ),
//         ),
//         centerTitle: true,
//         bottom: PreferredSize(
//           preferredSize: Size.fromHeight(41),
//           child: Container(
//             // color: Color(0xFF8B80FF), // Updated background color
//             child: Padding(
//               padding: const EdgeInsets.all(8.0),
//               child: SizedBox(
//                 width: 352,
//                 height: 41,
//                 child: TextField(
//                   decoration: InputDecoration(
//                     hintText: 'Search...',
//                     hintStyle: TextStyle(
//                         color: Colors.black), // Updated hint text color
//                     prefixIcon: Icon(Icons.search,
//                         color: Colors.black), // Updated icon color
//                     filled: true,
//                     fillColor: Color(0xFF8B80FF),
//                     border: OutlineInputBorder(
//                       borderRadius: BorderRadius.circular(20.0),
//                       borderSide: BorderSide.none,
//                     ),
//                     contentPadding: EdgeInsets.symmetric(vertical: 10),
//                   ),
//                 ),
//               ),
//             ),
//           ),
//         ),
//       ),
//       body: Column(
//         crossAxisAlignment: CrossAxisAlignment.stretch,
//         children: [
//           Expanded(
//             child: FutureBuilder<List<Pet>>(
//               future: petService.getMyPets(userId),
//               builder: (context, snapshot) {
//                 if (snapshot.connectionState == ConnectionState.waiting) {
//                   return Center(child: CircularProgressIndicator());
//                 } else if (snapshot.hasError) {
//                   return Center(child: Text('Error: ${snapshot.error}'));
//                 } else if (snapshot.connectionState == ConnectionState.done &&
//                     snapshot.data == null) {
//                   return Center(
//                       child: Text(
//                     textAlign: TextAlign.center,
//                     'Tidak ada hewan peliharaan yang ditemukan. Silakan tambahkan hewan peliharaan baru.',
//                     style: GoogleFonts.poppins(
//                       fontSize: 16,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ));
//                 } else {
//                   List<Pet> myPets = snapshot.data ?? [];
//                   return GridView.builder(
//                     padding: EdgeInsets.all(30),
//                     gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//                       crossAxisCount: 2,
//                       childAspectRatio: 0.7,
//                       crossAxisSpacing: 20,
//                       mainAxisSpacing: 20,
//                     ),
//                     itemCount: myPets.length,
//                     itemBuilder: (context, index) {
//                       Pet pet = myPets[index];
//                       return GestureDetector(
                        // onTap: () {
                        //   Navigator.push(
                        //     context,
                        //     MaterialPageRoute(
                        //       builder: (context) => MealMonitoringScreen(petId: pet.id!),
                        //     ),
                        //   );
                        // },
//                         child: buildPetCard(pet),
//                       );
//                     },
//                   );
//                 }
//               },
//             ),
//           ),
//         ],
//       ),
//       floatingActionButton: Padding(
//         padding: const EdgeInsets.all(20.0),
//         child: FloatingActionButton(
//           onPressed: () => _navigateToAddPetScreen(context),
//           backgroundColor: Color(0xFFFC9340),
//           child: Icon(
//             Icons.add,
//             color: Colors.white,
//           ),
//           tooltip: 'Add New Pet',
//           elevation: 0,
//           shape: CircleBorder(),
//         ),
//       ),
//       floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
//     );
//   }

//   Widget buildCategoryButton(String category) {
//     return FittedBox(
//       child: Container(
//         decoration: BoxDecoration(
//           color: Colors.white, // Updated background color
//           borderRadius: BorderRadius.circular(15),
//         ),
//         child: Padding(
//           padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
//           child: Text(
//             category,
//             style: TextStyle(
//               color: Colors.black, // Updated text color
//               fontSize: 15,
//               fontFamily: 'Jua',
//               fontWeight: FontWeight.w400,
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   Widget buildPetCard(Pet pet) {
//     return AspectRatio(
//       aspectRatio: 0.77,
//       child: Container(
//         decoration: ShapeDecoration(
//           color: Colors.white,
//           shape: RoundedRectangleBorder(
//             side: BorderSide(width: 1, color: Color(0xFF8B80FF)),
//             borderRadius: BorderRadius.circular(15),
//           ),
//         ),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.stretch,
//           children: [
//             Container(
//               decoration: BoxDecoration(
//                 color: Color(0xFF8B80FF),
//                 borderRadius: BorderRadius.only(
//                   topLeft: Radius.circular(15),
//                   topRight: Radius.circular(15),
//                   bottomLeft: Radius.circular(15),
//                   bottomRight: Radius.circular(15),
//                 ),
//               ),
//               child: Center(
//                 child: Padding(
//                   padding: const EdgeInsets.symmetric(vertical: 8),
//                   child: Text(
//                     pet.species?.toUpperCase() ?? 'Unknown',
//                     style: TextStyle(
//                       color: Colors.white,
//                       fontSize: 16,
//                       fontFamily: 'Jua',
//                       fontWeight: FontWeight.w400,
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//             Expanded(
//               child: Center(
//                 child: Column(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     Container(
//                       width: 140,
//                       height: 140,
//                       decoration: ShapeDecoration(
//                         color: Color(0xFF8B80FF),
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(15),
//                         ),
//                       ),
//                       child: ClipRRect(
//                           borderRadius: BorderRadius.circular(15),
//                           child: pet.photoUrl == null
//                               ? Image.asset('assets/images/kucing.png')
//                               : Image.network(pet.photoUrl!,
//                                   fit: BoxFit.cover)),
//                     ),
//                     SizedBox(height: 8),
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                         Text(
//                           pet.name,
//                           style: TextStyle(
//                             color: Colors.black,
//                             fontSize: 24,
//                             fontFamily: 'Jua',
//                             fontWeight: FontWeight.w400,
//                           ),
//                           textAlign: TextAlign.center,
//                         ),
//                         SizedBox(width: 4),
//                         Icon(
//                           pet.gender == 'Jantan' ? Icons.male : Icons.female,
//                           color: pet.gender == 'Betina'
//                               ? Colors.blue
//                               : Colors.pink,
//                         ),
//                       ],
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:owpet/src/models/user.dart';
import 'package:owpet/src/providers/search_provider.dart';
import 'package:owpet/src/screens/Makan/meal_monitoring_screen.dart';
import 'package:owpet/src/screens/add_profile.dart';
import 'package:owpet/src/screens/Pets/add_pet_screen.dart';
import 'package:owpet/src/screens/Pets/detail_pet_screen.dart';
import 'package:owpet/src/services/pet_service.dart';
import 'package:owpet/src/models/pet.dart';
import 'package:provider/provider.dart';

class MealChoicePetScreen extends StatefulWidget {
  final User user;

  MealChoicePetScreen({required this.user});

  @override
  _MealChoicePetScreenState createState() => _MealChoicePetScreenState();
}

class _MealChoicePetScreenState extends State<MealChoicePetScreen> {
  final List<String> categories = ['All', 'Anjing', 'Kucing', 'Kelinci', 'Burung'];
  TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_filterPets);
    _fetchPets();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _fetchPets() async {
    await context.read<SearchProvider>().fetchPets(context, widget.user.id);
  }

  void _filterPets() {
    context.read<SearchProvider>().search(_searchController.text);
  }

  void _navigateToAddPetScreen(BuildContext context) async {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => AddPetScreen(
                userId: widget.user.id,
              )),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        title: Text(
          'Owpets - Hewan Peliharaan',
          style: GoogleFonts.jua(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.only(right: 20, left: 20, top: 8),
            child: SizedBox(
              width: MediaQuery.of(context).size.width * 0.9,
              height: 41,
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: 'Search...',
                  hintStyle: TextStyle(color: Colors.black),
                  prefixIcon: Icon(Icons.search, color: Colors.black),
                  filled: true,
                  fillColor: Color(0xFF8B80FF),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20.0),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: EdgeInsets.symmetric(vertical: 10),
                ),
              ),
            ),
          ),
          Expanded(
            child: Consumer<SearchProvider>(
              builder: (context, provider, child) {
                if (provider.pets.isEmpty) {
                  return Center(
                    child: Text(
                      'Tidak ada hewan peliharaan yang ditemukan. Silakan tambahkan hewan peliharaan baru.',
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  );
                }

                return LayoutBuilder(
                  builder: (context, constraints) {
                    int crossAxisCount = constraints.maxWidth < 600 ? 2 : 4;

                    return GridView.builder(
                      padding: EdgeInsets.all(30),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: crossAxisCount,
                        childAspectRatio: 0.7,
                        crossAxisSpacing: 20,
                        mainAxisSpacing: 20,
                      ),
                      itemCount: provider.pets.length,
                      itemBuilder: (context, index) {
                        Pet pet = provider.pets[index];
                        return GestureDetector(
                           onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => MealMonitoringScreen(petId: pet.id!),
                            ),
                          );
                        },
                          child: buildPetCard(pet),
                        );
                      },
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.all(20.0),
        child: FloatingActionButton(
          onPressed: () => _navigateToAddPetScreen(context),
          backgroundColor: Color(0xFFFC9340),
          child: Icon(
            Icons.add,
            color: Colors.white,
          ),
          tooltip: 'Add New Pet',
          elevation: 0,
          shape: CircleBorder(),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }

  Widget buildPetCard(Pet pet) {
    return AspectRatio(
      aspectRatio: 0.77,
      child: LayoutBuilder(
        builder: (context, constraints) {
          double cardHeight = constraints.maxHeight;
          double cardWidth = constraints.maxWidth;
          double imageSize =
              cardHeight * 0.5; // Adjust image size relative to card height

          return Container(
            decoration: ShapeDecoration(
              color: Colors.white,
              shape: RoundedRectangleBorder(
                side: BorderSide(width: 1, color: Color(0xFF8B80FF)),
                borderRadius: BorderRadius.circular(15),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Container(
                  width: cardWidth,
                  height: cardHeight * 0.2,
                  decoration: BoxDecoration(
                    color: Color(0xFF8B80FF),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(15),
                      topRight: Radius.circular(15),
                    ),
                  ),
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: Text(
                          textAlign: TextAlign.center,
                          pet.species?.toUpperCase() ?? 'Unknown',
                          style: GoogleFonts.jua(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          )),
                    ),
                  ),
                ),
                Expanded(
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: imageSize,
                          height: imageSize,
                          decoration: ShapeDecoration(
                            color: Color(0xFF8B80FF),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(15),
                            child: pet.photoUrl == null
                                ? Image.asset('assets/images/kucing.png',
                                    fit: BoxFit.cover)
                                : Image.network(pet.photoUrl!,
                                    fit: BoxFit.cover),
                          ),
                        ),
                        SizedBox(height: cardHeight * 0.04),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              pet.name,
                              // style: TextStyle(
                              //   color: Colors.black,
                              //   fontSize: cardHeight * 0.08,
                              //   fontWeight: FontWeight.w400,
                              // ),
                              style: GoogleFonts.jua(
                                fontSize: cardHeight * 0.1,
                                fontWeight: FontWeight.w400,
                                color: Colors.black,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            SizedBox(width: 4),
                            Icon(
                              pet.gender == 'Jantan'
                                  ? Icons.male
                                  : Icons.female,
                              color: pet.gender == 'Betina'
                                  ? Colors.blue
                                  : Colors.pink,
                              size: cardHeight * 0.08,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
