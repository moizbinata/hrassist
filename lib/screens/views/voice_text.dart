import 'package:fluttertoast/fluttertoast.dart';
import 'package:page_transition/page_transition.dart';
import 'package:prj1/screens/Questionlist.dart';
import 'package:string_similarity/string_similarity.dart';
import 'package:avatar_glow/avatar_glow.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:highlight_text/highlight_text.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

class VoiceToText extends StatefulWidget {
  final int qNo;
  const VoiceToText({Key? key, required this.qNo}) : super(key: key);

  @override
  _VoiceToTextState createState() => _VoiceToTextState();
}

class _VoiceToTextState extends State<VoiceToText> {
  GetStorage box = GetStorage();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _speech = stt.SpeechToText();
  }

  final Map<String, HighlightedWord> _highlights = {
    'flutter': HighlightedWord(
      onTap: () => print('flutter'),
      textStyle: const TextStyle(
        color: Colors.blue,
        fontWeight: FontWeight.bold,
      ),
    ),
    'voice': HighlightedWord(
      onTap: () => print('voice'),
      textStyle: const TextStyle(
        color: Colors.green,
        fontWeight: FontWeight.bold,
      ),
    ),
    'subscribe': HighlightedWord(
      onTap: () => print('subscribe'),
      textStyle: const TextStyle(
        color: Colors.red,
        fontWeight: FontWeight.bold,
      ),
    ),
    'like': HighlightedWord(
      onTap: () => print('like'),
      textStyle: const TextStyle(
        color: Colors.blueAccent,
        fontWeight: FontWeight.bold,
      ),
    ),
    'comment': HighlightedWord(
      onTap: () => print('comment'),
      textStyle: const TextStyle(
        color: Colors.green,
        fontWeight: FontWeight.bold,
      ),
    ),
  };

  late stt.SpeechToText _speech;
  bool _isListening = false;
  String comingAns = 'Press button and start speaking';
  double _confidence = 1.0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Confidence: ${(_confidence * 100.0).toStringAsFixed(1)}%'),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: AvatarGlow(
        animate: _isListening,
        glowColor: Theme.of(context).primaryColor,
        endRadius: 75.0,
        duration: const Duration(milliseconds: 2000),
        repeatPauseDuration: const Duration(milliseconds: 100),
        repeat: true,
        child: Row(
          children: [
            FloatingActionButton(
              heroTag: "btn1",
              onPressed: _listen,
              child: Icon(_isListening ? Icons.mic : Icons.mic_none),
            ),
            SizedBox(
              width: 10,
            ),
            FloatingActionButton(
              heroTag: "btn2",
              onPressed: () {
                stringSimmilarity(widget.qNo);
              },
              child: Icon(Icons.check),
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        reverse: true,
        child: Container(
          padding: const EdgeInsets.fromLTRB(30.0, 30.0, 30.0, 150.0),
          child: TextHighlight(
            text: comingAns,
            words: _highlights,
            textStyle: const TextStyle(
              fontSize: 18.0,
              color: Colors.white,
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
      ),
    );
  }

  void stringSimmilarity(int ansNo) async {
    FirebaseFirestore db = FirebaseFirestore.instance;
    List expAns = [];
    String q_id = box.read('q_id').toString();
    print(q_id);
    final DocumentSnapshot snapshot =
        await db.collection("users").doc(q_id).get();
    print(snapshot['a' + ansNo.toString() + '_1']);
    for (int i = 1; i < 6; i++) {
      expAns.add(snapshot['a' + ansNo.toString() + '_$i']);
      // print(snapshot['a1_${i.toString()}']);
      // print(i);
    }
    print(expAns);
    List<int> flags = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0];
    for (int i = 0; i < expAns.length; i++) {
      if (comingAns.similarityTo(expAns[i]) > 0.5) {
        print("score for exp ans $i");
        print(comingAns.similarityTo(expAns[i]));
        flags[ansNo - 1]++;
      }
    }
    print("Score for answer ${ansNo.toString()} is: " +
        flags[ansNo - 1].toString());
    double perc = (flags[ansNo - 1] / 5) * 100;
    String userID = FirebaseAuth.instance.currentUser!.uid;
    FirebaseFirestore.instance
        .collection("interviewee_details")
        .doc(userID)
        .update(
      {
        "a${ansNo.toString()}": comingAns,
        "conf${ansNo.toString()}": (_confidence * 100).toStringAsFixed(1),
        "percent${ansNo.toString()}": perc.toString(),
      },
    ).whenComplete(() => completeAndRoute());
  }

  void completeAndRoute() {
    print("updated");
    Fluttertoast.showToast(msg: "Answer has been recorded.");
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => QuestionList()),
    );
  }

  void _listen() async {
    if (!_isListening) {
      bool available = await _speech.initialize(
        onStatus: (val) => print('onStatus: $val'),
        onError: (val) => print('onError: $val'),
      );
      if (available) {
        setState(() => _isListening = true);
        _speech.listen(
          onResult: (val) => setState(() {
            comingAns = val.recognizedWords;
            if (val.hasConfidenceRating && val.confidence > 0) {
              _confidence = val.confidence;
            }
          }),
        );
      }
    } else {
      setState(() => _isListening = false);
      _speech.stop();
    }
  }
}
