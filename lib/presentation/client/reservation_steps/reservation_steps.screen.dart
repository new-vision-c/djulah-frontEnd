import 'package:djulah/app/config/app_config.dart';
import 'package:djulah/presentation/client/reservation_steps/widgets/step1.dart';
import 'package:djulah/presentation/client/reservation_steps/widgets/step2.dart';
import 'package:djulah/presentation/client/reservation_steps/widgets/step3_mobile.dart';
import 'package:djulah/presentation/client/reservation_steps/widgets/step3_bank.dart';
import 'package:djulah/presentation/client/reservation_steps/widgets/step4.dart';
import 'package:djulah/presentation/client/reservation_steps/widgets/success.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:get/get.dart';

import '../../../infrastructure/theme/client_theme.dart';
import '../../components/buttons/primary_button.widget.dart';
import '../components/app_bar.dart';
import 'controllers/reservation_steps.controller.dart';

class ReservationStepsScreen extends GetView<ReservationStepsController> {
  const ReservationStepsScreen({super.key});
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: SafeArea(
          child: Column(
            children: [
              Obx(() => AppBarCustom(
                title: "",
                withLeading: controller.canGoBack,
                onLeadingPressed: controller.canGoBack ? () => controller.previousPage() : null,
                action: Padding(
                  padding: EdgeInsets.only(right: 16.r),
                  child: GestureDetector(
                    onTap: () => Get.back(),
                    child: Icon(
                      Icons.close,
                      size: 20.r,
                      fontWeight: FontWeight.w600,
                      color: ClientTheme.primaryColor,
                    ),
                  ),
                ),
              )),
              Expanded(
                child: Container(
                  color: Color(0xFFF3F3F3),
                  child: Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(left: 16.r, right: 16.r, top: 32.h),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Obx(() {
                            final idx = controller.currentPage.value;
                            return Text(
                              controller.subtitles[idx],
                              style: TextStyle(
                                fontSize: 20.sp,
                                fontWeight: FontWeight.w600,
                                letterSpacing: -1.r,
                                height: 24.sp / 20.sp,
                                color: Colors.black,
                              ),
                            );
                          }),
                        ),
                      ),
                      SizedBox(height: 24.h),
                      Expanded(
                        child: PageView(
                          controller: controller.pageController,
                          physics: NeverScrollableScrollPhysics(),
                          onPageChanged: (index) {
                            controller.currentPage.value = index;
                          },
                          children: [
                            _buildPageContent(Step1()),
                            _buildPageContent(Step2()),
                            Obx(() => _buildPageContent(
                              controller.selectedPaymentMethod.value == 0
                                  ? Step3Bank()
                                  : Step3Mobile(),
                            )),
                            _buildPageContent(Step4()),
                          ],
                        ),
                      ),
                      _buildBottomSection(),
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

  Widget _buildPageContent(Widget child) {
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: 16.r),
      child: child,
    );
  }

  Widget _buildBottomSection() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.r, vertical: 16.h),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Step indicator
          Obx(() => _buildStepIndicator()),
          SizedBox(height: 16.h),
          // Button
          Obx(() {
            String buttonText;
            switch (controller.currentPage.value) {
              case 0:
              case 1:
                buttonText = "Suivant";
                break;
              case 2:
                buttonText = "Payer";
                break;
              case 3:
                buttonText = "Procéder au payement";
                break;
              default:
                buttonText = "Suivant";
            }

            final isEnabled = controller.isStepValid.value;
            
            return PrimaryButton(
              text: buttonText,
              disabledColor: Color(0xFFE8E8E8),
              isEnabled: isEnabled,
              onPressed: isEnabled
                  ? () {
                      if (controller.currentPage.value < 3) {
                        controller.nextPage();
                      } else {
                        AppConfig.isLoadingApp.value=true;
                        Future.delayed(Duration(seconds: 5)).then((value) {
                          Get.to(SuccessReservation());
                          AppConfig.isLoadingApp.value=false;
                        },);
                      }
                    }
                  : null,
            );
          }),
        ],
      ),
    );
  }

  Widget _buildStepIndicator() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(4, (index) {
        final isCurrent = index == controller.currentPage.value;
        return Expanded(
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: 4.r),
            height: 4.h,
            decoration: BoxDecoration(
              color: isCurrent
                  ? Colors.black
                  : Color(0xFF202020).withOpacity( 0.4) ,
              borderRadius: BorderRadius.circular(2.r),
            ),
          ),
        );
      }),
    );
  }
}
