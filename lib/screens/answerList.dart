import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';
import 'package:prj1/utils/speechController.dart';

class AnswerList extends GetView<SpeechController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: Text("Answers"),
      ),
      body: Container(
        child: Column(
          children: [
            Obx(() => Flexible(
                    child: Text(
                  controller.speechText.value,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 10,
                )))
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          controller.listen();
        },
        child: Icon(Icons.mic),
      ),
    );
  }
}
