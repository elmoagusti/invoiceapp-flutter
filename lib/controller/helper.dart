import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../repo/sharedprefs.dart';

class HelpC extends GetxController {
  void onInit() {
    super.onInit();
  }

  final a = 1.obs;
  final stats = 0.obs;

  void select(int value) {
    a.value = value;
  }

  void status(int value) {
    stats.value = value;
  }

  RxList<XFile> imageFileList = <XFile>[].obs;
  RxString imgPath = "".obs;

  imageFile(XFile? value) {
    imageFileList.value = (value == null ? null : [value])!;
    imgPath.value = value!.path;
    print(value.path);
  }

  void onImageButtonPressed(ImageSource source,
      {bool isMultiImage = false}) async {
    final ImagePicker _picker = ImagePicker();

    if (isMultiImage) {
      try {
        final pickedFileList = await _picker.pickMultiImage(
          maxWidth: 300,
          maxHeight: 300,
          imageQuality: 100,
        );
        imageFileList.value = pickedFileList!;
        for (var i = 0; i < pickedFileList.length; i++) {
          print(pickedFileList[i].path);
        }
      } catch (e) {
        print(e);
      }
    } else {
      try {
        final pickedFile = await _picker.pickImage(
          source: source,
          maxWidth: 300,
          maxHeight: 300,
          imageQuality: 50,
        );
        imageFile(pickedFile);
      } catch (e) {
        print(e);
      }
    }
  }
}
