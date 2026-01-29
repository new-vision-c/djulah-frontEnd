import 'package:djulah/infrastructure/navigation/route_names.dart';
import 'package:djulah/infrastructure/theme/client_theme.dart';
import 'package:djulah/presentation/components/connection_status_banner.dart';
import 'package:djulah/presentation/components/shimmer_box.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import 'controllers/messages.controller.dart';

class MessagesScreen extends GetView<MessagesController> {
  const MessagesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          centerTitle: false,
          elevation: 0,
          shape: const Border(
              bottom: BorderSide(
            color: Color(0xFFE8E8E8),
          )),
          title: Text(
            "Messages",
            style: TextStyle(
                fontSize: 20.sp,
                fontWeight: FontWeight.w600,
                letterSpacing: -1.r,
                height: 24.sp / 20.sp,
                color: Colors.black),
          ),
          toolbarHeight: 68.r,
          actionsPadding: EdgeInsets.only(right: 16.r),
          actions: [
            ClipRRect(
                borderRadius: BorderRadius.circular(100.h),
                child: Container(
                  width: 36.r,
                  height: 36.r,
                  color: const Color(0xFFF3F3F3),
                  padding: EdgeInsets.all(8.r),
                  child: Image.asset(
                      "assets/images/client/BottomNavImages/search.png"),
                )),
            SizedBox(
              width: 12.w,
            ),
            ClipRRect(
                borderRadius: BorderRadius.circular(100.h),
                child: Container(
                  width: 36.r,
                  height: 36.r,
                  color: const Color(0xFFF3F3F3),
                  padding: EdgeInsets.all(8.r),
                  child: Image.asset("assets/images/client/settings.png"),
                ))
          ],
        ),
        body: Column(
          children: [
            // Bannière d'état de connexion
            const ConnectionStatusBanner(),
            Expanded(
              child: Obx(() {
                if (controller.isLoading.value) {
                  return ListView.builder(
                    padding: EdgeInsets.symmetric(horizontal: 16.r, vertical: 20.r),
                    itemCount: 5,
                    itemBuilder: (context, index) => _buildShimmerItem(),
                  );
                }

                return RefreshIndicator(
                  onRefresh: controller.refresh,
                  child: ListView.builder(
                    padding: EdgeInsets.symmetric(horizontal: 16.r, vertical: 20.r),
            itemCount: controller.conversations.length,
            itemBuilder: (context, index) {
              final conversation = controller.conversations[index];
              return GestureDetector(
                onTap: () {
                  Get.toNamed(RouteNames.clientConversation, arguments: conversation);
                },
                child: Container(
                  height: 80.sp,
                  padding: EdgeInsets.symmetric(vertical: 8.r),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(32.r),
                        child: SizedBox(
                          height: 64.r,
                          width: 64.r,
                          child: Image.asset(conversation.otherUserAvatar),
                        ),
                      ),
                      SizedBox(
                        width: 12.r,
                      ),
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  conversation.otherUserName,
                                  style: TextStyle(
                                      fontSize: 20.sp,
                                      overflow: TextOverflow.ellipsis,
                                      fontWeight: FontWeight.w600,
                                      height: 24.sp / 20.sp,
                                      letterSpacing: -1.r),
                                ),
                                Text(
                                  conversation.lastMessageTime,
                                  style: TextStyle(
                                      fontSize: 12.sp,
                                      color: const Color(0xFF5E5E5E),
                                      fontWeight: FontWeight.w400,
                                      height: 16.sp / 12.sp,
                                      letterSpacing: -0.36.r),
                                )
                              ],
                            ),
                            SizedBox(
                              height: 2.r,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Text(
                                    conversation.lastMessage,
                                    maxLines: 1,
                                    style: TextStyle(
                                        fontSize: 14.sp,
                                        overflow: TextOverflow.ellipsis,
                                        fontWeight: conversation.unreadCount > 0
                                            ? FontWeight.w600
                                            : FontWeight.w400,
                                        height: 20.sp / 14.sp,
                                        letterSpacing: -1.r),
                                  ),
                                ),
                                if (conversation.unreadCount > 0)
                                  Container(
                                    height: 20.r,
                                    width: 20.r,
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                        color: ClientTheme.primaryColor,
                                        borderRadius:
                                            BorderRadius.circular(100)),
                                    child: Text(
                                      conversation.unreadCount
                                          .toString()
                                          .padLeft(2, '0'),
                                      style: TextStyle(
                                          fontSize: 12.sp,
                                          color: Colors.white,
                                          fontWeight: FontWeight.w400,
                                          height: 16.sp / 12.sp,
                                          letterSpacing: -0.36.r),
                                    ),
                                  )
                              ],
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              );
            },
          ),
                );
              }),
            ),
          ],
        ));
  }

  Widget _buildShimmerItem() {
    return Container(
      height: 80.sp,
      padding: EdgeInsets.symmetric(vertical: 8.r),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ShimmerBox(width: 64.r, height: 64.r, borderRadius: 32.r),
          SizedBox(width: 12.r),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ShimmerBox(width: 120.r, height: 20.sp, borderRadius: 4.r),
                    ShimmerBox(width: 40.r, height: 12.sp, borderRadius: 4.r),
                  ],
                ),
                SizedBox(height: 8.r),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ShimmerBox(width: 180.r, height: 14.sp, borderRadius: 4.r),
                    ShimmerBox(width: 20.r, height: 20.r, borderRadius: 10.r),
                  ],
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
