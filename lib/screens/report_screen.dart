import 'package:flutter/material.dart';
import 'package:parkingo/screens/main_screen.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';

class ReportScreen extends StatefulWidget {
  const ReportScreen({Key? key}) : super(key: key);

  @override
  State<ReportScreen> createState() => _ReportScreenState();
}

class _ReportScreenState extends State<ReportScreen> {
  final _formKey = GlobalKey<FormState>();
  final _reportController = TextEditingController();

  @override
  void dispose() {
    _reportController.dispose();
    super.dispose();
  }

  String _getBody(String report) {
    String body = "";
    body += "==============\n";
    body += "아래 내용을 함께 보내주시면 큰 도움이 됩니다 \n";
    body += report;
    body += "\n";
    body += "==============\n";
    return body;
  }


  void _sendEmail(String re) async {

    String body = await _getBody(re);
    print('\n\n------- 전송하기-----------\n');
    print(body);
    final Email email = Email(
      body: body,
      subject: '[ParKingo 오류 문의]',
      recipients: ['ddi03231@gmail.com'],
      cc: [],
      bcc: [],
      attachmentPaths: [],
      isHTML: false,
    );

    try {
      await FlutterEmailSender.send(email);
    } catch (error) {
      String title = "기본 메일 앱을 사용할 수 없기 때문에 앱에서 바로 문의를 전송하기 어려운 상황입니다.\n\n아래 이메일로 연락주시면 친절하게 답변해드릴게요 :)\n\nonionfamily.official@gmail.com";
      String message = "";
      print(title);
      print(error);
      //_showErrorAlert(title: title, message: message);
    }
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
                          MaterialPageRoute(builder: (context) => MainScreen()),
                        );
                      },
                      icon: Icon(
                        Icons.arrow_back_ios_new,
                        size: screenWidth * 0.07,
                        color: Color(0xff393A3C),
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
                    '빈자리에 대해\n잘못된정보를 발견하셨나요?',
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
                    '빈자리에 대해 잘못된 정보를 발경하신 경우\n(ex. 빈자리가 있다고 뜨는데 아무리 돌아봐도 없다 등)\n저희에게 알려주세요! 빠른 확인 후 답변 드리겠습니다.',
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
              Card(
                shape: RoundedRectangleBorder(
                  //모서리를 둥글게 하기 위해 사용
                  borderRadius: BorderRadius.circular(16.0),
                ),
                elevation: 4.0,
                child: Container(
                  width: screenWidth*0.9,
                  padding: const EdgeInsets.all(8.0),
                  child: Form(
                    key: _formKey,
                    child: TextFormField(
                      controller: _reportController,
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        hintText: '이곳에 발견하신 문제점을 적어주세요.',
                        hintStyle: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w400,
                            color: Color(0xffB2B8BE)),
                      ),
                      maxLines: 15,
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: screenHeight * 0.02,
              ),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState?.validate() == false){
                    return;
                  }
                  final reportText = _reportController.text;
                  _sendEmail(reportText);
                },
                style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16.0),
                    ),
                    fixedSize: Size(screenWidth * 0.9, screenHeight * 0.05)),
                child: Text('제출하기'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
