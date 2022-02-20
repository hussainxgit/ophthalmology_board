import 'package:flutter/material.dart';
import 'package:ophthalmology_board/models/quiz.dart';

class QuizQuestion extends StatefulWidget {
  final Function chooseAnswer;
  final Function clearAnswer;
  final Question question;

  const QuizQuestion(
      {Key? key,
      required this.question,
      required this.chooseAnswer,
      required this.clearAnswer})
      : super(key: key);

  @override
  _QuizQuestionState createState() => _QuizQuestionState();
}

class _QuizQuestionState extends State<QuizQuestion> {
  int? selectedAnswer;

  @override
  Widget build(BuildContext context) {
    return ListView(
      shrinkWrap: true,
      physics: const ScrollPhysics(),
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ListTile(
              title: Text(widget.question.question!,
                  style: const TextStyle(
                      fontSize: 20.0, fontWeight: FontWeight.bold)),
            ),
            const SizedBox(
              height: 20.0,
            ),
            ListView.separated(
                separatorBuilder: (BuildContext context, int index) {
                  return const SizedBox(height: 16);
                },
                shrinkWrap: true,
                physics: const ScrollPhysics(),
                itemCount: widget.question.choices!.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                      side: BorderSide(color: selectedAnswer == index ? Colors.blue : Colors.black45),
                    ),
                    onTap: () {
                      if (selectedAnswer == index) {
                        setState(() {
                          widget.clearAnswer(widget.question.uid,widget.question.choices![index]);
                          selectedAnswer = null;
                        });
                      } else {
                        setState(() {
                          widget.chooseAnswer(widget.question.uid,
                              widget.question.choices![index]);
                          selectedAnswer = index;
                        });
                      }
                    },
                    title: Text(widget.question.choices![index].choice),
                    trailing: selectedAnswer == index ? const Icon(Icons.done, color: Colors.blue,) : const Icon(Icons.circle_outlined),

                  );
                }),
            const Divider(),
          ],
        )
      ],
    );
  }
}
