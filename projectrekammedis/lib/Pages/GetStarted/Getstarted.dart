import 'dart:ui';
import 'package:get/get.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:flutter/material.dart';
import 'package:projectrekammedis/Component/AppColor.dart';

class Getstarted extends StatefulWidget {
  const Getstarted({super.key});

  @override
  State<Getstarted> createState() => _GetstartedState();
}

class _GetstartedState extends State<Getstarted> {
  int _currentPage = 0;

  final _Pagecontroller = PageController();

  void _nextpage() {
    if (_currentPage == 2) {
      Get.offAllNamed("/Login");
    } else {
      _Pagecontroller.nextPage(
          duration: Duration(milliseconds: 500), curve: Curves.easeInOut);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: const Color.fromARGB(4, 213, 197, 194).withOpacity(0.1),
      body: Stack(children: [
        Container(
          height: double.infinity,
          color: Appcolor.textPrimary.withOpacity(0.1),
          child: Padding(
              padding:
                  EdgeInsets.only(top: 50, bottom: 30, left: 20, right: 20),
              child: SingleChildScrollView(
                child: Column(children: [
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.8,
                    child: PageView(
                        controller: _Pagecontroller,
                        onPageChanged: (int page) {
                          setState(() {
                            _currentPage = page;
                          });
                        },
                        children: [
                          Slide_1(),
                          Slide_2(),
                          Slide_3(),
                        ]),
                  ),
                ]),
              )),
        ),
        Positioned(
          bottom: 40, // Posisikan sesuai kebutuhan
          left: 0,
          right: 0,
          child: Center(
            child: SmoothPageIndicator(
              controller: _Pagecontroller,
              count: 3,
              effect: WormEffect(
                dotColor: Appcolor.textPrimary.withOpacity(0.3),
                dotHeight: 5,
                spacing: 15,
                dotWidth: 15,
                activeDotColor: Appcolor.textPrimary,
              ),
            ),
          ),
        ),
        Positioned(
          top: 300,
          left: 0,
          right: 0,
          child: Center(
            child: SizedBox(
                width: MediaQuery.of(context).size.width / 1.5,
                child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Appcolor.textPrimary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        )),
                    onPressed: _nextpage,
                    child: Text(
                      _currentPage == 2 ? "Mulai" : "Selanjutnya",
                      style: TextStyle(
                          color: Appcolor.Primary,
                          fontSize: 17,
                          fontWeight: FontWeight.bold),
                    ))),
          ),
        )
      ]),
    );
  }
}

class Slide_3 extends StatelessWidget {
  const Slide_3({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Center(
          child: Text("MomEase",
              style: TextStyle(
                  color: Appcolor.textPrimary,
                  fontWeight: FontWeight.bold,
                  fontSize: 40)),
        ),
        SizedBox(
          height: 20,
        ),
        Center(
          child: Text(
            " Siapkan Kehadiran Sang Buah Hati",
            style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0XFF384984)),
          ),
        ),
        SizedBox(
          height: 10,
        ),
        Text(
          "Bersama MomEase, Anda tidak hanya memantau kehamilan tetapi juga mempersiapkan diri menyambut kelahiran sang buah hati.",
          textAlign: TextAlign.justify,
          style: TextStyle(
              color: Colors.black.withOpacity(0.5),
              fontSize: 19,
              fontWeight: FontWeight.bold),
        ),
        Spacer(),
        SizedBox(
          width: double.infinity,
          height: MediaQuery.of(context).size.height / 2.9,
          child: Image.asset("Images/onboarding/onboarding2.png"),
        ),
      ],
    );
  }
}

class Slide_2 extends StatelessWidget {
  const Slide_2({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Center(
          child: Text("MomEase",
              style: TextStyle(
                  color: Appcolor.textPrimary,
                  fontWeight: FontWeight.bold,
                  fontSize: 40)),
        ),
        SizedBox(
          height: 20,
        ),
        Center(
          child: Text(
            "Fitur Unggulan",
            style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0XFF384984)),
          ),
        ),
        SizedBox(
          height: 10,
        ),
        Text(
          "Dengan fitur-fitur inovatif dari MomEase, Anda dapat melacak perkembangan janin, mengatur jadwal pemeriksaan",
          textAlign: TextAlign.justify,
          style: TextStyle(
              color: Colors.black.withOpacity(0.5),
              fontSize: 19,
              fontWeight: FontWeight.bold),
        ),
        Spacer(),
        SizedBox(
          width: double.infinity,
          height: MediaQuery.of(context).size.height / 2.9,
          child: Image.asset("Images/onboarding/onboarding3.png"),
        ),
      ],
    );
  }
}

class Slide_1 extends StatelessWidget {
  const Slide_1({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Center(
          child: Text("MomEase",
              style: TextStyle(
                  color: Appcolor.textPrimary,
                  fontWeight: FontWeight.bold,
                  fontSize: 40)),
        ),
        SizedBox(
          height: 20,
        ),

        Center(
          child: Text(
            "Selamat Datang",
            style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0XFF384984)),
          ),
        ),
        SizedBox(
          height: 10,
        ),
        Text(
          "mitra terpercaya untuk perjalanan kehamilan Anda! Kami hadir untuk membantu Anda memantau setiap momen penting selama kehamilan,",
          textAlign: TextAlign.justify,
          style: TextStyle(
              color: Colors.black.withOpacity(0.5),
              fontSize: 19,
              fontWeight: FontWeight.bold),
        ),
        // SizedBox(height: 50),
        Spacer(),
        SizedBox(
          width: double.infinity,
          height: MediaQuery.of(context).size.height / 2.9,
          child: Image.asset("Images/onboarding/onboarding1.png"),
        ),
      ],
    );
  }
}
