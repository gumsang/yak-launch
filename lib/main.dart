import 'package:alyak/domain/repository/dory_hive.dart';
import 'package:alyak/domain/repository/medicine_history_repository.dart';
import 'package:alyak/domain/repository/medicine_repository.dart';
import 'package:alyak/presentation/home_page/home_page.dart';
import 'package:alyak/util/dory_notofication.dart';
import 'package:alyak/util/dory_themes.dart';
import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:provider/provider.dart';

final notification = DoryNotificationService();
final hive = DoryHive();
final medicineRepository = MedicineRepository();
final historyRepository = MedicineHistoryRepository();
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting();

  await notification.initializeTimeZone();
  await notification.initializeNotification();

  await hive.initializeHive();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => DoryNotificationService(),
        )
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: DoryThemes.lightTheme,
        home: const HomePage(),
        darkTheme: DoryThemes.darkTheme,
      ),
    );
  }
}
