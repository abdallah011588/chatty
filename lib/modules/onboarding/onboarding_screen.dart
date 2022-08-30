import 'package:chat/localization/localization_methods.dart';
import 'package:chat/modules/login_screen/login_screen.dart';
import 'package:chat/shared/local/cache.dart';
import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class boardingModel {

  final String image, title, body;

  boardingModel({
    required this.image,
    required this.title,
    required this.body,
  });
}

class onboardingScreen extends StatefulWidget {
  const onboardingScreen({Key? key}) : super(key: key);

  @override
  State<onboardingScreen> createState() => _onboardingScreenState();
}

class _onboardingScreenState extends State<onboardingScreen> {

  var pageviewcontroller = PageController();
  bool islast = false;
  void submit() {
    cache.setData(key: 'onBoarding', value: true).then((value) {
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) => loginScreen(),
          ),
          (route) => false,
        );
    }).catchError((error) {
      print(error.toString());
    });
  }

  @override
  Widget build(BuildContext context) {

    List<boardingModel> boarding = [
      boardingModel(
        image: 'https://img.freepik.com/free-vector/texting-concept-illustration_114360-2744.jpg?t=st=1649504770~exp=1649505370~hmac=aacc67193fb8a543cbaa139c42e9e719f51c7efc624fc6b438d09f2b9928ee54&w=740',
        title: getTranslated(context, 'boarding1')!,
        body:getTranslated(context, 'body1')!,
      ),
      boardingModel(
          image: 'https://img.freepik.com/free-vector/messaging-concept-illustration_114360-1093.jpg?w=740',
          title: getTranslated(context, 'boarding2')!,
          body: getTranslated(context, 'body2')!,
      ),
      boardingModel(
          image: 'https://img.freepik.com/free-vector/voice-chat-concept-illustration_114360-7794.jpg?w=740&t=st=1661529733~exp=1661530333~hmac=2fe2bf795a98bf81ac310af13b8dcf5035823ad7660694acb517a5481c42342d',
          title: getTranslated(context, 'boarding3')!,
          body: getTranslated(context, 'body3')!,
      ),
      boardingModel(
          image: 'https://img.freepik.com/free-vector/chatting-concept-illustration_114360-500.jpg?w=740',
          title: getTranslated(context, 'boarding4')!,
          body: getTranslated(context, 'body4')!,
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        actions: [
          TextButton(
            onPressed: () {
              submit();
            },
            child: Text(
              getTranslated(context, 'Skip')!,
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Expanded(
              child: PageView.builder(
                itemBuilder: (context, index) => pageviewBuilder(boarding[index]),
                controller: pageviewcontroller,
                physics: BouncingScrollPhysics(),
                itemCount: boarding.length,
                onPageChanged: (int index) {
                  if (index == boarding.length - 1) {
                    setState(() {
                      islast = true;
                    });
                  } else {
                    setState(() {
                      islast = false;
                    });
                  }
                },
              ),
            ),
            SizedBox(
              height: 40.0,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SmoothPageIndicator(
                  controller: pageviewcontroller,
                  count: boarding.length,
                  effect: ExpandingDotsEffect(
                    activeDotColor: Colors.teal,
                    dotColor: Colors.grey,
                    dotHeight: 10,
                    expansionFactor: 4,
                    dotWidth: 10,
                    spacing: 10,
                  ),
                ),
              //  Spacer(),
                FloatingActionButton(
                  onPressed: () {
                    if (islast) {
                      submit();
                    } else {
                      pageviewcontroller.nextPage(
                        duration: Duration(milliseconds: 750),
                        curve: Curves.fastLinearToSlowEaseIn,
                      );
                    }
                  },
                  child: Icon(Icons.arrow_forward_ios),
                  backgroundColor: Colors.teal,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

Widget pageviewBuilder(boardingModel model) => Column(
  crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Image(
           image: NetworkImage('${model.image}'),
        )),
        SizedBox(
          height: 10.0,
        ),
        Container(
          decoration: BoxDecoration(
              color: Colors.teal[200],
              borderRadius: BorderRadius.only(topRight:Radius.circular(20),bottomLeft: Radius.circular(20))
          ),
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Text(
              '${model.title}',
              style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold,),
            ),
          ),
        ),
        SizedBox(
          height: 10.0,
        ),
        Text(
          '${model.body}',
          style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold,color: Colors.teal),
        ),
        SizedBox(
          height: 10.0,
        ),
      ],
    );
