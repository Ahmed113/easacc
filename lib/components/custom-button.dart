import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomButton extends StatelessWidget {
  CustomButton({
    super.key,
    this.side, required this.btnText,
    this.backgroundColor, this.image,
    this.onPressed
  });
  BorderSide? side;
  Color? backgroundColor;
  final String btnText;
  ImageProvider<Object>? image;
  void Function()? onPressed;
  @override
  Widget build(BuildContext context) {
    return Center(
      child: OutlinedButton(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
            alignment: Alignment.center,
            fixedSize: Size(300.w ,40.h),
            textStyle: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold),
            foregroundColor: Colors.white70,
            side: side,
            // side: BorderSide(color: Colors.white70, width: 2),
            backgroundColor: backgroundColor,
            shape: const StadiumBorder(),
          ),
          child: image == null? Text(btnText):
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                  height: 20.h,
                  child: Image(image: image!)),
              SizedBox(
                width: 10.w,
              ),
              Text(btnText),
            ],
          )
      ),
    );
  }
}