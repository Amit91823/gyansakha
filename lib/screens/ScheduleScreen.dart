import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ScheduleScreen extends StatefulWidget {
  const ScheduleScreen({Key? key}) : super(key: key);

  @override
  _ScheduleScreenState createState() => _ScheduleScreenState();
}

class _ScheduleScreenState extends State<ScheduleScreen> {
  final _formkey = GlobalKey<FormState>();
  final _database = FirebaseFirestore.instance;
  Map<String, String> _formdata = {};

  TimeOfDay? time1;
  TimeOfDay? time2;

  @override
  void initState() {
    super.initState();
    time1 = TimeOfDay.now();
    time2 = TimeOfDay.now();
  }

  Future<TimeOfDay?> selectTime(BuildContext context) async {
    TimeOfDay? _picked;
    _picked = await showTimePicker(context: context, initialTime: time1!);

    return _picked;
  }

  DateTime selectedDate = DateTime.now();

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2101));
    if (picked != null && picked != selectedDate)
      setState(() {
        selectedDate = picked;
      });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: Colors.teal,
          title: Text(
            "Schedule Classes",
            style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
                color: Colors.white),
          ),
        ),
        body: Form(
            key: _formkey,
            child: Column(children: [
              Container(
                  child: TextFormField(
                initialValue: "${selectedDate.toLocal()}".split(' ')[0],
                decoration:
                    InputDecoration(hintText: "Date", labelText: "Date"),
                onTap: () {
                  _selectDate(context);
                },
                validator: (String? data) {
                  if (data!.isEmpty) {
                    return "Time is Required!";
                  }
                  return null;
                },
                onSaved: (String? data) {
                  _formdata["date"] = data!;
                },
              )),
              Container(
                margin: EdgeInsets.all(10),
                child: TextFormField(
                  key: Key(time1.toString()),
                  onTap: () async {
                    TimeOfDay? x = await selectTime(context);
                    setState(() {
                      time1 = x;
                    });
                  },
                  initialValue:
                      '${time1?.hour.toString().padLeft(2, '0')} : ${time1?.minute.toString().padLeft(2, '0')}',
                  decoration: InputDecoration(
                    labelText: "From",
                  ),
                  validator: (String? data) {
                    if (data!.isEmpty) {
                      return "Time is Required!";
                    }
                    return null;
                  },
                  onSaved: (String? data) {
                    _formdata["time1"] = data!;
                  },
                ),
              ),
              Container(
                margin: EdgeInsets.all(10),
                child: TextFormField(
                  key: Key(time2.toString()),
                  onTap: () async {
                    time2 = await selectTime(context);
                    setState(() {});
                  },
                  initialValue:
                      '${time2?.hour.toString().padLeft(2, '0')} : ${time2?.minute.toString().padLeft(2, '0')}',
                  decoration: InputDecoration(
                    labelText: "To",
                  ),
                  validator: (String? data) {
                    if (data!.isEmpty) {
                      return "Time is Required!";
                    }
                    return null;
                  },
                  onSaved: (String? data) {
                    _formdata["time2"] = data!;
                  },
                ),
              ),
              Container(
                margin: EdgeInsets.all(10),
                child: TextFormField(
                  decoration: InputDecoration(
                    labelText: "Topic",
                  ),
                  validator: (String? data) {
                    if (data!.isEmpty) {
                      return "Topic is Required!";
                    }
                    return null;
                  },
                  onSaved: (String? data) {
                    _formdata["topic"] = data!;
                  },
                ),
              ),
              Container(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(primary: Colors.teal),
                  onPressed: _submit,
                  child: Text("Schedule"),
                ),
              )
            ])));
  }

  void _submit() {
    if (_formkey.currentState!.validate()) {
      _formkey.currentState!.save();
      DateTime? _t1 = DateTime.parse(
          "${_formdata['date']}T${_formdata['time1']!.replaceAll(" ", "")}");
      DateTime? _t2 = DateTime.parse(
          "${_formdata['date']}T${_formdata['time2']!.replaceAll(" ", "")}");

      _database.collection("schedule").add({
        "date": _formdata['date'],
        "from": _t1.microsecondsSinceEpoch,
        "to": _t2.microsecondsSinceEpoch,
        "topic": _formdata['topic']
      });
      Navigator.of(context).pop();
    }
  }
}
