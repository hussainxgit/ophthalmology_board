import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:get/instance_manager.dart';
import 'package:ophthalmology_board/services/data_services.dart';
import 'package:ophthalmology_board/views/all_users_view.dart';
import 'package:ophthalmology_board/views/quizzes_questions/add_quiz.dart';
import 'package:ophthalmology_board/views/quizzes_questions/all_questions_view.dart';
import 'package:ophthalmology_board/views/quizzes_questions/all_quizzes_view.dart';
import 'package:ophthalmology_board/views/quizzes_questions/add_question.dart';
import 'package:ophthalmology_board/widgets/operative_log_header.dart';
import 'package:ophthalmology_board/widgets/recently_operative_logs_list.dart';
import 'package:ophthalmology_board/widgets/custom_app_bar.dart';
import 'add_surgical_log.dart';
import 'all_operative_logs_view.dart';

class HomeView extends StatefulWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  _HomeViewState() {
    appBarActions = [
      const SizedBox(),
      IconButton(
        icon: const Icon(Icons.add),
        tooltip: 'Add log',
        onPressed: () {
          Get.to(const AddSurgicalLog());
        },
      ),
      IconButton(
        icon: const Icon(Icons.add),
        tooltip: 'Add Question',
        onPressed: () {
          Get.to(() => const AddQuestion());
        },
      ),
      _dataServices.doctorUser.value.containsRole('admin')
          ? IconButton(
              icon: const Icon(Icons.create),
              tooltip: 'Create Quiz',
              onPressed: () {
                Get.to(() => const AddQuiz());
              },
            )
          : const SizedBox(),
      const SizedBox(),
    ];
  }

  int _selectedDestination = 0;
  PageController _pageController = PageController();
  final DataServices _dataServices = Get.find();
  int page = 0;

  List<Widget> appBarActions = [];

  void selectDestination(int index) {
    setState(() {
      _selectedDestination = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    return Scaffold(
      drawer: Drawer(
        child: Padding(
          padding: const EdgeInsets.all(0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(
                    right: 16.0, left: 16, top: 75, bottom: 32),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Dr. ${_dataServices.doctorUser.value.name}',
                      style: textTheme.headline5,
                    ),
                    Text(
                      'Year: ${_dataServices.doctorUser.value.rotationYear}',
                      style: textTheme.subtitle1,
                    ),
                  ],
                ),
              ),
              const Divider(
                height: 1,
                thickness: 1,
              ),
              ListTile(
                leading: const Icon(Icons.home),
                title: const Text('Home'),
                selected: _selectedDestination == 0,
                onTap: () {
                  selectDestination(0);
                  Navigator.pop(context);
                  Future.delayed(const Duration(milliseconds: 400), () {
                    setState(() {
                      _pageController.jumpToPage(0);
                    });
                  });
                },
              ),
              ListTile(
                leading: const Icon(Icons.book),
                title: const Text('Operative logs'),
                selected: _selectedDestination == 1,
                onTap: () {
                  selectDestination(1);
                  Navigator.pop(context);
                  Future.delayed(const Duration(milliseconds: 400), () {
                    setState(() {
                      _pageController.jumpToPage(1);
                    });
                  });
                },
              ),
              _dataServices.doctorUser.value.containsRole('admin')
                  ? ListTile(
                      leading: const Icon(Icons.book),
                      title: const Text('Questions'),
                      selected: _selectedDestination == 2,
                      onTap: () {
                        selectDestination(2);
                        Navigator.pop(context);
                        Future.delayed(const Duration(milliseconds: 400), () {
                          setState(() {
                            _pageController.jumpToPage(2);
                          });
                        });
                      },
                    )
                  : const SizedBox(),
              ListTile(
                leading: const Icon(Icons.book),
                title: const Text('Quizzes'),
                selected: _selectedDestination == 3,
                onTap: () {
                  selectDestination(3);
                  Navigator.pop(context);
                  Future.delayed(const Duration(milliseconds: 400), () {
                    setState(() {
                      _pageController.jumpToPage(3);
                    });
                  });
                },
              ),
              _dataServices.doctorUser.value.containsRole('admin')
                  ? ListTile(
                leading: const Icon(Icons.book),
                title: const Text("All users"),
                selected: _selectedDestination == 4,
                onTap: () {
                  selectDestination(4);
                  Navigator.pop(context);
                  Future.delayed(const Duration(milliseconds: 400), () {
                    setState(() {
                      _pageController.jumpToPage(4);
                    });
                  });
                },
              )
                  : const SizedBox(),
              const Divider(
                height: 1,
                thickness: 1,
              ),
              Expanded(
                child: Align(
                  alignment: Alignment.bottomLeft,
                  child: ListTile(
                    leading: const Icon(Icons.logout),
                    title: const Text('Sign out'),
                    selected: _selectedDestination == 6,
                    onTap: () {
                      _dataServices.logoutUser();
                    },
                  ),
                ),
              ),
              const SizedBox(
                height: 30.0,
              )
            ],
          ),
        ),
      ),
      appBar: CustomAppBar(
        actionList: [appBarActions[_selectedDestination]],
      ),
      body: SafeArea(
        child: PageView(
          physics: const NeverScrollableScrollPhysics(),
          controller: _pageController,
          onPageChanged: onPageChanged,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: ListView(
                children: [
                  const OperativeLogHeader(),
                  const Divider(
                    thickness: 1,
                  ),
                  const SizedBox(
                    height: 8.0,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Recently logged',
                        style: TextStyle(fontSize: 20.0),
                      ),
                      InkWell(
                        onTap: () {
                          selectDestination(1);
                          setState(() {
                            _pageController.jumpToPage(1);
                          });
                        },
                        child: const Text(
                          'View all',
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 8.0,
                  ),
                  RecentlyOperativeLogsList()
                ],
              ),
            ),
            const AllOperativeLogsView(),
            AllQuestionsView(),
            QuizzesListViewController(),
            const AllUsersView()
          ],
        ),
      ),
    );
  }

  void navigationTapped(int page) {
    _pageController.jumpToPage(page);
  }

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: 0);
  }

  @override
  void dispose() {
    super.dispose();
    _pageController.dispose();
  }

  void onPageChanged(int page) {
    setState(() {
      page = page;
    });
  }
}
