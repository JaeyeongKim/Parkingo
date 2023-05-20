
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:parkingo/materials/parking_lot.dart';
import 'package:dio/dio.dart';
import 'package:parkingo/notifications/notification.dart';



class TestScreen extends StatefulWidget {
  const TestScreen({Key? key}) : super(key: key);

  @override
  State<TestScreen> createState() => _TestScreenState();
}

class _TestScreenState extends State<TestScreen> {
  final dio = Dio();
  bool _isRunning = false;
  Timer? _timer;

  @override
  void initState() {

    super.initState();
  }

  void getHttp() async {
    final response = await dio.get('server_ip');
    print(response);
  }

  void alarm(){
    setState(() {
      _isRunning = !_isRunning;
      print(_isRunning);
    });
    if(_isRunning){
      _timer = Timer.periodic(const Duration(seconds: 5), (timer) {
        FlutterLocalNotification.showNotification();
      });
    }else{
      _timer?.cancel();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue,
      body:Center(
        child: ParkingLot(),
      ),
      floatingActionButton: FloatingActionButton(onPressed: () {
        alarm();
      },child: Icon(Icons.add), heroTag: 'dio',),
    );
  }
}
