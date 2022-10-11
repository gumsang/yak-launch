import 'package:alyak/domain/model/medicine_history_model.dart';
import 'package:alyak/domain/model/medicine_model.dart';
import 'package:alyak/presentation/history_page/components/history_empty_widget.dart';
import 'package:alyak/presentation/today_page/components/today_take_tile.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:intl/intl.dart';

import '../../main.dart';
import '../../util/dory_constants.dart';

class HistoryPage extends StatelessWidget {
  const HistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '잘 복용 했어요 👏🏻',
          style: Theme.of(context).textTheme.headline4,
        ),
        const SizedBox(height: regularSpace),
        const Divider(height: 1, thickness: 1.0),
        Expanded(
          child: ValueListenableBuilder(
            valueListenable: historyRepository.historyBox.listenable(),
            builder: _buildListView,
          ),
        )
      ],
    );
  }

  Widget _buildListView(
      BuildContext context, Box<MedicineHistory> historyBox, _) {
    final histories = historyBox.values.toList().reversed.toList();
    if(histories.isEmpty){
      return const HistoryEmpty();
    }
    return ListView.builder(
      itemCount: histories.length,
      itemBuilder: (context, index) {
        final history = histories[index];
        return _TimeTile(history: history);
      },
    );
  }
}

class _TimeTile extends StatelessWidget {
  const _TimeTile({
    Key? key,
    required this.history,
  }) : super(key: key);

  final MedicineHistory history;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          flex: 1,
          child: Text(
            DateFormat('yyyy\nMM.dd E', 'ko').format(history.takeTime),
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.subtitle2!.copyWith(
                  height: 1.6,
                  leadingDistribution: TextLeadingDistribution.even,
                ),
          ),
        ),
        const SizedBox(width: smallSpace),
        Stack(
          alignment: const Alignment(0.0, -0.3),
          children: const [
            SizedBox(
              height: 130,
              child: VerticalDivider(
                width: 1,
                thickness: 1,
              ),
            ),
            CircleAvatar(
              radius: 4,
              child: CircleAvatar(
                radius: 3,
                backgroundColor: Colors.white,
              ),
            ),
          ],
        ),
        Expanded(
          flex: 3,
          child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            Visibility(
                visible: medicine.imagePath != null,
                child: MedicineImageButton(imagePath: medicine.imagePath)),
            const SizedBox(
              width: smallSpace,
            ),
            Text(
                '${DateFormat('a hh:mm', 'ko').format(history.takeTime)}\n${medicine.name}',
                style: Theme.of(context).textTheme.subtitle2!.copyWith(
                      height: 1.6,
                      leadingDistribution: TextLeadingDistribution.even,
                    )),
          ]),
        )
      ],
    );
  }

  MeidicineModel get medicine {
    return medicineRepository.medicineBox.values.singleWhere(
      (element) =>
          element.id == history.medicineId &&
          element.key == history.medicineKey,
      orElse: () => MeidicineModel(
        id: -1,
        name: history.name, //'삭제된 약입니다',
        alarms: [],
        imagePath: history.imagePath,
      ),
    );
  }
}
