// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_habit_run/app/bubble_button.dart';
// import 'package:google_mobile_ads/google_mobile_ads.dart';

// enum TypeReward { Daily, FinishRun }

// class AdsReward extends StatefulWidget {
//   const AdsReward(
//       {this.child,
//       this.bytes,
//       this.distance,
//       this.avg,
//       this.time,
//       this.steps,
//       this.typeReward = TypeReward.Daily,
//       this.function,
//       this.pointReward,
//       this.daysInRow});
//   final Widget child;
//   final String bytes;
//   final String time;
//   final double avg;
//   final int steps;
//   final double distance;
//   final TypeReward typeReward;
//   final Function function;
//   final int pointReward;
//   final int daysInRow;
//   @override
//   _AdsRewardState createState() => _AdsRewardState();
// }

// class _AdsRewardState extends State<AdsReward> {
//   RewardedAd _rewardedAd;
//   int _numRewardedLoadAttempts = 0;
//   int maxFailedLoadAttempts = 3;

//   void createRewardedAd() {
//     RewardedAd.load(
//         adUnitId: 'ca-app-pub-3940256099942544/5224354917',
//         request: const AdRequest(),
//         rewardedAdLoadCallback: RewardedAdLoadCallback(
//           onAdLoaded: (RewardedAd ad) {
//             print('$ad loaded.');
//             _rewardedAd = ad;
//             _numRewardedLoadAttempts = 0;
//           },
//           onAdFailedToLoad: (LoadAdError error) {
//             print('RewardedAd failed to load: $error');
//             _rewardedAd = null;
//             _numRewardedLoadAttempts += 1;
//             if (_numRewardedLoadAttempts <= maxFailedLoadAttempts) {
//               createRewardedAd();
//             }
//           },
//         ));
//   }

//   Future<void> showRewardedAd() async {
//     if (_rewardedAd == null) {
//       return;
//     }
//     _rewardedAd.fullScreenContentCallback = FullScreenContentCallback(
//       onAdShowedFullScreenContent: (RewardedAd ad) {
//         if (widget.typeReward == TypeReward.FinishRun) {
//           widget.function(context, widget.pointReward * 2);
//         } else {
//           widget.function(context, widget.daysInRow);
//         }
//       },
//       onAdDismissedFullScreenContent: (RewardedAd ad) async {
//         print('$ad onAdDismissedFullScreenContent.');
//         ad.dispose();
//         if (widget.typeReward != TypeReward.FinishRun) {
//           Navigator.of(context).pop();
//         }
//       },
//       onAdFailedToShowFullScreenContent: (RewardedAd ad, AdError error) {
//         print('$ad onAdFailedToShowFullScreenContent: $error');
//         ad.dispose();
//         if (widget.typeReward != TypeReward.FinishRun) {
//           Navigator.of(context).pop();
//         }
//       },
//     );

//     _rewardedAd.show(onUserEarnedReward: (RewardedAd ad, RewardItem reward) {
//       print('$ad with reward $RewardItem(${reward.amount}, ${reward.type})');
//     });
//     _rewardedAd = null;
//   }

//   @override
//   void initState() {
//     super.initState();
//     createRewardedAd();
//   }

//   @override
//   void dispose() {
//     super.dispose();
//     _rewardedAd?.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return BubbleButton(
//       onTap: () async {
//         await showRewardedAd();
//       },
//       child: widget.child,
//     );
//   }
// }
