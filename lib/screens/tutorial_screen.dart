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
  var images = [
    "https://i.pinimg.com/originals/44/ce/2c/44ce2cfa6267fde44790205135a78051.jpg",
    "https://i.pinimg.com/originals/d4/85/9f/d4859f69a68cd854e0aac9465fe0804b.jpg",
    "https://petapixel.com/assets/uploads/2019/02/mooncompositemain-800x800.jpg",
    "https://www.iphonehacks.com/wp-content/uploads/2019/11/Anamorphic-Pro-Visual-Effects-Mac-Bundle.jpg",
    "https://thumbs.gfycat.com/AgileSleepyHanumanmonkey.webp",
    "https://www.youtube.com/watch?v=sC9qhNPvW1M"
  ];

  var guidance = [
    'Tipps zur perfekten Videoaufnahme',
    'Achten Sie auf Ihre Umgebung und ein angemessenes Auftreten (Kleidung, innere Laune)'
        'Achten Sie darauf, dass Sie gut erkennbar sind, Kamera auf Augenhöhe nicht zu hoch, nicht zu tief. Passt das Licht?',
    'In guter Stimmung? Dann legen Sie einfach los. Sie haben 60 Sekunden Zeit. Zeigen Sie wer sie sind.',
    'Machen Sie sich vorher ein Paar Gedanken, was Ihnen wichtig ist, was sie sagen möchten. Nennen Sie ruhig Ihren Namen erzählen Sie von Ihrem Unternehmerischen Gedanken, Ihrer Passion.',
    'Als Nachfolgeinteressierte/r: Was motiviert Sie für eine Unternehmensübernahme?'
        'Als zukünftig Abgebende/r: Was ist das Besondere an Ihrem Unternehmen, was bieten Sie mit Ihrem Unternehmen der potentiellen Nachfolge?',
    'Beispielvideo'
  ];

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new Scaffold(
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
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Text(
                              guidance[index],
                              style: TextStyle(
                                color: Colors.black,
                              ),
                            ),
                            Flexible(
                              child: Image.network(
                                images[index],
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
        itemCount: images.length,
        pagination: new SwiperPagination(
            builder: new DotSwiperPaginationBuilder(
          activeColor: kSecondGreenColor,
        )),
        control: new SwiperControl(
          color: kSecondGreenColor,
        ),
      ),
    );
  }
}
