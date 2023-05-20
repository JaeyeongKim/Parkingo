import 'package:flutter/material.dart';

class ParkingLot extends StatefulWidget {
  const ParkingLot({Key? key}) : super(key: key);

  @override
  State<ParkingLot> createState() => _ParkingLotState();
}

class _ParkingLotState extends State<ParkingLot> {
  void _showDialog(){
    var screenHeight = MediaQuery.of(context).size.height;
    var screenWidth = MediaQuery.of(context).size.width;
    showDialog(
        context: context,
        builder: (BuildContext ctx){
          return AlertDialog(
            content: InteractiveViewer(
              child: Center(
                child: Container(
                  height: screenHeight*0.3,
                  width:screenWidth,
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      fit: BoxFit.fill,
                      image: AssetImage("./assets/parking_lot.png"), // 배경 이미지
                    ),
                  ),
                  child: Scaffold(
                    backgroundColor: Colors.transparent, // 배경색을 투명으로 설정
                  ),
                ),
              ),
            ),
          );
        }
    );
  }


  @override
  Widget build(BuildContext context) {
    var screenHeight = MediaQuery.of(context).size.height;
    var screenWidth = MediaQuery.of(context).size.width;
    return Card(
      clipBehavior: Clip.hardEdge,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 5,
      child: Container(
        height: screenHeight * 0.25,
        decoration: const BoxDecoration(
          image: DecorationImage(
            fit: BoxFit.fill,
            image: AssetImage("./assets/parking_lot.png"), // 배경 이미지
          ),
        ),
        child: Scaffold(
          backgroundColor: Colors.transparent, // 배경색을 투명으로 설정
          floatingActionButton: SizedBox(
              height: screenHeight * 0.03,
              width: screenHeight * 0.03,
              child: FloatingActionButton(
                onPressed: () {
                  _showDialog();
                },
                backgroundColor: const Color(0xffE6E6E6).withOpacity(0.5),
                shape:  ContinuousRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: const Icon(Icons.search, color: Color(0xff767676)),
              )),
        ),
      ),
    );
  }
}
