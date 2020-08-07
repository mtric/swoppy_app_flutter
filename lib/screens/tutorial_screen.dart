import 'package:Swoppy/components/rounded_button.dart';
import 'package:Swoppy/components/slides.dart';
import 'package:Swoppy/screens/video_screen.dart';
import 'package:Swoppy/utilities/constants.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';

class TutorialScreen extends StatefulWidget {
  static const String id = 'tutorial_screen';
  final String title;
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
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    if (index == slideList.length - 1)
                      Center(
                        child: RoundedButton(
                          title: 'Hier zum Video',
                          colour: kSecondBlueColor,
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => VideoScreen(
                                  videoPath: ktutorialVideoPath,
                                  isAsset: true,
                                  isNetwork: false,
                                ),
                              ),
                            );
                          },
                        ),
                      )
                    else
                      Expanded(
                        child: Card(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              if (index == 0)
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: AutoSizeText(
                                    slideList[index].guidance,
                                    textAlign: TextAlign.center,
                                    style: kTutorialTitleTextStyle,
                                  ),
                                )
                              else
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: AutoSizeText(
                                    slideList[index].guidance,
                                    textAlign: TextAlign.justify,
                                    style: kTutorialGuidanceTextStyle,
                                  ),
                                ),
                              Flexible(
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Image.asset(
                                    slideList[index].url,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                  ],
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
