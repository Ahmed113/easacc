import 'package:easacc/helper/show-snack-bar.dart';
import 'package:easacc/view/login/cubit/login-cubit.dart';
import 'package:easacc/view/login/cubit/login-state.dart';
import 'package:easacc/view/setting/cubit/setting-cubit.dart';
import 'package:easacc/view/setting/setting-page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

import '../../components/custom-button.dart';

class LoginPage extends StatelessWidget {
  LoginPage({super.key});

  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    // context.read<SettingCubit>().initBluetooth();
    return BlocListener<SocialLoginCubit, SocialLoginState>(
      listener: (BuildContext context, SocialLoginState state) {
        if (state is GoogleLoginLoading) {
          isLoading = true;
        } else if (state is GoogleLoginSuccess) {
          isLoading = true;
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => SettingPage(
                user: state.user,
              ),
            ),
          );
        } else if (state is GoogleLoginFailed) {
          showSnackBar(context, state.msg);
        } else if (state is FBLoginLoading) {
          isLoading = true;
        } else if (state is FBLoginSuccess) {
          // isLoading = true;
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => SettingPage(
                userData: state.user,
              ),
            ),
          );
        }
      },
      child: ModalProgressHUD(
        inAsyncCall: isLoading,
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          body: Container(
            padding:
                const EdgeInsets.only(top: 50, left: 20, right: 20, bottom: 8),
            decoration: const BoxDecoration(
                image: DecorationImage(
                    image: AssetImage("assets/backgroundImg8.jpg"),
                    fit: BoxFit.cover)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Text(
                    "Welcome Back, Sign In!",
                    style: TextStyle(color: Colors.white, fontSize: 25.sp),
                  ),
                ),
                const Spacer(
                  flex: 1,
                ),
                CustomButton(
                  btnText: "Continue with Google",
                  side: BorderSide(
                      color: const Color(0xff5A4AAE).withOpacity(.5), width: 2),
                  image: const AssetImage("assets/google.png"),
                  onPressed: () {
                    BlocProvider.of<SocialLoginCubit>(context)
                        .logInWithGoogle();
                  },
                ),
                SizedBox(
                  height: 10.h,
                ),
                CustomButton(
                  btnText: "Continue with Facebook",
                  side: BorderSide(
                      color: const Color(0xff5A4AAE).withOpacity(.5), width: 2),
                  image: const AssetImage("assets/facebook.png"),
                  onPressed: () {
                    BlocProvider.of<SocialLoginCubit>(context).loginWithFB();
                  },
                ),
                const Spacer(
                  flex: 2,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
