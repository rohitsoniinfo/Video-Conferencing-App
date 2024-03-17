import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

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
                  borderRadius: leftBorder,
                boxShadow: const  [
                  BoxShadow(blurRadius: 10)
                ]
              ),
            )),
        Align(
            alignment: Alignment.topRight,
            child: Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                  color: isTop == true ? Colors.red : Colors.blue,
                  borderRadius: rightBorder,
                  boxShadow: const [
                    BoxShadow(blurRadius: 10)
                  ]
              ),

            )),
      ],
    );
  }

  Widget customTextField(String shownText, TextEditingController controller, IconData prefixIcon,List<TextInputFormatter> inputformatters) {
    return TextField(
      inputFormatters: inputformatters,
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
