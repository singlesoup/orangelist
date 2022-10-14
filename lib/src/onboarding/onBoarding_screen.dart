import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:soulfyre/src/onboarding/onBoarding_data.dart';
import 'package:soulfyre/src/theme/colors.dart';

import '../utils/global_size.dart';

class OnBoardingScreen extends StatefulWidget {
  const OnBoardingScreen({super.key});

  @override
  State<OnBoardingScreen> createState() => _OnBoardingScreenState();
}

class _OnBoardingScreenState extends State<OnBoardingScreen> {
  int _currentPage = 0;
  final int _totalPages = onBoardingList.length;
  final PageController _pageController = PageController();

  List<Widget> _buildPageIndicator() {
    List<Widget> list = [];

    for (var i = 0; i < _totalPages; i++) {
      list.add(i == _currentPage ? _indicator(true) : _indicator(false));
    }
    return list;
  }

  Widget _indicator(bool isActive) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 180),
      margin: const EdgeInsets.symmetric(horizontal: 4),
      decoration: BoxDecoration(
        color: isActive ? themeColor : themeColor.withOpacity(0.4),
        borderRadius: BorderRadius.circular(16),
      ),
      height: Global.screenHeight! * 0.02,
      width: isActive ? Global.screenWidth! * 0.06 : Global.screenWidth! * 0.04,
    );
  }

  @override
  Widget build(BuildContext context) {
    Global global = Global();
    global.init(context);
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 12),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(
              height: Global.screenHeight! * 0.7,
              child: PageView(
                physics: const BouncingScrollPhysics(),
                controller: _pageController,
                onPageChanged: (int page) {
                  setState(() {
                    _currentPage = page;
                  });
                },
                children: [
                  _buildPages(index: 0),
                  _buildPages(index: 1),
                  _buildPages(index: 2),
                  _buildPages(index: 3),
                ],
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            const SizedBox(
              height: 50,
            ),
            Padding(
              padding: const EdgeInsets.only(
                top: 15.0,
                left: 15.0,
                right: 15.0,
              ),
              child: _currentPage != _totalPages - 1
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              _pageController.jumpToPage(3);
                            });
                          },
                          child: Text(
                            'Skip',
                            style:
                                Theme.of(context).textTheme.bodyText1!.copyWith(
                                      color: Colors.grey[800],
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20,
                                    ),
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: _buildPageIndicator(),
                        ),
                        InkWell(
                          splashColor: Colors.white,
                          onTap: () {
                            _pageController.nextPage(
                              duration: const Duration(milliseconds: 500),
                              curve: Curves.ease,
                            );
                          },
                          child: CircleAvatar(
                            radius: 22,
                            backgroundColor: themeColor,
                            child: const Icon(
                              Icons.chevron_right,
                              color: Colors.white,
                              size: 26,
                            ),
                          ),
                        ),
                      ],
                    )
                  : ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(themeColor),
                      ),
                      onPressed: () {
                        Navigator.of(context).pushReplacement(
                          MaterialPageRoute(
                            builder: (context) => Container(),
                            //TODO: Return HomeScreen here
                          ),
                        );
                      },
                      child: Text('Get Started',
                          style: Theme.of(context)
                              .textTheme
                              .button!
                              .copyWith(color: buttontxtColor)),
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPages({required int index}) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (index != 0)
            Expanded(child: SvgPicture.asset(onBoardingList[index].assetName)),
          const SizedBox(
            height: 25,
          ),
          Center(
            child: Text(
              onBoardingList[index].head,
              textAlign: TextAlign.center,
              style: index == 0
                  ? Theme.of(context)
                      .textTheme
                      .headline3!
                      .copyWith(color: textColor, fontWeight: FontWeight.bold)
                  : Theme.of(context).textTheme.headline5!.copyWith(
                        color: textColor,
                      ),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Align(
            alignment: Alignment.center,
            child: Text(
              onBoardingList[index].subHead,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyText1!.copyWith(
                    color: textColor,
                  ),
            ),
          ),
        ],
      ),
    );
  }
}
