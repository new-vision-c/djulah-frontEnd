import 'dart:ui';
import 'package:djulah/infrastructure/navigation/route_names.dart';
import 'package:djulah/infrastructure/theme/client_theme.dart';
import 'package:djulah/presentation/client/home/controllers/search_modal.controller.dart';
import 'package:djulah/presentation/client/result_search/controllers/result_search.controller.dart';
import 'package:djulah/presentation/components/shimmer_box.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';


class SearchModal extends StatefulWidget {
  final int initialTabIndex;
  final Function(Map<String, dynamic>)? onLocationSelected;
  
  const SearchModal({
    super.key, 
    this.initialTabIndex = 0,
    this.onLocationSelected,
  });

  static Future<void> show(BuildContext context, {
    int initialTabIndex = 0,
    Function(Map<String, dynamic>)? onLocationSelected,
  }) {
    return showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: "Search",
      barrierColor: Colors.transparent,
      transitionDuration: const Duration(milliseconds: 400),
      pageBuilder: (context, animation, secondaryAnimation) {
        return SearchModal(
          initialTabIndex: initialTabIndex,
          onLocationSelected: onLocationSelected,
        );
      },
      transitionBuilder: (context, animation, secondaryAnimation, child) {
        final curvedAnimation = CurvedAnimation(
          parent: animation,
          curve: Curves.easeOutBack,
          reverseCurve: Curves.easeInBack,
        );
        
        return SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(0, -1.0),
            end: Offset.zero,
          ).animate(curvedAnimation),
          child: child,
        );
      },
    );
  }

  @override
  State<SearchModal> createState() => _SearchModalState();
}

class _SearchModalState extends State<SearchModal> with TickerProviderStateMixin {
  int _currentTabIndex = 0;
  late SearchModalController _controller;

  @override
  void initState() {
    super.initState();
    _currentTabIndex = widget.initialTabIndex;
    _controller = Get.put(SearchModalController());
  }

  @override
  void dispose() {
    Get.delete<SearchModalController>();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Stack(
        children: [
          // Blurred background
          Positioned.fill(
            child: GestureDetector(
              onTap: () => Navigator.of(context).pop(),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
                child: Container(
                  color: Colors.white.withOpacity(0.5),
                ),
              ),
            ),
          ),
          // Modal content
          SafeArea(
            child: SingleChildScrollView(
              padding: EdgeInsets.only(left: 16.r, right: 16.r, top: 32.r, bottom: 16.r),
              child: Column(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.of(context).pop(),
                    child: Container(
                      padding: EdgeInsets.all(8.r),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.close,
                        size: 24.r,
                        color: ClientTheme.primaryColor,
                      ),
                    ),
                  ),
                  SizedBox(height: 30.h),
                  _buildTopBar(),
                  SizedBox(height: 16.h),
                  _buildLocationCard(),
                  if (_currentTabIndex == 0) ...[
                    SizedBox(height: 12.h),
                    _buildDateCard(),
                  ],
                  SizedBox(height: 12.h),
                  _buildLogementTypeCard(),
                  SizedBox(height: 20.h),
                  _buildBottomActions(),
                  SizedBox(height: 12.h),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTopBar() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      mainAxisSize: MainAxisSize.max,
      children: [
        _buildTabItem(
          index: 0,
          icon: "assets/images/client/hotel.svg",
          label: 'home.furnished'.tr,
        ),
        _buildTabItem(
          index: 1,
          icon: "assets/images/client/BottomNavImages/house.svg",
          label: 'home.unfurnished'.tr,
        ),
        _buildTabItem(
          index: 3,
          icon: "assets/images/client/hotel.svg",
          label: 'home.commercial'.tr,
        ),
      ],
    );
  }

  Widget _buildTabItem({
    required int index,
    required String icon,
    required String label,
  }) {
    final isSelected = _currentTabIndex == index;
    return GestureDetector(
      onTap: () {
        setState(() {
          _currentTabIndex = index;
          // Clear property type selection when switching tabs
          _controller.selectedLogementType.value = '';
        });
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SvgPicture.asset(
            icon,
            width: 24.r,
            height: 24.r,
            colorFilter: ColorFilter.mode(
              isSelected ? ClientTheme.primaryColor : Color(0xFF9CA3AF),
              BlendMode.srcIn,
            ),
          ),
          SizedBox(height: 6.h),
          Text(
            label,
            style: TextStyle(
              fontSize: 13.sp,
              fontWeight: FontWeight.w500,
              letterSpacing: -0.2,
              color: isSelected ? ClientTheme.primaryColor : Color(0xFF9CA3AF),
            ),
          ),
          SizedBox(height: 8.h),
          Container(
            height: 2.5.h,
            width: 70.w,
            decoration: BoxDecoration(
              color: isSelected ? ClientTheme.primaryColor : Colors.transparent,
              borderRadius: BorderRadius.circular(2.r),
            ),
          ),
        ],
      ),
    );
  }

