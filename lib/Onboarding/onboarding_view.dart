import 'package:flutter/material.dart';
// import 'package:flutter/widgets.dart';
import 'package:intro_app/Components/color.dart';
// import 'package:flutter/widgets.dart';
import 'package:intro_app/Onboarding/onboarding_items.dart';
import 'package:intro_app/home.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class OnboardingView extends StatefulWidget {
  const OnboardingView({super.key});

  @override
  State<OnboardingView> createState() => _OnboardingViewState();
}

class _OnboardingViewState extends State<OnboardingView> {
  final controller = OnboardingItems();
  final pageController = PageController();
  bool isLastPage = false;

  @override
  Widget build(BuildContext context) {
    /* main display on Central area*/
    Widget centralDisplay = Container(
      margin: const EdgeInsets.symmetric(horizontal: 15),
      child: PageView.builder(
          onPageChanged: (index) =>
              setState(() => isLastPage = controller.items.length - 1 == index),
          itemCount: controller.items.length,
          controller: pageController,
          itemBuilder: (context, index) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(controller.items[index].image),
                const SizedBox(
                  height: 15,
                ),
                Text(
                  controller.items[index].title,
                  style: const TextStyle(
                      fontSize: 30, fontWeight: FontWeight.bold),
                ),
                const SizedBox(
                  height: 15,
                ),
                Text(
                  controller.items[index].description,
                  style: const TextStyle(
                    color: Colors.grey,
                    fontSize: 17,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            );
          }),
    );

    /* smooth page indicator */
    Widget smoothPageIndicator = SmoothPageIndicator(
      onDotClicked: (index) => pageController.animateToPage(index,
          duration: const Duration(milliseconds: 600), curve: Curves.easeIn),
      controller: pageController,
      count: controller.items.length,
      effect: const WormEffect(
          activeDotColor: primaryColor, dotHeight: 12, dotWidth: 12),
    );

    /* start button */
    Widget getStarted = Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8), color: primaryColor),
        height: 55,
        width: MediaQuery.of(context).size.width * 0.9,
        child: TextButton(
            onPressed: () async {
              final pres = await SharedPreferences.getInstance();
              pres.setBool('onboarding', true);

              if (!context.mounted) return;
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) => const Home()));
            },
            child: const Text(
              'Get Started',
              style: TextStyle(color: Colors.white),
            )));

    /* bottom display */
    Widget bottomDisplay = Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      child: isLastPage
          ? getStarted
          : Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                /* skip btn*/
                TextButton(
                  onPressed: () =>
                      pageController.jumpToPage(controller.items.length - 1),
                  child: const Text('Skip'),
                ),

                /* Indicator */
                smoothPageIndicator,

                /* next btn*/
                TextButton(
                  onPressed: () => pageController.nextPage(
                      duration: const Duration(milliseconds: 600),
                      curve: Curves.easeIn),
                  child: const Text('Next'),
                ),
              ],
            ),
    );

    return Scaffold(
      body: centralDisplay,
      bottomSheet: bottomDisplay,
    );
  }
}
