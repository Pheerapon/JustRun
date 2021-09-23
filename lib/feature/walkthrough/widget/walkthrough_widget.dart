import 'package:flutter/material.dart';
import 'package:flutter_habit_run/app/widget_support.dart';
import 'package:flutter_habit_run/common/constant/colors.dart';

class WalkThroughWidget {
  static Widget createIndicator({int currentImage, int lengthImage}) {
    return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(lengthImage, (index) {
          return AnimatedContainer(
              duration: const Duration(milliseconds: 500),
              height: index == currentImage ? 8 : 6,
              width: index == currentImage ? 8 : 6,
              margin: const EdgeInsets.symmetric(horizontal: 6),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: index == currentImage
                      ? ultramarineBlue
                      : indicator.withOpacity(0.3)));
        }));
  }

  static Widget createFigure(
      {String gender, double height, bool choose = true, String image}) {
    return Stack(
      alignment: Alignment.bottomCenter,
      clipBehavior: Clip.none,
      children: [
        Container(
          height: height / 203 * 60,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(24),
              color: choose ? colorGenderSelected : colorGender),
        ),
        choose
            ? Positioned(
                bottom: 60,
                child: ClipOval(
                  child: Container(
                    height: 18,
                    width: 74,
                    color: black.withOpacity(0.1),
                  ),
                ))
            : const SizedBox(),
        Positioned(
            bottom: 52,
            child: Image.asset(
              image,
              height: height / 29 * 12,
            )),
        Positioned(
          bottom: 14,
          child: Text(
            gender,
            style: AppWidget.boldTextFieldStyle(
                fontSize: 20,
                height: 30,
                color: choose ? white : textGenderUnSelected),
          ),
        ),
      ],
    );
  }

  static Widget createTextField(
      {BuildContext context,
      TextEditingController controller,
      FocusNode focusNode,
      FocusNode focusNext,
      bool autoFocus = false,
      String suffixText,
      String title}) {
    UnderlineInputBorder createInputDecoration() {
      return UnderlineInputBorder(borderSide: BorderSide(color: colorGender));
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: AppWidget.boldTextFieldStyle(
              fontSize: 18, color: ultramarineBlue, height: 28),
        ),
        TextFormField(
            controller: controller,
            focusNode: focusNode,
            autofocus: autoFocus,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            onFieldSubmitted: (term) {
              focusNode.unfocus();
              FocusScope.of(context).requestFocus(focusNext);
            },
            style: AppWidget.boldTextFieldStyle(
                color: Theme.of(context).color9,
                fontSize: 32,
                height: 37.5,
                fontFamily: 'Futura',
                fontStyle: FontStyle.italic),
            decoration: InputDecoration(
              suffixText: suffixText,
              suffixStyle: AppWidget.boldTextFieldStyle(
                  fontSize: 18, color: Theme.of(context).color9, height: 28),
              focusedBorder: createInputDecoration(),
              enabledBorder: createInputDecoration(),
            )),
      ],
    );
  }
}
