import '../redux/view.dart';
import 'package:intl/intl.dart';
import '../models/Models.dart';
import 'package:flutter/material.dart';
import '../widgets/dashboard_page.dart';
import '../widgets/history_page.dart';
import '../widgets/others_page.dart';

class ExpenseManagementScreen extends StatefulWidget {
  final ViewModel model;
  ExpenseManagementScreen(this.model);

  @override
  _ExpenseManagementScreenState createState() =>
      _ExpenseManagementScreenState();
}

class _ExpenseManagementScreenState extends State<ExpenseManagementScreen> {
  int _selectedIndex = 0;
  bool isGot = false;

  Widget body() {
    switch (_selectedIndex) {
      case 0:
        return DashboardPage(widget.model);
        break;
      case 1:
        return HistoryPage(widget.model);
        break;
      case 2:
        return OthersPage();
        break;
      default:
        return DashboardPage(widget.model);
    }
  }

  @override
  void initState() {
    super.initState();
    widget.model.getAllExpense();
  }

  @override
  void didUpdateWidget(ExpenseManagementScreen oldWidget) {
    if (isGot) {
      isGot = false;
      widget.model.getAllExpense();
    } else
      isGot = true;
    super.didUpdateWidget(oldWidget);
  }

  void _onItemTapped(int index) {
    if (_selectedIndex != index) {
      setState(() {
        _selectedIndex = index;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: body(),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => widget.model.openModalExpense(
          context,
          true,
          new Expense(
            id: DateFormat('dd/MM/yyyy HH:mm:ss').format(DateTime.now()),
            contentName: "Chi phí phát sinh",
            contentType: -1,
            title: '',
            amount: 0,
            date: DateFormat('dd/MM/yyyy HH:mm:ss').format(DateTime.now()),
            pictureId: '',
            picture: null,
          ),
        ),
        child: Icon(Icons.note_add),
        backgroundColor: Colors.green,
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard),
            title: Text('Dashboard'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.history),
            title: Text('History'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.storage),
            title: Text('Others'),
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Theme.of(context).primaryColor,
        onTap: _onItemTapped,
      ),
    );
  }
}
