import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:get/instance_manager.dart';
import 'package:ophthalmology_board/models/quiz.dart';
import 'package:ophthalmology_board/services/data_services.dart';
import 'package:ophthalmology_board/widgets/custom_app_bar.dart';

class AddQuestion extends StatefulWidget {
  const AddQuestion({Key? key}) : super(key: key);

  @override
  State<AddQuestion> createState() => _AddQuestionState();
}

class _AddQuestionState extends State<AddQuestion> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  TextEditingController dateCtl = TextEditingController();
  TextEditingController questionController = TextEditingController();
  TextEditingController choicesController = TextEditingController();
  Map<String, dynamic> questionChoices = {};
  DateTime selectedDate = DateTime.now();
  List<int> answers = [];
  final DataServices _dataServices = Get.find();

  Future<DateTime?> showDate(BuildContext context) async {
    return await showDatePicker(
            context: context,
            initialDate: selectedDate,
            firstDate: DateTime(1998),
            lastDate: DateTime(2100)) ??
        selectedDate;
  }

  Question question = Question();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        actionList: [
          IconButton(
            icon: const Icon(Icons.save),
            tooltip: 'Send',
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                if (answers.isEmpty) {
                  return;
                } else if (questionChoices.isEmpty) {
                  return;
                }
                question.creator = 'aseel';
                question.question = questionController.text;
                question.choices = questionChoices;
                question.answer = answers;
                question.creationDate = selectedDate;
                _dataServices
                    .addQuestion(question)
                    .whenComplete(() => Get.back());
              }
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(
                      height: 20.0,
                    ),
                    const Text(
                      'Add Question',
                      style: TextStyle(
                          fontSize: 20.0, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(
                      height: 20.0,
                    ),
                    TextFormField(
                      controller: questionController,
                      maxLines: null,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Write your question';
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        labelText: "Write Question",
                        labelStyle: TextStyle(
                            fontSize: 14, color: Colors.grey.shade400),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(
                            color: Colors.grey.shade300,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: const BorderSide(
                              color: Colors.blueAccent,
                            )),
                        errorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: const BorderSide(
                              color: Colors.red,
                            )),
                      ),
                    ),
                    const SizedBox(
                      height: 20.0,
                    ),
                    TextFormField(
                      onEditingComplete: () {
                        setState(() {
                          if (choicesController.text.isNotEmpty) {
                            questionChoices.addAll({
                              (questionChoices.length.toString()):
                                  choicesController.text
                            });
                          }
                        });
                      },
                      controller: choicesController,
                      maxLines: null,
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                        labelText: "Create choices",
                        labelStyle: TextStyle(
                            fontSize: 14, color: Colors.grey.shade400),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(
                            color: Colors.grey.shade300,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: const BorderSide(
                              color: Colors.blueAccent,
                            )),
                      ),
                    ),
                    const SizedBox(
                      height: 20.0,
                    ),
                    ListView.builder(
                        shrinkWrap: true,
                        itemCount: questionChoices.length,
                        itemBuilder: (context, index) {
                          return ListTile(
                            leading: SizedBox(
                                child: Text((index + 1).toString() + ' -')),
                            title: Text(questionChoices[index.toString()]),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                answers
                                        .where(
                                            (element) => element == (index + 1))
                                        .isEmpty
                                    ? IconButton(
                                        onPressed: () {
                                          setState(() {
                                            answers.add((index + 1));
                                          });
                                        },
                                        icon: const Icon(Icons.done))
                                    : IconButton(
                                        onPressed: () {
                                          setState(() {
                                            answers.remove((index + 1));
                                          });
                                        },
                                        icon: const Icon(Icons.close)),
                                IconButton(
                                    onPressed: () {
                                      setState(() {
                                        Map<String, dynamic> tempChoicesMap =
                                            {};
                                        int temp = 0;
                                        questionChoices.removeWhere(
                                            (key, value) =>
                                                key == index.toString());
                                        questionChoices.forEach((key, value) {
                                          tempChoicesMap
                                              .addAll({temp.toString(): value});
                                          temp++;
                                        });
                                        questionChoices.clear();
                                        questionChoices.addAll(tempChoicesMap);
                                        if (answers.isNotEmpty) {
                                          answers.remove(answers
                                              .where((element) =>
                                                  element == (index + 1))
                                              .single);
                                        }
                                      });
                                    },
                                    icon: const Icon(Icons.delete)),
                              ],
                            ),
                          );
                        }),
                    const SizedBox(
                      height: 20.0,
                    ),
                    const Text(
                      'Answers',
                      style: TextStyle(
                          fontSize: 20.0, fontWeight: FontWeight.bold),
                    ),
                    ListTile(
                      title: Text(answers.isEmpty ? '' : answers.toString()),
                    ),
                  ],
                ))
          ],
        ),
      ),
    );
  }
}
