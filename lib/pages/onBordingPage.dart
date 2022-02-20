import 'package:clicandeats/pages/signInPage.dart';
import 'package:flutter/material.dart';

class MyBehavior extends ScrollBehavior {
  @override
  Widget buildViewportChrome(
      BuildContext context, Widget child, AxisDirection axisDirection) {
    return child;
  }
}

class OnBoardingPage {
  String img;
  String title;
  String content;
  OnBoardingPage({ required this.title,required this.content,required this.img});
}

class Onbording extends StatefulWidget {
  @override
  _OnbordingState createState() => _OnbordingState();
}

class _OnbordingState extends State<Onbording> {
  List<OnBoardingPage> contents = [
    OnBoardingPage(
        title: 'Choisissez votre repas',
        content: 'Choisissez parmi les meilleurs restos du coin',
        img: 'assets/images/onboarding/1.png'),
    OnBoardingPage(
        title: 'Faites votre commande',
        content: 'Commandez et payez via notre plateforme 100% sécurisée',
        img: 'assets/images/onboarding/2.png'),
    OnBoardingPage(
        title: 'Attendez à la maison',
        content: 'Recevez votre commande en moins de 30 min !',
        img: 'assets/images/onboarding/3.png'),
  ];
  int currentIndex = 0;
  late PageController _controller;

  @override
  void initState() {
    _controller = PageController(initialPage: 0);
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xfffb9466),
      body: Padding(
        padding: const EdgeInsets.all(30.0),
        child: Column(
          children: [
            Expanded(
              child: ScrollConfiguration(
                behavior: MyBehavior(),
                child: PageView.builder(
                  controller: _controller,
                  itemCount: contents.length,
                  onPageChanged: (int index) {
                    setState(() {
                      currentIndex = index;
                    });
                  },
                  itemBuilder: (_, i) {
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Image.asset(
                          contents[i].img,
                          height: 200,
                        ),
                        FittedBox(
                          child: Text(
                            contents[i].title,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 32,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Text(
                          contents[i].content,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 24,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width / 2,
                          child: OutlinedButton(
                            child: Text(
                              currentIndex == contents.length - 1
                                  ? "Terminer"
                                  : "Suivant",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 23,
                                color: Colors.white,
                              ),
                            ),
                            style: OutlinedButton.styleFrom(
                              padding: EdgeInsets.all(20),
                              side: BorderSide(color: Colors.white, width: 2),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            onPressed: () {
                              if (currentIndex == contents.length - 1) {
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => SignIn(),
                                  ),
                                );
                              }
                              _controller.nextPage(
                                duration: Duration(milliseconds: 500),
                                curve: Curves.easeIn,
                              );
                            },
                          ),
                        )
                      ],
                    );
                  },
                ),
              ),
            ),
            Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  contents.length,
                  (index) => buildDot(index, context),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Container buildDot(int index, BuildContext context) {
    return Container(
      height: currentIndex == index ? 17 : 10,
      width: currentIndex == index ? 17 : 10,
      margin: EdgeInsets.only(right: 5),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: currentIndex == index
              ? Colors.white
              : Colors.white.withOpacity(0.5)),
    );
  }
}
