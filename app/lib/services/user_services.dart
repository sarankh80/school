import 'dart:io';

import 'package:com.gogospider.booking/main.dart';
import 'package:com.gogospider.booking/model/user_data_model.dart';
import 'package:com.gogospider.booking/utils/constant.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:path/path.dart';

import 'base_services.dart';

class UserService extends BaseService {
  FirebaseFirestore fireStore = FirebaseFirestore.instance;
  FirebaseStorage _storage = FirebaseStorage.instance;

  UserService() {
    ref = fireStore.collection(USER_COLLECTION);
  }

  Future<void> updateUserInfo(Map data, String id, {File? profileImage}) async {
    if (profileImage != null) {
      String fileName = basename(profileImage.path);
      Reference storageRef = _storage.ref().child("$PROFILE_IMAGE/$fileName");
      UploadTask uploadTask = storageRef.putFile(profileImage);
      await uploadTask.then((e) async {
        await e.ref.getDownloadURL().then((value) {
          appStore.setUserProfile(value);
          data.putIfAbsent("photoUrl", () => value);
        });
      });
    }

    return ref!.doc(id).update(data as Map<String, Object?>);
  }

  Future<void> updateUserStatus(Map data, String id) async {
    return ref!.doc(id).update(data as Map<String, Object?>);
  }

  Future<UserData> getUser({String? key, String? email}) {
    return ref!
        .where(key ?? "email", isEqualTo: email)
        .limit(1)
        .get()
        .then((value) {
      if (value.docs.isNotEmpty) {
        return UserData.fromJson(
            value.docs.first.data() as Map<String, dynamic>);
      } else {
        throw USER_NOT_FOUND;
      }
    });
  }

  Future<UserData> getUserEmail({String? key, String? email}) {
    return ref!
        .where(key ?? "email", isEqualTo: email)
        .limit(1)
        .get()
        .then((value) {
      if (value.docs.isNotEmpty) {
        return UserData.fromJson(
            value.docs.first.data() as Map<String, dynamic>);
      } else {
        return UserData();
      }
    });
  }

  Future<UserData> getUserByPhone({String? key, String? phone}) {
    return ref!
        .where(key ?? "contact_number", isEqualTo: phone)
        .limit(1)
        .get()
        .then((value) {
      if (value.docs.isNotEmpty) {
        return UserData.fromJson(
            value.docs.first.data() as Map<String, dynamic>);
      } else {
        throw USER_NOT_FOUND;
      }
    });
  }

  Stream<List<UserData>> users({String? searchText}) {
    return ref!
        .where(
          'caseSearch',
          arrayContains:
              searchText.validate().isEmpty ? null : searchText!.toLowerCase(),
        )
        .snapshots()
        .map((x) {
      return x.docs.map((y) {
        return UserData.fromJson(y.data() as Map<String, dynamic>);
      }).toList();
    });
  }

  Future<UserData> userByEmail(String? email) async {
    return await ref!
        .where('email', isEqualTo: email)
        .limit(1)
        .get()
        .then((value) {
      if (value.docs.isNotEmpty) {
        return UserData.fromJson(
            value.docs.first.data() as Map<String, dynamic>);
      } else {
        throw 'No User Found';
      }
    });
  }

  Stream<UserData> singleUser(String? id, {String? searchText}) {
    return ref!.where('uid', isEqualTo: id).limit(1).snapshots().map((event) {
      return UserData.fromJson(event.docs.first.data() as Map<String, dynamic>);
    });
  }

  Future<UserData> userByMobileNumber(
      String? phone, String? email, String? userType) async {
    if (email != null)
      return await ref!
          .where('email', isEqualTo: email)
          .where('user_type', isEqualTo: userType)
          .limit(1)
          .get()
          .then((value) {
        if (value.docs.isNotEmpty) {
          return UserData.fromJson(
              value.docs.first.data() as Map<String, dynamic>);
        } else {
          throw USER_NOT_FOUND;
        }
      });
    else
      return await ref!
          .where('contact_number', isEqualTo: phone)
          .where('user_type', isEqualTo: userType)
          .limit(1)
          .get()
          .then(
        (value) {
          if (value.docs.isNotEmpty) {
            return UserData.fromJson(
                value.docs.first.data() as Map<String, dynamic>);
          } else {
            throw USER_NOT_FOUND;
          }
        },
      );
  }

  Future<void> saveToContacts(
      {required String senderId, required String receiverId}) async {
    return ref!
        .doc(senderId)
        .collection(CONTACT_COLLECTION)
        .doc(receiverId)
        .update({
      'lastMessageTime': DateTime.now().millisecondsSinceEpoch
    }).catchError((e) {
      throw "USER_NOT_CREATED";
    });
  }

  Future<void> saveToGroupContacts(
      {required String senderId, required String receiverId}) async {
    return ref!
        .doc(senderId)
        .collection(CONTACT_SUPPORT_COLLECTION)
        .doc(receiverId)
        .update({
      'lastMessageTime': DateTime.now().millisecondsSinceEpoch
    }).catchError((e) {
      throw "USER_NOT_CREATED";
    });
  }
}
