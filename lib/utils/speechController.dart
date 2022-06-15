import 'package:get/get.dart';
import 'package:speech_to_text/speech_to_text.dart';

class SpeechController extends GetxController {
  var isListening = false.obs;
  var speechText = "Press the mic button and start speaking".obs;
  late SpeechToText speechToText;
  @override
  void onInit() {
    super.onInit();
    speechToText = SpeechToText();
  }

  @override
  void onReady() {}

  @override
  void onClose() {}
  Future<void> listen() async {
    print("listening");
    if (!isListening.value) {
      speechToText = SpeechToText();

      bool available = await speechToText.initialize(
        onStatus: (val) {},
        onError: (val) {},
      );
      if (available) {
        isListening.value = true;
        speechToText.listen(onResult: (val) {
          speechText.value = val.recognizedWords;
          print(speechText.value);
        });
      }
    } else {
      isListening.value = false;
      speechToText.stop();
      speechText.value = "";
    }
  }
}
