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
    url:
        "https://i.pinimg.com/originals/44/ce/2c/44ce2cfa6267fde44790205135a78051.jpg",
    guidance: 'Tipps zur perfekten Videoaufnahme',
  ),
  Slide(
    url:
        "https://i.pinimg.com/originals/d4/85/9f/d4859f69a68cd854e0aac9465fe0804b.jpg",
    guidance:
        'Achten Sie auf Ihre Umgebung und ein angemessenes Auftreten (Kleidung, innere Laune) Achten Sie darauf, dass Sie gut erkennbar sind, Kamera auf Augenhöhe nicht zu hoch, nicht zu tief. Passt das Licht?',
  ),
  Slide(
    url:
        "https://petapixel.com/assets/uploads/2019/02/mooncompositemain-800x800.jpg",
    guidance:
        'In guter Stimmung? Dann legen Sie einfach los. Sie haben 60 Sekunden Zeit. Zeigen Sie wer sie sind.',
  ),
  Slide(
    url:
        "https://www.iphonehacks.com/wp-content/uploads/2019/11/Anamorphic-Pro-Visual-Effects-Mac-Bundle.jpg",
    guidance:
        'Machen Sie sich vorher ein Paar Gedanken, was Ihnen wichtig ist, was sie sagen möchten. Nennen Sie ruhig Ihren Namen erzählen Sie von Ihrem Unternehmerischen Gedanken, Ihrer Passion.',
  ),
  Slide(
    url: "https://thumbs.gfycat.com/AgileSleepyHanumanmonkey.webp",
    guidance:
        'Als Nachfolgeinteressierte/r: Was motiviert Sie für eine Unternehmensübernahme?'
        'Als zukünftig Abgebende/r: Was ist das Besondere an Ihrem Unternehmen, was bieten Sie mit Ihrem Unternehmen der potentiellen Nachfolge?',
  ),
  Slide(
      url: "https://media2.giphy.com/media/hhqP18gMiwkY8/giphy.gif",
      guidance: 'Dummy')
];
