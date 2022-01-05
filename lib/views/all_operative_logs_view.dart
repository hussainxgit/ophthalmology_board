import 'package:flutter/material.dart';
import 'package:ophthalmology_board/widgets/operative_logs_list.dart';

class AllOperativeLogsView extends StatelessWidget {
  const AllOperativeLogsView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: OperativeLogsList(),
    );
  }
}
