import 'dart:convert';
import 'dart:typed_data';

import 'package:camera/camera.dart';
import 'package:expense_management/screens/CameraCaptureScreen.dart';
import 'package:expense_management/utils/SqfliteControl.dart';

import '../../models/Models.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ModalExpense extends StatefulWidget {
  final type;
  final Expense expense;
  final Function action;
  ModalExpense(this.type, this.expense, this.action);

  @override
  _ModalExpenseState createState() => _ModalExpenseState();
}

class _ModalExpenseState extends State<ModalExpense> {
  // Variable & state
  final titleController = new TextEditingController();
  final amountController = new TextEditingController();
  final List<Content> contentList = [
    Content(name: 'Thu nhập', type: 1),
    Content(name: 'Được cho mượn', type: 1),
    Content(name: 'Chi phí phát sinh', type: -1),
    Content(name: 'Cho mượn', type: -1),
    Content(name: 'Tiêu dùng định kỳ', type: -1),
    Content(name: 'Mua sắm, giải trí, ăn uống', type: -1)
  ];

  Content contentValue = Content(name: 'Chi phí phát sinh', type: -1);
  String dropdownValue = 'Chi phí phát sinh';
  DateTime pickedDate = DateTime.now();
  Picture picture;
  final _formKey = GlobalKey<FormState>();

