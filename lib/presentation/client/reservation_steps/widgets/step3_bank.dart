import 'package:djulah/infrastructure/theme/client_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../controllers/reservation_steps.controller.dart';

class Step3Bank extends GetView<ReservationStepsController> {
  const Step3Bank({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20.r),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // Card Holder Name
          Text(
            "Card Holder name",
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.w500,
              letterSpacing: -0.8.r,
              height: 20.sp / 14.sp,
              color: Colors.black,
            ),
          ),
          SizedBox(height: 8.h),
          _buildTextField(
            controller: controller.cardHolderNameController,
            hintText: "Placeholder",
            keyboardType: TextInputType.name,
          ),
          
          SizedBox(height: 16.h),
          Divider(color: Color(0xFFE8E8E8), thickness: 1.r),
          SizedBox(height: 16.h),
          Text(
            "Card number",
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.w500,
              letterSpacing: -0.8.r,
              height: 20.sp / 14.sp,
              color: Colors.black,
            ),
          ),
          SizedBox(height: 8.h),
          _buildTextField(
            controller: controller.cardNumberController,
            hintText: "Placeholder",
            keyboardType: TextInputType.number,
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
              LengthLimitingTextInputFormatter(16),
              _CardNumberFormatter(),
            ],
          ),
          
          SizedBox(height: 16.h),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Expiry date",
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w500,
                        letterSpacing: -0.8.r,
                        height: 20.sp / 14.sp,
                        color: Colors.black,
                      ),
                    ),
                    SizedBox(height: 8.h),
                    _buildTextField(
                      controller: controller.expiryDateController,
                      hintText: "MM/YY",
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                        LengthLimitingTextInputFormatter(4),
                        _ExpiryDateFormatter(),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(width: 16.r),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "CVV",
                      style:TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w500,
                        letterSpacing: -0.8.r,
                        height: 20.sp / 14.sp,
                        color: Colors.black,
                      ),
                    ),
                    SizedBox(height: 8.h),
                    _buildTextField(
                      controller: controller.cvvController,
                      hintText: "Placeholder",
                      keyboardType: TextInputType.number,
                      obscureText: true,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                        LengthLimitingTextInputFormatter(4),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hintText,
    TextInputType keyboardType = TextInputType.text,
    bool obscureText = false,
    List<TextInputFormatter>? inputFormatters,
  }) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      obscureText: obscureText,
      inputFormatters: inputFormatters,
      style: TextStyle(
        fontSize: 14.sp,
        fontWeight: FontWeight.w500,
        color: Colors.black,
      ),
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: TextStyle(
          fontSize: 16.sp,
          fontWeight: FontWeight.w400,
          height: 20.sp/16.sp,
          color: ClientTheme.textTertiaryColor,
        ),
        filled: true,
        fillColor: Color(0xFFE8F7FC),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
          borderSide: BorderSide(
            color: ClientTheme.primaryColor,
            width: 1.r,
          ),
        ),
        contentPadding: EdgeInsets.symmetric(
          horizontal: 16.r,
          vertical: 14.h,
        ),
      ),
    );
  }
}

class _CardNumberFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final text = newValue.text.replaceAll(' ', '');
    final buffer = StringBuffer();
    for (int i = 0; i < text.length; i++) {
      buffer.write(text[i]);
      if ((i + 1) % 4 == 0 && i != text.length - 1) {
        buffer.write(' ');
      }
    }
    return TextEditingValue(
      text: buffer.toString(),
      selection: TextSelection.collapsed(offset: buffer.length),
    );
  }
}

class _ExpiryDateFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final text = newValue.text.replaceAll('/', '');
    final buffer = StringBuffer();
    for (int i = 0; i < text.length; i++) {
      buffer.write(text[i]);
      if (i == 1 && i != text.length - 1) {
        buffer.write('/');
      }
    }
    return TextEditingValue(
      text: buffer.toString(),
      selection: TextSelection.collapsed(offset: buffer.length),
    );
  }
}
