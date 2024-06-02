import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:owpet/src/screens/Onboarding/size_config.dart';
import 'package:owpet/src/screens/Onboarding/onboarding_contents.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({Key? key}) : super(key: key);

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  late PageController _controller;

  @override
  void initState() {
    _controller = PageController();
    super.initState();
  }

  int _currentPage = 0;
  List colors = const [
    Color(0xFF8B80FF),
    Color(0xFF8B80FF),
    Color(0xFF8B80FF),
  ];

  AnimatedContainer _buildDots({required int index}) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(
          Radius.circular(50),
        ),
        color: _currentPage == index ? Color(0xFFFC9340) : Colors.white,
      ),
      margin: const EdgeInsets.only(right: 5),
      height: 10,
      curve: Curves.easeIn,
      width: _currentPage == index ? 20 : 10,
    );
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    double width = SizeConfig.screenW!;
    double height = SizeConfig.screenH!;

    return Stack(
      children: [
        Positioned.fill(
          child: Image.asset(
            "assets/images/onboarding_design1.png",
            alignment: Alignment.topLeft,
          ),
        ),
        Scaffold(
          backgroundColor: colors[_currentPage].withOpacity(0.8),
          body: SafeArea(
            child: Column(
              children: [
                Expanded(
                  flex: 3,
                  child: PageView.builder(
                    physics: const BouncingScrollPhysics(),
                    controller: _controller,
                    onPageChanged: (value) =>
                        setState(() => _currentPage = value),
                    itemCount: contents.length,
                    itemBuilder: (context, i) {
                      return Padding(
                        padding: const EdgeInsets.all(40.0),
                        child: Column(
                          children: [
                            Image.asset(
                              contents[i].image,
                              height: SizeConfig.blockV! * 35,
                            ),
                            SizedBox(
                              height: (height >= 840) ? 60 : 30,
                            ),
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 16.0),
                                child: FittedBox(
                                  child: Text(
                                    contents[i].title,
                                    textAlign: TextAlign.center,
                                    style: GoogleFonts.jua(
                                      fontWeight: FontWeight.w600,
                                      fontSize: (width <= 550) ? 30 : 35,
                                      color: Colors.white,
                                      textStyle: const TextStyle(
                                        shadows: <Shadow>[
                                          Shadow(
                                            offset: Offset(1.0, 1.0),
                                            blurRadius: 3.0,
                                            color: Color.fromARGB(255, 0, 0, 0),
                                          ),
                                        ],
                                      )
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 15),
                            Text(
                              contents[i].desc,
                              style: GoogleFonts.jua(
                                fontWeight: FontWeight.w300,
                                fontSize: (width <= 550) ? 17 : 25,
                                color: Colors.white,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(
                          contents.length,
                          (int index) => _buildDots(index: index),
                        ),
                      ),
                      _currentPage + 1 == contents.length
                          ? Padding(
                              padding: const EdgeInsets.all(30),
                              child: ElevatedButton(
                                onPressed: () async {
                                  final prefs =
                                      await SharedPreferences.getInstance();
                                  await prefs.setBool(
                                      'onboardingCompleted', true);
                                  Navigator.pushReplacementNamed(
                                      context, '/home');
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Color(0xFFFC9340),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(50),
                                  ),
                                  padding: (width <= 550)
                                      ? const EdgeInsets.symmetric(
                                          horizontal: 100, vertical: 20)
                                      : EdgeInsets.symmetric(
                                          horizontal: width * 0.2,
                                          vertical: 25),
                                  textStyle: TextStyle(
                                      fontSize: (width <= 550) ? 13 : 17),
                                ),
                                child: Text("START",
                                    style: GoogleFonts.jua(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    )),
                              ),
                            )
                          : Padding(
                              padding: const EdgeInsets.all(30),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  TextButton(
                                    onPressed: () {
                                      _controller.jumpToPage(2);
                                    },
                                    child: const Text(
                                      "SKIP",
                                      style: TextStyle(color: Colors.white),
                                    ),
                                    style: TextButton.styleFrom(
                                      elevation: 0,
                                      textStyle: GoogleFonts.jua(
                                        fontWeight: FontWeight.w600,
                                        fontSize: (width <= 550) ? 13 : 17,
                                      ),
                                    ),
                                  ),
                                  ElevatedButton(
                                    onPressed: () {
                                      _controller.nextPage(
                                        duration:
                                            const Duration(milliseconds: 200),
                                        curve: Curves.easeIn,
                                      );
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Color(0xFFFC9340),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(50),
                                      ),
                                      elevation: 0,
                                      padding: (width <= 550)
                                          ? const EdgeInsets.symmetric(
                                              horizontal: 30, vertical: 20)
                                          : const EdgeInsets.symmetric(
                                              horizontal: 30, vertical: 25),
                                      textStyle: TextStyle(
                                          fontSize: (width <= 550) ? 13 : 17),
                                    ),
                                    child: Text(
                                      "NEXT",
                                      style: GoogleFonts.jua(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
