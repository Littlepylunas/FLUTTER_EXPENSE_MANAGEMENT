import 'package:flutter/material.dart';
import '../../utils/global.dart';
import '../../models/Models.dart';

class ExpenseList extends StatefulWidget {
  final List<Expense> expenses;
  final Function openModalExpense;
  final Function removeExpense;

  ExpenseList(this.expenses, this.openModalExpense, this.removeExpense);

  @override
  _ExpenseListState createState() => _ExpenseListState();
}

class _ExpenseListState extends State<ExpenseList> {
  // Functions
  Future<void> _showMyDialog(Expense e) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: true, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Warning!!!'),
          elevation: 24,
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Confirm delete this record.'),
                Text('This action can not be undo? Confirm ?'),
              ],
            ),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text('Back'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            FlatButton(
              child: Text('Confirm'),
              onPressed: () {
                widget.removeExpense(e);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: widget.expenses.map((e) {
        return Card(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Container(
                alignment: Alignment.center,
                width: MediaQuery.of(context).size.width * 0.25,
                height: 65,
                margin: EdgeInsets.symmetric(vertical: 5),
                decoration: BoxDecoration(
                  color: (e.contentType == -1)
                      ? Theme.of(context).primaryColorDark
                      : Theme.of(context).primaryColorLight,
                  shape: BoxShape.circle,
                ),
                child: Text(
                  e.contentType == -1
                      ? ('-' + Global.toText(e.amount.truncate().toInt()))
                      : ('+' + Global.toText(e.amount.truncate().toInt())),
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
                padding: EdgeInsets.all(5),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.symmetric(vertical: 5),
                    width: MediaQuery.of(context).size.width * 0.4,
                    child: Text(
                      e.contentName,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).accentColor,
                      ),
                    ),
                  ),
                  Row(
                    children: <Widget>[
                      Visibility(
                        visible: e.pictureId != '',
                        child: Icon(
                          Icons.image,
                          size: 16,
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                      Text(
                        e.date,
                        style: TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                    ],
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(vertical: 5),
                    width: MediaQuery.of(context).size.width * 0.4,
                    child: Text(
                      e.title,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.left,
                      style: TextStyle(
                          fontSize: 12, color: Theme.of(context).accentColor),
                    ),
                  ),
                ],
              ),
              Container(
                alignment: Alignment.centerRight,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    IconButton(
                      icon: Icon(Icons.edit),
                      color: Theme.of(context).primaryColor,
                      onPressed: () =>
                          widget.openModalExpense(context, false, e),
                    ),
                    IconButton(
                      icon: Icon(Icons.delete),
                      color: Colors.red,
                      onPressed: () => _showMyDialog(e),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}
