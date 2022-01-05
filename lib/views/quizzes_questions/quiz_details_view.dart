import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/instance_manager.dart';
import 'package:get/state_manager.dart';
import 'package:ophthalmology_board/models/doctor_user.dart';
import 'package:ophthalmology_board/models/quiz.dart';
import 'package:ophthalmology_board/services/api_services.dart';
import 'package:ophthalmology_board/services/data_services.dart';
import 'package:ophthalmology_board/views/quizzes_questions/quiz_answer_details_view.dart';

class QuizDetailsView extends StatefulWidget {
  final Quiz quiz;

  const QuizDetailsView({Key? key, required this.quiz}) : super(key: key);

  @override
  _QuizDetailsViewState createState() => _QuizDetailsViewState();
}

class _QuizDetailsViewState extends State<QuizDetailsView> {
  final DataServices _dataServices = Get.find();

  @override
  void initState() {
    super.initState();
    _dataServices.getQuizResults(widget.quiz);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            icon: const Icon(Icons.delete),
            tooltip: 'Delete',
            onPressed: () {
              _dataServices
                  .removeQuiz(widget.quiz)
                  .whenComplete(() => Get.back());
            },
          ),
        ],
      ),
      body: Obx(() => ListView.builder(
            shrinkWrap: true,
            itemCount: _dataServices.quizParticipants.length,
            itemBuilder: (BuildContext context, int index) {
              return ListTile(
                leading: Container(
                  padding: const EdgeInsets.only(right: 12.0),
                  decoration: const BoxDecoration(
                      border: Border(right: BorderSide(width: 0.7))),
                  child: Text(_dataServices.doctorUser.value.rotationYear!),
                ),
                title: Text(
                  _dataServices.quizParticipants[index].name!,
                ),
                subtitle: Text(_dataServices.quizParticipants[index].quizResult == null
                    ? 'Not finished yet'
                    : 'Score: ' + _dataServices.quizParticipants[index].quizResult!.score.toString()),
                trailing: const Icon(Icons.keyboard_arrow_right, size: 30.0),
                onTap: () {
                  if(_dataServices.quizParticipants[index].quizResult != null){
                    Get.to(() => QuizAnswerDetailsView(quizResult: _dataServices.quizParticipants[index].quizResult!));
                  }
                },
              );
            },
          )),
    );
  }
}
