import 'package:get/get.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:ophthalmology_board/models/data_response.dart';
import 'package:ophthalmology_board/models/doctor_user.dart';
import 'package:ophthalmology_board/models/operation.dart';
import 'package:ophthalmology_board/models/quiz.dart';
import 'package:ophthalmology_board/services/api_services.dart';

class DataServices extends GetxController {
  final ApiServices _apiServices = ApiServices();
  final DataResponse _dataResponse = DataResponse();
  Rx<DoctorUser> doctorUser = DoctorUser().obs;
  Rx<bool> isLogged = false.obs;
  RxList<Quiz> allQuizzes = <Quiz>[].obs;
  RxList<Operation> doctorOperations = <Operation>[].obs;
  RxList<Question> allQuestion = <Question>[].obs;
  RxList<Question> quizQuestions = <Question>[].obs;
  RxList<DoctorUser> quizParticipants = <DoctorUser>[].obs;
  RxList<QuizResult> quizResults = <QuizResult>[].obs;
  RxList<DoctorUser> allUsers = <DoctorUser>[].obs;

  DataServices();

  Future<RxList<Operation>> getAllDoctorOperations() async {
    doctorOperations
        .assignAll(await _apiServices.getAllOperations(doctorUser.value));
    doctorOperations.refresh();
    return doctorOperations;
  }

  Future<List<Question>> getQuizQuestions(Quiz quiz) async {
    quizQuestions.assignAll(await _apiServices.getQuizQuestions(quiz));
    quizQuestions.refresh();
    return quizQuestions;
  }

  Future<RxList<Question>> getAllQuestions() async {
    allQuestion.assignAll(await _apiServices.getAllQuestions());
    allQuestion.refresh();
    return allQuestion;
  }

  Future<RxList<Quiz>> getAllQuizzes() async {
    allQuizzes.assignAll(await _apiServices.getAllQuizzes());
    allQuizzes.refresh();
    return allQuizzes;
  }

  Future<RxList<Quiz>> getResidentsUncompletedQuizzes(
      DoctorUser doctorUser) async {
    allQuizzes.assignAll(
        await _apiServices.getResidentUncompletedQuizzes(doctorUser));
    allQuizzes.refresh();
    return allQuizzes;
  }

  Future<RxList<Quiz>> getResidentsCompletedQuizzes(
      DoctorUser doctorUser) async {
    allQuizzes.assignAll(
        await _apiServices.getResidentUncompletedQuizzes(doctorUser));
    allQuizzes.refresh();
    return allQuizzes;
  }

  initAppMainData() async {
    await isUserSignedIn();
    getAllDoctorOperations();
    if (doctorUser.value.containsRole('admin')) {
      getAllQuestions();
      getAllQuizzes();
      getAllUsers();
    } else if (doctorUser.value.containsRole('resident') &&
        doctorUser.value.containsRole('admin') != true) {
      getResidentsUncompletedQuizzes(doctorUser.value);
    }
  }

  int getCurrentMonthLogs({required int monthInt}) {
    return doctorOperations
        .where((o) => o.operationDate!.month == monthInt)
        .toList()
        .length;
  }

  Future<DataResponse> signInUser(String email, password) async {
    DataResponse requestResponse =
        await _apiServices.signInUser(email, password);
    if (requestResponse.onSuccess) {
      doctorUser.value = requestResponse.object as DoctorUser;
      isLogged.value = true;
    }
    return requestResponse;
  }

  Future signUpUser(DoctorUser user, String password) async {
    await _apiServices.signUpUser(user, password);
  }

  Future logoutUser() async {
    _apiServices.logout();
    doctorUser.value.clear();
    isLogged.value = false;
  }

  Future<void> addQuestion(Question question) async {
    allQuestion.add(question);
    allQuestion.sort((a, b) {
      return b.creationDate!.compareTo(a.creationDate!);
    });
    allQuestion.refresh();
    await _apiServices.addQuestion(question);
  }

  Future<void> removeQuestion(Question question) async {
    allQuestion.remove(question);
    allQuestion.sort((a, b) {
      return b.creationDate!.compareTo(a.creationDate!);
    });
    allQuestion.refresh();
    await _apiServices.deleteQuestion(question);
  }

  Future<void> createQuiz(Quiz quiz) async {
    allQuizzes.add(quiz);
    allQuizzes.sort((a, b) {
      return b.creationDate!.compareTo(a.creationDate!);
    });
    allQuizzes.refresh();
    await _apiServices.createQuiz(quiz);
  }

  Future<void> removeQuiz(Quiz quiz) async {
    allQuizzes.remove(quiz);
    allQuizzes.sort((a, b) {
      return b.creationDate!.compareTo(a.creationDate!);
    });
    allQuizzes.refresh();
    await _apiServices.deleteQuiz(quiz);
  }

  removeFromLocalQuiz(Quiz quiz) async {
    allQuizzes.remove(quiz);
    allQuizzes.refresh();
  }

  getQuizResults(Quiz quiz) async {
    quizResults.value = await _apiServices.getQuizResults(quiz);
    quizParticipants.value = await _apiServices.getQuizParticipants(quiz);
    for (int i = 0; i < quizParticipants.length; i++) {
      for (var e in quizResults) {
        if (e.doctorUid == quizParticipants[i].uid) {
          quizParticipants[i].quizResult = e;
          print(quizParticipants[i].quizResult!.score);
        } else {
          print('not found what');
        }
      }
    }
    quizResults.refresh();
    quizParticipants.refresh();
  }

  Future<void> getAllUsers() async {
    allUsers.value = await _apiServices.getAllUsers();
  }

  Future<bool> isUserSignedIn() async {
    return await _apiServices.isUserLoggedIn().then((value) async {
      if (value != null) {
        doctorUser.value = (await _apiServices.isUserLoggedIn())!;
        isLogged.value = true;
        isLogged.refresh();
        doctorUser.refresh();
        return true;
      }
      return false;
    });
  }
}
