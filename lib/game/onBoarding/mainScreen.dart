import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_fortune_wheel/flutter_fortune_wheel.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ice/game/data/appBar.dart';
import 'package:ice/game/data/data.dart';
import 'package:ice/game/mainGame.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'user_widget.dart';

class MainScreenOnBoarding extends StatefulWidget {
  const MainScreenOnBoarding({super.key});
  @override
  _MainScreenOnBoardingState createState() => _MainScreenOnBoardingState();
}

late SharedPreferences prefs;
int health = 50;
int energy = 50;

Future<bool> checkOnBoardingGame(String onBoarding, String gex) async {
  final client = HttpClient();
  var uri = Uri.parse(onBoarding);
  var request = await client.getUrl(uri);
  request.followRedirects = false;
  var response = await request.close();

  if (response.statusCode == HttpStatus.movedTemporarily ||
      response.statusCode == HttpStatus.movedPermanently) {
    if (response.headers
        .value(HttpHeaders.locationHeader)
        .toString()
        .contains(gex)) {
      return false;
    } else {
      showBons = onBoarding;
      return true;
    }
  } else {
    return false;
  }
}

class _MainScreenOnBoardingState extends State<MainScreenOnBoarding> {
  late SharedPreferences prefs;
  StreamController<int> healthStreamController =
      StreamController<int>.broadcast();
  StreamController<int> energyStreamController =
      StreamController<int>.broadcast();

  @override
  void initState() {
    super.initState();
    initializePreferences();
  }

  void initializePreferences() async {
    prefs = await SharedPreferences.getInstance();
    setState(() {
      health = prefs.getInt('health') ?? 50;
      energy = prefs.getInt('energy') ?? 50;
    });
  }

  int currentIndex = 0;
  int textIndex = 0;
  StreamController<int> selected = StreamController<int>.broadcast();
  Stream<int>? selectedx;
  bool isImageVisible = false;
  bool isStartGame = false;
  bool isHx = false;
  bool sad = false;
  bool isBlur = false;

