import 'dart:async';
import 'dart:math';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_fortune_wheel/flutter_fortune_wheel.dart';
import 'package:shared_preferences/shared_preferences.dart';

class WheelScreen extends StatefulWidget {
  final VoidCallback onClosePressed;
  final void Function(int health) onHealthChanged;
  final VoidCallback onSubtractEnergy;
  WheelScreen(
      {required this.onClosePressed,
      required this.onHealthChanged,
      required this.onSubtractEnergy});
  @override
  _WheelScreenState createState() => _WheelScreenState();
}

late SharedPreferences prefs;

class _WheelScreenState extends State<WheelScreen> {
  Future<int> getHealthFromSharedPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int energy = prefs.getInt('energy') ?? 100;
    return energy;
  }

  StreamController<int> healthStreamController =
      StreamController<int>.broadcast();

  StreamController<int> energyStreamController =
      StreamController<int>.broadcast();

  bool shouldSpin = false;
  bool canSpin = true;
  int energy = 50;

  void initializePreferences() async {
    prefs = await SharedPreferences.getInstance();
    setState(() {
      energy = prefs.getInt('energy') ?? 50;
      if (energy < 10) {
        canSpin = false;
        showEnergyLowSnackbar();
      }
    });
  }

  void showEnergyLowSnackbar() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        backgroundColor: Colors.blue,
        content: Center(
          child: Text(
            'Energy is too low to spin',
            style: TextStyle(color: Colors.white),
          ),
        ),
        duration: Duration(seconds: 3),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    initializePreferences();
    getHealthFromSharedPreferences().then((value) {
      setState(() {
        energy = value;
        // healthStreamController.add(newHealthValue);
      });
    });
  }

  Future<void> updateHealthInSharedPreferences(int newEnergy) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    energyStreamController.add(newEnergy);
    await prefs.setInt('energy', newEnergy);

  }

  Future<void> decreaseHealth() async {
    setState(() {
      energy -= 15;
    });

    await updateHealthInSharedPreferences(energy);
  }

  final StreamController<int> selectedController =
      StreamController<int>.broadcast();
  int currentIndex = 4;
  bool heart = false;
  bool isShow = false;
  bool ener = false;
  bool queen = false;
  final player = AudioPlayer();
  String asset = '';
  Future<void> delayedPrint(int index) async {
    await Future.delayed(const Duration(seconds: 6));
    // player.play(AssetSource('music/win.mp3'));
    if (!mounted) {
      return;
    }

    if (index == 0) {
      setState(() {
        isShow = true;
        heart = true;
        asset = 'assets/fort/2.png';
        int health = 0;
        health = prefs.getInt('health') ?? 50;
        int newHealth = 100 - health;
        newHealth = newHealth + health;
        prefs.setInt('health', newHealth);
        energyStreamController.add(newHealth);
      });
    } else if (index == 1) {
      setState(() {
        isShow = true;
        ener = true;
        asset = 'assets/fort/1.png';
      });
    } else if (index == 2) {
      setState(() {
        isShow = true;
        queen = true;
        final random = Random();
        int randomNumber = random.nextInt(8);
    
        asset = 'assets/queen/$randomNumber.png';
      });
    }
  }

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
  void dispose() {
    selectedController.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.center,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 140.0),
        child: Stack(
          children: [
            Image.asset(
              'assets/images/fort_bg.png',
              fit: BoxFit.fill,
              height: MediaQuery.of(context).size.height * .47,
              width: MediaQuery.of(context).size.width * .8,
            ),
            Positioned.fill(
              child: Center(
                child: SizedBox(
                  height: MediaQuery.of(context).size.height * 0.37,
                  width: MediaQuery.of(context).size.width * 0.37,
                  child: isShow == false
                      ? FortuneWheel(
                          animateFirst: false,
                          selected: selectedController.stream,
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
                              borderColor:
                                  const Color.fromARGB(255, 41, 98, 223),
                              borderWidth: 2,
                            );
                            return FortuneItem(
                              style: itemStyle,
                              child: Padding(
                                padding: const EdgeInsets.only(left: 50),
                                child: Container(
                                  height:
                                      MediaQuery.of(context).size.height * .15,
                                  width:
                                      MediaQuery.of(context).size.width * .15,
                                  child: Image.asset(
                                    'assets/fort/$it.png',
                                    height: MediaQuery.of(context).size.height *
                                        .15,
                                    width:
                                        MediaQuery.of(context).size.width * .15,
                                    fit: BoxFit.contain,
                                  ),
                                ),
                              ),
                            );
                          }).toList(),
                        )
                      : Center(
                          child: Stack(
                            children: [
                              Image.asset(
                                'assets/images/win.png',
                                height: 200,
                                width: 200,
                              ),
                              Positioned(
                                top: 40,
                                left: 25,
                                child: Image.asset(
                                  asset,
                                  height: 120,
                                  width: 120,
                                ),
                              ),
                            ],
                          ),
                        ),
                ),
              ),
            ),
            Positioned(
              top: MediaQuery.of(context).size.height * 0.37,
              left: MediaQuery.of(context).size.width / 3.5,
              child: InkWell(
                onTap: () {
                  initializePreferences();
                  if (canSpin) {
                    decreaseHealth();
                    widget.onSubtractEnergy();
                    int selectedIndex = Fortune.randomInt(0, items.length);

                    setState(() {
                      shouldSpin = true;
                      if (shouldSpin) {
                        selectedController.add(selectedIndex);
 
                        setState(() {
                          shouldSpin = false;
                        });
                        int id = 0;
                        if (selectedIndex == 0) {
                          setState(() {
                            id = 1;
                          });
                        } else if (selectedIndex == 1) {
                          setState(() {
                            id = 0;
                          });
                        } else if (selectedIndex == 2) {
                          setState(() {
                            id = 2;
                          });
                        } else if (selectedIndex == 3) {
                          setState(() {
                            id = 1;
                          });
                        } else if (selectedIndex == 4) {
                          setState(() {
                            id = 0;
                          });
                        } else if (selectedIndex == 5) {
                          setState(() {
                            id = 2;
                          });
                        } else if (selectedIndex == 6) {
                          setState(() {
                            id = 1;
                          });
                        } else if (selectedIndex == 7) {
                          setState(() {
                            id = 0;
                          });
                        }
                        delayedPrint(id);
                      }
                    });
                  }
                },
                child: Image.asset(
                  'assets/images/spin.png',
                  fit: BoxFit.fill,
                  height: MediaQuery.of(context).size.height * 0.11,
                  width: MediaQuery.of(context).size.width * 0.25,
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
                      isShow = true;
                      queen = false;
                      heart = false;
                      ener = false;
                    });
                    widget.onClosePressed();
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
    );
  }
}
