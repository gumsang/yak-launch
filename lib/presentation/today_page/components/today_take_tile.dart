import 'dart:io';

import 'package:alyak/presentation/add_medicine_page/add_medicine_page.dart';
import 'package:alyak/presentation/components/%08time_setting_bottomsheet.dart';
import 'package:alyak/presentation/components/more_action_bottomsheet%20copy.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../domain/model/medicine_alarm_model.dart';
import '../../../domain/model/medicine_history_model.dart';
import '../../../main.dart';
import '../../../util/dory_constants.dart';
import '../../add_alarm_page/add_alarm_page_view_model.dart';
import '../../add_medicine_page/components/add_medicine_page_component.dart';

import '../today_page.dart';
import 'image_detail_page.dart';

class BeforeTakeTile extends StatelessWidget {
  const BeforeTakeTile({
    Key? key,
    required this.medicineAlarm,
  }) : super(key: key);

  final MedicineAlarm medicineAlarm;

  @override
  Widget build(BuildContext context) {
    final textStyle = Theme.of(context).textTheme.bodyText2;
    final viewModel = AddAlarmViewModel(medicineAlarm.id);
    return Row(
      children: [
        MedicineImageButton(imagePath: medicineAlarm.imagePath),
        const SizedBox(
          width: smallSpace,
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: _buildTileBody(textStyle, context, viewModel),
          ),
        ),
        _MoreButton(medicineAlarm: medicineAlarm)
      ],
    );
  }

  List<Widget> _buildTileBody(
      TextStyle? textStyle, BuildContext context, AddAlarmViewModel viewModel) {
    return [
      Text('🕑 ${medicineAlarm.alarmTime}', style: textStyle),
      const SizedBox(height: 6),
      Wrap(
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          Text('${medicineAlarm.name},', style: textStyle),
          TileActionButton(
            onTap: () {
              historyRepository.addHistory(
                MedicineHistory(
                  medicineId: medicineAlarm.id,
                  medicineKey: medicineAlarm.key,
                  alarmTime: medicineAlarm.alarmTime,
                  takeTime: DateTime.now(),
                  imagePath: medicineAlarm.imagePath,
                  name: medicineAlarm.name,
                ),
              );
            },
            title: '지금',
          ),
          Text('|', style: textStyle),
          TileActionButton(
            onTap: () => _onPreviousTake(context, viewModel),
            title: '아까',
          ),
          Text('먹었어요!', style: textStyle),
        ],
      )
    ];
  }

  void _onPreviousTake(BuildContext context, AddAlarmViewModel viewModel) {
    showModalBottomSheet(
      context: context,
      builder: (context) => TimeSettingBottomSheet(
          initialTime: medicineAlarm.alarmTime, viewModel: viewModel),
    ).then((takeDateTime) {
      if (takeDateTime == null || takeDateTime is! DateTime) {
        return;
      }

      historyRepository.addHistory(
        MedicineHistory(
          medicineId: medicineAlarm.id,
          alarmTime: medicineAlarm.alarmTime,
          takeTime: takeDateTime,
          medicineKey: medicineAlarm.key,
          imagePath: medicineAlarm.imagePath,
          name: medicineAlarm.name,
        ),
      );
    });
  }
}

class AfterTakeTile extends StatelessWidget {
  const AfterTakeTile({
    Key? key,
    required this.medicineAlarm,
    required this.history,
  }) : super(key: key);

  final MedicineAlarm medicineAlarm;
  final MedicineHistory history;

