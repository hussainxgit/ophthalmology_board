import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:get/instance_manager.dart';
import 'package:intl/intl.dart';
import 'package:ophthalmology_board/models/operation.dart';
import 'package:ophthalmology_board/services/data_services.dart';

class RecentlyOperativeLogsList extends StatelessWidget {
  RecentlyOperativeLogsList({Key? key}) : super(key: key);
  final DataServices _dataServices = Get.find();

  @override
  Widget build(BuildContext context) {
    return Obx(()=> ListView.builder(
      shrinkWrap: true,
      itemCount: _dataServices.doctorOperations.length > 7 ? 7 : _dataServices.doctorOperations.length,
      itemBuilder: (BuildContext context, int index) {
        Operation operation = _dataServices.doctorOperations[index];
        return ListTile(
          leading: Container(
            padding: const EdgeInsets.only(right: 12.0),
            decoration: const BoxDecoration(
                border: Border(right: BorderSide(width: 0.7))),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(DateFormat('MMM').format(DateTime(0, operation.operationDate!.month))),
                Text(operation.operationDate!.day.toString()),
              ],
            ),
          ),
          title: Text(
            operation.patientName!,
          ),
          subtitle: Text(
            operation.procedure!,
          ),
          trailing: const Icon(Icons.keyboard_arrow_right, size: 30.0),
          onTap: () {},
        );
      },
    ));
  }
}
