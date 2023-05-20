import 'dart:async';

import 'package:flutter/material.dart';
import 'package:parkingo/materials/circle_b.dart';
import 'package:parkingo/materials/circle_empty.dart';
import 'package:parkingo/materials/circle_g.dart';
import 'package:parkingo/materials/circle_p.dart';
import 'package:parkingo/materials/circle_r.dart';
import 'package:parkingo/notifications/notification.dart';
import 'package:parkingo/providers/continuous_provider.dart';
import 'package:parkingo/screens/main_screen.dart';
import 'package:dio/dio.dart';
import 'package:provider/provider.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({Key? key}) : super(key: key);

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  final dio = Dio();
  bool clr = true;
  List<bool> favoriteColor = [true, true, true, true, true];
  int _vacancy = 0;
  int _vacancyEng = 0;
  bool _visible = true;
  Duration _d = new Duration(seconds: 1);
  String _notification = '';

  int _oldvalue =100;
  int _newvalue =0;
  Timer? _timer;


  @override
  void initState() {
    _getvacncy();
    super.initState();
  }

  void _visibility() async {
    setState(() {
      _visible = !_visible;
    });
    await Future.delayed(_d, () {});
    setState(() {
      _visible = !_visible;
    });
  }


  Color getColor(int value){
    Color color;

    if(value == 0) {
      color = Color(0xffDD5358);
    } else if (value ~/ 49 < 50){
      color = Color(0xffFFDD95);
    }else{
      color = Color(0xff08B65A);
    }

    return color;
  }

  void sendNotification() async{
    if(!favoriteColor[0]){
      _timer = Timer.periodic(const Duration(seconds: 5), (timer) async{
        final response = await dio.get('server_ip');
        print(response);
        setState(() {
          _oldvalue = _newvalue;
          _newvalue = int.parse(response.toString());
        });

        if(_newvalue == 0 && _oldvalue == 0){
          FlutterLocalNotification.showNotification();
        }
      });
    }else{
      _cancel();
    }
  }

  void _cancel(){
    _timer?.cancel();
  }

  void _getvacncy() async {
    final response = await dio.get('server_ip');
    setState(() {
      _vacancy = 55 + int.parse(response.toString());
      _vacancyEng = _vacancy - 55;
      if (_vacancy >= 65) {
        clr = true;
      } else {
        clr = false;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    var screenHeight = MediaQuery.of(context).size.height;
    var screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: const Color(0xffEAEAEA),
      body: ListView(
        children: [
          Column(
            children: [
              SizedBox(
                height: screenHeight * 0.03,
              ),
              Row(
                children: [
                  SizedBox(
                    width: screenWidth * 0.025,
                  ),
                  IconButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const MainScreen()),
                        );
                      },
                      icon: Icon(
                        Icons.arrow_back_ios_new,
                        size: screenWidth * 0.07,
                        color: const Color(0xff393A3C),
                      )),
                ],
              ),
              SizedBox(
                height: screenHeight * 0.03,
              ),
              Row(
                children: [
                  SizedBox(
                    width: screenWidth * 0.05,
                  ),
                  const Text(
                    '원하시는 주차장의\n빈자리 알림을 받아보세요',
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: Color(0xff393A3C)),
                  ),
                ],
              ),
              SizedBox(
                height: screenHeight * 0.015,
              ),
              Row(
                children: [
                  SizedBox(
                    width: screenWidth * 0.05,
                  ),
                  const Text(
                    '빈자리가 없는 주차장의 경우 빈자리가 생기면 알림을\n보내드리고, 빈자리가 있는 주차장의 경우 만차가 되면\n일회성 알림을 보내드려요 :)',
                    style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w400,
                        color: Color(0xff9D9EA0)),
                  ),
                ],
              ),
              SizedBox(
                height: screenHeight * 0.02,
              ),
              Row(
                children: [
                  SizedBox(
                    width: screenWidth * 0.05,
                  ),
                  const Text(
                    '정기적 수신',
                    style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w400,
                        color: Color(0xffE55257)),
                  ),
                  const Text(
                    '을 원하시는 경우,',
                    style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w400,
                        color: Color(0xff9D9EA0)),
                  ),
                ],
              ),
              Row(
                children: [
                  SizedBox(
                    width: screenWidth * 0.05,
                  ),
                  const Text(
                    '메인화면에서',
                    style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w400,
                        color: Color(0xff9D9EA0)),
                  ),
                  const Text(
                    ' 주차장 이름 옆에 있는 하트',
                    style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w400,
                        color: Color(0xffE55257)),
                  ),
                  const Text(
                    '를 눌러주세요',
                    style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w400,
                        color: Color(0xff9D9EA0)),
                  ),
                ],
              ),
              SizedBox(
                height: screenHeight * 0.05,
              ),
              Container(
                width: screenWidth * 0.9,
                child: Row(
                  children: [
                    SizedBox(
                      width: screenWidth * 0.03,
                    ),
                    Container(
                      alignment: Alignment.center,
                      child: CircleRed(widthP: screenWidth * 0.10),
                    ),
                    SizedBox(
                      width: screenWidth * 0.04,
                    ),
                    Container(
                      width: screenWidth * 0.25,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            '공학관 주차장',
                            style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w700,
                                color: Color(0xff393A3C)),
                          ),
                          SizedBox(
                            height: screenHeight * 0.003,
                          ),
                          Row(
                            children: [
                              const Text(
                                '빈자리',
                                style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w400,
                                    color: Color(0xff9D9EA0)),
                              ),
                              Text(
                                ' ${_vacancyEng}개',
                                style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w400,
                                    color: getColor(_vacancyEng)),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      width: screenWidth * 0.25,
                    ),
                    ElevatedButton(
                        onPressed: () {
                          context.read<ProviderContinue>().convert();
                          setState(() {
                            favoriteColor[0] = !favoriteColor[0];
                            if (favoriteColor[0]) {
                              _notification = "해제";
                            } else {
                              _notification = "등록";
                            }
                          });
                          _visibility();
                          sendNotification();
                        },
                        child: const Text('등록하기'),
                        style: ElevatedButton.styleFrom(
                            primary: favoriteColor[0]
                                ? const Color(0xff4880EE)
                                : const Color(0xff9DBDF5))),
                  ],
                ),
              ),
              SizedBox(
                height: screenHeight * 0.02,
              ),
              Container(
                width: screenWidth * 0.9,
                child: Row(
                  children: [
                    SizedBox(
                      width: screenWidth * 0.03,
                    ),
                    Container(
                      alignment: Alignment.center,
                      child: CircleYellow(widthP: screenWidth * 0.10),
                    ),
                    SizedBox(
                      width: screenWidth * 0.04,
                    ),
                    Container(
                      width: screenWidth * 0.25,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'C구역 주차장',
                            style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w700,
                                color: Color(0xff393A3C)),
                          ),
                          SizedBox(
                            height: screenHeight * 0.003,
                          ),
                          Row(
                            children: const [
                              Text(
                                '빈자리',
                                style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w400,
                                    color: Color(0xff9D9EA0)),
                              ),
                              Text(
                                ' 37개',
                                style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w400,
                                    color: Color(0xff08B65A)),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      width: screenWidth * 0.25,
                    ),
                    ElevatedButton(
                        onPressed: () {
                          setState(() {
                            favoriteColor[1] = !favoriteColor[1];
                            if (favoriteColor[1]) {
                              _notification = "해제";
                            } else {
                              _notification = "등록";
                            }
                          });
                          _visibility();
                        },
                        child: const Text('등록하기'),
                        style: ElevatedButton.styleFrom(
                            primary: favoriteColor[1]
                                ? const Color(0xff4880EE)
                                : const Color(0xff9DBDF5))),
                  ],
                ),
              ),
              SizedBox(
                height: screenHeight * 0.02,
              ),
              Container(
                width: screenWidth * 0.9,
                child: Row(
                  children: [
                    SizedBox(
                      width: screenWidth * 0.03,
                    ),
                    Container(
                      alignment: Alignment.center,
                      child: CirclePurple(widthP: screenWidth * 0.10),
                    ),
                    SizedBox(
                      width: screenWidth * 0.04,
                    ),
                    Container(
                      width: screenWidth * 0.25,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            '야구장 주차장',
                            style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w700,
                                color: Color(0xff393A3C)),
                          ),
                          SizedBox(
                            height: screenHeight * 0.003,
                          ),
                          Row(
                            children: const [
                              Text(
                                '빈자리',
                                style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w400,
                                    color: Color(0xff9D9EA0)),
                              ),
                              Text(
                                ' 11개',
                                style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w400,
                                    color: Color(0xffE7D711)),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      width: screenWidth * 0.25,
                    ),
                    ElevatedButton(
                        onPressed: () {
                          setState(() {
                            favoriteColor[2] = !favoriteColor[2];
                            if (favoriteColor[2]) {
                              _notification = "해제";
                            } else {
                              _notification = "등록";
                            }
                          });
                          _visibility();
                        },
                        child: const Text('등록하기'),
                        style: ElevatedButton.styleFrom(
                            primary: favoriteColor[2]
                                ? const Color(0xff4880EE)
                                : const Color(0xff9DBDF5))),
                  ],
                ),
              ),
              SizedBox(
                height: screenHeight * 0.02,
              ),
              Container(
                width: screenWidth * 0.9,
                child: Row(
                  children: [
                    SizedBox(
                      width: screenWidth * 0.03,
                    ),
                    Container(
                      alignment: Alignment.center,
                      child: CircleBlue(widthP: screenWidth * 0.10),
                    ),
                    SizedBox(
                      width: screenWidth * 0.04,
                    ),
                    Container(
                      width: screenWidth * 0.25,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            '농구장 주차장',
                            style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w700,
                                color: Color(0xff393A3C)),
                          ),
                          SizedBox(
                            height: screenHeight * 0.003,
                          ),
                          Row(
                            children: const [
                              Text(
                                '빈자리',
                                style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w400,
                                    color: Color(0xff9D9EA0)),
                              ),
                              Text(
                                ' 7개',
                                style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w400,
                                    color: Color(0xffE7D711)),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      width: screenWidth * 0.25,
                    ),
                    ElevatedButton(
                        onPressed: () {
                          setState(() {
                            favoriteColor[3] = !favoriteColor[3];
                            if (favoriteColor[3]) {
                              _notification = "해제";
                            } else {
                              _notification = "등록";
                            }
                          });
                          _visibility();
                        },
                        child: const Text('등록하기'),
                        style: ElevatedButton.styleFrom(
                            primary: favoriteColor[3]
                                ? const Color(0xff4880EE)
                                : const Color(0xff9DBDF5))),
                  ],
                ),
              ),
              SizedBox(
                height: screenHeight * 0.02,
              ),
              Container(
                width: screenWidth * 0.9,
                child: Row(
                  children: [
                    SizedBox(
                      width: screenWidth * 0.03,
                    ),
                    Container(
                      alignment: Alignment.center,
                      child: CircleGreen(widthP: screenWidth * 0.10),
                    ),
                    SizedBox(
                      width: screenWidth * 0.04,
                    ),
                    Container(
                      width: screenWidth * 0.25,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            '연구동 주차장',
                            style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w700,
                                color: Color(0xff393A3C)),
                          ),
                          SizedBox(
                            height: screenHeight * 0.003,
                          ),
                          Row(
                            children: const [
                              Text(
                                '빈자리',
                                style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w400,
                                    color: Color(0xff9D9EA0)),
                              ),
                              Text(
                                ' 0개',
                                style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w400,
                                    color: Color(0xffDD5358)),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      width: screenWidth * 0.25,
                    ),
                    ElevatedButton(
                        onPressed: () {
                          setState(() {
                            favoriteColor[4] = !favoriteColor[4];
                            if (favoriteColor[4]) {
                              _notification = "해제";
                            } else {
                              _notification = "등록";
                            }
                          });
                          _visibility();
                        },
                        child: const Text('등록하기'),
                        style: ElevatedButton.styleFrom(
                            primary: favoriteColor[4]
                                ? const Color(0xff4880EE)
                                : const Color(0xff9DBDF5))),
                  ],
                ),
              ),
              SizedBox(
                height: screenHeight * 0.05,
              ),
              Center(
                child: AnimatedOpacity(
                  opacity: _visible ? 0.0 : 1.0,
                  duration: const Duration(milliseconds: 500),
                  child: Container(
                      width: screenWidth * 0.6,
                      height: screenHeight * 0.07,
                      decoration: const BoxDecoration(
                          color: Color(0xff8D94A0),
                          borderRadius:
                              BorderRadius.all(Radius.circular(50.0))),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.notifications,
                            color: Color(0xffF7CF6C),
                          ),
                          SizedBox(
                            width: screenWidth * 0.03,
                          ),
                          Text(
                            '알림을 ${_notification}했어요',
                            style: const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w400,
                                color: Color(0xffFFFFFF)),
                          ),
                        ],
                      )),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
