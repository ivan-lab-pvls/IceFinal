import 'package:affise_attribution_lib/affise.dart';
import 'package:in_app_review/in_app_review.dart';
import 'package:shared_preferences/shared_preferences.dart';

String bonuses = 'typeHaventBonuses';
bool isBonuses = false;
late SharedPreferences prefers;
final rateCallView = InAppReview.instance;

Future<void> init() async {
  prefers = await SharedPreferences.getInstance();
}

Future<void> isRateCalled() async {
  await init(); // Initialize SharedPreferences

  bool isRated = prefers.getBool('IsRated') ?? false;
  if (!isRated) {
    if (await rateCallView.isAvailable()) {
      rateCallView.requestReview();
      await prefers.setBool('IsRated', true);
    }
  }
}

Future<String> getRDID() async {
  return Future.value(Affise.getRandomDeviceId());
}

// Future<String> getStatus() async {
//   return Future.value(Affise.getStatus());
// }

Future<String> getRUID() async {
  return Future.value(Affise.getRandomUserId());
}