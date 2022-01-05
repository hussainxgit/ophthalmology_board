import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/instance_manager.dart';
import 'package:ophthalmology_board/services/data_services.dart';
import 'package:ophthalmology_board/views/home_view.dart';
import 'package:ophthalmology_board/views/splash_screen_view.dart';


class MainViewController extends StatelessWidget {
  MainViewController({Key? key}) : super(key: key);
  final DataServices _dataServices = Get.put(DataServices());

  @override
  Widget build(BuildContext context) {
    _dataServices.initAppMainData();
    return Obx(() => _dataServices.isLogged.value ? const HomeView() : const SplashScreen());
  }
}

