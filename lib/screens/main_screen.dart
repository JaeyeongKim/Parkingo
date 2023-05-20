import 'dart:async';

import 'package:flutter/material.dart';
import 'package:parkingo/materials/circle_r.dart';
import 'package:parkingo/materials/circle_b.dart';
import 'package:parkingo/materials/circle_y.dart';
import 'package:parkingo/materials/circle_p.dart';
import 'package:parkingo/materials/circle_g.dart';
import 'package:parkingo/materials/circle_empty.dart';
import 'package:parkingo/materials/parking_lot.dart';
import 'package:parkingo/notifications/notification.dart';
import 'package:parkingo/providers/once_provider.dart';
import 'package:parkingo/screens/notification_screen.dart';
import 'package:parkingo/screens/report_screen.dart';
import 'package:parkingo/screens/test_screen.dart';
import 'package:dio/dio.dart';
import 'package:provider/provider.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final dio = Dio();
  bool clr = true;
  List<bool> favoriteColor = [true, true, true, true, true];
  int _vacancy = 0;
  int _vacancyEng = 0;

  int _oldvalue =100;
  int _newvalue =0;

  Timer? _timer;

  @override
  void initState() {
    _getvacncy();
    FlutterLocalNotification.init();
    Future.delayed(const Duration(seconds: 2),
        FlutterLocalNotification.requestNotificationPermission()
    );

    super.initState();
  }

  void sendNotification() async{
    final _ch = context.read<ProviderOnce>().once;
    print(_ch);

    if(!_ch){
      _timer = Timer.periodic(const Duration(seconds: 5), (timer) async{
        final response = await dio.get('http://3.36.26.33:5000/');
        setState(() {
          _oldvalue = _newvalue;
          _newvalue = int.parse(response.toString());
        });

        if(_newvalue == 0 && _oldvalue == 0){
          FlutterLocalNotification.showNotification();
          // ignore: use_build_context_synchronously
          context.read<ProviderOnce>().convert();
          _cancel();
        }
      });
    }else{
      _cancel();
    }
  }

  void _cancel(){
    _timer?.cancel();
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
  void _getvacncy() async {
    final response = await dio.get('http://3.36.26.33:5000/');
    print(response);
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
                height: screenHeight * 0.05,
              ),
              Row(
                children: [
                  SizedBox(
                    width: screenWidth * 0.05,
                  ),
                  Container(
                    width: screenHeight * 0.05,
                    height: screenHeight * 0.05,
                    decoration: const BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage('./assets/vector.png'),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: screenWidth * 0.01,
                  ),
                  Container(
                    //padding: EdgeInsets.only(top:screenHeight*0.5),
                    width: screenWidth * 0.3,
                    height: screenHeight * 0.05,
                    decoration: const BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage('./assets/parkingo.png'),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: screenWidth * 0.4,
                  ),
                  IconButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const NotificationScreen()),
                      );
                    },
                    icon: Icon(Icons.notifications, size: screenHeight * 0.04),
                    color: const Color(0xffB2B8BE),
                  ),
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
                    '성균관대학교 자연과학캠퍼스',
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: Color(0xff393A3C)),
                  ),
                ],
              ),
              SizedBox(
                height: screenHeight * 0.01,
              ),
              Row(
                children: [
                  SizedBox(
                    width: screenWidth * 0.05,
                  ),
                  const Text(
                    '주차장 현황을 알려드려요',
                    style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w400,
                        color: Color(0xff9D9EA0)),
                  ),
                ],
              ),
              SizedBox(
                height: screenHeight * 0.03,
              ),
              Card(
                shape: RoundedRectangleBorder(
                  //모서리를 둥글게 하기 위해 사용
                  borderRadius: BorderRadius.circular(16.0),
                ),
                elevation: 4.0,
                child: Container(
                  width: screenWidth * 0.85,
                  padding: EdgeInsets.fromLTRB(screenWidth * 0.05,
                      screenHeight * 0.03, screenWidth * 0.05, 0),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          const Text(
                            '현재 ',
                            style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w700,
                                color: Color(0xff393A3C)),
                          ),
                          Text(
                            '${_vacancy}개',
                            style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w700,
                                color: Color(0xff10DB6A)),
                          ),
                          const Text(
                            '의 빈자리가 있어요 :)',
                            style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w700,
                                color: Color(0xff393A3C)),
                          ),
                          SizedBox(
                            width: screenWidth * 0.02,
                          ),
                          IconButton(
                              onPressed: () {
                                _getvacncy();
                              },
                              icon: Icon(Icons.sync, size: screenHeight * 0.03),
                              color: const Color(0xffB2B8BE))
                        ],
                      ),
                      SizedBox(
                        height: screenHeight * 0.02,
                      ),
                      Row(
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
                            width: screenWidth*0.25,
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
                                          color: getColor(_vacancyEng)
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            width: screenWidth * 0.18,
                          ),
                          IconButton(
                              onPressed: () {
                                context.read<ProviderOnce>().convert();
                                setState(() {

                                });
                                sendNotification();

                              },
                              icon: Icon(Icons.favorite,
                                  size: screenHeight * 0.03),
                              color: context.watch<ProviderOnce>().once
                                  ? const Color(0xffB2B8BE)
                                  : const Color(0xffF9595F))
                        ],
                      ),
                      SizedBox(
                        height: screenHeight * 0.02,
                      ),
                      Row(
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
                                          color:  Color(0xff08B65A)),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            width: screenWidth * 0.18,
                          ),
                          IconButton(
                              onPressed: () {
                                setState(() {
                                  favoriteColor[1] = !favoriteColor[1];
                                });
                              },
                              icon: Icon(Icons.favorite,
                                  size: screenHeight * 0.03),
                              color: favoriteColor[1]
                                  ? const Color(0xffB2B8BE)
                                  : const Color(0xffF9595F))
                        ],
                      ),
                      SizedBox(
                        height: screenHeight * 0.02,
                      ),
                      Row(
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
                            width: screenWidth * 0.18,
                          ),
                          IconButton(
                              onPressed: () {
                                setState(() {
                                  favoriteColor[2] = !favoriteColor[2];
                                });
                              },
                              icon: Icon(Icons.favorite,
                                  size: screenHeight * 0.03),
                              color: favoriteColor[2]
                                  ? const Color(0xffB2B8BE)
                                  : const Color(0xffF9595F))
                        ],
                      ),
                      SizedBox(
                        height: screenHeight * 0.02,
                      ),
                      Row(
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
                            width: screenWidth * 0.18,
                          ),
                          IconButton(
                              onPressed: () {
                                setState(() {
                                  favoriteColor[3] = !favoriteColor[3];
                                });
                              },
                              icon: Icon(Icons.favorite,
                                  size: screenHeight * 0.03),
                              color: favoriteColor[3]
                                  ? const Color(0xffB2B8BE)
                                  : const Color(0xffF9595F))
                        ],
                      ),
                      SizedBox(
                        height: screenHeight * 0.02,
                      ),
                      Row(
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
                            width: screenWidth * 0.18,
                          ),
                          IconButton(
                              onPressed: () {
                                setState(() {
                                  favoriteColor[4] = !favoriteColor[4];
                                });
                              },
                              icon: Icon(Icons.favorite,
                                  size: screenHeight * 0.03),
                              color: favoriteColor[4]
                                  ? const Color(0xffB2B8BE)
                                  : const Color(0xffF9595F))
                        ],
                      ),
                      SizedBox(
                        height: screenHeight * 0.03,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            width: screenWidth * 0.75,
                            height: screenHeight * 0.08,
                            decoration: const BoxDecoration(
                              border: Border(
                                top: BorderSide(
                                  color: Color(0xffF0F1F3),
                                  width: 3,
                                ),
                              ),
                            ),
                            child: Center(
                              child: TextButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const ReportScreen()),
                                  );
                                },
                                child: const Text(
                                  '잘못된 정보를 발견하셨나요? 오류를 신고해주세요 >',
                                  style: TextStyle(
                                      fontSize: 11,
                                      fontWeight: FontWeight.w400,
                                      color: Color(0xffB2B8BE)),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: screenHeight * 0.05,
              ),
              Card(
                shape: RoundedRectangleBorder(
                  //모서리를 둥글게 하기 위해 사용
                  borderRadius: BorderRadius.circular(16.0),
                ),
                elevation: 4.0,
                child: Container(
                  width: screenWidth * 0.85,
                  padding: EdgeInsets.fromLTRB(screenWidth * 0.05,
                      screenHeight * 0.03, screenWidth * 0.05, 0),
                  child: Column(
                    children: [
                      Row(
                        children: const [
                          Text(
                            '주차장 위치 및 이용 정보',
                            style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w700,
                                color: Color(0xff393A3C)),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: screenHeight * 0.005,
                      ),
                      Row(
                        children: const [
                          Text(
                            '각 주차장 이름과 위치를 확인하세요',
                            style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w400,
                                color: Color(0xff9D9EA0)),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: screenHeight * 0.03,
                      ),
                      const ParkingLot(),
                      SizedBox(
                        height: screenHeight * 0.03,
                      ),
                      Table(
                        border: const TableBorder(
                            horizontalInside: BorderSide(
                                width: 1,
                                style: BorderStyle.solid,
                                color: Color(0xff9D9D9D)),
                            top: BorderSide(
                                width: 1,
                                style: BorderStyle.solid,
                                color: Color(0xff9D9D9D)),
                            bottom: BorderSide(
                                width: 1,
                                style: BorderStyle.solid,
                                color: Color(0xff9D9D9D))),
                        columnWidths: <int, TableColumnWidth>{
                          0: FixedColumnWidth(screenWidth * 0.42),
                          1: FixedColumnWidth(screenWidth * 0.33),
                        },
                        defaultVerticalAlignment:
                            TableCellVerticalAlignment.middle,
                        children: <TableRow>[
                          TableRow(children: [
                            Container(
                              decoration:
                                  const BoxDecoration(color: Color(0xffE8E8E8)),
                              height: screenHeight * 0.04,
                              child: const Center(
                                child: Text(
                                  '교원, 직원',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w400,
                                      color: Color(0xff393A3C)),
                                ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.fromLTRB(
                                  screenWidth * 0.02, 0, screenWidth * 0.02, 0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  CircleRed(
                                    widthP: screenWidth * 0.05,
                                  ),
                                  CircleYellow(
                                    widthP: screenWidth * 0.05,
                                  ),
                                  CircleGreen(
                                    widthP: screenWidth * 0.05,
                                  ),
                                  CircleBlue(
                                    widthP: screenWidth * 0.05,
                                  ),
                                  CirclePurple(
                                    widthP: screenWidth * 0.05,
                                  ),
                                ],
                              ),
                            ),
                          ]),
                          TableRow(children: [
                            Container(
                              decoration:
                                  const BoxDecoration(color: Color(0xffE8E8E8)),
                              height: screenHeight * 0.07,
                              child: const Center(
                                child: Text(
                                  '시간강사, 연구원, 대학생\n조교, 계약직원',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w400,
                                      color: Color(0xff393A3C)),
                                ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.fromLTRB(
                                  screenWidth * 0.02, 0, screenWidth * 0.02, 0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  CircleEmpty(
                                    widthP: screenWidth * 0.05,
                                  ),
                                  CircleYellow(
                                    widthP: screenWidth * 0.05,
                                  ),
                                  CircleGreen(
                                    widthP: screenWidth * 0.05,
                                  ),
                                  CircleBlue(
                                    widthP: screenWidth * 0.05,
                                  ),
                                  CirclePurple(
                                    widthP: screenWidth * 0.05,
                                  ),
                                ],
                              ),
                            ),
                          ]),
                          TableRow(children: [
                            Container(
                              decoration:
                                  const BoxDecoration(color: Color(0xffE8E8E8)),
                              height: screenHeight * 0.07,
                              child: const Center(
                                child: Text(
                                  '일반차량, 방문차량, 납품처 및\n 단기계약/AS업체 차량',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w400,
                                      color: Color(0xff393A3C)),
                                ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.fromLTRB(
                                  screenWidth * 0.02, 0, screenWidth * 0.02, 0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  CircleEmpty(
                                    widthP: screenWidth * 0.05,
                                  ),
                                  CircleYellow(
                                    widthP: screenWidth * 0.05,
                                  ),
                                  CircleEmpty(
                                    widthP: screenWidth * 0.05,
                                  ),
                                  CircleEmpty(
                                    widthP: screenWidth * 0.05,
                                  ),
                                  CircleEmpty(
                                    widthP: screenWidth * 0.05,
                                  ),
                                ],
                              ),
                            ),
                          ]),
                          TableRow(children: [
                            Container(
                              decoration:
                                  const BoxDecoration(color: Color(0xffE8E8E8)),
                              height: screenHeight * 0.04,
                              child: const Center(
                                child: Text(
                                  '학부생, 학부졸업생',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w400,
                                      color: Color(0xff393A3C)),
                                ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.fromLTRB(
                                  screenWidth * 0.02, 0, screenWidth * 0.02, 0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  CircleEmpty(
                                    widthP: screenWidth * 0.05,
                                  ),
                                  CircleEmpty(
                                    widthP: screenWidth * 0.05,
                                  ),
                                  CircleEmpty(
                                    widthP: screenWidth * 0.05,
                                  ),
                                  CircleEmpty(
                                    widthP: screenWidth * 0.05,
                                  ),
                                  CirclePurple(
                                    widthP: screenWidth * 0.05,
                                  ),
                                ],
                              ),
                            ),
                          ]),
                          TableRow(children: [
                            Container(
                              decoration:
                                  const BoxDecoration(color: Color(0xffE8E8E8)),
                              height: screenHeight * 0.07,
                              child: const Center(
                                child: Text(
                                  '학교 차량, 공무 차량,\n장애 학생 지원 차량',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w400,
                                      color: Color(0xff393A3C)),
                                ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.fromLTRB(
                                  screenWidth * 0.02, 0, screenWidth * 0.02, 0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  CircleRed(
                                    widthP: screenWidth * 0.05,
                                  ),
                                  CircleYellow(
                                    widthP: screenWidth * 0.05,
                                  ),
                                  CircleGreen(
                                    widthP: screenWidth * 0.05,
                                  ),
                                  CircleBlue(
                                    widthP: screenWidth * 0.05,
                                  ),
                                  CirclePurple(
                                    widthP: screenWidth * 0.05,
                                  ),
                                ],
                              ),
                            ),
                          ]),
                        ],
                      ),
                      SizedBox(
                        height: screenHeight * 0.03,
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: screenHeight * 0.05,
              ),
              Card(
                shape: RoundedRectangleBorder(
                  //모서리를 둥글게 하기 위해 사용
                  borderRadius: BorderRadius.circular(16.0),
                ),
                elevation: 4.0,
                child: Container(
                  width: screenWidth * 0.85,
                  padding: EdgeInsets.fromLTRB(screenWidth * 0.05,
                      screenHeight * 0.03, screenWidth * 0.05, 0),
                  child: Column(
                    children: [
                      Row(
                        children: const [
                          Text(
                            '주차장 요금 정보',
                            style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w700,
                                color: Color(0xff393A3C)),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: screenHeight * 0.005,
                      ),
                      Row(
                        children: const [
                          Text(
                            '주차장 요금은 일반 요금과 정기권 요금으로 나뉘어요',
                            style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w400,
                                color: Color(0xff9D9EA0)),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: screenHeight * 0.03,
                      ),
                      Row(
                        children: const [
                          Text(
                            '일반요금',
                            style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w700,
                                color: Color(0xff393A3C)),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: screenHeight * 0.015,
                      ),
                      Table(
                        border: const TableBorder(
                            horizontalInside: BorderSide(
                                width: 1,
                                style: BorderStyle.solid,
                                color: Color(0xff9D9D9D)),
                            top: BorderSide(
                                width: 1,
                                style: BorderStyle.solid,
                                color: Color(0xff9D9D9D)),
                            bottom: BorderSide(
                                width: 1,
                                style: BorderStyle.solid,
                                color: Color(0xff9D9D9D))),
                        columnWidths: <int, TableColumnWidth>{
                          0: FixedColumnWidth(screenWidth * 0.3),
                          1: FixedColumnWidth(screenWidth * 0.45),
                        },
                        defaultVerticalAlignment:
                            TableCellVerticalAlignment.middle,
                        children: <TableRow>[
                          TableRow(children: [
                            Container(
                              decoration:
                                  const BoxDecoration(color: Color(0xffE8E8E8)),
                              height: screenHeight * 0.04,
                              child: const Center(
                                child: Text(
                                  '10분 미만',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w400,
                                      color: Color(0xff393A3C)),
                                ),
                              ),
                            ),
                            const Text(
                              '무료',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w400,
                                  color: Color(0xff393A3C)),
                            )
                          ]),
                          TableRow(children: [
                            Container(
                              decoration:
                                  const BoxDecoration(color: Color(0xffE8E8E8)),
                              height: screenHeight * 0.04,
                              child: const Center(
                                child: Text(
                                  '10분~29분',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w400,
                                      color: Color(0xff393A3C)),
                                ),
                              ),
                            ),
                            const Text(
                              '2,000원',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w400,
                                  color: Color(0xff393A3C)),
                            )
                          ]),
                          TableRow(children: [
                            Container(
                              decoration:
                                  const BoxDecoration(color: Color(0xffE8E8E8)),
                              height: screenHeight * 0.07,
                              child: const Center(
                                child: Text(
                                  '30분 이상',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w400,
                                      color: Color(0xff393A3C)),
                                ),
                              ),
                            ),
                            const Text(
                              '  2,000원 + 10분당 500원 추가\n  두시간 초과 시 10분당 1,000원',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w400,
                                  color: Color(0xff393A3C)),
                            )
                          ]),
                        ],
                      ),
                      SizedBox(
                        height: screenHeight * 0.007,
                      ),
                      Row(
                        children: const [
                          Text(
                            '※ 1일 최대 요금은 30,000원입니다',
                            style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w400,
                                color: Color(0xffB2B8BE)),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: screenHeight * 0.03,
                      ),
                      Row(
                        children: const [
                          Text(
                            '정기권',
                            style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w700,
                                color: Color(0xff393A3C)),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: screenHeight * 0.015,
                      ),
                      Table(
                        border: const TableBorder(
                            horizontalInside: BorderSide(
                                width: 1,
                                style: BorderStyle.solid,
                                color: Color(0xff9D9D9D)),
                            top: BorderSide(
                                width: 1,
                                style: BorderStyle.solid,
                                color: Color(0xff9D9D9D)),
                            bottom: BorderSide(
                                width: 1,
                                style: BorderStyle.solid,
                                color: Color(0xff9D9D9D))),
                        columnWidths: <int, TableColumnWidth>{
                          0: FixedColumnWidth(screenWidth * 0.3),
                          1: FixedColumnWidth(screenWidth * 0.45),
                        },
                        defaultVerticalAlignment:
                            TableCellVerticalAlignment.middle,
                        children: <TableRow>[
                          TableRow(children: [
                            Container(
                              decoration:
                                  const BoxDecoration(color: Color(0xffE8E8E8)),
                              height: screenHeight * 0.06,
                              child: const Center(
                                child: Text(
                                  '교원, 직원',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w400,
                                      color: Color(0xff393A3C)),
                                ),
                              ),
                            ),
                            const Text(
                              '10,000원 / 1개월\n50,000원 / 6개월',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w400,
                                  color: Color(0xff393A3C)),
                            )
                          ]),
                          TableRow(children: [
                            Container(
                                decoration: const BoxDecoration(
                                    color: Color(0xffE8E8E8)),
                                child: Column(
                                  children: [
                                    Container(
                                      width: screenWidth * 0.3,
                                      height: screenHeight * 0.04,
                                      decoration: const BoxDecoration(
                                          border: Border(
                                              bottom: BorderSide(
                                                  color: Color(0xff9D9D9D),
                                                  width: 1))),
                                      child: const Center(
                                        child: Text(
                                          '연구원',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              fontSize: 12,
                                              fontWeight: FontWeight.w400,
                                              color: Color(0xff393A3C)),
                                        ),
                                      ),
                                    ),
                                    Container(
                                      width: screenWidth * 0.3,
                                      height: screenHeight * 0.04,
                                      decoration: const BoxDecoration(
                                          border: Border(
                                              bottom: BorderSide(
                                                  color: Color(0xff9D9D9D),
                                                  width: 1))),
                                      child: const Center(
                                        child: Text(
                                          '대학원생',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              fontSize: 12,
                                              fontWeight: FontWeight.w400,
                                              color: Color(0xff393A3C)),
                                        ),
                                      ),
                                    ),
                                    Container(
                                      width: screenWidth * 0.3,
                                      height: screenHeight * 0.04,
                                      child: const Center(
                                        child: Text(
                                          '학부생',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              fontSize: 12,
                                              fontWeight: FontWeight.w400,
                                              color: Color(0xff393A3C)),
                                        ),
                                      ),
                                    ),
                                  ],
                                )),
                            const Text(
                              '10,000원 / 1개월\n40,000원 / 6개월',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w400,
                                  color: Color(0xff393A3C)),
                            )
                          ]),
                          TableRow(children: [
                            Container(
                              decoration:
                                  const BoxDecoration(color: Color(0xffE8E8E8)),
                              height: screenHeight * 0.06,
                              child: const Center(
                                child: Text(
                                  '상근용역업체 직원',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w400,
                                      color: Color(0xff393A3C)),
                                ),
                              ),
                            ),
                            const Text(
                              '10,000원 / 1개월\n50,000원 / 6개월',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w400,
                                  color: Color(0xff393A3C)),
                            )
                          ]),
                          TableRow(children: [
                            Container(
                              decoration:
                                  const BoxDecoration(color: Color(0xffE8E8E8)),
                              height: screenHeight * 0.07,
                              child: const Center(
                                child: Text(
                                  '기타',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w400,
                                      color: Color(0xff393A3C)),
                                ),
                              ),
                            ),
                            const Text(
                              '20,000원 / 1개월',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w400,
                                  color: Color(0xff393A3C)),
                            )
                          ]),
                        ],
                      ),
                      SizedBox(
                        height: screenHeight * 0.03,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => TestScreen()),
          );
        },
        child: Icon(Icons.add),
        heroTag: 'test',
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}
