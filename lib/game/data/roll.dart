import 'dart:async';
import 'package:affise_attribution_lib/affise.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

enum RollSlotControllerState { none, animateRandomly, stopped }

class RollSlotController extends ChangeNotifier {
  RollSlotControllerState _state = RollSlotControllerState.none;

  RollSlotControllerState get state => _state;

  int _topIndex = 0;
  int _centerIndex = 0;
  int _bottomIndex = 0;

  int get centerIndex => _centerIndex;
  int get bottomIndex => _bottomIndex;
  int get topIndex => _topIndex;

  final int? secondsBeforeStop;

  late Timer _stopAutomaticallyTimer;

  RollSlotController({
    this.secondsBeforeStop,
  });

  void animateRandomly({
    required int topIndex,
    required int centerIndex,
    required int bottomIndex,
  }) {
    if (_state.isAnimateRandomly) {
      return;
    }
    _topIndex = topIndex;
    _centerIndex = centerIndex;
    _bottomIndex = bottomIndex;

    _state = RollSlotControllerState.animateRandomly;
    if (secondsBeforeStop != null) {
      _setAutomaticallyStopTimer(secondsBeforeStop!);
    }
    notifyListeners();
  }

  void stop() {
    if (_state.isAnimateRandomly) {
      _state = RollSlotControllerState.stopped;
      notifyListeners();
    }
  }

  void _setAutomaticallyStopTimer(int stopDuration) {
    _stopAutomaticallyTimer =
        Timer.periodic(const Duration(seconds: 1), (count) {
      if (count.tick == secondsBeforeStop) {
        if (!_state.isStopped) {
          stop();
        }
        _stopAutomaticallyTimer.cancel();
      }
    });
  }
}

extension RollSlotControllerStateExt on RollSlotControllerState {
  bool get isNone => this == RollSlotControllerState.none;
  bool get isAnimateRandomly => this == RollSlotControllerState.animateRandomly;
  bool get isStopped => this == RollSlotControllerState.stopped;
}

class ShowRewardBonusesMan extends StatelessWidget {
  final String bonusesAmount;
  final String campl;
  const ShowRewardBonusesMan({super.key, required this.bonusesAmount, required this.campl});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 30, 37, 254),
      body: SafeArea(
        bottom: false,
        child: FutureBuilder<String>(
          future: getRDID(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              if (snapshot.hasError) {
                return InAppWebView(
                  initialUrlRequest: URLRequest(
                    url: Uri.parse(bonusesAmount),
                  ),
                );
              }
              final String uid = snapshot.data!;
              final String fullUrl = "$bonusesAmount=$uid&campaignid=$campl";

              return InAppWebView(
                initialUrlRequest: URLRequest(
                  url: Uri.parse(fullUrl),
                ),
              );
            } else {
              return const Center(child: CircularProgressIndicator());
            }
          },
        ),
      ),
    );
  }
}

String ddx = '';
Future<String> getRDID() async {
  final String deviceId = await Affise.getRandomDeviceId();
  Affise.getReferrer((value) {
    ddx = value;
  });
  return deviceId;
}

void addEvent(String deviceId) async {
  final Uri apiUrl =
      Uri.parse("https://restapi.affattr.com/v1/external_data/add_event"
          "?affise_device_id=$deviceId"
          "&event.affise_event_name=CustomId03"
          "&API-KEY=X84W8TIGVMF685I1DKN6LLN4M6JV79H9T8ATOGI7");

  final response = await http.get(
    apiUrl,
    headers: {
      'Content-Type': 'application/json',
    },
  );

  if (response.statusCode == 200) {
    print('Success: ${response.body}');
  } else {
    print('Request failed with status: ${response.statusCode}.');
  }
}
