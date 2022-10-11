import 'dart:io';

import 'package:alyak/domain/model/medicine_model.dart';
import 'package:alyak/main.dart';
import 'package:alyak/presentation/add_alarm_page/add_alarm_page_view_model.dart';
import 'package:alyak/presentation/components/%08time_setting_bottomsheet.dart';
import 'package:alyak/util/dory_constants.dart';
import 'package:alyak/util/dory_file_service.dart';
import 'package:alyak/util/dory_notofication.dart';
import 'package:alyak/util/dory_widgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../util/add_page_widget.dart';

// ignore: must_be_immutable
class AddAlarmPage extends StatelessWidget {
  AddAlarmPage(
      {super.key,
      required this.medicineImage,
      required this.medicineName,
      required this.updateMedicineId}) {
    viewModel = AddAlarmViewModel(updateMedicineId);
  }

  final int updateMedicineId;
  final File? medicineImage;
  final String medicineName;

  late AddAlarmViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    final doryNotificationServiceViewModel =
        context.watch<DoryNotificationService>();
    return Scaffold(
      appBar: AppBar(),
      body: AddPageBody(
        children: [
          Text(
            '매일 잊지말고 복약!',
            style: Theme.of(context).textTheme.headline4,
          ),
          const SizedBox(height: smallSpace),
          const Text(
            '불로장생, 무병장수하시오.',
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: largeSpace),
          Expanded(
            child: AnimatedBuilder(
              builder: (context, _) {
                return ListView(children: alarmWidgets);
              },
              animation: viewModel,
            ),
          ),
        ],
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: submitButtonBoxPadding,
          child: SizedBox(
            height: submitButtonHeight,
            child: ElevatedButton(
              onPressed: () async {
                final isUpdate = updateMedicineId != -1;

                isUpdate
                    ? await _onUpdateMedicine(
                        context, doryNotificationServiceViewModel)
                    : await _onAddMedicine(
                        context, doryNotificationServiceViewModel);
              },
              style: ElevatedButton.styleFrom(
                textStyle: Theme.of(context).textTheme.subtitle1,
              ),
              child: const Text('완료'),
            ),
          ),
        ),
      ),
    );
  }

  List<Widget> get alarmWidgets {
    final children = <Widget>[];

    children.addAll(
      viewModel.alarms.map(
        (alarmTime) => AlarmBox(
          time: alarmTime,
          viewModel: viewModel,
        ),
      ),
    );
    children.add(AddAlarmButton(
      viewModel: viewModel,
    ));
    return children;
  }

  Future<void> _onAddMedicine(BuildContext context,
      DoryNotificationService doryNotificationServiceViewModel) async {
    bool result = false;
    final doryNotificationServiceViewModel =
        context.read<DoryNotificationService>();
    //1. add alarm
    for (var alarm in viewModel.alarms) {
      result = await doryNotificationServiceViewModel.addNotifcication(
        alarmTimeStr: alarm,
        title: '$alarm 약먹을 시간이네!',
        body: '$medicineName 먹는거 잊지말기',
        medicineId: medicineRepository.newId,
      );
      if (!result) {
        // ignore: use_build_context_synchronously
        return showPermissionDenied(context, permission: '알람');
      }
    }

    //2. save image (local dir)
    String? imageFilePath;
    if (medicineImage != null) {
      imageFilePath = await saveImageToLocalDirectory(medicineImage!);
    }

    final medicine = MeidicineModel(
      id: medicineRepository.newId,
      name: medicineName,
      alarms: viewModel.alarms.toList(),
      imagePath: imageFilePath,
    );
    medicineRepository.addMedicine(medicine);

    // ignore: use_build_context_synchronously
    Navigator.popUntil(context, (route) => route.isFirst);

    //3. add medicine model (local db, hive)
  }

  Future<void> _onUpdateMedicine(BuildContext context,
      DoryNotificationService doryNotificationServiceViewModel) async {
    bool result = false;
    final doryNotificationServiceViewModel =
        context.read<DoryNotificationService>();

    final alarmIds = _updateMedicine.alarms.map(
      (alarmTime) =>
          doryNotificationServiceViewModel.alarmId(updateMedicineId, alarmTime),
    );
    await doryNotificationServiceViewModel.deleteMultipleAlarm(alarmIds);
    //1. add alarm
    for (var alarm in viewModel.alarms) {
      result = await doryNotificationServiceViewModel.addNotifcication(
        medicineId: updateMedicineId,
        alarmTimeStr: alarm,
        title: '$alarm 약 먹을 시간이예요!',
        body: '$medicineName 잊지말고 복약!',
      );
    }

    if (!result) {
      // ignore: use_build_context_synchronously
      return showPermissionDenied(context, permission: '알람');
    }

    //2. save image (local dir)
    String? imageFilePath = _updateMedicine.imagePath;
    if (_updateMedicine.imagePath != medicineImage?.path) {
      // 2-1. delete previous image
      if (_updateMedicine.imagePath != null) {
        deleteImage(_updateMedicine.imagePath!);
      }

      // 2-2. save image (local dir)
      if (medicineImage != null) {
        imageFilePath = await saveImageToLocalDirectory(medicineImage!);
      }
    }

    final medicine = MeidicineModel(
      id: updateMedicineId,
      name: medicineName,
      imagePath: imageFilePath,
      alarms: viewModel.alarms.toList(),
    );
    medicineRepository.updateMedicine(
      key: _updateMedicine.key,
      medicine: medicine,
    );
    // ignore: use_build_context_synchronously
    Navigator.popUntil(context, (route) => route.isFirst);
  }

  MeidicineModel get _updateMedicine =>
      medicineRepository.medicineBox.values.singleWhere(
        (medicine) => medicine.id == updateMedicineId,
      );
}

class AlarmBox extends StatelessWidget {
  const AlarmBox({
    Key? key,
    required this.time,
    required this.viewModel,
  }) : super(key: key);

  final String time;
  final AddAlarmViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          flex: 1,
          child: IconButton(
            onPressed: () {
              viewModel.removeAlarm(time);
            },
            icon: const Icon(CupertinoIcons.minus_circle),
          ),
        ),
        Expanded(
          flex: 5,
          child: TextButton(
            style: TextButton.styleFrom(
                textStyle: Theme.of(context).textTheme.subtitle2),
            onPressed: () {
              showModalBottomSheet(
                context: context,
                builder: (context) {
                  return TimeSettingBottomSheet(
                    viewModel: viewModel,
                    initialTime: time,
                  );
                },
              ).then((value) {
                if (value == null || value is! DateTime) return;
                viewModel.setAlarm(
                  prevTime: time,
                  setTime: value,
                );
              });
            },
            child: Text(time),
          ),
        ),
      ],
    );
  }
}

class AddAlarmButton extends StatelessWidget {
  const AddAlarmButton({
    Key? key,
    required this.viewModel,
  }) : super(key: key);

  final AddAlarmViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      style: TextButton.styleFrom(
        textStyle: Theme.of(context).textTheme.subtitle2,
        padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 6),
      ),
      onPressed: viewModel.addNowAlarm,
      child: Row(
        children: const [
          Expanded(flex: 1, child: Icon(CupertinoIcons.plus_circle_fill)),
          Expanded(
            flex: 5,
            child: Center(child: Text('복용시간 추가')),
          ),
        ],
      ),
    );
  }
}
