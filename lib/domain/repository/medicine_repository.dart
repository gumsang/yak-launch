import 'dart:developer';

import 'package:alyak/domain/model/medicine_model.dart';
import 'package:alyak/domain/repository/dory_hive.dart';

import 'package:hive/hive.dart';



class MedicineRepository {
  Box<MeidicineModel>? _medicineBox;

  Box<MeidicineModel> get medicineBox {
    _medicineBox ??= Hive.box<MeidicineModel>(DoryHiveBox.medicine);
    return _medicineBox!;
  }

  void addMedicine(MeidicineModel medicine) async {
    int key = await medicineBox.add(medicine);

    log('[addMedicine] add (key:$key) $medicine');
    log('result ${medicineBox.values.toList()}');
  }

  void deleteMedicine(int key) async {
    await medicineBox.delete(key);

    log('[deleteMedicineß] delete (key:$key)');
    log('result ${medicineBox.values.toList()}');
  }

  void updateMedicine({
    required int key,
    required MeidicineModel medicine,
  }) async {
    await medicineBox.put(key, medicine);

    log('[updateMedicine] update (key:$key) $medicine');
    log('result ${medicineBox.values.toList()}');
  }

  int get newId {
    final lastId = medicineBox.values.isEmpty ? 0 : medicineBox.values.last.id;
    return lastId + 1;
  }
}