  @override
  Widget build(BuildContext context) {
    final textStyle = Theme.of(context).textTheme.bodyText2;
    final viewModel = AddAlarmViewModel(medicineAlarm.id);
    return Row(
      children: [
        Stack(
          children: [
            MedicineImageButton(imagePath: medicineAlarm.imagePath),
            CircleAvatar(
              radius: 40,
              backgroundColor: Colors.green.withOpacity(0.7),
              child: const Icon(
                CupertinoIcons.check_mark,
                color: Colors.white,
              ),
            ),
          ],
        ),
        const SizedBox(
          width: smallSpace,
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: _buildTileBody(textStyle, context, viewModel),
          ),
        ),
        _MoreButton(medicineAlarm: medicineAlarm)
      ],
    );
  }

  List<Widget> _buildTileBody(
      TextStyle? textStyle, BuildContext context, AddAlarmViewModel viewModel) {
    return [
      Text.rich(
        TextSpan(
            text: '✅ ${medicineAlarm.alarmTime} →',
            style: textStyle,
            children: [
              TextSpan(
                  text: DateFormat('HH:mm').format(history.takeTime),
                  style: textStyle?.copyWith(fontWeight: FontWeight.w500))
            ]),
      ),
      const SizedBox(height: 6),
      Wrap(
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          Text(medicineAlarm.name, style: textStyle),
          TileActionButton(
            onTap: () => _onTap(context, viewModel),
            title: DateFormat('HH시mm에').format(history.takeTime),
          ),
          Text('먹었어요!', style: textStyle),
        ],
      )
    ];
  }

  String get takeTimeStr => DateFormat('HH:mm').format(history.takeTime);

  void _onTap(BuildContext context, AddAlarmViewModel viewModel) {
    showModalBottomSheet(
      context: context,
      builder: (context) => SingleChildScrollView(
        child: TimeSettingBottomSheet(
          submitTitle: '수정',
          initialTime: takeTimeStr,
          viewModel: viewModel,
          bottomWidget: TextButton(
            onPressed: () {
              historyRepository.deleteHistory(history.key);
              Navigator.pop(context);
            },
            child: Text(
              '복약 시간을 지우고 싶어요.',
              style: Theme.of(context).textTheme.subtitle2,
            ),
          ),
        ),
      ),
    ).then((takeDateTime) {
      if (takeDateTime == null || takeDateTime is! DateTime) {
        return;
      }

      historyRepository.updateHistory(
        key: history.key,
        history: MedicineHistory(
          medicineId: medicineAlarm.id,
          alarmTime: medicineAlarm.alarmTime,
          takeTime: takeDateTime,
          medicineKey: medicineAlarm.key,
          imagePath: medicineAlarm.imagePath,
          name: medicineAlarm.name,
        ),
      );
    });
  }
}

class _MoreButton extends StatelessWidget {
  const _MoreButton({
    Key? key,
    required this.medicineAlarm,
  }) : super(key: key);

  final MedicineAlarm medicineAlarm;

  @override
  Widget build(BuildContext context) {
    return CupertinoButton(
      onPressed: () {
        //medicineRepository.deleteMedicine(medicineAlarm.key);
        showModalBottomSheet(
          context: context,
          builder: (context) => MoreActionBottomSheet(
            onPressedModify: () {
              Navigator.push(
                context,
                FadePageRoute(
                  page: AddMedicinePage(
                    updateMedicineId: medicineAlarm.id,
                  ),
                ),
              ).then((_) => Navigator.maybePop(context));
            },
            onPressedDeleteOnlyMedicine: () {
              //알람삭제
              notification.deleteMultipleAlarm(alarmIds);
              //하이브 데이터 삭제
              medicineRepository.deleteMedicine(medicineAlarm.key);
              //pop
              Navigator.pop(context);
            },
            onPressedDeleteAll: () {
              //알람삭제
              notification.deleteMultipleAlarm(alarmIds);
              //하이브 history 삭제
              historyRepository.deleteAllHistory(keys);
              //하이브 medicine 삭제
              medicineRepository.deleteMedicine(medicineAlarm.key);
              //pop
              Navigator.pop(context);
            },
          ),
        );
      },
      child: const Icon(CupertinoIcons.ellipsis_vertical),
    );
  }

  List<String> get alarmIds {
    final medicine = medicineRepository.medicineBox.values
        .singleWhere((element) => element.id == medicineAlarm.id);
    final alarmIds = medicine.alarms
        .map((alarmStr) => notification.alarmId(medicineAlarm.id, alarmStr))
        .toList();
    return alarmIds;
  }

  Iterable<int> get keys {
    final histories = historyRepository.historyBox.values.where((history) =>
        history.medicineId == medicineAlarm.id &&
        history.medicineKey == medicineAlarm.key);
    final keys = histories.map((e) => e.key as int);
    return keys;
  }
}

class MedicineImageButton extends StatelessWidget {
  const MedicineImageButton({
    Key? key,
    required this.imagePath,
  }) : super(key: key);

  final String? imagePath;

  @override
  Widget build(BuildContext context) {
    return CupertinoButton(
      padding: EdgeInsets.zero,
      onPressed: imagePath == null
          ? null
          : () {
              Navigator.push(context,
                  FadePageRoute(page: ImageDetailPage(imagePath: imagePath!)));
            },
      child: CircleAvatar(
        radius: 40,
        foregroundImage: imagePath == null ? null : FileImage(File(imagePath!),
        ),
        child: imagePath == null ? const Icon(CupertinoIcons.alarm_fill) : null,
      ),
    );
  }
}
