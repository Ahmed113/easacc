import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

@immutable
abstract class SocialLoginState{}

class SocialLoginInitial extends SocialLoginState{}
class GoogleLoginSuccess extends SocialLoginState{
  GoogleLoginSuccess({required this.user});
  User user;
}
class GoogleLoginLoading extends SocialLoginState{}
class GoogleLoginFailed extends SocialLoginState{
  GoogleLoginFailed({required this.msg});
  String msg;
}


// class FBLoginInitial extends FBLoginState{}
class FBLoginSuccess extends SocialLoginState{
  FBLoginSuccess({required this.user,});
  Map user;
}
class FBLoginLoading extends SocialLoginState{}
class FBLoginFailed extends SocialLoginState{
  FBLoginFailed({required this.msg});
  String msg;
}
