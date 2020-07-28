import 'package:flutter/cupertino.dart';

class Slide {
  final String url;
  final String guidance;

  Slide({
    @required this.url,
    @required this.guidance,
  });
}

final slideList = [
  Slide(
    url: "images/dummyPic_1_ok.jpg",
    guidance: 'Tipps zur perfekten Videoaufnahme',
  ),
  Slide(
    url: "images/dummyPic_2_candle.jpg",
    guidance:
        'Achten Sie auf Ihre Umgebung und ein angemessenes Auftreten (Kleidung, innere Laune). Achten Sie darauf, dass Sie gut erkennbar sind, Kamera auf Augenhöhe nicht zu hoch, nicht zu tief. Passt das Licht?',
  ),
  Slide(
    url: "images/dummyPic_3_moon.jpg",
    guidance:
        'In guter Stimmung? Dann legen Sie einfach los. Sie haben 60 Sekunden Zeit. Zeigen Sie wer sie sind.',
  ),
  Slide(
    url: "images/dummyPic_4_sunset.jpg",
    guidance:
        'Machen Sie sich vorher ein Paar Gedanken, was Ihnen wichtig ist, was sie sagen möchten. Nennen Sie ruhig Ihren Namen erzählen Sie von Ihren unternehmerischen Gedanken, Ihrer Passion.',
  ),
  Slide(
    url: "images/dummyPic_5_pierce.webp",
    guidance:
        'Als Nachfolgeinteressierte/r: Was motiviert Sie für eine Unternehmensübernahme? Als zukünftig Abgebende/r: Was ist das Besondere an Ihrem Unternehmen, was bieten Sie mit Ihrem Unternehmen der potentiellen Nachfolge?',
  ),
  Slide(url: "images/dummyPic_6_welcome.webp", guidance: 'Dummy')
];
