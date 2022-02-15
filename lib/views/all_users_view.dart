import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:get/instance_manager.dart';
import 'package:ophthalmology_board/services/data_services.dart';
import 'package:ophthalmology_board/views/auth/sign_up_view.dart';

class AllUsersView extends StatefulWidget {
  const AllUsersView({Key? key}) : super(key: key);

  @override
  _AllUsersViewState createState() => _AllUsersViewState();
}

class _AllUsersViewState extends State<AllUsersView> {
  final DataServices _dataServices = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
          itemCount: _dataServices.allUsers.length,
          itemBuilder: (context, index) {
            return ListTile(
              onTap: () {},
              title: Text(_dataServices.allUsers[index].name ?? 'Null'),
              subtitle: Text(_dataServices.allUsers[index].roles.toString()),
            );
          }),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Get.to(() => SignupPage());
        },
        child: const Text('Add'),
      ),
    );
  }
}
