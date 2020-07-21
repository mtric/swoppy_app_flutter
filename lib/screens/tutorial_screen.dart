import 'package:Swoppy/components/rounded_button.dart';
import 'package:Swoppy/components/slides.dart';
import 'package:Swoppy/screens/videoExample_screen.dart';
import 'package:Swoppy/utilities/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';

class TutorialScreen extends StatefulWidget {
  static const String id = 'tutorial_screen';
  String title;
  TutorialScreen({Key key, this.title}) : super(key: key);
  @override
  _TutorialScreenState createState() => _TutorialScreenState();
}

class _TutorialScreenState extends State<TutorialScreen> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new Scaffold(
      appBar: AppBar(
        title: Text('Tutorial'),
      ),
      body: new Swiper(
        itemBuilder: (BuildContext context, int index) {
          return Stack(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(60.0),
                child: Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      if (index == slideList.length - 1)
                        Flexible(
                          child: Center(
                            child: RoundedButton(
                              title: 'Hier zum Video',
                              colour: kSecondBlueColor,
                              onPressed: () {
                                Navigator.pushNamed(context, VideoExample.id);
                              },
                            ),
                          ),
                        )
                      else
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Text(
                                slideList[index].guidance,
                                style: TextStyle(
                                  color: Colors.black,
                                ),
                              ),
                              Flexible(
                                child: Image.network(
                                  slideList[index].url,
                                ),
                              ),
                            ],
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
        itemCount: slideList.length,
        pagination: new SwiperPagination(
            builder: new DotSwiperPaginationBuilder(
          activeColor: kSecondGreenColor,
          color: kMainLightGreyColor,
        )),
        control: new SwiperControl(
          color: kSecondGreenColor,
        ),
      ),
    );
  }
}
