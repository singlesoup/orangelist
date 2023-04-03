import 'package:orangelist/src/onboarding/models/on_boarding_model.dart';
import 'package:orangelist/src/utils/constants.dart';

List<OnBoard> onBoardingList = [
  OnBoard(head: "Orangelist", subHead: onBoardingMainDesc, assetName: ""),
  OnBoard(
    head: "Monthly Task overview",
    subHead: monthlyTaskOverview,
    assetName: "assets/images/monthlyOverview.svg",
  ),
  OnBoard(
    head: "Drag and set task order",
    subHead: obFuture,
    assetName: "assets/images/dragAndOrder.svg",
  ),
  OnBoard(
    head: "No Ads, it's free!!",
    subHead: itsFree,
    assetName: "assets/images/happy.svg",
  ),
];


/// SVGs from : https://undraw.co/illustrations
/// logo from: https://www.shopify.com/tools/logo-maker/artificial-intelligence