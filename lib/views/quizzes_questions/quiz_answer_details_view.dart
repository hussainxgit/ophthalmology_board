import 'package:flutter/material.dart';
import 'package:ophthalmology_board/models/quiz.dart';

class QuizAnswerDetailsView extends StatelessWidget {
  const QuizAnswerDetailsView({Key? key, required this.quizResult})
      : super(key: key);
  final QuizResult quizResult;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.black87,
          centerTitle: true,
          title: const Text('Under development !'),
        ),
        body: ListView(
          shrinkWrap: true,
          children: [
            const SizedBox(
              height: 20.0,
            ),
            Center(
                child: Text('Duration taken: ${quizResult.duration} seconds')),
            ListView.builder(
                shrinkWrap: true,
                physics: const ScrollPhysics(),
                itemCount: quizResult.chosenAnswers?.length,
                itemBuilder: (BuildContext context, index) {
                  return Column(
                    children: [
                      const SizedBox(
                        height: 20.0,
                      ),
                      const Text('Question UID:'),
                      Text(quizResult.chosenAnswers![index].keys.single),
                      const Text('Answer:'),
                      Text(quizResult.chosenAnswers![index].values.single
                          .toString()),
                      const SizedBox(
                        height: 20.0,
                      )
                    ],
                  );
                }),
            const Center(
                child: Text(
                    'This page still under development')),
          ],
        ));
  }
}
