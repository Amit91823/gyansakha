import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gyansakha/screens/MassegesScreen.dart';
import 'package:gyansakha/screens/ScheduleScreen.dart';
import 'package:gyansakha/screens/SettingScreen.dart';
import 'package:gyansakha/screens/UpdateScheduledScreen.dart';
import 'package:jitsi_meet/feature_flag/feature_flag.dart';
import 'package:jitsi_meet/jitsi_meet.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({Key? key}) : super(key: key);

  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard>
    with SingleTickerProviderStateMixin {
  TabController? _tabController;

  @override
  void initState() {
    _tabController = TabController(length: 3, vsync: this);
    super.initState();
  }

  void _joinMeeting({required String roomid, required String topic}) async {
    try {
      FeatureFlag featureFlag = FeatureFlag();
      featureFlag.welcomePageEnabled = false;
      featureFlag.resolution = FeatureFlagVideoResolution
          .MD_RESOLUTION; // Limit video resolution to 360p

      var options = JitsiMeetingOptions(room: roomid)
        // Required, spaces will be trimmed
        ..subject = topic
        ..userDisplayName = "Amit"
        ..userEmail = "amit@gmail.com"
        ..audioOnly = false
        ..audioMuted = true
        ..videoMuted = false;

      await JitsiMeet.joinMeeting(options);
    } catch (error) {
      debugPrint("error: $error");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.teal,
        title: Text(
          "Classes",
          style: TextStyle(
              color: Colors.white, fontSize: 20.0, fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
              onPressed: () {
                FirebaseAuth.instance.signOut();
              },
              icon: Icon(Icons.exit_to_app))
        ],
      ),
      body: TabBarView(controller: _tabController, children: [
        Column(children: [
          Container(
            margin: EdgeInsets.only(top: 5),
            width: MediaQuery.of(context).size.width,
            height: 50,
            padding: EdgeInsets.all(9),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(
                Radius.circular(40),
              ),
              border: Border.all(
                width: 3,
                color: Colors.grey,
                style: BorderStyle.solid,
              ),
            ),
            child: TextField(
              decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: "Search",
                  hintStyle: TextStyle(height: 1),
                  prefixIcon: Icon(
                    Icons.search,
                  )),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Column(
                children: [
                  Card(
                    margin: EdgeInsets.only(top: 15),
                    elevation: 8,
                    color: Colors.white70,
                    shadowColor: Colors.teal,
                    child: Container(
                      width: 100,
                      height: 60,
                      margin: EdgeInsets.only(top: 10),
                      child: Icon(
                        Icons.voice_chat_outlined,
                        size: 50,
                        color: Colors.teal,
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(bottom: 10),
                    child: Text(
                      "Start Classes",
                      style: TextStyle(
                          color: Colors.teal,
                          fontSize: 11.0,
                          fontWeight: FontWeight.bold),
                    ),
                  )
                ],
              ),
              Column(
                children: [
                  GestureDetector(
                    onTap: () {
                      print("clicked!!!!");
                      Navigator.of(context).push(
                          MaterialPageRoute(builder: (_) => ScheduleScreen()));
                    },
                    child: Card(
                      margin: EdgeInsets.only(top: 15),
                      elevation: 8,
                      shadowColor: Colors.teal,
                      color: Colors.white70,
                      child: Container(
                        width: 100,
                        height: 60,
                        margin: EdgeInsets.only(top: 10),
                        child: Icon(
                          Icons.date_range_outlined,
                          size: 50,
                          color: Colors.teal,
                        ),
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(bottom: 10),
                    child: Text(
                      "schedule Classes",
                      style: TextStyle(
                          color: Colors.teal,
                          fontSize: 11.0,
                          fontWeight: FontWeight.bold),
                    ),
                  )
                ],
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                margin: EdgeInsets.only(left: 20, top: 25),
                child: Icon(
                  Icons.format_list_bulleted_outlined,
                  size: 30,
                  color: Colors.teal,
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 20, left: 15),
                padding: EdgeInsets.all(10),
                child: Text(
                  "My Classes",
                  style: TextStyle(
                      color: Colors.teal,
                      fontSize: 13.0,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
          Expanded(
              child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                  stream: FirebaseFirestore.instance
                      .collection("schedule")
                      .orderBy("from", descending: true)
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    }

                    QuerySnapshot<Map<String, dynamic>>? _data = snapshot.data;

                    return ListView.builder(
                        itemCount: _data?.docs.length,
                        itemBuilder: (context, i) {
                          DateTime _from = DateTime.fromMicrosecondsSinceEpoch(
                              _data?.docs[i].data()['from']);
                          DateTime _to = DateTime.fromMicrosecondsSinceEpoch(
                              _data?.docs[i].data()['to']);

                          return Dismissible(
                            key: Key(_data!.docs[i].id),
                            background: Container(
                              alignment: Alignment.centerLeft,
                              padding: EdgeInsets.only(left: 25),
                              color: Colors.red,
                              child: Text(
                                "Delete",
                                style: TextStyle(
                                    color: Colors.white, fontSize: 16),
                              ),
                            ),
                            direction: DismissDirection.startToEnd,
                            onDismissed: (direction) {
                              FirebaseFirestore.instance
                                  .collection("schedule")
                                  .doc(_data.docs[i].id)
                                  .delete();
                              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                  content: Text(
                                      ('${_data.docs[i].data()['date']} has been Deleted succesfully'))));
                            },
                            child: ListTile(
                              onLongPress: () {
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (_) => UpdateScheduledScreen(
                                        id: _data.docs[i].id)));
                              },
                              onTap: () {
                                _joinMeeting(
                                    roomid: _data.docs[i].id,
                                    topic: _data.docs[i].data()['topic']);
                              },
                              title: Text(_data.docs[i].data()['topic']),
                              subtitle: Text(
                                  "${_data.docs[i].data()['date']} - ${_from.hour.toString().padLeft(2, '0')} : ${_from.minute.toString().padLeft(2, '0')} -> ${_to.hour.toString().padLeft(2, '0')} : ${_to.minute.toString().padLeft(2, '0')}"),
                            ),
                          );
                        });
                  }))
        ]),
        MassegesScreen(),
        SettingScreen()
      ]),
      bottomNavigationBar: TabBar(
        labelColor: Colors.teal,
        controller: _tabController,
        tabs: [
          Tab(icon: Icon(Icons.chat), text: "Meet & Chat"),
          Tab(icon: Icon(Icons.textsms_outlined), text: "Masseges"),
          Tab(icon: Icon(Icons.settings_outlined), text: "Settings"),
        ],
      ),
    );
  }
}
