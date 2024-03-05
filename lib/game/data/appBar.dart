import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget {
  final Stream<int> healthStream;
  final Stream<int> energyStream;
  final VoidCallback onTap;
  final VoidCallback onClosePressed;
  CustomAppBar(
      {required this.healthStream,
      required this.energyStream,
      required this.onTap,
      required this.onClosePressed});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<int>(
      stream: healthStream,
      builder: (context, healthSnapshot) {
        return StreamBuilder<int>(
          stream: energyStream,
          builder: (context, energySnapshot) {
            int health = healthSnapshot.data ?? 60;
            int energy = energySnapshot.data ?? 60;

            return AppBar(
              backgroundColor: const Color(0xFF2D6CF6),
              leading: IconButton(
                onPressed: onTap,
                icon: Image.asset(
                  'assets/images/settings.png',
                  height: 40,
                  width: 40,
                ),
              ),
              actions: [
                // Energy Indicator
                Container(
                  height: 40,
                  width: MediaQuery.of(context).size.width * 0.35,
                  child: Center(
                    child: Stack(
                      children: [
                        Align(
                          alignment: Alignment.center,
                          child: Container(
                            height: 20,
                            width: MediaQuery.of(context).size.width * 0.31,
                            decoration: BoxDecoration(
                              color: const Color(0xFF1867C3),
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                        ),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: FractionallySizedBox(
                            alignment: Alignment.centerLeft,
                            widthFactor: energy / 100,
                            child: Container(
                              height: 20,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(20),
                              ),
                            ),
                          ),
                        ),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Container(
                            height: 35,
                            width: 35,
                            child: Image.asset('assets/images/power.png'),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(
                  width: 20,
                ),
                // Health Indicator
                Container(
                  height: 40,
                  width: MediaQuery.of(context).size.width * .35,
                  child: Center(
                    child: Stack(
                      children: [
                        Align(
                          alignment: Alignment.center,
                          child: Container(
                            height: 20,
                            width: MediaQuery.of(context).size.width * 0.31,
                            decoration: BoxDecoration(
                              color: const Color(0xFF1867C3),
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                        ),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: FractionallySizedBox(
                            alignment: Alignment.centerLeft,
                            widthFactor: health / 100,
                            child: Container(
                              height: 20,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(20),
                              ),
                            ),
                          ),
                        ),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Container(
                            height: 35,
                            width: 35,
                            child: Image.asset('assets/images/heart.png'),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(
                  width: 20,
                ),
              ],
            );
          },
        );
      },
    );
  }
}
