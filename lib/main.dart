import 'package:easacc/view/login/cubit/login-cubit.dart';
import 'package:easacc/view/login/login-page.dart';
import 'package:easacc/view/setting/cubit/setting-cubit.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'firebase_options.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp( MultiBlocProvider(providers: [
    BlocProvider(create: (BuildContext context){
      return SocialLoginCubit();
    }),
    BlocProvider(create: (BuildContext context){
      return SettingCubit();
    }),
  ],
  child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Easacc',
        home: LoginPage(),

      ),
    );
  }
}

