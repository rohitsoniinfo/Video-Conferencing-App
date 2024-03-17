import 'package:flutter/services.dart';

class Validator
{

  List<TextInputFormatter> nameFormatter = [FilteringTextInputFormatter.allow(RegExp(r'^[A-Za-z ]+$')),];
  List<TextInputFormatter> contactFormatter = [ FilteringTextInputFormatter.allow(RegExp(r"[+0-9 -]"))];
  List<TextInputFormatter> addressFormatter = [ FilteringTextInputFormatter.allow(RegExp(r'^[A-Za-z ]+$'))];
  List<TextInputFormatter> passwordFormatter =  [FilteringTextInputFormatter.allow(RegExp(r"[a-zA-Z0-9.!@#\$%&'*+-/=?^_`{|}~]")),];

  String? emailValidator(String? email){
    RegExp emailRegex = RegExp(r'^[\w\.-]+@[\w-]+\.\w{2,3}(\.\w{2,3})?$');
    final isEmailValid = emailRegex.hasMatch(email ?? '');
    if(!isEmailValid)
    {
      return 'Please enter a valid email';
    }
    return null;
  }

  String? nameValidator(String? name)
  {
    return name!.length < 3 ? "name is too short." : null;
  }

  String? contactValidator(String? contact)
  {
    return  contact!.length<10 ? "Please enter a valid contact number" : null;
  }

  String? addressValidator(String? address)
  {
    return address!.length<4 ? "Please enter a valid address" : null;
  }

  String? genderValidator(String? gender)
  {
    return gender == null ? "Please select your gender" : null;
  }

  String? passwordValidator(String? password)
  {
    return password!.length<6 ? "password length must be least 6." : null;
  }

}