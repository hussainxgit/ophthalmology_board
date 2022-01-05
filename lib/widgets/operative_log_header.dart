import 'package:flutter/material.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:get/instance_manager.dart';
import 'package:ophthalmology_board/services/data_services.dart';

class OperativeLogHeader extends StatelessWidget {
  const OperativeLogHeader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final DataServices _dataServices = Get.find();
    final int currentMonth = DateTime.now().month;
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'Operative log',
          style: textTheme.headline5,
        ),
        const SizedBox(
          height: 27.0,
        ),
        SizedBox(
          height: 75,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Column(
                children: [
                  Text(
                    'Total logs',
                    style: textTheme.subtitle2,
                  ),
                  const SizedBox(
                    height: 16.0,
                  ),
                  Obx(() => Text(
                        _dataServices.doctorOperations.length.toString(),
                        style: textTheme.headline5,
                      )),
                ],
              ),
              const VerticalDivider(
                thickness: 1,
                endIndent: 0,
              ),
              Column(
                children: [
                  Text(
                    'This month',
                    style: textTheme.subtitle2,
                  ),
                  const SizedBox(
                    height: 16.0,
                  ),
                  Obx(() => Text(
                        _dataServices
                            .getCurrentMonthLogs(monthInt: currentMonth)
                            .toString(),
                        style: textTheme.headline5,
                      )),
                ],
              ),
            ],
          ),
        )
      ],
    );
  }
}
