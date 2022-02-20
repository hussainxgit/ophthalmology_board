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
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: ListView(
        shrinkWrap: true,
        physics: const ScrollPhysics(),
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(widget.question.question!,
                  style: const TextStyle(
                      fontSize: 20.0, fontWeight: FontWeight.bold)),
              const SizedBox(
                height: 20.0,
              ),
              ListView.builder(
                  shrinkWrap: true,
                  physics: const ScrollPhysics(),
                  itemCount: widget.question.choices1!.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      tileColor:
                          selectedAnswer == index ? Colors.green : Colors.white,
                      onTap: () {
                        if (selectedAnswer == index) {
                          setState(() {
                            widget.clearAnswer(widget.question.uid,widget.question.choices1![index]);
                            selectedAnswer = null;
                          });
                        } else {
                          setState(() {
                            widget.chooseAnswer(widget.question.uid,
                                widget.question.choices1![index]);
                            selectedAnswer = index;
                          });
                        }
                      },
                      leading:
                          SizedBox(child: Text((index + 1).toString() + ' -')),
                      title: Text(widget.question.choices1![index].choice),
                    );
                  }),
              const Divider(),
            ],
          )
        ],
      ),
    );
  }
}
