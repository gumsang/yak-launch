import 'package:alyak/presentation/add_medicine_page/add_medicine_page.dart';
import 'package:alyak/presentation/history_page/history_page.dart';
import 'package:alyak/presentation/today_page/today_page.dart';
import 'package:alyak/util/dory_colors.dart';
import 'package:alyak/util/dory_constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;
  final _pages = [
    const TodayPage(),
    const HistoryPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Scaffold(
        body: Padding(
          padding: pagePadding,
          child: SafeArea(child: _pages[_currentIndex]),
        ),
        floatingActionButton: FloatingActionButton(
            onPressed: _onAddMedicine, child: const Icon(Icons.add)),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        bottomNavigationBar: _buildBottomAppbar(),
      ),
    );
  }

  BottomAppBar _buildBottomAppbar() {
    return BottomAppBar(
      child: Container(
        height: kBottomNavigationBarHeight,
        color: Colors.white,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            CupertinoButton(
              child: Icon(
                CupertinoIcons.check_mark,
                color: _currentIndex == 0
                    ? DoryColors.primaryColor
                    : Colors.grey[350],
              ),
              onPressed: () {
                _onCurrentPage(0);
              },
            ),
            CupertinoButton(
              onPressed: () {
                _onCurrentPage(1);
              },
              child: Icon(
                CupertinoIcons.text_badge_checkmark,
                color: _currentIndex == 1
                    ? DoryColors.primaryColor
                    : Colors.grey[350],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _onCurrentPage(int pageIndex) {
    setState(() {
      _currentIndex = pageIndex;
    });
  }

  _onAddMedicine() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const AddMedicinePage()),
    );
  }
}
