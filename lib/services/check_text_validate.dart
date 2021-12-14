import 'package:flutter/material.dart';

class CheckTextValidate {
  String? validateStudentNum(FocusNode focusNode, String value){
    if(value.isEmpty){
      focusNode.requestFocus();
      return '값이 비었습니다.';
    }else {
      String pattern = r'^([1-3]{1})([0-9]{1})([0-9]{1})([0-9]{1})$';
      RegExp regExp = new RegExp(pattern);
      if(!regExp.hasMatch(value)){
        focusNode.requestFocus();
        return '잘못된 \n학번입니다.';
      } else{
        return null;
      }
    }
  }

  String? validateName(FocusNode focusNode, String value){
    if(value.isEmpty){
      focusNode.requestFocus();
      return '값이 비었습니다.';
    }else {
      String pattern = r'^([가-힣]{1})([가-힣]{1})([가-힣]{0,1})([가-힣\s]{0,1})([가-힣\s]{0,1})([가-힣\s]{0,1})([가-힣\s]{0,1})$';
      RegExp regExp = new RegExp(pattern);
      if(!regExp.hasMatch(value)){
        focusNode.requestFocus();
        return '2~7자 사이로 \n입력하세요.';
      } else{
        return null;
      }
    }
  }

}