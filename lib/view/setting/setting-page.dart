import 'package:easacc/view/login/login-page.dart';
import 'package:easacc/view/setting/cubit/setting-cubit.dart';
import 'package:easacc/view/setting/cubit/setting-state.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../components/custom-text-field.dart';
import '../../helper/show-snack-bar.dart';
import '../login/cubit/login-cubit.dart';
import '../web-view-page/webView-page.dart';

class SettingPage extends StatelessWidget {
  SettingPage({
    super.key,
    this.user,
    this.userData,
  });

  final User? user;
  final Map? userData;

  final TextEditingController searchController = TextEditingController();

  List<String> blueDevices = List.empty(growable: true);

  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        padding: const EdgeInsets.only(top: 50, left: 20, right: 20, bottom: 8),
        decoration: const BoxDecoration(
            image: DecorationImage(
                image: AssetImage("assets/backgroundImg8.jpg"),
                fit: BoxFit.cover)),
        child: Column(
          children: [
            Center(
              child: user != null
                  ? Text(
                      "Hello, ${user?.displayName!} ",
                      style: TextStyle(color: Colors.white, fontSize: 25.sp),
                    )
                  : Text(
                      "Hello, ${userData?["name"]!} ",
                      style: TextStyle(color: Colors.white, fontSize: 25.sp),
                    ),
            ),
            SizedBox(
              height: 15.h,
            ),
            Text(
              "Web Search",
              style: TextStyle(
                  color: Colors.white38,
                  fontSize: 20.sp,
                  fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: 8.h,
            ),
            CustomTextField(
              textEditingController: searchController,
              fillColor: Colors.white12,
              onSubmitted: (url) {
                onSubmitHandle(context, url);
              },
              onPrefixIconPressed: () {
                onSubmitHandle(context, searchController.text);
              },
              prefixIcon: Icons.search,
              suffixIcon: Icons.clear,
            ),
            SizedBox(
              height: 10.h,
            ),
            const Divider(
              color: Colors.black12,
              thickness: 2,
            ),
            SizedBox(
              height: 10.h,
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF143D59),
                textStyle: const TextStyle(
                  color: Colors.deepOrangeAccent,
                ),
              ),
              onPressed: () async {
                // _initBluetooth();
                // _startScan();
                BuildContext currentContext = context;
                BlocProvider.of<SettingCubit>(currentContext).disposeBlueDevices();
                BlocProvider.of<SettingCubit>(currentContext).initBluetooth();
                BlocProvider.of<SettingCubit>(currentContext).getWifiScannedResults();
              },
              child: const Text("Find Near Devices"),
            ),
            SizedBox(
              width: 1.w,
            ),
            BlocBuilder<SettingCubit, SettingState>(
              builder: (BuildContext context, SettingState state) {
                if (state is SettingInitialState) {
                  // print("$state");
                  return DropdownButton<String>(
                    items: null,
                    onChanged: (String? value) {},
                  );
                }
                if (state is BluSettingStateLoading) {
                  // print("$state");
                  return Column(
                    children: [
                      const CircularProgressIndicator(),
                      SizedBox(
                        height: 2.h,
                      ),
                      DropdownButton<String>(
                        items: null,
                        onChanged: (String? value) {},
                      ),
                    ],
                  );
                }
                if (state is BluSettingStateSuccess) {
                  return DropdownButton<String>(
                    items: state.combinedDevices?.map((String value) {
                      // print("{value}");
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    value: state.combinedDevices?[0],
                    onChanged: (String? value) {},
                  );
                  // }
                }
                if (state is BluSettingStateFailed) {
                  // print("${state.msg}");
                  return Column(
                    children: [
                      Text("${state.msg}",style:const TextStyle(color: Colors.white,)),
                      SizedBox(
                        height: 10.h,
                      ),
                      DropdownButton<String>(
                        items: null,
                        onChanged: (String? value) {},
                      ),
                    ],
                  );
                }
                if (state is WifiSettingStateSuccess) {
                  // print("${state.wifiDevices?[1].ssid}");
                  return DropdownButton<String>(
                    items: state.combinedDevices?.map((String value) {
                      // print("${value}");
                      return DropdownMenuItem<String>(
                        value: state.combinedDevices?[0],
                        child: Text(value),
                      );
                    }).toList(),
                    onChanged: (String? value) {},
                  );
                }
                if (state is WifiSettingStateLoading) {
                  // print(" $state");
                  return Column(
                    children: [
                      const CircularProgressIndicator(),
                      SizedBox(
                        height: 15.h,
                      ),
                      DropdownButton<String>(
                        items: null,
                        onChanged: (String? value) {},
                      ),
                    ],
                  );
                }
                if (state is WifiSettingStateFailed) {
                  return Column(
                    children: [
                      Text("${state.msg}",style:const TextStyle(color: Colors.white,)),
                      SizedBox(
                        height: 15.h,
                      ),
                      DropdownButton<String>(
                        items: null,
                        onChanged: (String? value) {},
                      ),
                    ],
                  );
                } else {
                  return DropdownButton<String>(
                    items: const [
                      DropdownMenuItem<String>(
                        value: "Scan to find Devices!",
                        child: Text("Scan to find Devices!"),
                      )
                    ],
                    onChanged: (String? value) {},
                  );
                }
              },
            ),
            const Spacer(
              flex: 1,
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF143D59),
                textStyle: const TextStyle(
                  color: Colors.deepOrangeAccent,
                ),
              ),
              onPressed: () {
                user != null
                    ? context.read<SocialLoginCubit>().googleSignOut()
                    : context.read<SocialLoginCubit>().fbSignOut();
                Navigator.pop(context);
              },
              child: const Text('Sign out'),
            )
          ],
        ),
      ),
    );
  }

  bool checkIsUrl(String url) {
    RegExp urlRegex = RegExp(
      r"^(http:\/\/www\.|https:\/\/www\.|http:\/\/|https:\/\/)?"
      r"([a-zA-Z0-9-]+\.){1,}"
      r"([a-zA-Z]{2,})(:[0-9]{1,})?((\/\w+)*\/)?([\w\-\.]+[^#?\s]+)?(.*?)?(#[\w\-]+)?$",
      caseSensitive: false,
      multiLine: false,
    );
    return urlRegex.hasMatch(url);
  }

  void onSubmitHandle(BuildContext context, String url) {
    checkIsUrl(url) == true
        ? Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => WebViewPage(
                      url: url,
                    )))
        : showSnackBar(context, "Invalid Url");
  }
}
