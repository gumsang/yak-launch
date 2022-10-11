// ignore_for_file: file_names

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../util/dory_constants.dart';
import '../../util/dory_widgets.dart';
import '../add_alarm_page/add_alarm_page_view_model.dart';

class TimeSettingBottomSheet extends StatelessWidget {
  const TimeSettingBottomSheet({
    Key? key,
    required this.initialTime,
    required this.viewModel,
    this.submitTitle = '선택',
    this.bottomWidget,
  }) : super(key: key);

  final String initialTime;
  final AddAlarmViewModel viewModel;
  final String submitTitle;
  final Widget? bottomWidget;

  @override
  Widget build(BuildContext context) {
    final initialTimeData = DateFormat('HH:mm').parse(initialTime);
    final now = DateTime.now();
    final initialDateTime = DateTime(now.year, now.month, now.day,
        initialTimeData.hour, initialTimeData.minute);
    DateTime setDateTime = initialDateTime;

    //time값을 datetime값으로 변환해야함
    return BottomSheetBody(
      children: [
        SizedBox(
          height: 200,
          child: CupertinoDatePicker(
            onDateTimeChanged: (dateTime) {
              setDateTime = dateTime;
            },
            mode: CupertinoDatePickerMode.time,
            //초기 시간 설정
            initialDateTime: initialDateTime,
          ),
        ),
        const SizedBox(
          height: smallSpace,
        ),
        if (bottomWidget != null) bottomWidget!,
        const SizedBox(height: smallSpace),
        Row(
          children: [
            Expanded(
              child: SizedBox(
                height: submitButtonHeight,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      textStyle: Theme.of(context).textTheme.subtitle1),
                  onPressed: () {
                    Navigator.pop(context, setDateTime);
                    //,하고 setdatetime 하면 팝 하고 셋데타 값이 넘어감
                  },
                  child: Text(submitTitle),
                ),
              ),
            ),
            const SizedBox(width: smallSpace),
            Expanded(
              child: SizedBox(
                height: submitButtonHeight,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      textStyle: Theme.of(context).textTheme.subtitle1,
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.black),
                  onPressed: () => Navigator.pop(context),
                  child: const Text('취소'),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
