import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class UpdateScheduledScreen extends StatefulWidget {
  final String id;
  const UpdateScheduledScreen({required this.id});

  @override
  _UpdateScheduledScreenState createState() => _UpdateScheduledScreenState();
}

class _UpdateScheduledScreenState extends State<UpdateScheduledScreen> {
  final _formkey = GlobalKey<FormState>();
  final _database = FirebaseFirestore.instance;
  Map<String, String> _formdata = {};
  DateTime? selectedDate;

  TimeOfDay? time1;
  TimeOfDay? time2;

  @override
  void initState() {
    super.initState();
  }

  Future<TimeOfDay?> selectTime(BuildContext context, TimeOfDay time) async {
    TimeOfDay? _picked;
    _picked = await showTimePicker(context: context, initialTime: time);

    return _picked;
  }

  Future<void> _selectDate(BuildContext context, DateTime selectDate) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: selectDate,
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
            "Update Scheduled Classes",
            style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
                color: Colors.white),
          ),
        ),
        body: StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
            stream: FirebaseFirestore.instance
                .collection("schedule")
                .doc(widget.id)
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }

              DocumentSnapshot<Map<String, dynamic>>? _data = snapshot.data;

              return Form(
                  key: _formkey,
                  child: Column(children: [
                    Container(
                        child: TextFormField(
                      initialValue: (selectedDate == null)
                          ? "${_data?.data()!['date']}"
                          : "${selectedDate?.toLocal()}".split(" ")[0],
                      decoration:
                          InputDecoration(hintText: "Date", labelText: "Date"),
                      onTap: () {
                        _selectDate(context,
                            DateTime.parse("${_data?.data()!['date']}T00:00"));
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
                          TimeOfDay? x = await selectTime(
                              context,
                              TimeOfDay(
                                  hour: DateTime.fromMicrosecondsSinceEpoch(
                                          _data?.data()!['from'])
                                      .hour,
                                  minute: DateTime.fromMicrosecondsSinceEpoch(
                                          _data?.data()!['from'])
                                      .minute));
                          setState(() {
                            time1 = x;
                          });
                        },
                        initialValue: (time1 == null)
                            ? "${DateTime.fromMicrosecondsSinceEpoch(_data?.data()!['from']).hour}:${DateTime.fromMicrosecondsSinceEpoch(_data?.data()!['from']).minute}"
                            : "${time1?.hour}:${time1?.minute}",
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
                          time2 = await selectTime(
                              context,
                              TimeOfDay(
                                  hour: DateTime.fromMicrosecondsSinceEpoch(
                                          _data?.data()!['to'])
                                      .hour,
                                  minute: DateTime.fromMicrosecondsSinceEpoch(
                                          _data?.data()!['to'])
                                      .minute));
                          setState(() {});
                        },
                        initialValue: (time2 == null)
                            ? "${DateTime.fromMicrosecondsSinceEpoch(_data?.data()!['to']).hour}:${DateTime.fromMicrosecondsSinceEpoch(_data?.data()!['to']).minute}"
                            : "${time2?.hour}:${time2?.minute}",
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
                        initialValue: _data?.data()!['topic'],
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
                  ]));
            }));
  }

  void _submit() {
    if (_formkey.currentState!.validate()) {
      _formkey.currentState!.save();
      print(_formdata['date']);
      DateTime? _t1 = DateTime.parse(
          "${_formdata['date']}T${_formdata['time1']!.replaceAll(" ", "")}");
      DateTime? _t2 = DateTime.parse(
          "${_formdata['date']}T${_formdata['time2']!.replaceAll(" ", "")}");

      _database.collection("schedule").doc(widget.id).update({
        "date": _formdata['date'],
        "from": _t1.microsecondsSinceEpoch,
        "to": _t2.microsecondsSinceEpoch,
        "topic": _formdata['topic']
      });
      Navigator.of(context).pop();
    }
  }
}