  void _showImage(Picture pic) {
    Uint8List data = base64Decode(pic.base64);
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DisplayPictureScreen(imageData: data),
      ),
    );
  }

  Future<Picture> _getPicture(String pictureId) async {
    var item = await SqfliteControl.instance.queryOneRow(
        SqfliteControl.tablePicture, SqfliteControl.columnPictureId, pictureId);
    if (item.length != 0)
      return Picture.fromMap(item);
    else
      return null;
  }

  void _updatePicture(String base64) {
    setState(() {
      picture = Picture(id: widget.expense.id, base64: base64);
    });
  }

  void _openCamera() {
    print('Opening Camera Capture Screen');
    WidgetsFlutterBinding.ensureInitialized();
    CameraDescription camFront;
    CameraDescription camBack;
    availableCameras().then((cameras) {
      cameras.forEach((camera) {
        if (camera.lensDirection == CameraLensDirection.front &&
            camFront == null) camFront = camera;
        if (camera.lensDirection == CameraLensDirection.back && camBack == null)
          camBack = camera;
      });
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => CameraCaptureScreen(
            camFront,
            camBack,
            _updatePicture,
          ),
        ),
      );
    });
  }

  // Functions
  void _initValue() {
    if (widget.expense.pictureId != '') {
      _getPicture(widget.expense.pictureId).then((_picture) {
        setState(() {
          picture = _picture;
        });
        print("Picture is: .....................................");
        print("Picture Id is: " + picture.id);
        print("Picture Data Length is: " + picture.base64.length.toString());
      });
    }
    try {
      if (!widget.type) {
        // print('${widget.expense.amount} at ${widget.expense.date.toString()}');
        setState(() {
          contentValue = Content(
              name: widget.expense.contentName,
              type: widget.expense.contentType);
          dropdownValue = widget.expense.contentName;
          pickedDate =
              DateFormat('dd/MM/yyyy HH:mm:ss').parse(widget.expense.date);
          titleController.text = widget.expense.title;
          amountController.text = widget.expense.amount.toString();
        });
      }
    } catch (ex) {
      print(ex.toString());
      return;
    }
  }

  void _openDatePicker() {
    showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
    ).then((pickedValue) {
      if (pickedValue == null) return;
      setState(() {
        pickedDate = pickedValue;
      });
    });
  }

  @override
  void initState() {
    _initValue();
    super.initState();
  }

  Widget _getThumbnaillPic(context) {
    if (picture == null) {
      return Align(
        alignment: Alignment.bottomLeft,
        child: Visibility(
          visible: picture == null,
          child: Card(
            elevation: 5,
            child: Container(
              width: 100,
              height: 100,
              child: IconButton(
                icon: Icon(
                  Icons.add_a_photo,
                  size: 40,
                ),
                color: Colors.grey[400],
                onPressed: () {
                  _openCamera();
                },
              ),
            ),
          ),
        ),
      );
    } else
      return Align(
        alignment: Alignment.bottomLeft,
        child: Visibility(
          visible: picture != null,
          child: Card(
            elevation: 5,
            child: Container(
              width: 100,
              height: 100,
              child: GestureDetector(
                child: Image.memory(base64Decode(picture.base64)),
                onTap: () {
                  _showImage(picture);
                },
              ),
            ),
          ),
        ),
      );
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Container(
        padding: EdgeInsets.all(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Expanded(
                  child: TextFormField(
                    // initialValue: widget.expense.amount.toString(),
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(labelText: 'Amount'),
                    controller: amountController,
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Please enter some number';
                      }
                      return null;
                    },
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(left: 15),
                  child: DropdownButton<String>(
                    value: dropdownValue,
                    icon: Icon(Icons.arrow_drop_down),
                    iconSize: 24,
                    elevation: 16,
                    style: TextStyle(color: Theme.of(context).primaryColor),
                    underline: Container(
                      height: 2,
                      color: Theme.of(context).primaryColor,
                    ),
                    onChanged: (String newValue) {
                      var target = contentList
                          .firstWhere((element) => element.name == newValue);
                      setState(() {
                        dropdownValue = newValue;
                        contentValue = target;
                      });
                    },
                    items: <String>[
                      'Thu nhập',
                      'Được cho mượn',
                      'Chi phí phát sinh',
                      'Cho mượn',
                      'Tiêu dùng định kỳ',
                      'Mua sắm, giải trí, ăn uống'
                    ].map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
            TextFormField(
              // initialValue: widget.expense.title,
              decoration: InputDecoration(labelText: 'Title'),
              controller: titleController,
              validator: (value) {
                if (value.isEmpty) {
                  return 'Please enter some text';
                }
                return null;
              },
            ),
            Container(
              margin: EdgeInsets.only(top: 15),
              alignment: Alignment.bottomLeft,
              child: Text(
                'Picture',
                style: TextStyle(
                  color: Colors.grey[700],
                  fontSize: 16,
                ),
              ),
            ),
            _getThumbnaillPic(context),
            Row(
              children: <Widget>[
                Expanded(
                  child: Text(
                    DateFormat().format(pickedDate),
                    style: TextStyle(color: Colors.grey),
                  ),
                ),
                FlatButton(
                  onPressed: _openDatePicker,
                  textColor: Theme.of(context).primaryColor,
                  child: Text(
                    'Choose Date',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
            RaisedButton(
              child: Text(widget.type ? 'Add Expense' : 'Edit Expense'),
              color: Theme.of(context).primaryColor,
              textColor: Colors.white,
              onPressed: () {
                if (_formKey.currentState.validate()) {
                  Expense expense = Expense(
                    id: widget.expense.id,
                    contentType: contentValue.type,
                    contentName: contentValue.name,
                    title: titleController.text,
                    amount: double.parse(amountController.text),
                    date: DateFormat('dd/MM/yyyy HH:mm:ss').format(pickedDate),
                    pictureId: picture == null ? '' : widget.expense.id,
                    picture: picture,
                  );
                  // Process data.
                  widget.action(expense);
                  Navigator.of(context).pop();
                }
              },
            )
          ],
        ),
      ),
    );
  }
}

// A widget that displays the picture taken by the user.
class DisplayPictureScreen extends StatelessWidget {
  final Uint8List imageData;

  const DisplayPictureScreen({Key key, this.imageData}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // The image is stored as a file on the device. Use the `Image.file`
      // constructor with the given path to display the image.
      body: Image.memory(imageData),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.grey[800],
        child: Icon(
          Icons.arrow_back_ios,
          color: Colors.white,
        ),
        onPressed: () {
          Navigator.pop(context);
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.startTop,
    );
  }
}
