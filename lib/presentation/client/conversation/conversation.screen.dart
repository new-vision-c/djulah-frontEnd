import 'package:djulah/domain/entities/conversation.dart';
import 'package:djulah/presentation/client/conversation/widgets/box_message.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../generated/assets.dart';
import '../../../infrastructure/theme/client_theme.dart';
import '../components/app_bar.dart';
import 'controllers/conversation.controller.dart';

class ConversationScreen extends GetView<ConversationController> {
  const ConversationScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: Column(
            children: [
              AppBarCustom(
                title: controller.conversation.otherUserName,
                action: Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(100.h),
                      child: Container(
                        width: 36.r,
                        height: 36.r,
                        color: const Color(0xFFF3F3F3),
                        padding: EdgeInsets.all(8.r),
                        child: Image.asset(
                          "assets/images/client/BottomNavImages/search.png",
                        ),
                      ),
                    ),
                    SizedBox(width: 12.w),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(100.h),
                      child: Container(
                        alignment: Alignment.center,
                        width: 36.r,
                        height: 36.r,
                        color: const Color(0xFFF3F3F3),
                        child: Icon(
                          Icons.menu,
                          color: ClientTheme.primaryColor,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Container(
                  padding: EdgeInsets.only(
                    right: 16.r,
                    left: 16.r,
                    bottom: 20.h,
                  ),
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage(Assets.clientBackgroundMessagerie),
                      fit: BoxFit.cover,
                    ),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Expanded(
                        child: Obx(
                          () => ListView.builder(
                            padding: EdgeInsets.only(top: 10.h, bottom: 20.h),
                            shrinkWrap: true,
                            scrollDirection: Axis.vertical,
                            physics: const BouncingScrollPhysics(),
                            reverse: true,
                            itemCount: controller.messages.length,
                            itemBuilder: (context, index) {
                              final msg = controller.messages[index];
                              return Padding(
                                padding: EdgeInsets.only(bottom: 20.h),
                                child: BoxMessage(
                                  text: msg.text,
                                  time: msg.time,
                                  isMe: msg.isMe,
                                  status: msg.status,
                                  onRetry: msg.status == MessageStatus.failed
                                      ? () => controller.retryMessage(msg.id)
                                      : null,
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                      IntrinsicHeight(
                        child: Row(
                          children: [
                            Expanded(
                              child: TextField(
                                scrollPadding: EdgeInsets.zero,
                                controller: controller.messageController,
                                onChanged: (val) {
                                  controller.message = val;
                                  controller.update();
                                },
                                keyboardType: TextInputType.text,
                                style: TextStyle(
                                  fontSize: 16.r,
                                  fontStyle: FontStyle.normal,
                                  fontWeight: FontWeight.w400,
                                  letterSpacing: -0.48.r,
                                  height: 20.r / 24.r,
                                  color: Colors.black,
                                ),
                                decoration: InputDecoration(
                                  hintText: "Send a message",
                                  hintStyle: TextStyle(
                                    color: ClientTheme.textTertiaryColor,
                                    fontSize: 16.r,
                                    fontStyle: FontStyle.normal,
                                    fontWeight: FontWeight.w400,
                                    letterSpacing: -0.48,
                                    height: 20.r / 24.r,
                                  ),
                                  contentPadding: EdgeInsets.all(12.r),
                                  filled: true,
                                  suffixIcon: Container(
                                    padding: EdgeInsets.all(10.r),
                                    child: Icon(
                                      Icons.camera_alt_outlined,
                                      color: ClientTheme.primaryColor,
                                    ),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8.r),
                                    borderSide: BorderSide(
                                      color: ClientTheme.primaryColor,
                                    ),
                                  ),
                                  fillColor: ClientTheme.inputBackgroundColor,
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8.r),
                                    borderSide: BorderSide.none,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(width: 12.w),
                            GetBuilder<ConversationController>(
                              builder: (ctrl) {
                                bool hasText = ctrl.messageController.text
                                    .trim()
                                    .isNotEmpty;
                                return IconButton(
                                  padding: EdgeInsets.all(12.r),
                                  style: ButtonStyle(
                                    backgroundColor: WidgetStateProperty.all(
                                      ClientTheme.primaryColor,
                                    ),
                                    shape: WidgetStateProperty.all(
                                      RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(
                                          8.r,
                                        ),
                                      ),
                                    ),
                                  ),
                                  onPressed: () {
                                    if (hasText) {
                                      ctrl.sendMessage();
                                    }
                                  },
                                  icon: Icon(
                                    hasText
                                        ? Icons.send
                                        : Icons.mic_none_outlined,
                                    color: Colors.white,
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
