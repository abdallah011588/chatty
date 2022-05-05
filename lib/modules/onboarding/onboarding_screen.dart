import 'package:chat/modules/login_screen/login_screen.dart';
import 'package:chat/shared/local/cache.dart';
import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';


class boardingModel
{
  final String image,title,body;

  boardingModel({
    required this.image,
    required this.title,
    required this.body,
  });
}

class onboardingScreen extends StatefulWidget{
  const onboardingScreen({Key? key}) : super(key: key);

  @override
  State<onboardingScreen> createState() => _onboardingScreenState();
}

class _onboardingScreenState extends State<onboardingScreen>
{

  List<boardingModel> boarding=[
    boardingModel(image: 'https://img.freepik.com/free-vector/texting-concept-illustration_114360-2744.jpg?t=st=1649504770~exp=1649505370~hmac=aacc67193fb8a543cbaa139c42e9e719f51c7efc624fc6b438d09f2b9928ee54&w=740',
        title: 'boarding 1', body: 'body 1'),

    boardingModel(image: 'https://img.freepik.com/free-vector/messaging-concept-illustration_114360-1093.jpg?w=740',
        title: 'boarding 2', body: 'body 2'),

    boardingModel(image: 'https://img.freepik.com/free-vector/video-call-with-girlfriend-mobile-phone-vector-flat-cartoon_101884-204.jpg?w=740',
        title: 'boarding 3', body: 'body 3'),

    boardingModel(image: 'https://img.freepik.com/free-vector/chatting-concept-illustration_114360-500.jpg?w=740',
        title: 'boarding 4', body: 'body 4'),
  ];

  var pageviewcontroller=PageController();

  bool islast=false;

  void submit()
  {
    cache.setData(key: 'onBoarding', value: true).then((value) {
      if(true)
      {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => loginScreen(),),
              (route) => false,
        );
      }
    }).catchError((error){
      print(error.toString());
    });




  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          TextButton(
              onPressed: (){
                submit();
              },
              child: Text('Skip',style: TextStyle(color: Colors.white),),
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
                itemCount:boarding.length ,
                onPageChanged: (int index){
                  if(index==boarding.length-1)
                  {
                    setState(()
                    {
                      islast=true;
                    });
                  }
                  else{
                    setState(()
                    {
                      islast=false;
                    });
                  }
                },
              ),

            ),
            SizedBox(height: 40.0,),
            Row(
              children: [
                SmoothPageIndicator(
                  controller: pageviewcontroller,
                  count: boarding.length,
                  effect:ExpandingDotsEffect(
                  activeDotColor: Colors.teal,
                    dotColor: Colors.grey,
                    dotHeight: 10,
                    expansionFactor: 4,
                    dotWidth: 10,
                    spacing: 10,
                  ),
                ),
                Spacer(),

                FloatingActionButton(
                  onPressed: (){
                    if(islast)
                    {
                      submit();
                    }
                    else{
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



Widget pageviewBuilder(boardingModel model)=>Column(
  children: [
    Expanded(child: Image(image: NetworkImage('${model.image}'),)),
    SizedBox(height: 10.0,),
    Text('${model.title}',
      style:TextStyle(fontSize: 24.0,fontWeight: FontWeight.bold),
    ),
    SizedBox(height: 10.0,),
    Text('${model.body}',
      style:TextStyle(fontSize: 24.0,fontWeight: FontWeight.bold),
    ),
    SizedBox(height: 10.0,),
  ],
);