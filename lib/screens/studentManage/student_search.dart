import 'package:dalgeurak/controllers/meal_controller.dart';
import 'package:dalgeurak/screens/widget_reference.dart';
import 'package:dimigoin_flutter_plugin/dimigoin_flutter_plugin.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:korea_regexp/korea_regexp.dart';

import '../../themes/color_theme.dart';
import '../../themes/text_theme.dart';

class StudentSearch extends SearchDelegate {
  late List<DimigoinUser> _studentList;
  late WidgetReference _widgetReference;
  late double _width, _height;

  @override
  String get searchFieldLabel => '학번, 이름으로 검색';

  @override
  InputDecorationTheme get searchFieldDecorationTheme => InputDecorationTheme(
    hintStyle: studentSearchFieldLabel.copyWith(color: grayTwelve),
    labelStyle: studentSearchFieldLabel, //TODO 오류인지 뭔지는 모르겠는데 스타일이 정상적으로 적용되지 않음. 추후 확인필요.
    border: InputBorder.none,
  );

  @override
  List<Widget> buildActions(BuildContext context) {
    return [];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back_ios_rounded, color: dalgeurakGrayFour),
      onPressed: () {
        Navigator.pop(context);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return Container();
  }

  @override
  ThemeData appBarTheme(BuildContext context) {
    // TODO: implement appBarTheme
    return super.appBarTheme(context).copyWith(
      appBarTheme: super.appBarTheme(context).appBarTheme.copyWith(
        elevation: 0.4,
      )
    );
  }


  @override
  Widget buildSuggestions(BuildContext context) {
    _height = MediaQuery.of(context).size.height;
    _width = MediaQuery.of(context).size.width;

    MealController _mealController = Get.find<MealController>();
    _widgetReference = WidgetReference(width: _width, height: _height, context: context);


    return FutureBuilder(
        future: _mealController.getStudentList(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            _studentList = List<DimigoinUser>.from(snapshot.data);

            dynamic resultWidget;

            if (query.isNotEmpty) {
              List<DimigoinUser> suggestionList = changeSearchTerm(query);
              
              resultWidget = ListView.builder(
                itemCount: suggestionList.length,
                itemBuilder: (context, index) {
                  DimigoinUser selectStudent = suggestionList[index];

                  return ListTile(
                    title: Text(selectStudent.studentId.toString(), style: studentSearchListTileStudentId),
                    subtitle: Text(selectStudent.name!, style: studentSearchListTileStudentName),
                    leading: SizedBox(
                      width: _width * 0.1,
                      height: _width * 0.1,
                      child: Column(
                        children: [
                          SizedBox(height: _height * 0.0115),
                          SvgPicture.asset('assets/images/icons/user_select.svg', width: _width * 0.07),
                        ],
                      ),
                    ),
                    trailing: GestureDetector(
                      child: Container(
                        width: _width * 0.15,
                        height: _height * 0.045,
                        decoration: BoxDecoration(
                            color: dalgeurakGrayOne,
                            borderRadius: BorderRadius.circular(5)
                        ),
                        child: Center(child: Text("관리", style: studentSearchListTileBtn)),
                      ),
                      onTap: () => StudentManageWidgetReference(widgetReference: _widgetReference, student: selectStudent).showStudentManageBottomSheet()
                    ),
                  );
                },
              );
            } else {
              resultWidget = Stack(
                alignment: Alignment.topCenter,
                children: [
                  SizedBox(width: _width, height: _height),
                  Column(
                    children: [
                      SizedBox(height: _height * 0.1),
                      Text(
                        "검색어를 입력해주세요",
                        style: studentSearchQueryEmptyTitle,
                      ),
                      SizedBox(height: _height * 0.02),
                      Text(
                        "학생 이름(유도희 or ㅇㄷㅎ)을 직접 입력하거나,\n각 학생의 학번(2321)으로 찾을 수도 있어요",
                        style: studentSearchQueryEmptySubTitle,
                        textAlign: TextAlign.center,
                      )
                    ],
                  )
                ],
              );
            }


            return Scaffold(
              backgroundColor: Colors.white,
              body: resultWidget,
            );
          } else if (snapshot.hasError) { //데이터를 정상적으로 불러오지 못했을 때
            return Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(width: _width, height: _height * 0.4),
                Center(child: Text("데이터를 정상적으로 불러오지 못했습니다. \n다시 시도해 주세요.", textAlign: TextAlign.center)),
              ],
            );
          } else { //데이터를 불러오는 중
            return Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(width: _width, height: _height * 0.4),
                Center(child: CircularProgressIndicator()),
              ],
            );
          }
        }
    );
  }

  changeSearchTerm(String text) {
    RegExp regExp = getRegExp(
        text,
        RegExpOptions(
          initialSearch: true,
          startsWith: false,
          endsWith: false,
          fuzzy: false,
          ignoreSpace: false,
          ignoreCase: false,
        )
    );

    List<DimigoinUser> result = [];
    result.addAll(_studentList.where((element) => regExp.hasMatch(element.name as String)).toList());
    result.addAll(_studentList.where((element) => regExp.hasMatch(element.studentId.toString())).toList());


    return result;
  }
}