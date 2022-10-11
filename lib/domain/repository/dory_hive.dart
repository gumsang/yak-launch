import 'package:alyak/domain/model/medicine_history_model.dart';
import 'package:alyak/domain/model/medicine_model.dart';
import 'package:hive_flutter/hive_flutter.dart';



class DoryHive {
  Future<void> initializeHive() async {
    await Hive.initFlutter();

    Hive.registerAdapter<MeidicineModel>(MeidicineModelAdapter());
    Hive.registerAdapter<MedicineHistory>(MedicineHistoryAdapter());

    await Hive.openBox<MeidicineModel>(DoryHiveBox.medicine);
    await Hive.openBox<MedicineHistory>(DoryHiveBox.medicineHistory);
  }
}

class DoryHiveBox {
  static const String medicine = 'medicine';
  static const String medicineHistory = 'medicine_history';
}