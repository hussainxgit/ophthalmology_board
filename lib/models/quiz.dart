import 'package:cloud_firestore/cloud_firestore.dart';

class Quiz {
  String? uid, title, creator;
  DateTime? creationDate, startDate, deadlineDate;
  List<String>? participants = [], questions = [], completedParticipants = [];
  int? duration;

  Quiz({
    this.uid,
    this.title,
    this.creator,
    this.creationDate,
    this.startDate,
    this.deadlineDate,
    this.participants,
    this.questions,
    this.duration,
    this.completedParticipants,
  });

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'creator': creator,
      'creationDate': creationDate,
      'startDate': startDate,
      'deadlineDate': deadlineDate,
      'participants': participants,
      'questions': questions,
      'duration': duration,
    };
  }

  factory Quiz.fromMap(Map<String, dynamic> map, String uid) {
    return Quiz(
      uid: uid,
      title: map['title'] as String,
      creator: map['creator'] as String,
      duration: map['duration'] as int ,
      creationDate: (map['creationDate'] as Timestamp).toDate(),
      startDate: (map['startDate'] as Timestamp).toDate(),
      deadlineDate: (map['deadlineDate'] as Timestamp).toDate(),
      participants:( map['participants'] as List<dynamic>).map<String>((e) => e).toList(),
      questions: (map['questions'] as List<dynamic>).map<String>((e) => e).toList(),
      completedParticipants: map['completed_participants'] != null ? (map['completed_participants'] as List<dynamic>).map<String>((e) => e).toList() : [],
    );
  }
}

class QuizResult {
  String? uid, doctorUid, quizUid;
  int? duration, score;
  List<Map<String, dynamic>>? chosenAnswers = [];
  Timestamp? documentDate;

  QuizResult({
    this.uid,
    this.doctorUid,
    this.quizUid,
    this.duration,
    this.score,
    this.chosenAnswers,
    this.documentDate,
  });

  Map<String, dynamic> toMap() {
    return {
      'doctorUid': doctorUid,
      'quizUid': quizUid,
      'duration': duration,
      'score': score,
      'chosenAnswers': chosenAnswers,
    };
  }

  factory QuizResult.fromMap(Map<String, dynamic> map, String uid) {

    return QuizResult(
      uid: uid,
      doctorUid: map['doctorUid'] as String,
      quizUid: map['quizUid'] as String,
      duration: map['duration'] as int,
      score: map['score'] as int,
      chosenAnswers: (map['chosenAnswers'] as List<dynamic>).map<Map<String, dynamic>>((e) => e).toList(),
      // documentDate: map['documentDate'] as Timestamp,
    );
  }
}

class Question {
  String? uid, question, creator;
  List<int>? answer = [];
  Map<String, dynamic>? choices;
  DateTime? creationDate;

  Question({
    this.uid,
    this.question,
    this.answer,
    this.choices,
    this.creator,
    this.creationDate,
  });

  Map<String, dynamic> toMap() {
    return {
      'question': question,
      'answer': answer,
      'choices': choices,
      'creator': creator,
      'creationDate': creationDate,
    };
  }

  factory Question.fromMap(Map<String, dynamic> map, String uid) {
    return Question(
      uid: uid,
      question: map['question'] as String,
      creator: map['creator'] as String,
      creationDate: (map['creationDate'] as Timestamp).toDate(),
      answer: map['answer'].cast<int>(),
      choices: map['choices'] as Map<String, dynamic>,
    );
  }
}