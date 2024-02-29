import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomTextField extends StatelessWidget {
  CustomTextField({
    super.key,
    TextEditingController? textEditingController,
    this.onSubmitted, this.image, this.suffixIconColor,
    this.hintText, this.fillColor, this.suffixIcon,
    this.prefixIcon, this.onPrefixIconPressed
  }) : _textEditingController = textEditingController;

  final TextEditingController? _textEditingController;
  void Function(String)? onSubmitted;
  ImageProvider<Object>? image;
  Color? suffixIconColor;
  String? hintText;
  Color? fillColor;
  IconData? suffixIcon;
  IconData? prefixIcon;
  void Function()? onPrefixIconPressed;


  @override
  Widget build(BuildContext context) {
    return TextField(
      cursorColor: Colors.blueGrey,
      controller: _textEditingController,
      onSubmitted: onSubmitted,
      decoration: InputDecoration(
        contentPadding:
        const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        suffixIcon: image != null? ImageIcon(
           image,
          color: suffixIconColor,
        ): IconButton(
          icon: Icon(suffixIcon, color: const Color(0xffE76402),),
          onPressed: () {
            _textEditingController?.clear();
          },
        ),
        prefixIcon: IconButton(
            icon: Icon(prefixIcon,color: const Color(0xffE76402),),
          onPressed: onPrefixIconPressed,),
        hintText: hintText,
        hintStyle: TextStyle(
            fontSize: 19.sp, color: Colors.blueGrey.withOpacity(.8)),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: const BorderSide(
            color: Color(0xffE76402),
            width: 2.0,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide:
          const BorderSide(color: Color(0xffE7ECDF), width: 2.0),
        ),
        filled: true,
        fillColor: fillColor,
      ),
      style: TextStyle(fontSize: 19.sp),
    );
  }
}