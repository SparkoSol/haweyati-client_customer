import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:haweyati/widgits/emptyContainer.dart';

class DatePickerField extends StatefulWidget {
  var title;
  Function(DateTime) onChanged;

  DatePickerField.withDate( {this.title = "selected date", this.onChanged} );
  DatePickerField({this.title = "selected date", this.onChanged});

  @override createState() => _DatePickerFieldState();

  static String formattedDate(DateTime date)
    => date.day.toString() + "\t-\t" + ["January", "Feburary", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"][date.month-1] + "\t-\t" + date.year.toString();
}

class _DatePickerFieldState extends State<DatePickerField> {
  var _textFieldController = TextEditingController();

  @override build(context) => GestureDetector(
    onTap: (){
      showDatePicker(initialDatePickerMode: DatePickerMode.day,
          context: context,
          lastDate: DateTime(3000),
          firstDate: DateTime.now(),
          initialDate: DateTime.now(),

          builder: (context, child) => Theme(data: ThemeData.dark(), child: Column(
            children: <Widget>[
              SizedBox(
                height: 500,
                child: child
              ),
            ],
            mainAxisAlignment: MainAxisAlignment.center,
          ))
      ).then((date) {
        setState(() {
          if (date != null) this._textFieldController.text = DatePickerField.formattedDate(date); widget.onChanged(date);
        });
       });

    },
    child: EmptyContainer(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12.0),
        child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(_textFieldController.text.isEmpty ? "Select Date" : _textFieldController.text),
            Icon(Icons.date_range, color: Colors.grey.shade700),
          ],
        ),
      ),
    ),
  );
}