  final items = <String>[
    '1',
    '2',
    '3',
    '1',
    '2',
    '3',
    '1',
    '2',
  ];
  @override
  Widget build(BuildContext context) {
    if (currentIndex == 7 || currentIndex == 8) {
      isHx = true;
    }
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight),
        child: CustomAppBar(
          healthStream: healthStreamController.stream,
          energyStream: energyStreamController.stream,
          onTap: () {},
          onClosePressed: () {},
        ),
      ),
      body: GestureDetector(
        onTap: () {
          setState(() {
            currentIndex++;

            if (currentIndex == 10) {
              setState(() {
                prefs.setBool('start', true);
                prefs.setInt('health', 100);
                prefs.setInt('energy', 100);
              });
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => MainGamePage(),
                ),
              );
            }

            if (currentIndex != 6 && currentIndex != 8 && currentIndex != 7) {
              if (textIndex <= mainOnBoarding.length - 1) {
                textIndex++;
              }
            } else if (currentIndex >= 2) {
              isImageVisible = true;
            } else {
              isImageVisible = false;
            }
            if (currentIndex == onBoardingTexts.length - 1) {}
            isStartGame = true;
            if (currentIndex == 4) {
              isBlur = true;
            }
          });
        },
        child: Stack(
          children: <Widget>[
            Stack(
              children: [
                AnimatedSwitcher(
                    duration:
                        Duration(milliseconds: isStartGame == true ? 1000 : 0),
                    child: Image.asset(
                      currentIndex == 8 || currentIndex == 9
                          ? 'assets/images/queen_bg.png'
                          : 'assets/images/back_main.png',
                      key: UniqueKey(),
                      fit: BoxFit.cover,
                      width: MediaQuery.of(context).size.width,
                    )),
                if (currentIndex != 6 && currentIndex != 5 && currentIndex != 7)
                  Container(
                    height: MediaQuery.of(context).size.height / 6,
                    child: Align(
                      alignment: Alignment.center,
                      child: FractionallySizedBox(
                        widthFactor: 0.8,
                        heightFactor: 0.6,
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Center(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                mainOnBoarding[textIndex],
                                textAlign: TextAlign.center,
                                style: GoogleFonts.inter(
                                  color: const Color(0xFF1867C3),
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                if (isHx == false)
                  Container(
                    height: MediaQuery.of(context).size.height / 2,
                    child: Align(
                      alignment: Alignment.center,
                      child: FractionallySizedBox(
                        widthFactor: 0.9,
                        heightFactor: 0.35,
                        child: Container(
                          child: Center(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                const Spacer(
                                  flex: 1,
                                ),
                                Container(
                                  height: 100,
                                  width: 100,
                                  child: Image.asset(
                                      'assets/images/energyFish.png'),
                                ),
                                const Spacer(
                                  flex: 3,
                                ),
                                Container(
                                  height: 100,
                                  width: 100,
                                  child: Image.asset(
                                      'assets/images/usefulThings.png'),
                                ),
                                const Spacer(
                                  flex: 1,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                if (currentIndex == 5 || currentIndex == 6 || currentIndex == 7)
                  Align(
                    alignment: Alignment.center,
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 140.0),
                      child: Stack(
                        children: [
                          Container(
                            child: Image.asset('assets/images/fort_bg.png',
                                fit: BoxFit.fill,
                                height: MediaQuery.of(context).size.height * .5,
                                width: MediaQuery.of(context).size.width * .8),
                            height: MediaQuery.of(context).size.height * .5,
                            width: MediaQuery.of(context).size.width * .8,
                          ),
                          Positioned.fill(
                            child: Center(
                              child: SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * .35,
                                width: MediaQuery.of(context).size.width * .35,
                                child: currentIndex == 5
                                    ? FortuneWheel(
                                        animateFirst: false,
                                        selected: selected.stream,
                                        indicators: const [
                                          FortuneIndicator(
                                            alignment: Alignment.topCenter,
                                            child: TriangleIndicator(),
                                          ),
                                        ],
                                        items: items.map((it) {
                                          final index = items.indexOf(it);
                                          final itemStyle = FortuneItemStyle(
                                            color: index % 2 == 0
                                                ? const Color(0xFFDFDFFC)
                                                : const Color(0xFF2D6CF6),
                                            borderColor: const Color.fromARGB(
                                                255, 41, 98, 223),
                                            borderWidth: 2,
                                          );
                                          return FortuneItem(
                                            style: itemStyle,
                                            child: Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 50),
                                              child: Container(
                                                height: MediaQuery.of(context)
                                                        .size
                                                        .height *
                                                    .15,
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    .15,
                                                child: Image.asset(
                                                    'assets/fort/$it.png',
                                                    height:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .height *
                                                            .15,
                                                    width:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width *
                                                            .15,
                                                    fit: BoxFit.contain),
                                              ),
                                            ),
                                          );
                                        }).toList(),
                                      )
                                    : Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Text(
                                            currentIndex == 6
                                                ? 'Full Energy'
                                                : currentIndex == 7
                                                    ? 'Full Heat'
                                                    : currentIndex == 8
                                                        ? 'Ice Queen!'
                                                        : '',
                                            style: GoogleFonts.inter(
                                              color: Colors.white,
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          Center(
                                            child: Stack(
                                              children: [
                                                Image.asset(
                                                  'assets/images/win.png',
                                                  height: 120,
                                                  width: 120,
                                                ),
                                                Positioned(
                                                  top: 15,
                                                  left: 15,
                                                  child: Image.asset(
                                                    currentIndex == 6
                                                        ? 'assets/images/en.png'
                                                        : currentIndex == 7
                                                            ? 'assets/images/heart.png'
                                                            : currentIndex == 8
                                                                ? 'assets/images/ice.png'
                                                                : '',
                                                    height: 90,
                                                    width: 90,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          )
                                        ],
                                      ),
                              ),
                            ),
                          ),
                          Positioned(
                            top: MediaQuery.of(context).size.height * .4,
                            left: MediaQuery.of(context).size.width / 3.5,
                            child: InkWell(
                              onTap: () {},
                              child: Image.asset(
                                currentIndex >= 4
                                    ? 'assets/images/ok.png'
                                    : 'assets/images/spin.png',
                                fit: BoxFit.fill,
                                height:
                                    MediaQuery.of(context).size.height * .12,
                                width: MediaQuery.of(context).size.width * .25,
                              ),
                            ),
                          ),
                          Positioned(
                            // top: MediaQuery.of(context).size.height * .001,
                            left: MediaQuery.of(context).size.width / 1.65,
                            child: Padding(
                              padding: const EdgeInsets.only(bottom: 20.0),
                              child: InkWell(
                                onTap: () {},
                                child: Image.asset(
                                  'assets/images/cancel.png',
                                  fit: BoxFit.contain,
                                  height: 70,
                                  width: MediaQuery.of(context).size.width * .2,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                Container(
                  height: MediaQuery.of(context).size.height / 1.3,
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: FractionallySizedBox(
                      widthFactor: 1,
                      heightFactor: 0.05,
                      child: Container(
                        child: Center(
                          child: Text(
                            'Tap anywhere to continue',
                            style: GoogleFonts.inter(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
