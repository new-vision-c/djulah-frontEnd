import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class ReservationStepsController extends GetxController {
  final currentPage = 0.obs;
  RxInt totalPages = 4.obs;
  final pageController = PageController();

  final selectedPaymentMethod = RxnInt();
  
  final isStepValid = false.obs;
  
  final selectedOperator = 'Mobile Money'.obs;
  final payerPhoneController = TextEditingController();
  
  final cardHolderNameController = TextEditingController();
  final cardNumberController = TextEditingController();
  final expiryDateController = TextEditingController();
  final cvvController = TextEditingController();

  final List<String> subtitles = [
    'Vérifiez avant de continuer',
    'Ajouter  un mode de payement',
    'Informations de payement',
    'Confirmer et payer',
  ];
  
  final List<String> operators = [
    'Mobile Money',
    'Orange Money',
  ];

  final count = 0.obs;
  
  @override
  void onInit() {
    super.onInit();
    validateCurrentStep();
    
    currentPage.listen((_) => validateCurrentStep());
    
    selectedPaymentMethod.listen((_) => validateCurrentStep());
    
    payerPhoneController.addListener(validateCurrentStep);
    cardHolderNameController.addListener(validateCurrentStep);
    cardNumberController.addListener(validateCurrentStep);
    expiryDateController.addListener(validateCurrentStep);
    cvvController.addListener(validateCurrentStep);
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    payerPhoneController.dispose();
    cardHolderNameController.dispose();
    cardNumberController.dispose();
    expiryDateController.dispose();
    cvvController.dispose();
    super.onClose();
  }

  void selectPaymentMethod(int index) {
    selectedPaymentMethod.value = index;
  }
  
  void nextPage() {
    if (currentPage.value < totalPages.value - 1) {
      pageController.nextPage(
        duration: Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }
  
  void previousPage() {
    if (currentPage.value > 0) {
      pageController.previousPage(
        duration: Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }
  
  void goToPage(int page) {
    pageController.animateToPage(
      page,
      duration: Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  void increment() => count.value++;
  
  /// Validate current step and update isStepValid
  void validateCurrentStep() {
    switch (currentPage.value) {
      case 0:
        // Step 1: Always valid (verification step)
        isStepValid.value = true;
        break;
      case 1:
        // Step 2: Payment method must be selected
        isStepValid.value = selectedPaymentMethod.value != null;
        break;
      case 2:
        // Step 3: Validate payment form based on selected method
        isStepValid.value = _validatePaymentForm();
        break;
      case 3:
        // Step 4: Confirmation - always valid
        isStepValid.value = true;
        break;
      default:
        isStepValid.value = false;
    }
  }
  
  /// Validate payment form based on selected method
  bool _validatePaymentForm() {
    if (selectedPaymentMethod.value == null) return false;
    
    if (selectedPaymentMethod.value == 0) {
      // Bank card validation
      return cardHolderNameController.text.trim().isNotEmpty &&
             cardNumberController.text.trim().length >= 16 &&
             expiryDateController.text.trim().isNotEmpty &&
             cvvController.text.trim().length >= 3;
    } else {
      // Mobile payment validation
      return payerPhoneController.text.trim().length >= 8;
    }
  }
  
  /// Check if we can go back
  bool get canGoBack => currentPage.value > 0;
}
