import 'package:flutter/material.dart';
import 'package:get/instance_manager.dart';
import 'package:get/state_manager.dart';
import 'package:ophthalmology_board/models/quiz.dart';
import 'package:ophthalmology_board/services/api_services.dart';
import 'package:ophthalmology_board/services/data_services.dart';
import 'package:ophthalmology_board/views/quizzes_questions/quiz_question.dart';
import 'package:ophthalmology_board/widgets/custom_dialogs.dart';
import 'package:timer_count_down/timer_count_down.dart';

class QuizView extends StatefulWidget {
  final Quiz quiz;

  const QuizView({Key? key, required this.quiz}) : super(key: key);

  @override
  _QuizViewState createState() => _QuizViewState();
}

class _QuizViewState extends State<QuizView> {
  final DataServices _dataServices = Get.find();
  final ApiServices _apiServices = ApiServices();
  List<Map<String, int>> chosenAnswers = [];
  List<Question> quizQuestions = [];
  int durationInSeconds = 0;
  int durationInMinutes = 0;
  int quizDurationResult = 0;

  @override
  void initState() {
    durationInSeconds = widget.quiz.duration!.round();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    durationInMinutes = (durationInSeconds / 60).round();
    return Scaffold(
      appBar: AppBar(
        title: Obx(() => Text(
            '${_dataServices.quizQuestions.length}/${chosenAnswers.length} answered')),
        actions: [
          Center(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Countdown(
                seconds: durationInSeconds,
                build: (BuildContext ctx, double time) {
                  quizDurationResult = durationInSeconds - time.round();
                  return Text(
                    time < 60
                        ? time.toString() + 's'
                        : durationInMinutes.toString() + 'm',
                    style: TextStyle(
                        color: time < 60 ? Colors.redAccent : Colors.white),
                  );
                },
                interval: const Duration(milliseconds: 100),
                onFinished: () {
                  quizFinish(context);
                },
              ),
            ),
          ),
        ],
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: ListView(
          shrinkWrap: true,
          children: [
            FutureBuilder(
                future: _dataServices.getQuizQuestions(widget.quiz),
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  if (snapshot.hasData) {
                    quizQuestions = snapshot.data;
                    return ListView.builder(
                        shrinkWrap: true,
                        physics: const ScrollPhysics(),
                        itemCount: _dataServices.quizQuestions.length,
                        itemBuilder: (BuildContext context, index) {
                          return QuizQuestion(
                              question: _dataServices.quizQuestions[index],
                              chooseAnswer: chooseAnswer,
                              clearAnswer: clearAnswer);
                        });
                  } else if (snapshot.hasError) {
                    return Container(
                        margin: const EdgeInsets.all(30.0),
                        child: Text(snapshot.error.toString()));
                  } else {
                    return Container(
                        margin: const EdgeInsets.all(30.0),
                        child: const Text('Loading'));
                  }
                }),
            const Divider(),
            const SizedBox(
              height: 30.0,
            ),
            SizedBox(
              height: 50,
              width: double.infinity,
              child: FlatButton(
                onPressed: () {
                  makeSureDialog(context).then(
                      (value) => value == true ? quizFinish(context) : null);
                },
                padding: const EdgeInsets.all(0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Ink(
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                      colors: [Colors.lightBlue, Colors.blueAccent],
                    ),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Container(
                    alignment: Alignment.center,
                    constraints: const BoxConstraints(
                        minHeight: 50, maxWidth: double.infinity),
                    child: const Text(
                      "Finish",
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.white),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void chooseAnswer(String questionUid, int answer) {
    Map<String, int> data = {questionUid: answer};
    setState(() {
      if (chosenAnswers.isNotEmpty) {
        chosenAnswers.removeWhere((element) => element[questionUid] != null);
      }
      chosenAnswers.add(data);
    });
    print(chosenAnswers);
  }

  void clearAnswer(String questionUid) {
    setState(() {
      chosenAnswers.removeWhere((element) => element[questionUid] != null);
    });
    print(chosenAnswers);
  }

  Future<void> quizFinish(BuildContext context) async {
    int score = 0;
    for (var element in chosenAnswers) {
      if (quizQuestions
          .where((i) => i.uid == element.keys.single)
          .single
          .answer!
          .contains(element.values.single)) {
        score++;
      }
    }
    _apiServices
        .addQuizResult(QuizResult(
            doctorUid: _dataServices.doctorUser.value.uid,
            quizUid: widget.quiz.uid,
            duration: quizDurationResult,
            score: score,
            chosenAnswers: chosenAnswers))
        .whenComplete(() => _dataServices
            .removeFromLocalQuiz(widget.quiz)
            .whenComplete(() => showQuizScore(context, score)));
  }
}