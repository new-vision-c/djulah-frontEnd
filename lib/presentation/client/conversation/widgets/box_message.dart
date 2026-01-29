import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

import '../../../../domain/entities/conversation.dart';
import '../../../../infrastructure/theme/client_theme.dart';

class BoxMessage extends StatelessWidget {
  final String text;
  final DateTime time;
  final bool isMe;
  final MessageStatus status;
  final VoidCallback? onRetry;

  const BoxMessage({
    super.key,
    required this.text,
    required this.time,
    required this.isMe,
    this.status = MessageStatus.sent,
    this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment:
          isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          constraints: BoxConstraints(maxWidth: 0.7.sw),
          padding: EdgeInsets.symmetric(vertical: 16.r, horizontal: 24.r),
          decoration: BoxDecoration(
            color: isMe 
                ? (status == MessageStatus.failed 
                    ? ClientTheme.primaryColor.withOpacity(0.7) 
                    : ClientTheme.primaryColor)
                : Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(16.r),
              topRight: Radius.circular(16.r),
              bottomLeft: isMe ? Radius.circular(16.r) : Radius.zero,
              bottomRight: isMe ? Radius.zero : Radius.circular(16.r),
            ),
            boxShadow: !isMe
                ? [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 5,
                      offset: const Offset(0, 2),
                    )
                  ]
                : null,
          ),
          child: Text(
            text,
            style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.w400,
                letterSpacing: -0.8.r,
                height: 20.sp / 16.sp,
                color: isMe ? Colors.white : Colors.black),
          ),
        ),
        SizedBox(height: 4.r),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              DateFormat('hh:mm a').format(time),
              style: TextStyle(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w400,
                  letterSpacing: -0.36.r,
                  height: 16.sp / 12.sp,
                  color: const Color(0xFFAFB8CF)),
            ),
            if (isMe) ...[
              SizedBox(width: 4.w),
              _buildStatusIcon(),
            ],
            // Bouton de retry pour les messages échoués
            if (isMe && status == MessageStatus.failed && onRetry != null) ...[
              SizedBox(width: 8.w),
              GestureDetector(
                onTap: onRetry,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 8.r, vertical: 2.r),
                  decoration: BoxDecoration(
                    color: Colors.red.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(4.r),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.refresh, size: 12.r, color: Colors.red),
                      SizedBox(width: 2.w),
                      Text(
                        'Réessayer',
                        style: TextStyle(
                          fontSize: 10.sp,
                          color: Colors.red,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ],
        )
      ],
    );
  }

  Widget _buildStatusIcon() {
    switch (status) {
      case MessageStatus.pending:
        return SizedBox(
          width: 12.r,
          height: 12.r,
          child: CircularProgressIndicator(
            strokeWidth: 1.5,
            color: Colors.grey.shade400,
          ),
        );
      case MessageStatus.failed:
        return Icon(Icons.error_outline_rounded, size: 14.r, color: Colors.red);
      case MessageStatus.sent:
        return Icon(Icons.check_rounded,
            size: 14.r, color: const Color(0xFFAFB8CF));
      case MessageStatus.viewed:
        return Icon(Icons.done_all_rounded, size: 14.r, color: Colors.blue);
    }
  }
}
