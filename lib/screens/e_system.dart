import 'package:string_similarity/string_similarity.dart';

List<int> flags = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0];
int percent = 0;
void matchAnswer(
    String ans1, String ans2, String ans3, String ans4, String ans5, int flag) {
  String answer1 = "";
  String answer2 = "";
  String answer3 = "";
  String answer4 = "";
  String answer5 = "";
  answer1 = ans1;
  answer2 = ans2;
  answer3 = ans3;
  answer4 = ans4;
  answer5 = ans5;
  var expertAnswers = [answer1, answer2, answer3, answer4, answer5];
  String comingAnswer = "";
  for (int i = 0; i < expertAnswers.length; i++) {
    if (comingAnswer.similarityTo(expertAnswers[i]) > 0.6) {
      flag++;
    }
  }
}

forAll10Ques() {
  for (int i = 0; i < 10; i++) {
    if (flags[i] > 3) {
      percent++;
    }
  }
  if (percent > 8) {
    print("Most recommended");
  } else if (percent > 5 && percent < 9) {
    print("Average");
  } else if (percent > 3 && percent < 6) {
    print("Average");
  } else if (percent > 0 && percent < 4) {
    print("Below Average");
  }
}
