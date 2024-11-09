import 'dart:io';

import 'package:com.gogospider.booking/component/back_widget.dart';
import 'package:com.gogospider.booking/component/chat_item_widget.dart';
import 'package:com.gogospider.booking/component/loader_widget.dart';
import 'package:com.gogospider.booking/main.dart';
import 'package:com.gogospider.booking/model/chat_message_model.dart';
import 'package:com.gogospider.booking/model/user_data_model.dart';
import 'package:com.gogospider.booking/services/chat_messages_service.dart';
import 'package:com.gogospider.booking/utils/colors.dart';
import 'package:com.gogospider.booking/utils/common.dart';
import 'package:com.gogospider.booking/utils/constant.dart';
import 'package:com.gogospider.booking/utils/images.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:paginate_firestore/paginate_firestore.dart';

class UserChatScreen extends StatefulWidget {
  final UserData receiverUser;

  UserChatScreen({required this.receiverUser});

  @override
  _UserChatScreenState createState() => _UserChatScreenState();
}

class _UserChatScreenState extends State<UserChatScreen> {
  TextEditingController messageCont = TextEditingController();
  FocusNode messageFocus = FocusNode();

  late final UserData senderUser;
  late File imageFile;
  late String imageUrl;

  @override
  void initState() {
    super.initState();
    init();
  }

  void init() async {
    if (widget.receiverUser.uid!.isEmpty) {
      await userService
          .getUserByPhone(phone: widget.receiverUser.contactNumber.validate())
          .then((value) {
        widget.receiverUser.uid = value.uid;
      }).catchError((e) {
        log(e.toString());
      });
    }
    senderUser = await userService.getUserByPhone(
        phone: appStore.userContactNumber.validate());
    setState(() {});

    chatMessageService = ChatMessageService();
    await chatMessageService.setUnReadStatusToTrue(
        senderId: appStore.uid, receiverId: widget.receiverUser.uid!);
  }

  //region Methods
  Future<void> sendMessages() async {
    // If Message TextField is Empty.
    if (messageCont.text.trim().isEmpty) {
      messageFocus.requestFocus();
      return;
    }

    // Making Request for sending data to firebase
    ChatMessageModel data = ChatMessageModel();

    data.receiverId = widget.receiverUser.uid;
    data.senderId = appStore.uid;
    data.message = messageCont.text;
    data.isMessageRead = false;
    data.createdAt = DateTime.now().millisecondsSinceEpoch;
    data.messageType = MessageType.TEXT.name;

    messageCont.clear();

    await chatMessageService.addMessage(data).then((value) async {
      log("--Message Successfully Added-- : ${widget.receiverUser.playerId}");

      /// Send Notification
      notificationService
          .sendPushNotifications(
              senderUser.firstName.validate(), data.message.validate(),
              receiverPlayerId: widget.receiverUser.playerId)
          .catchError((e) {
        log("Notification Error ${e.toString()}");
      });

      await chatMessageService
          .addMessageToDb(
              senderRef: value,
              chatData: data,
              sender: senderUser,
              receiverUser: widget.receiverUser)
          .then((value) {
        //
      }).catchError((e) {
        log(e.toString());
      });

      /// Save receiverId to Sender Doc.
      userService
          .saveToContacts(
              senderId: appStore.uid,
              receiverId: widget.receiverUser.uid.validate())
          .then((value) => log("---ReceiverId to Sender Doc.---"))
          .catchError((e) {
        log(e.toString());
      });

      /// Save senderId to Receiver Doc.
      userService
          .saveToContacts(
              senderId: widget.receiverUser.uid.validate(),
              receiverId: appStore.uid)
          .then((value) => log("---SenderId to Receiver Doc.---"))
          .catchError((e) {
        log(e.toString());
      });
    }).catchError((e) {
      log(e.toString());
    });
  }

  Future<void> sendFileMessage(
      File file, String fileUrl, MessageType messageEnum) async {
    // If Message TextField is Empty.
    // if (messageCont.text.trim().isEmpty) {
    //   messageFocus.requestFocus();
    //   return;
    // }

    // Making Request for sending data to firebase
    ChatMessageModel data = ChatMessageModel();

    data.receiverId = widget.receiverUser.uid;
    data.senderId = appStore.uid;
    // data.message = fileUrl;
    // data.photoUrl = fileUrl;
    data.isMessageRead = false;
    data.createdAt = DateTime.now().millisecondsSinceEpoch;
    data.messageType = messageEnum.name;

    messageCont.clear();

    await chatMessageService.addMessage(data).then((value) async {
      log("--Message Successfully Added--");

      /*  /// Send Notification */
      notificationService
          .sendPushNotifications(getStringAsync(DISPLAY_NAME), messageCont.text,
              receiverPlayerId: widget.receiverUser.playerId)
          .catchError((e) {
        log("Notification Error ${e.toString()}");
      });

      await chatMessageService
          .addMessageToDb(
              senderRef: value,
              chatData: data,
              sender: senderUser,
              receiverUser: widget.receiverUser,
              image: file)
          .then((value) {
        //
      }).catchError((e) {
        log(e.toString());
      });

      /// Save receiverId to Sender Doc.
      userService
          .saveToContacts(
              senderId: appStore.uid,
              receiverId: widget.receiverUser.uid.validate())
          .then((value) => log("---ReceiverId to Sender Doc.---"))
          .catchError((e) {
        log(e.toString());
      });

      /// Save senderId to Receiver Doc.
      userService
          .saveToContacts(
              senderId: widget.receiverUser.uid.validate(),
              receiverId: appStore.uid)
          .then((value) => log("---SenderId to Receiver Doc.---"))
          .catchError((e) {
        log(e.toString());
      });
    }).catchError((e) {
      log(e.toString());
    });
  }

