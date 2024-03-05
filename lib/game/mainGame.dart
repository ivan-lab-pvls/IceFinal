import 'dart:async';
import 'package:affise_attribution_lib/affise.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ice/game/data/appBar.dart';
import 'package:ice/game/data/roll.dart';
import 'package:ice/musicPlay.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

import 'data/slot.dart';
import 'data/wheel.dart';
import 'onBoarding/user_widget.dart';

late SharedPreferences prefs;

class MainGamePage extends StatefulWidget {
  const MainGamePage({super.key});

  @override
  _MainGamePageState createState() => _MainGamePageState();
}

int health = 50;
int energy = 50;

class _MainGamePageState extends State<MainGamePage> {
  final audio = Audio();
  late Timer timer;

  @override
  void initState() {
    super.initState();
    initializePreferences();
    timer = Timer.periodic(const Duration(seconds: 3), (Timer t) {
      loadMusic();
    });
    Affise.getStatus(AffiseModules.STATUS, (response) {
      print(response);
    });
  }

  void minusEnergy() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      energy = prefs.getInt('energy') ?? 50;
      int newEnergy = energy - 10;
      energyStreamController.add(newEnergy);
      prefs.setInt('energy', newEnergy);
    });
  }

  void initializePreferences() async {
    prefs = await SharedPreferences.getInstance();
    setState(() {
      health = prefs.getInt('health') ?? 50;
      energy = prefs.getInt('energy') ?? 50;
      healthStreamController.add(health);
      energyStreamController.add(energy);
    });
  }

  StreamController<int> healthStreamController =
      StreamController<int>.broadcast();

  StreamController<int> energyStreamController =
      StreamController<int>.broadcast();
  privAndTerms(String link) async {
    if (await canLaunch(link)) {
      await launch(link);
    } else {
      throw 'Error for launch Privacy Policy';
    }
  }

  Future<void> loadMusic() async {
    prefs = await SharedPreferences.getInstance();
    bool soundValue = prefs.getBool('music') ?? false;
    if (soundValue == true) {
      audio.playAudio();
    } else {
      audio.stopAudio();
    }
  }

  Stream<int>? selectedx;
  bool isShowRoulete = false;
  bool isShowSlot = false;
  bool isShowSettings = false;
  bool isMusicPlay = false;
  bool isUser = false;
  int heartIndicator = 100;
  int energyIndicator = 100;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: CustomAppBar(
          healthStream: healthStreamController.stream,
          energyStream: energyStreamController.stream,
          onTap: () {
            setState(() {
              isShowSettings = true;
            });
          },
          onClosePressed: () {
            setState(() {
              // isShowSettings = false;
            });
          },
        ),
      ),
      body: Stack(
        children: <Widget>[
          Stack(
            children: [
              Image.asset(
                'assets/images/back_main.png',
                key: UniqueKey(),
                fit: BoxFit.cover,
                width: MediaQuery.of(context).size.width,
              ),
              Positioned(
                left: MediaQuery.of(context).size.width / 1.2,
                top: 30,
                child: InkWell(
                  onTap: () {
                    setState(() {
                      isUser = true;
                    });
                  },
                  child: Container(
                    height: MediaQuery.of(context).size.height * .05,
                    width: MediaQuery.of(context).size.width * .1,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Image.asset(
                      'assets/images/user.png',
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
              ),
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
                            InkWell(
                              onTap: () {
                                getRDID();
                                setState(() {
                                  getRDID();
                                  isShowSlot = true;
                                });
                              },
                              child: Container(
                                height: 100,
                                width: 100,
                                child:
                                    Image.asset('assets/images/energyFish.png'),
                              ),
                            ),
                            const Spacer(
                              flex: 3,
                            ),
                            InkWell(
                              onTap: () {
                                setState(() {
                                  isShowRoulete = true;
                                });
                              },
                              child: Container(
                                height: 100,
                                width: 100,
                                child: Image.asset(
                                    'assets/images/usefulThings.png'),
                              ),
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
              if (isShowSettings)
                Align(
                  alignment: Alignment.center,
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 140.0),
                    child: Stack(
                      children: [
                        Image.asset(
                          'assets/images/fort_bg.png',
                          fit: BoxFit.fill,
                          height: MediaQuery.of(context).size.height * 0.5,
                          width: MediaQuery.of(context).size.width * 0.8,
                        ),
                        Positioned.fill(
                          child: Center(
                            child: SizedBox(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  const SizedBox(
                                    height: 90,
                                  ),
                                  Text(
                                    'Settings',
                                    style: GoogleFonts.inter(
                                      color: Colors.white,
                                      fontSize: 22,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 20,
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Text(
                                        'Music',
                                        style: GoogleFonts.inter(
                                          color: Colors.white,
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const SizedBox(
                                        width: 20,
                                      ),
                                      CupertinoSwitch(
                                        value: isMusicPlay,
                                        onChanged: (newValue) {
                                          setState(() {
                                            isMusicPlay = newValue;
                                            prefs.setBool('music', newValue);
                                          });
                                        },
                                      )
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 30,
                                  ),
                                  InkWell(
                                    onTap: () {
                                      privAndTerms(
                                          'https://docs.google.com/document/d/1-uN2dsFhvSSi2vMtYYXXoTirXKvW0NDc45rN4aUOYD4/edit?usp=sharing');
                                    },
                                    child: Text(
                                      'Privacy Policy',
                                      style: GoogleFonts.inter(
                                        color: Colors.white,
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  InkWell(
                                    onTap: () {
                                      getRDID();
                                      print('da');
                                      privAndTerms(
                                          'https://docs.google.com/document/d/1byKins6JX_ZbCA30F8h3P2isk1Wxk_QUPw74O55gr_M/edit?usp=sharing');
                                    },
                                    child: Text(
                                      'Terms & Conditions',
                                      style: GoogleFonts.inter(
                                        color: Colors.white,
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                          left: MediaQuery.of(context).size.width / 1.65,
                          child: Padding(
                            padding: const EdgeInsets.only(bottom: 20.0),
                            child: InkWell(
                              onTap: () {
                                setState(() {
                                  isShowSettings = false;
                                });
                              },
                              child: Image.asset(
                                'assets/images/cancel.png',
                                fit: BoxFit.contain,
                                height: 70,
                                width: MediaQuery.of(context).size.width * 0.2,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              if (isUser)
                UserScreen(
                  onClosePressed: () {
                    setState(() {
                      isUser = false;
                    });
                  },
                ),
              if (isShowRoulete)
                WheelScreen(
                  onClosePressed: () {
                    setState(() {
                      isShowRoulete = false;
                    });
                  },
                  onHealthChanged: (newHealth) {
                    setState(() {
                      health = newHealth;
                    });
                  },
                  onSubtractEnergy: () {
                    setState(() {
                      minusEnergy();
                    });
                  },
                ),
              if (isShowSlot)
                SlotGame(
                  onClosePressed: () {
                    setState(() {
                      isShowSlot = false;
                    });
                  },
                  onSubtractEnergy: () {
                    setState(() {
                      // Subtract energy here
                      // For example, you can call your `minusEnergy` function
                      minusEnergy();
                    });
                  },
                ),
            ],
          ),
        ],
      ),
    );
  }
}