  // ========== LOCATION CARD ==========
  Widget _buildLocationCard() {
    return Obx(() {
      final isExpanded = _controller.expandedFilter.value == 'location';
      final hasSelection = _controller.selectedLocation.value != null;
      
      return GestureDetector(
        onTap: () => _controller.toggleFilter('location'),
        child: AnimatedContainer(
          duration: Duration(milliseconds: 300),
          curve: Curves.easeInOut,
          padding: EdgeInsets.all(isExpanded ? 24.r : 16.r),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24.r),
            boxShadow: [
              BoxShadow(
                offset: Offset(0, 4),
                blurRadius: 24,
                spreadRadius: 0,
                color: Colors.black.withOpacity(0.08),
              ),
            ],
            border: hasSelection && !isExpanded
                ? Border.all(color: ClientTheme.primaryColor.withOpacity(0.3), width: 2)
                : null,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'search.where'.tr,
                          style: TextStyle(
                            fontSize: isExpanded ? 22.sp : 15.sp,
                            fontWeight: isExpanded ? FontWeight.w700 : FontWeight.w400,
                            letterSpacing: -0.5,
                            color: isExpanded ? Color(0xFF111827) : Color(0xFF6B7280),
                          ),
                        ),
                        if (!isExpanded && hasSelection) ...[
                          SizedBox(height: 4.h),
                          Text(
                            _controller.selectedLocation.value!['name'] as String,
                            style: TextStyle(
                              fontSize: 15.sp,
                              fontWeight: FontWeight.w600,
                              letterSpacing: -0.2,
                              color: ClientTheme.primaryColor,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ],
                    ),
                  ),
                  Icon(
                    isExpanded ? Icons.keyboard_arrow_up_rounded : Icons.keyboard_arrow_down_rounded,
                    size: 24.r,
                    color: Color(0xFF9CA3AF),
                  ),
                ],
              ),
              ClipRect(
                child: AnimatedSize(
                  duration: Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                  alignment: Alignment.topCenter,
                  child: isExpanded ? _buildLocationContent() : SizedBox.shrink(),
                ),
              ),
            ],
          ),
        ),
      );
    });
  }

  Widget _buildLocationContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 16.h),
        _buildSearchField(),
        SizedBox(height: 20.h),
        Text(
          'search.suggestions'.tr,
          style: TextStyle(
            fontSize: 13.sp,
            fontWeight: FontWeight.w400,
            letterSpacing: 0,
            color: Color(0xFF9CA3AF),
          ),
        ),
        SizedBox(height: 14.h),
        Obx(() => _buildSuggestionsList()),
      ],
    );
  }

  Widget _buildSearchField() {
    return Container(
      height: 52.h,
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(
          color: Color(0xFFE5E7EB),
          width: 1.2,
        ),
      ),
      child: Row(
        children: [
          Image.asset(
            "assets/images/client/BottomNavImages/search.png",
            width: 20.r,
            height: 20.r,
            color: Color(0xFF9CA3AF),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Obx(() => TextField(
              controller: _controller.searchController,
              textAlignVertical: TextAlignVertical.center,
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.w400,
                letterSpacing: -0.2,
                color: Color(0xFF111827),
              ),
              decoration: InputDecoration(
                hintText: 'home.start_search'.tr,
                hintStyle: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w400,
                  letterSpacing: -0.2,
                  color: Color(0xFF9CA3AF),
                ),
                border: InputBorder.none,
                contentPadding: EdgeInsets.zero,
                isDense: true,
                suffixIcon: _controller.searchText.value.isNotEmpty
                    ? GestureDetector(
                        onTap: _controller.clearSearch,
                        child: Icon(
                          Icons.clear,
                          size: 20.r,
                          color: Color(0xFF9CA3AF),
                        ),
                      )
                    : null,
              ),
            )),
          ),
        ],
      ),
    );
  }

  Widget _buildSuggestionsList() {
    if (_controller.isSearching.value) {
      return Column(
        children: List.generate(4, (index) => _buildShimmerTile()),
      );
    }

    if (_controller.searchText.value.isNotEmpty && _controller.searchResults.isNotEmpty) {
      return Column(
        children: _controller.searchResults
            .map((result) => _buildSearchResultTile(result))
            .toList(),
      );
    }

    // Show error message if there's an error
    if (_controller.searchError.value.isNotEmpty) {
      return _buildErrorWidget();
    }

    // Show no results message if searched but no results
    if (_controller.searchText.value.length >= 3 && _controller.searchResults.isEmpty) {
      return _buildNoResultsWidget();
    }

    return Column(
      children: _controller.suggestions
          .map((suggestion) => _buildSuggestionTile(suggestion))
          .toList(),
    );
  }

  Widget _buildShimmerTile() {
    return Padding(
      padding: EdgeInsets.only(bottom: 16.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ShimmerBox(width: 44.r, height: 44.r, borderRadius: 12.r),
          SizedBox(width: 14.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ShimmerBox(width: 120.w, height: 16.h, borderRadius: 4.r),
                SizedBox(height: 6.h),
                ShimmerBox(width: double.infinity, height: 14.h, borderRadius: 4.r),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNoResultsWidget() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 24.h),
      child: Center(
        child: Column(
          children: [
            Icon(
              Icons.search_off_rounded,
              size: 48.r,
              color: Color(0xFF9CA3AF),
            ),
            SizedBox(height: 12.h),
            Text(
              'search.no_results'.tr,
              style: TextStyle(
                fontSize: 15.sp,
                fontWeight: FontWeight.w500,
                color: Color(0xFF6B7280),
              ),
            ),
            SizedBox(height: 4.h),
            Text(
              'search.try_other_search'.tr,
              style: TextStyle(
                fontSize: 13.sp,
                fontWeight: FontWeight.w400,
                color: Color(0xFF9CA3AF),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorWidget() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 24.h),
      child: Center(
        child: Column(
          children: [
            Icon(
              Icons.wifi_off_rounded,
              size: 48.r,
              color: Color(0xFFEF4444),
            ),
            SizedBox(height: 12.h),
            Text(
              'search.connection_error'.tr,
              style: TextStyle(
                fontSize: 15.sp,
                fontWeight: FontWeight.w500,
                color: Color(0xFF6B7280),
              ),
            ),
            SizedBox(height: 4.h),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 32.w),
              child: Text(
                _controller.searchError.value,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w400,
                  color: Color(0xFF9CA3AF),
                ),
              ),
            ),
            SizedBox(height: 16.h),
            GestureDetector(
              onTap: () {
                _controller.onSearchChanged();
              },
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                decoration: BoxDecoration(
                  color: Color(0xFFF3F4F6),
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: Text(
                  'search.retry'.tr,
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w500,
                    color: Colors.black,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchResultTile(Map<String, dynamic> result) {
    final iconColor = Color(result['iconColor'] as int);
    final backgroundColor = Color(result['backgroundColor'] as int);
    final type = result['type'] as String;
    final isSelected = _controller.selectedLocation.value != null &&
        _controller.selectedLocation.value!['name'] == result['name'];

    return GestureDetector(
      onTap: () {
        _controller.selectLocation(result);
        if (widget.onLocationSelected != null) {
          widget.onLocationSelected!(result);
        }
      },
      child: AnimatedContainer(
        duration: Duration(milliseconds: 200),
        margin: EdgeInsets.only(bottom: 12.h),
        padding: EdgeInsets.all(12.r),
        decoration: BoxDecoration(
          color: isSelected ? ClientTheme.primaryColor.withOpacity(0.08) : Colors.transparent,
          borderRadius: BorderRadius.circular(16.r),
          border: isSelected
              ? Border.all(color: ClientTheme.primaryColor, width: 2)
              : Border.all(color: Colors.transparent, width: 2),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 44.r,
              height: 44.r,
              decoration: BoxDecoration(
                color: isSelected ? ClientTheme.primaryColor.withOpacity(0.2) : backgroundColor,
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Center(
                child: Icon(
                  _getIconForType(type),
                  size: 22.r,
                  color: isSelected ? ClientTheme.primaryColor : iconColor,
                ),
              ),
            ),
            SizedBox(width: 14.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    result['name'] as String,
                    style: TextStyle(
                      fontSize: 15.sp,
                      fontWeight: FontWeight.w600,
                      letterSpacing: -0.2,
                      color: isSelected ? ClientTheme.primaryColor : Color(0xFF111827),
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 3.h),
                  Text(
                    result['address'] as String,
                    style: TextStyle(
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w400,
                      letterSpacing: 0,
                      color: Color(0xFF9CA3AF),
                      height: 1.35,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            if (isSelected)
              Icon(
                Icons.check_circle,
                size: 22.r,
                color: ClientTheme.primaryColor,
              )
            else
              Icon(
                Icons.north_west,
                size: 16.r,
                color: Color(0xFFD1D5DB),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildSuggestionTile(Map<String, dynamic> suggestion) {
    final iconColor = Color(suggestion['iconColor'] as int);
    final backgroundColor = Color(suggestion['backgroundColor'] as int);
    final type = suggestion['type'] as String;
    final isSelected = _controller.selectedLocation.value != null &&
        _controller.selectedLocation.value!['name'] == suggestion['name'];

    return GestureDetector(
      onTap: () {
        // All suggestions are now selectable locations
        _controller.selectLocation(suggestion);
      },
      child: AnimatedContainer(
        duration: Duration(milliseconds: 200),
        margin: EdgeInsets.only(bottom: 12.h),
        padding: EdgeInsets.all(12.r),
        decoration: BoxDecoration(
          color: isSelected ? ClientTheme.primaryColor.withOpacity(0.08) : Colors.transparent,
          borderRadius: BorderRadius.circular(16.r),
          border: isSelected
              ? Border.all(color: ClientTheme.primaryColor, width: 2)
              : Border.all(color: Colors.transparent, width: 2),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 44.r,
              height: 44.r,
              decoration: BoxDecoration(
                color: isSelected ? ClientTheme.primaryColor.withOpacity(0.2) : backgroundColor,
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Center(
                child: _buildSuggestionIcon(type, isSelected ? ClientTheme.primaryColor : iconColor),
              ),
            ),
            SizedBox(width: 14.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    suggestion['name'] as String,
                    style: TextStyle(
                      fontSize: 15.sp,
                      fontWeight: FontWeight.w600,
                      letterSpacing: -0.2,
                      color: isSelected ? ClientTheme.primaryColor : Color(0xFF111827),
                    ),
                  ),
                  SizedBox(height: 3.h),
                  Text(
                    suggestion['address'] as String,
                    style: TextStyle(
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w400,
                      letterSpacing: 0,
                      color: Color(0xFF9CA3AF),
                      height: 1.35,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            if (isSelected)
              Icon(
                Icons.check_circle,
                size: 22.r,
                color: ClientTheme.primaryColor,
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildSuggestionIcon(String type, Color iconColor) {
    switch (type) {
      case 'nearby':
        return Container(
          width: 22.r,
          height: 22.r,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: iconColor, width: 2),
          ),
          child: Center(
            child: Container(
              width: 8.r,
              height: 8.r,
              decoration: BoxDecoration(
                color: iconColor,
                shape: BoxShape.circle,
              ),
            ),
          ),
        );
      case 'building':
        return Icon(
          Icons.apartment_rounded,
          size: 22.r,
          color: iconColor,
        );
      case 'star':
        return Container(
          width: 22.r,
          height: 22.r,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: iconColor, width: 2),
          ),
          child: Center(
            child: Icon(
              Icons.star_rounded,
              size: 14.r,
              color: iconColor,
            ),
          ),
        );
      default:
        return Icon(
          Icons.place_rounded,
          size: 22.r,
          color: iconColor,
        );
    }
  }

  IconData _getIconForType(String type) {
    switch (type) {
      case 'nearby':
        return Icons.my_location_rounded;
      case 'building':
        return Icons.apartment_rounded;
      case 'place':
        return Icons.place_rounded;
      case 'transport':
        return Icons.train_rounded;
      case 'monument':
        return Icons.account_balance_rounded;
      default:
        return Icons.place_rounded;
    }
  }

  // ========== DATE CARD ==========
  Widget _buildDateCard() {
    return Obx(() {
      final isExpanded = _controller.expandedFilter.value == 'date';
      final hasSelection = _controller.selectedDate.value != null;
      
      return GestureDetector(
        onTap: () => _controller.toggleFilter('date'),
        child: AnimatedContainer(
          duration: Duration(milliseconds: 300),
          curve: Curves.easeInOut,
          padding: EdgeInsets.all(isExpanded ? 24.r : 16.r),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(isExpanded ? 24.r : 16.r),
            boxShadow: [
              BoxShadow(
                offset: Offset(0, 4),
                blurRadius: isExpanded ? 24 : 12,
                spreadRadius: 0,
                color: Colors.black.withOpacity(0.08),
              ),
            ],
            border: hasSelection && !isExpanded
                ? Border.all(color: ClientTheme.primaryColor.withOpacity(0.3), width: 2)
                : null,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'search.when'.tr,
                        style: TextStyle(
                          fontSize: isExpanded ? 22.sp : 15.sp,
                          fontWeight: isExpanded ? FontWeight.w700 : FontWeight.w400,
                          letterSpacing: -0.2,
                          color: isExpanded ? Color(0xFF111827) : Color(0xFF6B7280),
                        ),
                      ),
                      if (!isExpanded && hasSelection) ...[
                        SizedBox(height: 4.h),
                        Text(
                          _controller.getFormattedDate(),
                          style: TextStyle(
                            fontSize: 15.sp,
                            fontWeight: FontWeight.w600,
                            letterSpacing: -0.2,
                            color: ClientTheme.primaryColor,
                          ),
                        ),
                      ],
                      if (!isExpanded && !hasSelection) ...[
                        SizedBox(height: 4.h),
                        Text(
                          'search.add_dates'.tr,
                          style: TextStyle(
                            fontSize: 15.sp,
                            fontWeight: FontWeight.w600,
                            letterSpacing: -0.2,
                            color: Color(0xFF111827),
                          ),
                        ),
                      ],
                    ],
                  ),
                  Icon(
                    isExpanded ? Icons.keyboard_arrow_up_rounded : Icons.keyboard_arrow_down_rounded,
                    size: 24.r,
                    color: Color(0xFF9CA3AF),
                  ),
                ],
              ),
              ClipRect(
                child: AnimatedSize(
                  duration: Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                  alignment: Alignment.topCenter,
                  child: isExpanded ? _buildDateContent() : SizedBox.shrink(),
                ),
              ),
            ],
          ),
        ),
      );
    });
  }

  Widget _buildDateContent() {
    final now = DateTime.now();
    final yesterday = now.subtract(Duration(days: 1));
    final tomorrow = now.add(Duration(days: 1));
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 20.h),
        // Quick options
        Text(
          'search.quick_options'.tr,
          style: TextStyle(
            fontSize: 13.sp,
            fontWeight: FontWeight.w400,
            color: Color(0xFF9CA3AF),
          ),
        ),
        SizedBox(height: 12.h),
        Wrap(
          spacing: 12.w,
          runSpacing: 12.h,
          children: [
            _buildQuickDateOption('search.yesterday'.tr, yesterday),
            _buildQuickDateOption('search.today'.tr, now),
            _buildQuickDateOption('search.tomorrow'.tr, tomorrow),
          ],
        ),
        SizedBox(height: 24.h),
        // Calendar picker
        Text(
          'search.choose_date'.tr,
          style: TextStyle(
            fontSize: 13.sp,
            fontWeight: FontWeight.w400,
            color: Color(0xFF9CA3AF),
          ),
        ),
        SizedBox(height: 12.h),
        _buildMonthYearCalendar(),
      ],
    );
  }

  Widget _buildQuickDateOption(String label, DateTime date) {
    return Obx(() {
      final isSelected = _controller.selectedDateLabel.value == label;
      
      return GestureDetector(
        onTap: () => _controller.selectDate(date, label),
        child: AnimatedContainer(
          duration: Duration(milliseconds: 200),
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
          decoration: BoxDecoration(
            color: isSelected ? ClientTheme.primaryColor : Colors.white,
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(
              color: isSelected ? ClientTheme.primaryColor : Color(0xFFE5E7EB),
              width: 1.5,
            ),
          ),
          child: Text(
            label,
            style: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.w600,
              color: isSelected ? Colors.white : Color(0xFF111827),
            ),
          ),
        ),
      );
    });
  }

  Widget _buildMonthYearCalendar() {
    final now = DateTime.now();
    final months = ['Janvier', 'Février', 'Mars', 'Avril', 'Mai', 'Juin', 
                    'Juillet', 'Août', 'Septembre', 'Octobre', 'Novembre', 'Décembre'];
    
    return Container(
      height: 280.h,
      child: Column(
        children: [
          // Month selector
          Container(
            height: 50.h,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: 12,
              separatorBuilder: (_, __) => SizedBox(width: 8.w),
              itemBuilder: (context, index) {
                // Start from current month
                final monthIndex = (now.month - 1 + index) % 12;
                final year = now.year + ((now.month - 1 + index) ~/ 12);
                final isCurrentMonth = monthIndex == now.month - 1 && year == now.year;
                
                return Obx(() {
                  final selectedDate = _controller.selectedDate.value;
                  final isSelected = selectedDate != null && 
                      selectedDate.month == monthIndex + 1 && 
                      selectedDate.year == year;
                  
                  return GestureDetector(
                    onTap: () {
                      // Select first day of month as default
                      _controller.selectDate(
                        DateTime(year, monthIndex + 1, 1),
                        '',
                      );
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                      decoration: BoxDecoration(
                        color: isSelected 
                            ? ClientTheme.primaryColor 
                            : isCurrentMonth 
                                ? ClientTheme.primaryColor.withOpacity(0.1) 
                                : Colors.white,
                        borderRadius: BorderRadius.circular(10.r),
                        border: Border.all(
                          color: isSelected || isCurrentMonth 
                              ? ClientTheme.primaryColor 
                              : Color(0xFFE5E7EB),
                          width: 1.5,
                        ),
                      ),
                      child: Text(
                        months[monthIndex],
                        style: TextStyle(
                          fontSize: 13.sp,
                          fontWeight: FontWeight.w600,
                          color: isSelected 
                              ? Colors.white 
                              : isCurrentMonth 
                                  ? ClientTheme.primaryColor 
                                  : Color(0xFF111827),
                        ),
                      ),
                    ),
                  );
                });
              },
            ),
          ),
          SizedBox(height: 16.h),
          // Days grid
          Expanded(
            child: Obx(() {
              final selectedDate = _controller.selectedDate.value;
              final displayMonth = selectedDate?.month ?? now.month;
              final displayYear = selectedDate?.year ?? now.year;
              final daysInMonth = DateTime(displayYear, displayMonth + 1, 0).day;
              final firstDayOfWeek = DateTime(displayYear, displayMonth, 1).weekday;
              
              return GridView.builder(
                physics: NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 7,
                  mainAxisSpacing: 8.h,
                  crossAxisSpacing: 8.w,
                  childAspectRatio: 1,
                ),
                itemCount: 42, // 6 weeks * 7 days
                itemBuilder: (context, index) {
                  // Header row for weekday names
                  if (index < 7) {
                    final weekDays = ['L', 'M', 'M', 'J', 'V', 'S', 'D'];
                    return Center(
                      child: Text(
                        weekDays[index],
                        style: TextStyle(
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF9CA3AF),
                        ),
                      ),
                    );
                  }
                  
                  final dayIndex = index - 7 - (firstDayOfWeek - 1);
                  if (dayIndex < 0 || dayIndex >= daysInMonth) {
                    return SizedBox.shrink();
                  }
                  
                  final day = dayIndex + 1;
                  final thisDate = DateTime(displayYear, displayMonth, day);
                  final isToday = thisDate.day == now.day && 
                      thisDate.month == now.month && 
                      thisDate.year == now.year;
                  final isSelected = selectedDate != null &&
                      selectedDate.day == day &&
                      selectedDate.month == displayMonth &&
                      selectedDate.year == displayYear;
                  final isPast = thisDate.isBefore(DateTime(now.year, now.month, now.day));
                  
                  return GestureDetector(
                    onTap: () {
                      if (!isPast || isToday) {
                        _controller.selectDate(thisDate, '');
                      }
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: isSelected 
                            ? ClientTheme.primaryColor 
                            : isToday 
                                ? ClientTheme.primaryColor.withOpacity(0.15) 
                                : Colors.transparent,
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                      child: Center(
                        child: Text(
                          '$day',
                          style: TextStyle(
                            fontSize: 14.sp,
                            fontWeight: isSelected || isToday ? FontWeight.w700 : FontWeight.w500,
                            color: isSelected 
                                ? Colors.white 
                                : isPast && !isToday
                                    ? Color(0xFFD1D5DB)
                                    : isToday 
                                        ? ClientTheme.primaryColor 
                                        : Color(0xFF111827),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              );
            }),
          ),
        ],
      ),
    );
  }

  // ========== LOGEMENT TYPE CARD ==========
  Widget _buildLogementTypeCard() {
    return Obx(() {
      final isExpanded = _controller.expandedFilter.value == 'type';
      final hasSelection = _controller.selectedLogementType.value.isNotEmpty;
      
      return GestureDetector(
        onTap: () => _controller.toggleFilter('type'),
        child: AnimatedContainer(
          duration: Duration(milliseconds: 300),
          curve: Curves.easeInOut,
          padding: EdgeInsets.all(isExpanded ? 24.r : 16.r),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(isExpanded ? 24.r : 16.r),
            boxShadow: [
              BoxShadow(
                offset: Offset(0, 4),
                blurRadius: isExpanded ? 24 : 12,
                spreadRadius: 0,
                color: Colors.black.withOpacity(0.08),
              ),
            ],
            border: hasSelection && !isExpanded
                ? Border.all(color: ClientTheme.primaryColor.withOpacity(0.3), width: 2)
                : null,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'search.property_type'.tr,
                        style: TextStyle(
                          fontSize: isExpanded ? 22.sp : 15.sp,
                          fontWeight: isExpanded ? FontWeight.w700 : FontWeight.w400,
                          letterSpacing: -0.2,
                          color: isExpanded ? Color(0xFF111827) : Color(0xFF6B7280),
                        ),
                      ),
                      if (!isExpanded && hasSelection) ...[
                        SizedBox(height: 4.h),
                        Text(
                          _controller.getLogementTypeLabel(),
                          style: TextStyle(
                            fontSize: 15.sp,
                            fontWeight: FontWeight.w600,
                            letterSpacing: -0.2,
                            color: ClientTheme.primaryColor,
                          ),
                        ),
                      ],
                      if (!isExpanded && !hasSelection) ...[
                        SizedBox(height: 4.h),
                        Text(
                          'search.add_types'.tr,
                          style: TextStyle(
                            fontSize: 15.sp,
                            fontWeight: FontWeight.w600,
                            letterSpacing: -0.2,
                            color: Color(0xFF111827),
                          ),
                        ),
                      ],
                    ],
                  ),
                  Icon(
                    isExpanded ? Icons.keyboard_arrow_up_rounded : Icons.keyboard_arrow_down_rounded,
                    size: 24.r,
                    color: Color(0xFF9CA3AF),
                  ),
                ],
              ),
              ClipRect(
                child: AnimatedSize(
                  duration: Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                  alignment: Alignment.topCenter,
                  child: isExpanded ? _buildLogementTypeContent() : SizedBox.shrink(),
                ),
              ),
            ],
          ),
        ),
      );
    });
  }

  Widget _buildLogementTypeContent() {
    final propertyTypes = _controller.getPropertyTypesForTab(_currentTabIndex);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 20.h),
        Text(
          'search.select_type'.tr,
          style: TextStyle(
            fontSize: 13.sp,
            fontWeight: FontWeight.w400,
            color: Color(0xFF9CA3AF),
          ),
        ),
        SizedBox(height: 16.h),
        Wrap(
          spacing: 12.w,
          runSpacing: 12.h,
          children: propertyTypes.map((type) {
            return _buildLogementTypeChip(type);
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildLogementTypeChip(Map<String, dynamic> type) {
    return Obx(() {
      final isSelected = _controller.selectedLogementType.value == type['id'];
      
      return GestureDetector(
        onTap: () => _controller.selectLogementType(type['id'] as String),
        child: AnimatedContainer(
          duration: Duration(milliseconds: 200),
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
          decoration: BoxDecoration(
            color: isSelected ? ClientTheme.primaryColor : Colors.white,
            borderRadius: BorderRadius.circular(14.r),
            border: Border.all(
              color: isSelected ? ClientTheme.primaryColor : Color(0xFFE5E7EB),
              width: 1.5,
            ),
            boxShadow: isSelected
                ? [
                    BoxShadow(
                      color: ClientTheme.primaryColor.withOpacity(0.3),
                      blurRadius: 8,
                      offset: Offset(0, 4),
                    ),
                  ]
                : null,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                type['icon'] as IconData,
                size: 20.r,
                color: isSelected ? Colors.white : Color(0xFF6B7280),
              ),
              SizedBox(width: 8.w),
              Text(
                type['label'] as String,
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                  color: isSelected ? Colors.white : Color(0xFF111827),
                ),
              ),
              if (isSelected) ...[
                SizedBox(width: 8.w),
                Icon(
                  Icons.check_circle,
                  size: 18.r,
                  color: Colors.white,
                ),
              ],
            ],
          ),
        ),
      );
    });
  }

  // ========== BOTTOM ACTIONS ==========
  Widget _buildBottomActions() {
    return Row(
      children: [
        GestureDetector(
          onTap: () {
            _controller.clearAllFilters();
          },
          child: Text(
            'search.clear_all'.tr,
            style: TextStyle(
              fontSize: 15.sp,
              fontWeight: FontWeight.w600,
              letterSpacing: -0.2,
              color: Color(0xFF111827),
              decoration: TextDecoration.underline,
              decorationColor: Color(0xFF111827),
              decorationThickness: 1.5,
            ),
          ),
        ),
        Spacer(),
        GestureDetector(
          onTap: () {
            // Trigger search action with all filters
            final filters = {
              'location': _controller.selectedLocation.value,
              'date': _controller.selectedDate.value,
              'logementType': _controller.selectedLogementType.value,
              'tabIndex': _currentTabIndex,
            };
            print("Search with filters: $filters");
            
            // Call the callback if provided (for refresh from result_search)
            if (widget.onLocationSelected != null && _controller.selectedLocation.value != null) {
              widget.onLocationSelected!(_controller.selectedLocation.value!);
            }
            
            Navigator.of(context).pop();
            
            // Check if we're already on the result search page
            if (Get.currentRoute == RouteNames.clientResultSearch) {
              // Refresh the existing controller
              final resultController = Get.find<ResultSearchController>();
              resultController.refreshSearch(filters);
            } else {
              // Navigate to result search page
              Get.toNamed(RouteNames.clientResultSearch, arguments: filters);
            }
          },
          child: Container(
            height: 48.h,
            padding: EdgeInsets.symmetric(horizontal: 24.w),
            decoration: BoxDecoration(
              color: ClientTheme.primaryColor,
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  "assets/images/client/BottomNavImages/search.png",
                  width: 18.r,
                  height: 18.r,
                  color: Colors.white,
                ),
                SizedBox(width: 10.w),
                Text(
                  'search.search_button'.tr,
                  style: TextStyle(
                    fontSize: 15.sp,
                    fontWeight: FontWeight.w600,
                    letterSpacing: -0.2,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
