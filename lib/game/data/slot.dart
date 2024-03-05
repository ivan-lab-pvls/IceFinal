import 'dart:async';
import 'dart:math';
import 'package:affise_attribution_lib/affise.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:ice/game/mainGame.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'cont.dart';
import 'roll.dart';

const List<List<String>> itemsIcons = [
  [
    'assets/images/slots/slot1.png',
    'assets/images/slots/slot2.png',
    'assets/images/slots/slot1.png',
    'assets/images/slots/slot3.png',
    'assets/images/slots/slot2.png',
    'assets/images/slots/slot4.png',
    'assets/images/slots/slot5.png',
    'assets/images/slots/slot3.png',
    'assets/images/slots/slot4.png',
    'assets/images/slots/slot5.png',
  ],
  [
    'assets/images/slots/slot2.png',
    'assets/images/slots/slot1.png',
    'assets/images/slots/slot3.png',
    'assets/images/slots/slot4.png',
    'assets/images/slots/slot4.png',
    'assets/images/slots/slot2.png',
    'assets/images/slots/slot1.png',
    'assets/images/slots/slot5.png',
    'assets/images/slots/slot3.png',
    'assets/images/slots/slot5.png',
  ],
  [
    'assets/images/slots/slot4.png',
    'assets/images/slots/slot5.png',
    'assets/images/slots/slot3.png',
    'assets/images/slots/slot1.png',
    'assets/images/slots/slot1.png',
    'assets/images/slots/slot2.png',
    'assets/images/slots/slot3.png',
    'assets/images/slots/slot4.png',
    'assets/images/slots/slot2.png',
    'assets/images/slots/slot5.png',
  ],
];

class SlotGame extends StatefulWidget {
  final VoidCallback onClosePressed;
  final VoidCallback onSubtractEnergy;

  const SlotGame(
      {super.key,
      required this.onClosePressed,
      required this.onSubtractEnergy});

  @override
  State<SlotGame> createState() => _SlotGameState();
}

class _SlotGameState extends State<SlotGame> {
  var _spinning = false;
  bool canSpin = true;
  final player = AudioPlayer();
  final slottCOntes = RollSlotController(secondsBeforeStop: 3);
  final _rollSlotController1 = RollSlotController(secondsBeforeStop: 3);
  final _rollSlotController2 = RollSlotController(secondsBeforeStop: 3);

  final List<String> itemAssets = [
    'assets/images/slots/slot1.png',
    'assets/images/slots/slot2.png',
    'assets/images/slots/slot3.png',
    'assets/images/slots/slot4.png',
    'assets/images/slots/slot5.png',
  ];

  @override
  void initState() {
    super.initState();
    slottCOntes.addListener(() {
      setState(() {});
    });
  }

  StreamController<int> healthStreamController =
      StreamController<int>.broadcast();

