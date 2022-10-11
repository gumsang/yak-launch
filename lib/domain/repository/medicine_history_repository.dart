import 'dart:developer';

import 'package:alyak/domain/model/medicine_history_model.dart';
import 'package:alyak/domain/repository/dory_hive.dart';

import 'package:hive/hive.dart';

class MedicineHistoryRepository {
  Box<MedicineHistory>? _historyBox;

  Box<MedicineHistory> get historyBox {
    _historyBox ??= Hive.box<MedicineHistory>(DoryHiveBox.medicineHistory);
    return _historyBox!;
  }

  void addHistory(MedicineHistory history) async {
    int key = await historyBox.add(history);

    log('[addHistory] add (key:$key) $history');
    log('result ${historyBox.values.toList()}');
  }

  void deleteHistory(int key) async {
    await historyBox.delete(key);

    log('[deleteHistory] delete (key:$key)');
    log('result ${historyBox.values.toList()}');
  }

  void updateHistory({
    required int key,
    required MedicineHistory history,
  }) async {
    await historyBox.put(key, history);

    log('[updateHistory] update (key:$key) $history');
    log('result ${historyBox.values.toList()}');
  }

  void deleteAllHistory(Iterable<int> keys) async {
    await historyBox.deleteAll(keys);

    log('[deleteHistory] delete (key:$keys)');
    log('result ${historyBox.values.toList()}');
  }
}
