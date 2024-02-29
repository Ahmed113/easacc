import 'package:easacc/view/login/cubit/login-state.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class SocialLoginCubit extends Cubit<SocialLoginState>{
  SocialLoginCubit():super(SocialLoginInitial());

  final GoogleSignIn _googleSignIn = GoogleSignIn(scopes: ['email',"https://www.googleapis.com/auth/userinfo.profile"]);
  late FirebaseAuth _auth;
  bool isUserSignedIn = false;
  User? _user;
  bool userSignedIn = false;

  Future<void> logInWithGoogle()async{
    emit(GoogleLoginLoading());
   try{
     FirebaseApp defaultApp = await Firebase.initializeApp();
     _auth = FirebaseAuth.instanceFor(app: defaultApp);
     userSignedIn = await _googleSignIn.isSignedIn();
     isUserSignedIn = userSignedIn;
     if (isUserSignedIn) {
       _user = _auth.currentUser;
       emit(GoogleLoginSuccess(user: _user!));
     }else{
       final GoogleSignInAccount? googleUser =
       await _googleSignIn.signIn();
       final GoogleSignInAuthentication? googleAuth =
       await googleUser?.authentication;
       final AuthCredential credential =
       GoogleAuthProvider.credential(
           accessToken: googleAuth?.accessToken,
           idToken: googleAuth?.idToken
       );
       _user = (await _auth.signInWithCredential(credential)).user;
       userSignedIn = await _googleSignIn.isSignedIn();
       isUserSignedIn = userSignedIn;
       if (isUserSignedIn) {
         emit(GoogleLoginSuccess(user: _user!));
       }
     }
   } on Exception catch(exp){
     emit(GoogleLoginFailed(msg: exp.toString()));
   }
  }

  Future<void> googleSignOut() async {
    await FirebaseAuth.instance.signOut();
    await _googleSignIn.signOut();
    emit(GoogleLoginFailed(msg: "Signed Out"));
  }

  late final String userAccessToken;
  Future<void> loginWithFB()async {
    emit(FBLoginLoading());
    try{
      final LoginResult result = await FacebookAuth.instance.login(
          permissions: ["public_profile","email"]);
      //     .then((value) {
      //   FacebookAuth.instance.getUserData().then((userData)async{
      //     emit(FBLoginSuccess(user: userData));
      //   });
      // });
      if (result.status == LoginStatus.success) {
        // final AccessToken userAccessToken = result.accessToken!;
        final userData = await FacebookAuth.instance.getUserData();
        emit(FBLoginSuccess(user: userData,));
      } else {
        emit(FBLoginFailed(msg: "Facebook login failed"));
      }

    }on Exception catch(msg){
      emit(FBLoginFailed(msg: "$msg"));
    }
  }

  Future<void> fbSignOut() async{
    emit(FBLoginFailed(msg: "Signed Out"));
    FacebookAuth.instance.logOut();
  }

}

// class FBLoginCubit extends Cubit<FBLoginState>{
//   FBLoginCubit(): super(FBLoginInitial());
//
//
// }