// ignore_for_file: file_names

import 'package:flutter/material.dart';

import '../../util/dory_widgets.dart';

class MoreActionBottomSheet extends StatelessWidget {
  const MoreActionBottomSheet(
      {super.key,
      required this.onPressedModify,
      required this.onPressedDeleteOnlyMedicine,
      required this.onPressedDeleteAll,});

  final VoidCallback onPressedModify;
  final VoidCallback onPressedDeleteOnlyMedicine;
  final VoidCallback onPressedDeleteAll;

  @override
  Widget build(BuildContext context) {
    return BottomSheetBody(
      children: [
        TextButton(
          onPressed: onPressedModify,
          child: const Text('약 정보 수정'),
        ),
        TextButton(
          style: TextButton.styleFrom(foregroundColor: Colors.red ),
          onPressed: onPressedDeleteOnlyMedicine,
          child: const Text('약 정보 삭제'),
        ),
        TextButton(
          style: TextButton.styleFrom(foregroundColor: Colors.red ),
          onPressed: onPressedDeleteAll,
          child: const Text('약 기록과 함께 약 정보 삭제'),
        ),
      ],
    );
  }
}
