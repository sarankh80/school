import 'package:com.gogospider.booking/component/back_widget.dart';
import 'package:com.gogospider.booking/component/loader_widget.dart';
import 'package:com.gogospider.booking/main.dart';
import 'package:com.gogospider.booking/model/contact_model.dart';
import 'package:com.gogospider.booking/screens/chat/component/user_item_builder.dart';
import 'package:com.gogospider.booking/utils/common.dart';
import 'package:com.gogospider.booking/utils/constant.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:paginate_firestore/paginate_firestore.dart';

class UserChatListScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: context.primaryColor,
          bottom: TabBar(
            indicatorColor: context.primaryColor,
            labelColor: Colors.white,
            tabs: [
              Tab(text: language.textHandyman),
              Tab(
                // text: language.helpSupport,
                text: "",
              )
            ],
          ),
          title: Text(
            language.lblchat,
            style: boldTextStyle(color: Colors.white, size: 20),
          ),
          leading: BackWidget(),
        ),
        body: TabBarView(
          children: [
            // Text("r"),
            PaginateFirestore(
              itemBuilder: (context, snap, index) {
                ContactModel contact = ContactModel.fromJson(
                    snap[index].data() as Map<String, dynamic>);
                log("COntact ID ${contact.uid.validate()}");
                return UserItemBuilder(userUid: contact.uid.validate());
              },
              options: GetOptions(source: Source.serverAndCache),
              isLive: false,
              padding: EdgeInsets.only(left: 0, top: 8, right: 0, bottom: 0),
              itemsPerPage: PER_PAGE_CHAT_LIST_COUNT,
              separator: Divider(height: 0, indent: 82),
              shrinkWrap: true,
              query:
                  chatMessageService.fetchChatListQuery(userId: appStore.uid),
              onEmpty: noDataFound(context),
              initialLoader: LoaderWidget(),
              itemBuilderType: PaginateBuilderType.listView,
              onError: (e) => noDataFound(context),
            ),
            PaginateFirestore(
              itemBuilder: (context, snap, index) {
                ContactModel contact = ContactModel.fromJson(
                    snap[index].data() as Map<String, dynamic>);
                return UserItemBuilder(userUid: contact.uid.validate());
              },
              options: GetOptions(source: Source.serverAndCache),
              isLive: false,
              padding: EdgeInsets.only(left: 0, top: 8, right: 0, bottom: 0),
              itemsPerPage: PER_PAGE_CHAT_LIST_COUNT,
              separator: Divider(height: 0, indent: 82),
              shrinkWrap: true,
              query: chatMessageService.fetchChatListSupportQuery(
                  userId: appStore.uid),
              onEmpty: noDataFound(context),
              initialLoader: LoaderWidget(),
              itemBuilderType: PaginateBuilderType.listView,
              onError: (e) => noDataFound(context),
            ),
          ],
        ),
      ),
    );

    // Scaffold(
    //   appBar: appBarWidget(
    //     language.lblchat,
    //     textColor: white,
    //     showBack: Navigator.canPop(context),
    //     elevation: 3.0,
    //     backWidget: BackWidget(),
    //     color: context.primaryColor,
    //   ),
    //   body: PaginateFirestore(
    //     itemBuilder: (context, snap, index) {
    //       ContactModel contact = ContactModel.fromJson(snap[index].data() as Map<String, dynamic>);
    //       return UserItemBuilder(userUid: contact.uid.validate());
    //     },
    //     options: GetOptions(source: Source.serverAndCache),
    //     isLive: false,
    //     padding: EdgeInsets.only(left: 0, top: 8, right: 0, bottom: 0),
    //     itemsPerPage: PER_PAGE_CHAT_LIST_COUNT,
    //     separator: Divider(height: 0, indent: 82),
    //     shrinkWrap: true,
    //     query: chatMessageService.fetchChatListQuery(userId: appStore.uid),
    //     onEmpty: noDataFound(context),
    //     initialLoader: LoaderWidget(),
    //     itemBuilderType: PaginateBuilderType.listView,
    //     onError: (e) => noDataFound(context),
    //   ),
    // );
  }
}