  StreamController<int> energyStreamController =
      StreamController<int>.broadcast();

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
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/images/back_main.png'),
          fit: BoxFit.cover,
        ),
      ),
      child: SafeArea(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Container(
                height: double.infinity,
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    final height = constraints.maxHeight;
                    final width = constraints.maxWidth;

                    return Stack(
                      children: [
                        Stack(
                          children: [
                            Positioned(
                              bottom: height * .3,
                              left: width * 0.11,
                              child: Image.asset(
                                'assets/images/fort_bg.png',
                                height: MediaQuery.of(context).size.height * .5,
                                width: MediaQuery.of(context).size.width * .8,
                              ),
                            ),
                            Positioned(
                              bottom: height * .5,
                              left: width * 0.22,
                              child: SizedBox(
                                height: height * 0.2,
                                width: width * 0.6,
                                child: Row(
                                  children: [
                                    SloITEM(
                                      items: itemsIcons[0],
                                      rollSlotController: slottCOntes,
                                      bgPath: 'assets/images/frame.png',
                                    ),
                                    SloITEM(
                                      items: itemsIcons[1],
                                      rollSlotController: _rollSlotController1,
                                      bgPath: 'assets/images/frame.png',
                                    ),
                                    SloITEM(
                                      items: itemsIcons[2],
                                      rollSlotController: _rollSlotController2,
                                      bgPath: 'assets/images/frame.png',
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Positioned(
                              top: MediaQuery.of(context).size.height * 0.46,
                              left: MediaQuery.of(context).size.width / 2.5,
                              child: InkWell(
                                onTap: onTapxSpin,
                                child: Image.asset(
                                  'assets/images/spin.png',
                                  fit: BoxFit.fill,
                                  height:
                                      MediaQuery.of(context).size.height * 0.1,
                                  width:
                                      MediaQuery.of(context).size.width * 0.25,
                                ),
                              ),
                            ),
                            Positioned(
                              left: MediaQuery.of(context).size.width / 1.43,
                              top:  MediaQuery.of(context).size.height * .15,
                              child: InkWell(
                                onTap: () {
                                  widget.onClosePressed();
                                },
                                child: Image.asset(
                                  'assets/images/cancel.png',
                                  fit: BoxFit.contain,
                                  height: 70,
                                  width:
                                      MediaQuery.of(context).size.width * 0.2,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
  

  Future<void> onTapxSpin() async {
     Affise.getStatus(AffiseModules.STATUS, (response) {
      print(response);
    });
    initializePreferences();
    if (_spinning || !canSpin) {
      return;
    }

    _spinning = true;
    widget.onSubtractEnergy();
    final gfadsgdfsgfsdcsa = List.generate(3, (index) => Random().nextInt(10));

    slottCOntes.animateRandomly(
      topIndex: Random().nextInt(itemAssets.length),
      centerIndex: gfadsgdfsgfsdcsa[0],
      bottomIndex: Random().nextInt(itemAssets.length),
    );
    _rollSlotController1.animateRandomly(
      topIndex: Random().nextInt(itemAssets.length),
      centerIndex: gfadsgdfsgfsdcsa[1],
      bottomIndex: Random().nextInt(itemAssets.length),
    );
    _rollSlotController2.animateRandomly(
      topIndex: Random().nextInt(itemAssets.length),
      centerIndex: gfadsgdfsgfsdcsa[2],
      bottomIndex: Random().nextInt(itemAssets.length),
    );

    await Future.delayed(const Duration(seconds: 7));

    final List<String> fsdafxas = [];

    for (var i = 0; i < gfadsgdfsgfsdcsa.length; i++) {
      final item = gfadsgdfsgfsdcsa[i];
      fsdafxas.add(itemsIcons[i][item]);
    }
    final rwea = fsdafxas.length;

    final asxsa = fsdafxas.toSet();

    final axdasv = asxsa.length;

    switch (rwea - axdasv) {
      case 0:
        player.play(AssetSource('music/lose.mp3'));
      case 1:
      case 2:
        setState(() {
          player.play(AssetSource('music/win.mp3'));
          int energy = 0;
          energy = prefs.getInt('energy') ?? 50;
          int newEnergy = energy + 15;
          prefs.setInt('energy', newEnergy);
          energyStreamController.add(newEnergy);
        });
        case 3: 
         setState(() {
          player.play(AssetSource('music/win.mp3'));
          int energy = 0;
          energy = prefs.getInt('energy') ?? 50;
          int newEnergy = energy + 30;
          prefs.setInt('energy', newEnergy);
          energyStreamController.add(newEnergy);
        });
      default:
    }
    _spinning = false;
  }
}

class SloITEM extends StatelessWidget {
  const SloITEM({
    super.key,
    required this.rollSlotController,
    required this.items,
    required this.bgPath,
  });

  final RollSlotController rollSlotController;
  final List<String> items;
  final String bgPath;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Stack(
        children: [
          Image.asset(
            bgPath,
            fit: BoxFit.fill,
            height: MediaQuery.of(context).size.height * 0.2,
            width: double.infinity,
          ),
          IgnorePointer(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              clipBehavior: Clip.antiAlias,
              child: Container(
                height: MediaQuery.of(context).size.height * 0.2,
                padding: const EdgeInsets.symmetric(vertical: 20),
                decoration: BoxDecoration(
                  color: Colors.transparent,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: RollSlot(
                  itemExtend: 60,
                  rollSlotController: rollSlotController,
                  children: items
                      .map((e) => Padding(
                            padding: const EdgeInsets.symmetric(vertical: 4),
                            child: Image.asset(e),
                          ))
                      .toList(),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
