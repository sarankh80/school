import 'dart:convert';

import 'package:com.gogospider.booking/main.dart';
import 'package:com.gogospider.booking/model/login_model.dart';
import 'package:com.gogospider.booking/model/user_data_model.dart';
import 'package:com.gogospider.booking/network/rest_apis.dart';
import 'package:com.gogospider.booking/utils/constant.dart';
import 'package:com.gogospider.booking/utils/model_keys.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:nb_utils/nb_utils.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;
Codec<String, String> stringToBase64 = utf8.fuse(base64);

class AuthServices {
  //region Google Login
  final GoogleSignIn googleSignIn = GoogleSignIn();

  Future<void> signInWithGoogle() async {
    GoogleSignInAccount? googleSignInAccount = await googleSignIn.signIn();

    if (googleSignInAccount != null) {
      //Authentication
      final GoogleSignInAuthentication googleSignInAuthentication =
          await googleSignInAccount.authentication;

      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleSignInAuthentication.accessToken,
        idToken: googleSignInAuthentication.idToken,
      );

      final UserCredential authResult =
          await _auth.signInWithCredential(credential);
      final User user = authResult.user!;

      assert(!user.isAnonymous);

      final User currentUser = _auth.currentUser!;
      assert(user.uid == currentUser.uid);

      googleSignIn.signOut();

      String firstName = '';
      String lastName = '';
      if (currentUser.displayName.validate().split(' ').length >= 1)
        firstName = currentUser.displayName.splitBefore(' ');
      if (currentUser.displayName.validate().split(' ').length >= 2)
        lastName = currentUser.displayName.splitAfter(' ');

      Map req = {
        "email": currentUser.email,
        "first_name": firstName,
        "last_name": lastName,
        "username": (firstName + lastName).toLowerCase(),
        "profile_image": currentUser.photoURL,
        "social_image": currentUser.photoURL,
        "accessToken": googleSignInAuthentication.accessToken,
        "login_type": LOGIN_TYPE_GOOGLE,
        "user_type": LOGIN_TYPE_USER,
      };

      log("Google Login Json" + jsonEncode(req));

      await loginUser(req, isSocialLogin: true).then((value) async {
        await loginFromFirebaseUser(currentUser, value);
      }).catchError((e) {
        log(e.toString());
        throw e;
      });
    } else {
      throw errorSomethingWentWrong;
    }
  }

  Future<void> loginFromFirebaseUser(
      User currentUser, LoginResponse loginData) async {
    if (await userService.isUserExist(loginData.data!.email)) {
      log("Firebase User Exist");
      await userService.userByEmail(loginData.data!.email).then((user) async {
        await saveUserData(loginData.data!);
      }).catchError((e) {
        log(e);
        throw e;
      });
    } else {
      log("Creating Firebase User");

      loginData.data!.uid = currentUser.uid.validate();
      loginData.data!.userType = LOGIN_TYPE_USER;
      loginData.data!.loginType = LOGIN_TYPE_GOOGLE;
      loginData.data!.playerId = getStringAsync(PLAYERID);
      if (isIOS) {
        loginData.data!.displayName = currentUser.displayName;
      }

      await userService
          .addDocumentWithCustomId(currentUser.uid, loginData.data!.toJson())
          .then((value) async {
        log("Firebase User Created");
        await saveUserData(loginData.data!);
      }).catchError((e) {
        throw USER_NOT_CREATED;
      });
    }
  }

  //endregion

  //region Email
  Future<void> signUpWithEmailPassword(context,
      {required LoginResponse registerResponse,
      bool? isOTP,
      bool isLogin = true}) async {
    UserData? registerData = registerResponse.data!;
    // print(registerData.uid);
    // print(registerData.email);
    UserCredential? userCredential = await _auth
        .createUserWithEmailAndPassword(
            email: registerData.email.validate(),
            password: registerData.password.validate())
        // ignore: body_might_complete_normally_catch_error
        .catchError((e) async {
      await _auth
          .signInWithEmailAndPassword(
              email: registerData.email.validate(),
              password: registerData.password.validate())
          .then((value) {
        //
        // print('setRegisterData $_auth');
        setRegisterData(
          currentUser: value.user!,
          registerData: registerData,
          userModel: UserData(
            id: registerData.id.validate(),
            uid: value.user!.uid,
            apiToken: registerData.apiToken,
            contactNumber: registerData.contactNumber,
            displayName: registerData.displayName,
            email: registerData.email,
            firstName: registerData.firstName,
            lastName: registerData.lastName,
            userType: registerData.userType,
            username: registerData.username,
            password: registerData.password,
          ),
          isRegister: true,
        );
      }).catchError((e) {
        toast(e.toString());
        return e;
      });

      log("Err ${e.toString()}");
    });
    if (userCredential.user != null) {
      User currentUser = userCredential.user!;
      String displayName =
          registerData.firstName.validate() + registerData.lastName.validate();

      UserData userModel = UserData()
        ..id = registerData.id.validate()
        ..apiToken = registerData.apiToken.validate()
        ..uid = currentUser.uid
        ..email = currentUser.email
        ..contactNumber = registerData.contactNumber
        ..firstName = registerData.firstName.validate()
        ..lastName = registerData.lastName.validate()
        ..username = registerData.username.validate()
        ..displayName = displayName
        ..userType = LOGIN_TYPE_USER
        ..loginType = getStringAsync(LOGIN_TYPE)
        ..createdAt = Timestamp.now().toDate().toString()
        ..updatedAt = Timestamp.now().toDate().toString()
        ..playerId = getStringAsync(PLAYERID);
      setRegisterData(
          currentUser: currentUser,
          registerData: registerData,
          userModel: userModel,
          isRegister: isLogin);
    }
  }

  Future<void> signUpWithPhonePassword(context,
      {required LoginResponse registerResponse,
      String? password,
      bool? isOTP,
      bool isLogin = true}) async {
    UserData? registerData = registerResponse.data!;

    UserCredential? userCredential = await _auth
        .createUserWithEmailAndPassword(
            email: registerData.userType! +
                registerData.contactNumber.validate() +
                "@gogospider.com",
            password: password!)
        // ignore: body_might_complete_normally_catch_error
        .catchError((e) async {
      await _auth
          .signInWithEmailAndPassword(
              email: registerData.email.validate(),
              password: registerData.password.validate())
          .then((value) {
        //
        setRegisterData(
          currentUser: value.user!,
          registerData: registerData,
          userModel: UserData(
            id: registerData.id.validate(),
            uid: value.user!.uid,
            apiToken: registerData.apiToken,
            contactNumber: registerData.contactNumber,
            displayName: registerData.displayName,
            email: registerData.email,
            firstName: registerData.firstName,
            lastName: registerData.lastName,
            userType: registerData.userType,
            username: registerData.username,
            password: registerData.password,
            verificationId: stringToBase64.encode(password),
          ),
          isRegister: true,
        );
      }).catchError((e) {
        toast(e.toString());
        return e;
      });

      log("Err ${e.toString()}");
    });
    if (userCredential.user != null) {
      User currentUser = userCredential.user!;
      String displayName =
          registerData.firstName.validate() + registerData.lastName.validate();

      UserData userModel = UserData()
        ..id = registerData.id.validate()
        ..apiToken = registerData.apiToken.validate()
        ..uid = currentUser.uid
        ..email = currentUser.email
        ..contactNumber = registerData.contactNumber
        ..firstName = registerData.firstName.validate()
        ..lastName = registerData.lastName.validate()
        ..username = registerData.username.validate()
        ..displayName = displayName
        ..userType = LOGIN_TYPE_USER
        ..loginType = getStringAsync(LOGIN_TYPE)
        ..createdAt = Timestamp.now().toDate().toString()
        ..updatedAt = Timestamp.now().toDate().toString()
        ..playerId = getStringAsync(PLAYERID)
        ..verificationId = stringToBase64.encode(password);

      setRegisterData(
          currentUser: currentUser,
          registerData: registerData,
          userModel: userModel,
          isRegister: isLogin);
    }
  }

  Future<UserData> signInWithEmailPassword(context,
      {required UserData userData}) async {
    return await _auth
        .signInWithEmailAndPassword(
            email: userData.email.validate(),
            password: userData.password.validate())
        .then((value) async {
      final User user = value.user!;

      UserData userModel = await userService.getUser(email: user.email);
      await updateUserData(userModel);

      return userModel;
    }).catchError((e) {
      log(e.toString());

      throw USER_NOT_FOUND;
    });
  }

  Future<UserData> signInWithPhonePassword(context,
      {required UserData userData}) async {
    return await _auth
        .signInWithEmailAndPassword(
            email: userData.email.validate(),
            password: userData.password.validate())
        .then((value) async {
      final User user = value.user!;

      UserData userModel = await userService.getUser(email: user.email);
      await updateUserData(userModel);

      return userModel;
    }).catchError((e) {
      log(e.toString());

      throw USER_NOT_FOUND;
    });
  }

  //endregion

  //region Change password
  Future<void> changePassword(String newPassword) async {
    await _auth.currentUser!.updatePassword(newPassword).then((value) async {
      await setValue("PASSWORD", newPassword);
    });
  }

  //endregion

  //region Common Methods
  Future<void> updateUserData(UserData user) async {
    userService.updateDocument(
      {
        'player_id': getStringAsync(PLAYERID),
        'updatedAt': Timestamp.now(),
      },
      user.uid,
    );
  }

  Future<void> updateUserDataId(UserData user, id) async {
    userService.updateDocument(
      {
        'id': id,
        'api_token': user.apiToken,
        'first_name': user.firstName,
        'last_name': user.lastName,
        'player_id': getStringAsync(PLAYERID),
        'updatedAt': Timestamp.now(),
      },
      user.uid,
    );
  }

  Future<void> updateUserDataPss(UserData user, id, pass) async {
    Codec<String, String> stringToBase64 = utf8.fuse(base64);
    userService.updateDocument(
      {
        'id': id,
        'verificationId': stringToBase64.encode(pass),
        'updatedAt': Timestamp.now(),
      },
      user.uid,
    );
  }

  Future<void> setRegisterData(
      {required User currentUser,
      UserData? registerData,
      required UserData userModel,
      bool isRegister = true}) async {
    await appStore.setUserProfile(currentUser.photoURL.validate());
    if (isRegister) {
      await userService
          .addDocumentWithCustomId(currentUser.uid, userModel.toJson())
          .then((value) async {
        if (registerData != null) {
          // Login Request
          // var request = {
          //   UserKeys.email: registerData.email.validate(),
          //   UserKeys.phoneNumber: registerData.contactNumber,
          //   UserKeys.password: registerData.password.validate(),
          //   UserKeys.playerId: getStringAsync(PLAYERID),
          // };

          // Calling Login API
          // await loginUser(request).then((res) async {
          //   if (res.data!.userType == LOGIN_TYPE_USER) {
          //     // When Login is Successfully done and will redirect to HomeScreen.
          //     await saveUserData(res.data!);

          //     appStore.setLoggedIn(true);
          //     appStore.setLoading(false);
          //   }
          // }).catchError((e) {
          //   toast("Please Login Again");
          //   appStore.setLoading(false);
          //   // throw USER_CANNOT_LOGIN;
          // });
        }
      }).catchError((e) {
        log(e.toString());
        appStore.setLoading(false);
        // throw USER_NOT_CREATED;
      });
    } else {
      await saveUserData(userModel);
    }
  }

  //endregion

  //region OTP

  Future<String> loginWithOTP(
    String phoneNumber, {
    Function(String)? onVerificationIdReceived,
    Function(String)? onVerificationError,
  }) async {
    String id = '';
    await _auth.verifyPhoneNumber(
      phoneNumber: phoneNumber,
      verificationCompleted: (PhoneAuthCredential credential) async {
        id = credential.verificationId.validate();
        onVerificationIdReceived?.call(id);
      },
      verificationFailed: (FirebaseAuthException e) {
        if (e.code == 'invalid-phone-number') {
          toast('The provided phone number is not valid.');
          onVerificationError?.call('The provided phone number is not valid.');
        } else {
          toast(language.somethingWentWrong);
          onVerificationError?.call(e.toString());
        }
      },
      codeSent: (String verificationId, int? resendToken) async {
        id = verificationId;
        onVerificationIdReceived?.call(id);
        // String smsCode = '12345678';
        // Create a PhoneAuthCredential with the code
        // PhoneAuthCredential credential = PhoneAuthProvider.credential(
        //     verificationId: verificationId, smsCode: smsCode);
        // Sign the user in (or link) with the credential
        // await _auth.signInWithCredential(credential);
      },
      codeAutoRetrievalTimeout: (String verificationId) {
        id = verificationId;

        // onVerificationIdReceived?.call(id);
        appStore.setLoading(false);
      },
    );
    return id;
  }

  Future<void> signUpWithOTP(context, UserData data) async {
    AuthCredential credential = PhoneAuthProvider.credential(
      verificationId: data.verificationId.validate(),
      smsCode: data.otpCode.validate(),
    );

    await _auth.signInWithCredential(credential).then((result) {
      if (result.user != null) {
        User currentUser = result.user!;
        UserData userModel = UserData();
        var displayName = data.firstName.validate() + data.lastName.validate();

        userModel.uid = currentUser.uid.validate();
        userModel.email = data.email.validate();
        userModel.contactNumber = data.contactNumber.validate();
        userModel.firstName = data.firstName.validate();
        userModel.lastName = data.lastName.validate();
        userModel.username = data.username.validate();
        userModel.displayName = displayName;
        userModel.userType = LOGIN_TYPE_USER;
        userModel.loginType = LOGIN_TYPE_OTP;
        userModel.createdAt = Timestamp.now().toDate().toString();
        userModel.updatedAt = Timestamp.now().toDate().toString();
        userModel.playerId = getStringAsync(PLAYERID);

        log("User ${userModel.toJson()}");

        setRegisterData(
            currentUser: currentUser,
            registerData: data,
            userModel: userModel,
            isRegister: true);
      }
    });
  }

  Future<void> setRegisterDataPhone(
      {required User currentUser,
      UserData? registerData,
      String? password,
      required UserData userModel,
      bool isRegister = true}) async {
    await appStore.setUserProfile(currentUser.photoURL.validate());
    await userService
        .addDocumentWithCustomId(currentUser.uid, userModel.toJson())
        .then((value) async {
      //   if (registerData != null) {
      var request = {
        // UserKeys.email: registerData.email.validate(),
        UserKeys.phoneNumber: registerData!.contactNumber,
        UserKeys.password: password,
        UserKeys.playerId: getStringAsync(PLAYERID),
      };
      // Calling Login API
      await loginUser(request).then((res) async {
        if (res.data!.userType == LOGIN_TYPE_USER) {
          // When Login is Successfully done and will redirect to HomeScreen.
          await saveUserData(res.data!);
          appStore.setLoggedIn(true);
          appStore.setLoading(false);
        }
      }).catchError((e) {
        toast("Please Login Again");
        appStore.setLoading(false);
        throw USER_CANNOT_LOGIN;
      });
    }).catchError((e) {
      log(e.toString());
      appStore.setLoading(false);
      throw USER_NOT_CREATED;
    });
  }

  Future<void> signUpWithPhone(context, userData, password) async {
    User currentUser = userData.data;
    UserData userModel = UserData();
    var displayName = (userData.data.firstName != null
            ? userData.data.firstName
            : "GoGo") +
        (userData.data.lastName != null ? userData.data.lastName : "Spider");
    userModel.uid = currentUser.uid.validate();
    userModel.email = userData.data.email.validate();
    userModel.contactNumber = userData.data.contactNumber.validate();
    userModel.firstName =
        userData.data.firstName != null ? userData.data.firstName : "GoGo";
    userModel.lastName =
        userData.data.lastName != null ? userData.data.lastName : "Spider";
    userModel.username = displayName;
    userModel.displayName = displayName;
    userModel.userType = LOGIN_TYPE_USER;
    userModel.loginType = LOGIN_TYPE_OTP;
    userModel.createdAt = Timestamp.now().toDate().toString();
    userModel.updatedAt = Timestamp.now().toDate().toString();
    userModel.playerId = getStringAsync(PLAYERID);
    userModel.verificationId = stringToBase64.encode(password);
    setRegisterDataPhone(
        currentUser: currentUser,
        registerData: userData.data,
        password: password,
        userModel: userModel,
        isRegister: true);
  }

  Future<void> loginUpWithPhone(context, data, password) async {
    print(data);
    User currentUser = data;
    UserData userModel = UserData();
    var displayName = (data.firstName != null ? data.firstName : "Spider") +
        (data.lastName != null ? data.lastName : "");
    userModel.uid = currentUser.uid.validate();
    userModel.email =
        LOGIN_TYPE_USER + data.contactNumber.validate() + "@gogospider.com";
    userModel.contactNumber = data.contactNumber.validate();
    userModel.firstName = data.firstName != null ? data.firstName : "Spider";
    userModel.lastName = data.lastName != null ? data.lastName : "Spider";
    userModel.username = data.username.validate();
    userModel.displayName = displayName;
    userModel.userType = LOGIN_TYPE_USER;
    userModel.loginType = LOGIN_TYPE_OTP;
    userModel.createdAt = Timestamp.now().toDate().toString();
    userModel.updatedAt = Timestamp.now().toDate().toString();
    userModel.playerId = getStringAsync(PLAYERID);
    userModel.verificationId = stringToBase64.encode(password);
    setRegisterDataPhone(
        currentUser: currentUser,
        registerData: data,
        password: password,
        userModel: userModel,
        isRegister: true);
  }

  void registerUserWhenUserNotFound(
      BuildContext context, LoginResponse res, String password) async {
    UserData data = UserData(
      id: res.data!.id.validate(),
      apiToken: res.data!.apiToken.validate(),
      contactNumber: res.data!.contactNumber.validate(),
      displayName: res.data!.displayName.validate(),
      email: res.data!.email.validate(),
      uid: res.data!.uid.validate(),
      firstName: res.data!.firstName.validate(),
      lastName: res.data!.lastName.validate(),
      userType: res.data!.userType.validate(),
      username: res.data!.username.validate(),
      password: password,
    );

    log(data.toJson());

    authService
        .signUpWithEmailPassword(context,
            registerResponse: LoginResponse(data: data), isLogin: false)
        .then((value) {})
        .catchError((e) {
      appStore.setLoading(false);

      log(e.toString());
    });
  }

//endregion
}
