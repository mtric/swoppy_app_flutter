import 'package:Swoppy/components/alertShowDialogCollection.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';

Future<String> fetchVideoUrl(BuildContext context, String name) async {
  String url;
  try {
    StorageReference ref = FirebaseStorage.instance.ref().child(name);
    url = (await ref.getDownloadURL()).toString();
    return url;
  } catch (e) {
    showNoVideoFound(context);
    return null;
  }
}
