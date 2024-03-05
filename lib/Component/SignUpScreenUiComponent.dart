import 'package:flutter/material.dart';


  OutlineInputBorder inputBorder() {
    //return type is OutlineInputBorder
    return const OutlineInputBorder(
        //Outline border type for TextFeild
        borderRadius: BorderRadius.all(Radius.circular(20)),
        borderSide: BorderSide(
          color: Colors.black,
          width: 3,
        ));
  }

  OutlineInputBorder focusBorder() {
    return const OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(20)),
        borderSide: BorderSide(
          color: Colors.black,
          width: 3,
        ));
  }

  Widget TopBottomDesign(bool isTop, BorderRadiusGeometry leftBorder,
      BorderRadiusGeometry rightBorder) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Align(
            alignment: Alignment.topLeft,
            child: Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                  color: isTop == true ? Colors.blue : Colors.red,
                  borderRadius: leftBorder),
            )),
        Align(
            alignment: Alignment.topRight,
            child: Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                  color: isTop == true ? Colors.red : Colors.blue,
                  borderRadius: rightBorder),
            )),
      ],
    );
  }

  Widget customTextField(String shownText, TextEditingController controller, IconData prefixIcon) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: shownText,
        labelStyle: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        enabledBorder: inputBorder(),
        focusedBorder: focusBorder(),
        prefixIcon: Icon(
          prefixIcon,
          color: Colors.black,
        ),
      ),
    );
  }