  Future<void> getImage() async {
    try {
      final pickedImage =
          await ImagePicker().pickImage(source: ImageSource.gallery);

      if (pickedImage != null) {
        imageFile = File(pickedImage.path);
      }
    } catch (e) {
      log(e.toString());
    }
    sendFileMessage(imageFile, imageUrl, MessageType.IMAGE).then((value) {});
    // uploadImageFile();
  }

  Future<void> uploadImageFile() async {
    String fileName = DateTime.now().millisecondsSinceEpoch.toString();
    Reference storageReference =
        FirebaseStorage.instance.ref().child("Chat Images").child(fileName);

    UploadTask storageUploadTask = storageReference.putFile(imageFile);
    storageUploadTask.then((res) {
      res.ref.getDownloadURL().then((value) {
        imageUrl = value;
        sendFileMessage(imageFile, imageUrl, MessageType.IMAGE).then((value) {
          log(imageUrl);
        });
        // log(imageUrl);
      });
    });
  }

  void _getFromGallery() async {
    final pickedFile = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      maxWidth: 1800,
      maxHeight: 1800,
    );
    if (pickedFile != null) {
      imageFile = File(pickedFile.path);
      sendFileMessage(imageFile, "", MessageType.IMAGE).then((value) {});
    }
  }

  _getFromCamera() async {
    final pickedFile = await ImagePicker().pickImage(
      source: ImageSource.camera,
      maxWidth: 1800,
      maxHeight: 1800,
    );
    if (pickedFile != null) {
      imageFile = File(pickedFile.path);
      sendFileMessage(imageFile, "", MessageType.IMAGE).then((value) {});
    }
  }

  void _showBottomSheet(BuildContext context) {
    showModalBottomSheet<void>(
      backgroundColor: context.cardColor,
      context: context,
      builder: (BuildContext context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            SettingItemWidget(
              title: language.lblGallery,
              leading: Icon(Icons.image, color: primaryColor),
              onTap: () {
                _getFromGallery();
                finish(context);
              },
            ),
            Divider(),
            SettingItemWidget(
              title: language.camera,
              leading: Icon(Icons.camera, color: primaryColor),
              onTap: () {
                _getFromCamera();
                finish(context);
              },
            ),
          ],
        ).paddingAll(16.0);
      },
    );
  }
  //endregion

  //region Widget
  Widget _buildChatFieldWidget() {
    return Container(
        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 8),
        color: context.cardColor,
        child: Row(
          children: [
            IconButton(
              icon:
                  Icon(Icons.camera_alt, color: context.primaryColor, size: 24),
              onPressed: () {
                _showBottomSheet(context);
              },
            ),
            AppTextField(
              textFieldType: TextFieldType.OTHER,
              controller: messageCont,
              textStyle: primaryTextStyle(),
              minLines: 1,
              onFieldSubmitted: (s) {
                sendMessages();
              },
              focus: messageFocus,
              cursorHeight: 20,
              maxLines: 5,
              cursorColor: appStore.isDarkMode ? Colors.white : Colors.black,
              textCapitalization: TextCapitalization.sentences,
              keyboardType: TextInputType.multiline,
              decoration: inputDecoration(context, borderRadius: 20).copyWith(
                  hintText: language.writeMsg,
                  hintStyle: secondaryTextStyle(),
                  fillColor: context.dividerColor,
                  filled: true,
                  focusedBorder: OutlineInputBorder(
                    borderRadius: radius(20),
                    borderSide: BorderSide(color: transparentColor, width: 1.0),
                  )),
            ).expand(),
            // 8.width,
            Container(
              // decoration: boxDecorationDefault(
              //     borderRadius: radius(80), color: primaryColor),
              child: IconButton(
                icon: Icon(Icons.send, color: context.primaryColor, size: 24),
                onPressed: () {
                  sendMessages();
                },
              ),
            )
          ],
        ));
  }

  //endregion

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarWidget(
        "",
        color: context.primaryColor,
        backWidget: BackWidget(),
        titleWidget: Text(widget.receiverUser.displayName.validate(),
            style: TextStyle(color: whiteColor)),
      ),
      body: SizedBox(
        height: context.height(),
        width: context.width(),
        child: Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: Image.asset(chat_default_wallpaper).image,
                  fit: BoxFit.cover,
                  colorFilter: appStore.isDarkMode
                      ? ColorFilter.mode(Colors.black54, BlendMode.luminosity)
                      : ColorFilter.mode(primaryColor, BlendMode.overlay),
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.only(bottom: 80),
              child: PaginateFirestore(
                reverse: true,
                isLive: true,
                padding: EdgeInsets.only(left: 8, top: 8, right: 8, bottom: 0),
                physics: BouncingScrollPhysics(),
                query: chatMessageService.chatMessagesWithPagination(
                    senderId: appStore.uid,
                    receiverUserId: widget.receiverUser.uid.validate()),
                initialLoader: LoaderWidget(),
                itemsPerPage: PER_PAGE_CHAT_COUNT,
                onEmpty: Text(language.lblNoChatsFound,
                        style: boldTextStyle(size: 20))
                    .center(),
                shrinkWrap: true,
                onError: (e) {
                  return noDataFound(context);
                },
                itemBuilderType: PaginateBuilderType.listView,
                itemBuilder: (context, snap, index) {
                  ChatMessageModel data = ChatMessageModel.fromJson(
                      snap[index].data() as Map<String, dynamic>);
                  data.isMe = data.senderId == appStore.uid;
                  return ChatItemWidget(chatItemData: data);
                },
              ),
            ),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: _buildChatFieldWidget(),
            )
          ],
        ),
      ),
    );
  }
}
