import 'package:dalgeurak/themes/color_theme.dart';
import 'package:dalgeurak/themes/text_theme.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';

class ApplicationInfo extends StatelessWidget {
  ApplicationInfo({Key? key}) : super(key: key);

  late double _height, _width;

  @override
  Widget build(BuildContext context) {
    _height = MediaQuery.of(context).size.height;
    _width = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: blueThree,
      body: Center(
          child: Stack(
            alignment: Alignment.center,
            children: [
              Positioned(
                  top: _height * 0.06,
                  left: _width * 0.025,
                  child: GestureDetector(
                    onTap: () => Get.back(),
                    child: Icon(
                      Icons.chevron_left,
                      size: _width * 0.12,
                    ),
                  )
              ),
              Positioned(
                top: _height * 0.075,
                child: Text("어플리케이션 정보", style: myProfileTitle),
              ),
              Positioned(
                top: _height * 0.18,
                child: Row(
                  children: [
                    Image.asset(
                      "assets/images/logo.png",
                      width: _width * 0.2,
                      height: _width * 0.2,
                    ),
                    SizedBox(width: _width * 0.05),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("달그락", style: appInfo.copyWith(fontSize: 25, fontWeight: FontWeight.w700)),
                        SizedBox(height: _height * 0.015),
                        Row(
                          children: [
                            Text("현재 설치된 버전: ", style: appInfo.copyWith(fontWeight: FontWeight.w400)),
                            FutureBuilder(
                                future: getAppVersion(),
                                builder: (BuildContext context, AsyncSnapshot snapshot) {
                                  if (snapshot.hasData) {
                                    return Text(snapshot.data, style: appInfo.copyWith(fontWeight: FontWeight.w400));
                                  } else if (snapshot.hasError) { //데이터를 정상적으로 불러오지 못했을 때
                                    return Stack(
                                      alignment: Alignment.center,
                                      children: [
                                        SizedBox(width: _width, height: _height * 0.4),
                                        Center(child: Text("다시 시도해 주세요.", textAlign: TextAlign.center)),
                                      ],
                                    );
                                  } else { //데이터를 불러오는 중
                                    return Stack(
                                      alignment: Alignment.center,
                                      children: [
                                        SizedBox(width: _width * 0.1, height: _height * 0.03),
                                        Center(child: CircularProgressIndicator()),
                                      ],
                                    );
                                  }
                                }
                            )
                          ],
                        )
                      ],
                    )
                  ],
                )
              ),
              Positioned(
                  bottom: 0,
                  child: Container(
                    width: _width,
                    height: _height * 0.65,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(topLeft: Radius.circular(13), topRight: Radius.circular(13)),
                        color: Colors.white
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        SizedBox(height: _height * 0.15),
                        Text.rich(
                          TextSpan(
                            children: [
                              TextSpan(
                                style: appInfo,
                                text: "본 어플리케이션 달그락은 \n한국디지털미디어고등학교 동아리",
                              ),
                              TextSpan(
                                style: appInfo.copyWith(color: Colors.lightBlueAccent, fontWeight: FontWeight.w700),
                                text: " 루나 ",
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () async {
                                    String url = 'https://luna.codes';
                                    _launchURL(url);
                                  },
                              ),
                              TextSpan(
                                style: appInfo,
                                text: "소속 \n20기 ",
                              ),
                              TextSpan(
                                style: appInfo.copyWith(
                                  color: Colors.lightBlueAccent,
                                ),
                                text: "웹프로그래밍과 유도희",
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () async {
                                    String url = 'http://dohui-portfolio.kro.kr';
                                    _launchURL(url);
                                  },
                              ),
                              TextSpan(
                                style: appInfo,
                                text: "와 \n",
                              ),
                              TextSpan(
                                style: appInfo.copyWith(
                                  color: Colors.lightBlueAccent,
                                ),
                                text: "이비즈니스과 라윤지",
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () async {
                                    String url = 'https://bit.ly/3roBF9W';
                                    _launchURL(url);
                                  },
                              ),
                              TextSpan(
                                style: appInfo,
                                text: "가 제작하였습니다.",
                              ),
                            ],
                          ),
                          textAlign: TextAlign.center,
                          style: appInfo,
                        ),
                        SizedBox(height: _height * 0.07),
                        Text.rich(
                          TextSpan(
                            children: [
                              TextSpan(
                                style: appInfo,
                                text: "본 서비스를 로그인하여 사용하는 것은\n",
                              ),
                              TextSpan(
                                style: appInfo.copyWith(
                                  color: Colors.lightBlueAccent,
                                ),
                                text: "개인정보처리약관",
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () async {
                                    String url = 'https://bit.ly/2XPgDq9';
                                    _launchURL(url);
                                  },
                              ),
                              TextSpan(
                                style: appInfo,
                                text: "과 ",
                              ),
                              TextSpan(
                                style: appInfo.copyWith(
                                  color: Colors.lightBlueAccent,
                                ),
                                text: "이용약관",
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () async {
                                    String url = 'https://bit.ly/3rR3CHz';
                                    _launchURL(url);
                                  },
                              ),
                              TextSpan(
                                style: appInfo,
                                text: "에\n동의하는 것으로 간주합니다.",
                              ),
                            ],
                          ),
                          textAlign: TextAlign.center,
                          style: appInfo,
                        ),
                      ],
                    ),
                  )
              ),
              Positioned(
                bottom: _height * 0.075,
                child: Text("※ 파란색 글씨를 누르시면 웹사이트로 연결됩니다.", style: appInfo.copyWith(color: grayOne)),
              ),
            ],
          )
      ),
    );
  }

  void _launchURL(String _url) async =>
      await canLaunch(_url) ? await launch(_url) : throw 'Could not launch $_url';

  getAppVersion() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();

    return packageInfo.version;
  }
}