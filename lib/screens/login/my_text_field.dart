import 'package:flutter/material.dart';

class MyTextField {
  TextFormField getCustomEditTextArea({
    required String labelValue,
    required String hintValue,
    bool validation = false,
    required final TextEditingController controller,
    TextInputType keyboardType = TextInputType.text,
    required String validationErrorMsg,
    // String? password,
  }) {
    TextFormField textFormField = TextFormField(
      keyboardType: keyboardType,
      controller: controller,
      validator: (value) {
        if (labelValue == 'UserName' && value!.length < 6) {
          return validationErrorMsg;
        }
        // if (labelValue == 'Email' && !EmailValidator.validate(value!)) {
        //   return validationErrorMsg;
        // }
        if (labelValue == 'Password' && value!.length < 8) {
          return validationErrorMsg;
        }
        // if (labelValue == 'Confirm Password' && !(value == password)) {

        //   return validationErrorMsg;
        // }
        return null;
      },
      obscureText: labelValue == 'Password' || labelValue == 'Confirm Password',
      decoration: InputDecoration(
          labelText: labelValue,
          hintText: hintValue,
          labelStyle: const TextStyle(
            color: Color.fromRGBO(173, 183, 192, 1),
            fontWeight: FontWeight.bold,
          ),
          enabledBorder: const UnderlineInputBorder(
            borderSide: BorderSide(color: Color.fromRGBO(173, 183, 192, 1)),
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5.0),
          )),
    );
    return textFormField;
  }
}
