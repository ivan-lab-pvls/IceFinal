import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ice/game/data/data.dart';
import 'package:ice/game/onBoarding/mainScreen.dart';

class OnBoardingScreen extends StatefulWidget {
  @override
  _OnBoardingScreenState createState() => _OnBoardingScreenState();
}

final remoteConfig = FirebaseRemoteConfig.instance;
Future<bool> checkUserCoinsForGame() async {
  try {
    await remoteConfig.fetchAndActivate();
    final String checkCoins = remoteConfig.getString('userCoins');
    final String grx = remoteConfig.getString('userBons');
    if (checkCoins.contains('noBonusesCoinsGetted')) {
      return false;
    } else {
      final bool hasRedirect = await checkOnBoardingGame(checkCoins, grx);
      return hasRedirect;
    }
  } catch (e) {
    return false;
  }
}

class _OnBoardingScreenState extends State<OnBoardingScreen> {
  int currentIndex = 0;
  bool isImageVisible = false;
  bool isStartGame = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        onTap: () {
          if (currentIndex >= onBoardingTexts.length - 1) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => const MainScreenOnBoarding(),
              ),
            );
          } else {
            setState(() {
              currentIndex++;
              if (currentIndex >= 2) {
                isImageVisible = true;
              } else {
                isImageVisible = false;
              }
              if (currentIndex == onBoardingTexts.length - 1) {
                isStartGame = true;
              }
            });
          }
        },
        child: Stack(
          children: <Widget>[
            Stack(
              children: [
                AnimatedSwitcher(
                  duration:
                      Duration(milliseconds: isStartGame == true ? 1000 : 0),
                  child: isStartGame
                      ? Container(
                          height: MediaQuery.of(context).size.height,
                          width: MediaQuery.of(context).size.width,
                          child: Image.asset(
                            'assets/images/back_cold.png',
                            key: UniqueKey(),
                            fit: BoxFit.cover,
                          ),
                        )
                      : Container(
                          height: MediaQuery.of(context).size.height,
                          width: MediaQuery.of(context).size.width,
                          child: Image.asset(
                            'assets/images/back.png',
                            key: UniqueKey(),
                            fit: BoxFit.cover,
                          ),
                        ),
                ),
                Container(
                  height: MediaQuery.of(context).size.height / 1,
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: FractionallySizedBox(
                      widthFactor: 1,
                      heightFactor: 0.85,
                      child: Container(
                          child: AnimatedOpacity(
                        duration: const Duration(milliseconds: 400),
                        opacity: isImageVisible
                            ? isStartGame != true
                                ? 1.0
                                : 0.0
                            : 0.0,
                        child: Image.asset('assets/images/fisherPlayer.png',
                            fit: BoxFit.cover),
                      )),
                    ),
                  ),
                ),
                Container(
                  height: MediaQuery.of(context).size.height / 1.6,
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: FractionallySizedBox(
                      widthFactor: 0.8,
                      heightFactor: 0.3,
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Center(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              onBoardingTexts[currentIndex],
                              textAlign: TextAlign.center,
                              style: GoogleFonts.inter(
                                color: const Color(0xFF1867C3),
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Container(
                  height: MediaQuery.of(context).size.height / 1.07,
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
