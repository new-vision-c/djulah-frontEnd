import 'dart:math';

import 'package:djulah/domain/entities/amenity.dart';
import 'package:djulah/domain/entities/logement.dart';
import 'package:djulah/domain/entities/review.dart';
import 'package:djulah/infrastructure/navigation/route_names.dart';
import 'package:djulah/presentation/components/buttons/primary_button.widget.dart';
import 'package:djulah/presentation/components/buttons/secondary_button.widget.dart';
import 'package:djulah/presentation/components/buttons/text_link_button.widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../generated/assets.dart';
import '../../../infrastructure/theme/client_theme.dart';
import '../../components/carousel_fade/carousel_fade.widget.dart';
import '../components/map.dart';
import 'controllers/details_logement.controller.dart';

class DetailsLogementScreen extends GetView<DetailsLogementController> {
  const DetailsLogementScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        top: false,
        bottom: true,
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              expandedHeight: 362.h,
              toolbarHeight: 50.h,
              backgroundColor: Colors.white,
              surfaceTintColor: Colors.white,
              automaticallyImplyLeading: false,
              leadingWidth: 0,
              titleSpacing: 0,
              centerTitle: false,
              pinned: true,
              floating: false,
              stretch: true,
              title: Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(horizontal: 16.r),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildHeaderButton(Icons.arrow_back, () => Get.back()),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        _buildHeaderButton(Icons.share_outlined, () => controller.shareLogement()),
                        SizedBox(width: 8.w),
                        _buildFavoriteButton(),
                      ],
                    ),
                  ],
                ),
              ),
              flexibleSpace: FlexibleSpaceBar(
                collapseMode: CollapseMode.pin,
                background: Stack(
                  fit: StackFit.expand,
                  children: [
                    CarouselFadeWidget(
                      showIndicator: true,
                      width: double.infinity,
                      height: 400.h,
                      children: _buildCarouselImages(),
                    ),
                    Positioned(
                      bottom: 0,
                      left: 0,
                      right: 0,
                      child: Container(
                        height: 15.h,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.vertical(
                            top: Radius.circular(30.r),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.r, vertical: 20.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildTitleSection(),
                    _buildHostSection(),
                    _buildDescriptionSection(),
                    _buildAmenitiesSection(),
                    _buildMapSection(),
                    SizedBox(height: 28.h),
                    Divider(color: const Color(0xFFE8E8E8), thickness: 1.r),
                    SizedBox(height: 28.h),
                    _buildReviewsSection(),
                    SizedBox(height: 28.h),
                    Divider(color: const Color(0xFFE8E8E8), thickness: 1.r),
                    SizedBox(height: 28.h),
                    _buildHostInfoSection(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: EdgeInsets.only(bottom: MediaQuery.of(context).padding.bottom),
        child: Container(
          height: 100.h,
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border(top: BorderSide(color: Color(0xFFE8E8E8), width: 1.r)),
          ),
          padding: EdgeInsets.symmetric(horizontal: 20.r, vertical: 24.r),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            spacing: 8.r,
            children: [
              SizedBox.square(
                dimension: 24.r,
                child: Image.asset("assets/images/client/badge-dollar-sign.png", fit: BoxFit.cover),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    controller.propriete?.priceText ?? "Prix non disponible",
                    style: TextStyle(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w600,
                      letterSpacing: -0.9.r,
                      height: 24.sp / 18.sp,
                      color: Colors.black,
                    ),
                  ),
                  Text(
                    "Réservez maintenant",
                    style: TextStyle(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w400,
                      letterSpacing: -0.36.r,
                      height: 16.sp / 12.sp,
                      color: ClientTheme.textTertiaryColor,
                    ),
                  ),
                ],
              ),
              Spacer(),
              PrimaryButton(
                text: "Réserver",
                width: 146.w,
                onPressed: () {
                  Get.toNamed(RouteNames.clientReservationSteps);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTitleSection() {
    final logement = controller.propriete;
    return Column(
      children: [
        Text(
          logement?.title ?? "Logement",
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 24.sp,
            fontWeight: FontWeight.w600,
            height: 1.2,
          ),
        ),
        SizedBox(height: 12.h),
        Text(
          "${logement?.category ?? 'Logement'} · ${logement?.location.shortAddress ?? 'Cameroun'}",
          style: TextStyle(
            fontSize: 12.sp,
            color: ClientTheme.textTertiaryColor,
          ),
        ),
        SizedBox(height: 8.h),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.star, color: const Color(0xFFF6BC2F), size: 14.r),
            Text(
              " ${logement?.rating ?? 0} · ${logement?.reviewCount ?? 0} commentaires",
              style: TextStyle(
                fontSize: 12.sp,
                color: ClientTheme.textTertiaryColor,
              ),
            ),
          ],
        ),
        SizedBox(height: 28.h),
      ],
    );
  }

  Widget _buildHostSection() {
    final host = controller.propriete?.host;
    return Column(
      children: [
        Divider(color: const Color(0xFFE8E8E8)),
        Padding(
          padding: EdgeInsets.symmetric(vertical: 28.h),
          child: Row(
            children: [
              ClipOval(
                child: Image.asset(
                  host?.avatarPath ?? Assets.avatarAvatarProfil,
                  width: 48.r,
                  height: 48.r,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Image.asset(
                    Assets.avatarAvatarProfil,
                    width: 48.r,
                    height: 48.r,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              SizedBox(width: 12.w),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Hôte : ${host?.name ?? 'Hôte Djulah'}",
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    "Hôte depuis ${host?.yearsAsHost ?? 1} an${(host?.yearsAsHost ?? 1) > 1 ? 's' : ''}",
                    style: TextStyle(
                      fontSize: 12.sp,
                      color: const Color(0xFF4B4B4B),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        Divider(color: const Color(0xFFE8E8E8)),
      ],
    );
  }

  Widget _buildDescriptionSection() {
    final logement = controller.propriete;
    final description = logement?.description ?? '';
    final hasDescription = description.isNotEmpty;
    final hasLongDescription = description.length > 150;
    
    if (!hasDescription) {
      return const SizedBox.shrink();
    }
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 28.h),
        Text(
          description,
          maxLines: hasLongDescription ? 4 : null,
          overflow: hasLongDescription ? TextOverflow.ellipsis : null,
          style: TextStyle(
            fontSize: 14.sp,
            color: ClientTheme.textTertiaryColor,
            height: 1.5,
          ),
        ),
        if (hasLongDescription) ...[
          SizedBox(height: 16.h),
          PrimaryButton(
            text: "Lire la suite",
            textColor: Colors.black,
            backgroundColor: const Color(0xFFF3F3F3),
            onPressed: () => _showFullDescription(description),
          ),
        ],
        SizedBox(height: 28.h),
        Divider(color: const Color(0xFFE8E8E8)),
      ],
    );
  }

  void _showFullDescription(String description) {
    Get.bottomSheet(
      Container(
        padding: EdgeInsets.all(24.r),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "À propos de ce logement",
                  style: TextStyle(
                    fontSize: 20.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                IconButton(
                  onPressed: () => Get.back(),
                  icon: Icon(Icons.close),
                ),
              ],
            ),
            SizedBox(height: 16.h),
            Flexible(
              child: SingleChildScrollView(
                child: Text(
                  description,
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: ClientTheme.textTertiaryColor,
                    height: 1.6,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      isScrollControlled: true,
    );
  }

  Widget _buildAmenitiesSection() {
    final amenities = controller.propriete?.amenities ?? [];
    final displayAmenities = amenities.take(4).toList();
    final totalAmenities = amenities.length;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 28.h),
        Text(
          "Ce que propose ce logement",
          style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.w600),
        ),
        SizedBox(height: 24.h),
        if (displayAmenities.isEmpty)
          ..._buildDefaultAmenities()
        else
          ...displayAmenities.map((amenity) => _buildAmenityItem(
                _getAmenityIcon(amenity.id),
                amenity.name,
              )),
        SizedBox(height: 24.h),
        if (totalAmenities > 4)
          PrimaryButton(
            text: "Afficher les $totalAmenities équipements",
            textColor: Colors.black,
            backgroundColor: const Color(0xFFF3F3F3),
            onPressed: () => _showAllAmenities(amenities),
          ),
        SizedBox(height: 28.h),
      ],
    );
  }

  String _getAmenityIcon(String amenityId) {
    switch (amenityId) {
      case 'wifi':
        return Assets.propositionLogementWifi;
      case 'kitchen':
        return Assets.propositionLogementCooking;
      case 'tv':
        return Assets.propositionLogementTvMinimal;
      case 'parking':
        return Assets.propositionLogementCarFront;
      default:
        return Assets.propositionLogementWifi;
    }
  }

  void _showAllAmenities(List<Amenity> amenities) {
    Get.bottomSheet(
      Container(
        padding: EdgeInsets.all(24.r),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Ce que propose ce logement",
                  style: TextStyle(
                    fontSize: 20.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                IconButton(
                  onPressed: () => Get.back(),
                  icon: Icon(Icons.close),
                ),
              ],
            ),
            SizedBox(height: 16.h),
            Flexible(
              child: SingleChildScrollView(
                child: Column(
                  children: amenities
                      .map((a) => _buildAmenityItem(_getAmenityIcon(a.id), a.name))
                      .toList(),
                ),
              ),
            ),
          ],
        ),
      ),
      isScrollControlled: true,
    );
  }

  List<Widget> _buildDefaultAmenities() {
    return [
      _buildAmenityItem(Assets.propositionLogementCooking, "Cuisine"),
      _buildAmenityItem(Assets.propositionLogementWifi, "Wifi"),
      _buildAmenityItem(Assets.propositionLogementTvMinimal, "Télévision"),
      _buildAmenityItem(Assets.propositionLogementCarFront, "Parking gratuit sur place"),
    ];
  }

  Widget _buildAmenityItem(String icon, String label) {
    return Padding(
      padding: EdgeInsets.only(bottom: 20.h),
      child: Row(
        children: [
          Image.asset(
            icon,
            width: 24.r,
            height: 24.r,
            errorBuilder: (_, __, ___) => Icon(Icons.check_circle_outline, size: 24.r),
          ),
          SizedBox(width: 12.w),
          Text(
            label,
            style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }

  Widget _buildMapSection() {
    final location = controller.propriete?.location;
    final hasLocation = location != null && location.latitude != 0 && location.longitude != 0;
    
    String displayAddress = 'Cameroun';
    if (location != null) {
      final parts = <String>[];
      if (location.neighborhood != null && location.neighborhood!.isNotEmpty) {
        parts.add(location.neighborhood!);
      }
      parts.add(location.city);
      parts.add(location.country);
      displayAddress = parts.join(', ');
    }
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Divider(color: const Color(0xFFE8E8E8), thickness: 1.r),
        SizedBox(height: 28.h),
        Text(
          "Où se trouve ce logement",
          style: TextStyle(
            fontSize: 20.sp,
            fontWeight: FontWeight.w600,
            letterSpacing: -1.r,
          ),
        ),
        SizedBox(height: 8.h),
        Text(
          displayAddress,
          style: TextStyle(
            fontSize: 14.sp,
            color: ClientTheme.textTertiaryColor,
          ),
        ),
        SizedBox(height: 28.h),
        if (hasLocation)
          MapWidget(
            latitude: location.latitude,
            longitude: location.longitude,
            height: 400,
            markerColor: Colors.black,
            overlayOpacity: 0.2,
          )
        else
          Container(
            height: 200.h,
            decoration: BoxDecoration(
              color: const Color(0xFFF3F3F3),
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.location_off, size: 40.r, color: ClientTheme.textTertiaryColor),
                  SizedBox(height: 8.h),
                  Text(
                    'Localisation non disponible',
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: ClientTheme.textTertiaryColor,
                    ),
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildReviewsSection() {
    final logement = controller.propriete;
    final reviews = logement?.reviews ?? [];
    final reviewCount = (logement?.reviewCount ?? 0) > 0 ? logement!.reviewCount : reviews.length;
    final rating = logement?.rating ?? 0.0;
    final hasReviews = reviews.isNotEmpty;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          spacing: 8.r,
          children: [
            Icon(
              rating > 0 ? Icons.star : Icons.star_border,
              color: Colors.black,
              size: 25.r,
            ),
            Text(
              reviewCount > 0
                  ? "${rating.toStringAsFixed(1).replaceAll('.', ',')} - $reviewCount commentaire${reviewCount > 1 ? 's' : ''}"
                  : "Aucun commentaire",
              style: TextStyle(
                fontSize: 20.sp,
                fontWeight: FontWeight.w600,
                letterSpacing: -1.r,
              ),
            ),
          ],
        ),
        SizedBox(height: 16.h),
        if (!hasReviews)
          _buildEmptyReviews()
        else
          SizedBox(
            height: 212.h,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              shrinkWrap: true,
              itemCount: reviews.length.clamp(0, 3),
              separatorBuilder: (_, __) => Row(
                children: [
                  SizedBox(width: 24.w),
                  VerticalDivider(color: const Color(0xFFE8E8E8), thickness: 1.r),
                  SizedBox(width: 24.w),
                ],
              ),
              itemBuilder: (context, index) => _buildReviewCard(reviews[index]),
            ),
          ),
        SizedBox(height: 22.h),
        if (reviewCount > 0)
          PrimaryButton(
            text: "Afficher les $reviewCount commentaires",
            textColor: Colors.black,
            backgroundColor: const Color(0xFFF3F3F3),
            onPressed: () => _showAllReviews(reviews),
          ),
      ],
    );
  }

  Widget _buildEmptyReviews() {
    return Container(
      padding: EdgeInsets.all(24.r),
      child: Center(
        child: Text(
          "Aucun commentaire pour le moment",
          style: TextStyle(
            fontSize: 14.sp,
            color: ClientTheme.textTertiaryColor,
          ),
        ),
      ),
    );
  }

  Widget _buildReviewCard(Review review) {
    return SizedBox(
      width: 308.w,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            spacing: 4.r,
            children: [
              ...List.generate(
                5,
                (index) => Icon(
                  index < review.rating.floor() ? Icons.star : Icons.star_border,
                  color: const Color(0xFFF6BC2F),
                  size: 12.r,
                ),
              ),
              Text(
                " · ${review.relativeDate}",
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w400,
                  letterSpacing: -0.42.r,
                  height: 20.sp / 14.sp,
                  color: ClientTheme.textTertiaryColor,
                ),
              ),
            ],
          ),
          SizedBox(height: 8.h),
          Text(
            review.excerpt,
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: ClientTheme.textTertiaryColor,
              letterSpacing: -0.42.r,
              height: 20.sp / 14.sp,
              fontSize: 14.sp,
              fontWeight: FontWeight.w400,
            ),
          ),
          SizedBox(height: 16.h),
          if (review.comment.length > 100)
            TextLinkButton(
              text: "Afficher tout le message",
              underline: true,
              fontSize: 14.sp,
              textColor: Colors.black,
              fontWeight: FontWeight.w500,
            ),
          Spacer(),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              ClipOval(
                child: Image.asset(
                  review.authorAvatarPath,
                  width: 48.r,
                  height: 48.r,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Image.asset(
                    Assets.avatarAvatarProfil,
                    width: 48.r,
                    height: 48.r,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              SizedBox(width: 12.w),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    review.authorName,
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    review.relativeDate,
                    style: TextStyle(
                      fontSize: 12.sp,
                      color: const Color(0xFF4B4B4B),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _showAllReviews(List<Review> reviews) {
    Get.bottomSheet(
      Container(
        height: Get.height * 0.8,
        padding: EdgeInsets.all(24.r),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "${reviews.length} commentaires",
                  style: TextStyle(
                    fontSize: 20.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                IconButton(
                  onPressed: () => Get.back(),
                  icon: Icon(Icons.close),
                ),
              ],
            ),
            SizedBox(height: 16.h),
            Expanded(
              child: ListView.separated(
                itemCount: reviews.length,
                separatorBuilder: (_, __) => Divider(height: 32.h),
                itemBuilder: (context, index) {
                  final review = reviews[index];
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          ClipOval(
                            child: Image.asset(
                              review.authorAvatarPath,
                              width: 48.r,
                              height: 48.r,
                              fit: BoxFit.cover,
                              errorBuilder: (_, __, ___) => Image.asset(
                                Assets.avatarAvatarProfil,
                                width: 48.r,
                                height: 48.r,
                              ),
                            ),
                          ),
                          SizedBox(width: 12.w),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                review.authorName,
                                style: TextStyle(
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              Row(
                                children: [
                                  ...List.generate(
                                    5,
                                    (i) => Icon(
                                      i < review.rating.floor()
                                          ? Icons.star
                                          : Icons.star_border,
                                      color: const Color(0xFFF6BC2F),
                                      size: 12.r,
                                    ),
                                  ),
                                  Text(
                                    " · ${review.relativeDate}",
                                    style: TextStyle(
                                      fontSize: 12.sp,
                                      color: const Color(0xFF4B4B4B),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                      SizedBox(height: 12.h),
                      Text(
                        review.comment,
                        style: TextStyle(
                          fontSize: 14.sp,
                          color: ClientTheme.textTertiaryColor,
                          height: 1.5,
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
      isScrollControlled: true,
    );
  }

  Widget _buildHostInfoSection() {
    final host = controller.propriete?.host;
    final hostName = host?.name ?? 'Hôte Djulah';
    final hostAvatar = host?.avatarPath ?? Assets.avatarAvatarProfil;
    final totalReviews = host?.totalReviews ?? 0;
    final globalRating = host?.globalRating ?? 0.0;
    final yearsAsHost = host?.yearsAsHost ?? 1;
    final language = host?.language ?? 'Français';
    final responseRate = host?.responseRate ?? 99;
    final responseTime = host?.responseTime ?? "dans l'heure";

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Faites connaissance avec votre hôte",
          style: TextStyle(
            fontSize: 20.sp,
            fontWeight: FontWeight.w600,
            letterSpacing: -1.r,
          ),
        ),
        SizedBox(height: 18.h),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16.r),
            boxShadow: [
              const BoxShadow(
                offset: Offset(0, 0),
                blurRadius: 17.2,
                spreadRadius: 6,
                color: Color.fromRGBO(0, 0, 0, 0.05),
              ),
              const BoxShadow(
                offset: Offset(0, 5),
                blurRadius: 5,
                spreadRadius: 0,
                color: Color.fromRGBO(201, 201, 201, 0.15),
              ),
            ],
          ),
          padding: EdgeInsets.all(24.r),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: EdgeInsets.all(20.r),
                child: Column(
                  children: [
                    ClipOval(
                      child: SizedBox.square(
                        dimension: 64.r,
                        child: Image.asset(
                          hostAvatar,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => Image.asset(
                            Assets.avatarAvatarProfil,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 8.h),
                    Text(
                      hostName,
                      style: TextStyle(
                        fontSize: 24.sp,
                        fontWeight: FontWeight.w600,
                        letterSpacing: -1.2.r,
                        height: 32.sp / 24.sp,
                        color: Colors.black,
                      ),
                    ),
                    Text(
                      "Hôte",
                      style: TextStyle(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w400,
                        letterSpacing: -0.36.r,
                        height: 16.sp / 12.sp,
                        color: ClientTheme.textTertiaryColor,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(width: 40.w),
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "$totalReviews",
                      style: TextStyle(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.w600,
                        letterSpacing: -0.9.r,
                        height: 24.sp / 18.sp,
                        color: Colors.black,
                      ),
                    ),
                    Text(
                      "évaluations",
                      style: TextStyle(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w400,
                        letterSpacing: -0.36.r,
                        height: 16.sp / 12.sp,
                        color: ClientTheme.textTertiaryColor,
                      ),
                    ),
                    SizedBox(height: 8.h),
                    Divider(color: const Color(0xFFE8E8E8), thickness: 1.r),
                    SizedBox(height: 8.h),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          globalRating.toStringAsFixed(1).replaceAll('.', ','),
                          style: TextStyle(
                            fontSize: 18.sp,
                            fontWeight: FontWeight.w600,
                            letterSpacing: -0.9.r,
                            height: 24.sp / 18.sp,
                            color: Colors.black,
                          ),
                        ),
                        Icon(Icons.star, color: Colors.black, size: 16.r),
                      ],
                    ),
                    Text(
                      "Note globale",
                      style: TextStyle(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w400,
                        letterSpacing: -0.36.r,
                        height: 16.sp / 12.sp,
                        color: ClientTheme.textTertiaryColor,
                      ),
                    ),
                    SizedBox(height: 8.h),
                    Divider(color: const Color(0xFFE8E8E8), thickness: 1.r),
                    SizedBox(height: 8.h),
                    Text(
                      "$yearsAsHost an${yearsAsHost > 1 ? 's' : ''}",
                      style: TextStyle(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.w600,
                        letterSpacing: -0.9.r,
                        height: 24.sp / 18.sp,
                        color: Colors.black,
                      ),
                    ),
                    Text(
                      "En tant qu'hôte",
                      style: TextStyle(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w400,
                        letterSpacing: -0.36.r,
                        height: 16.sp / 12.sp,
                        color: ClientTheme.textTertiaryColor,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 28.h),
        Row(
          spacing: 4.r,
          children: [
            SizedBox.square(
              dimension: 24.r,
              child: Image.asset(Assets.clientLanguageSquare, fit: BoxFit.cover),
            ),
            Text(
              "Langue parlée par l'hôte :",
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.w400,
                letterSpacing: -0.42.r,
                height: 20.sp / 14.sp,
                color: ClientTheme.textTertiaryColor,
              ),
            ),
            Flexible(
              child: Text(
                language,
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w400,
                  letterSpacing: -0.42.r,
                  height: 20.sp / 14.sp,
                  color: Colors.black,
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 28.h),
        PrimaryButton(
          text: "Envoyer un message à l'hôte",
          textColor: Colors.black,
          backgroundColor: const Color(0xFFF3F3F3),
          onPressed: () {
          },
        ),
        SizedBox(height: 28.h),
        Text(
          "Taux de réponse : $responseRate%\nL'hôte répond généralement $responseTime",
          style: TextStyle(
            fontSize: 14.sp,
            fontWeight: FontWeight.w500,
            letterSpacing: -0.7.r,
            height: 20.sp / 14.sp,
            color: Colors.black,
          ),
        ),
        SizedBox(height: 20.h),
        Row(
          children: [
            SizedBox.square(
              dimension: 32.r,
              child: Image.asset(
                "assets/images/client/warning-2.png",
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(width: 22.w),
            Expanded(
              child: Text(
                "Afin de protéger votre paiement, utilisez toujours Djulah pour envoyer de l'argent et communiquer avec les hôtes",
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w400,
                  letterSpacing: -0.36.r,
                  height: 16.sp / 12.sp,
                  color: Colors.black,
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 28.h),
      ],
    );
  }


  List<Widget> _buildCarouselImages() {
    final images = controller.propriete?.allImages ?? [
      'assets/images/client/imagesSplash/1.jpg',
      'assets/images/client/imagesSplash/2.jpg',
      'assets/images/client/imagesSplash/3.jpg',
      'assets/images/client/imagesSplash/4.jpg',
    ];

    return images
        .map((imagePath) => Image.asset(
              imagePath,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => Image.asset(
                'assets/images/client/imagesSplash/1.jpg',
                fit: BoxFit.cover,
              ),
            ))
        .toList();
  }

  Widget _buildHeaderButton(IconData icon, VoidCallback onTap) {
    return IconButton(
      onPressed: onTap,
      icon: ClipOval(
        child: Container(
          height: 36.r,
          width: 36.r,
          alignment: Alignment.center,
          color: Colors.white,
          child: Icon(icon, color: ClientTheme.primaryColor, size: 22.r),
        ),
      ),
    );
  }

  Widget _buildFavoriteButton() {
    return Obx(() {
      final isFav = controller.isFavorite.value;
      return GestureDetector(
        onTap: controller.toggleFavorite,
        child: ClipOval(
          child: Container(
            height: 36.r,
            width: 36.r,
            alignment: Alignment.center,
            color: Colors.white,
            child: TweenAnimationBuilder<double>(
              tween: Tween<double>(begin: 1.0, end: 1.0),
              duration: const Duration(milliseconds: 300),
              curve: Curves.elasticOut,
              builder: (context, scale, child) {
                return AnimatedScale(
                  scale: 1.0,
                  duration: const Duration(milliseconds: 150),
                  child: _HeartBeatAnimation(
                    isActive: isFav,
                    child: Icon(
                      isFav ? Icons.favorite : Icons.favorite_border,
                      color: isFav ? Colors.red : ClientTheme.primaryColor,
                      size: 22.r,
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      );
    });
  }
}

class _HeartBeatAnimation extends StatefulWidget {
  final bool isActive;
  final Widget child;

  const _HeartBeatAnimation({
    required this.isActive,
    required this.child,
  });

  @override
  State<_HeartBeatAnimation> createState() => _HeartBeatAnimationState();
}

class _HeartBeatAnimationState extends State<_HeartBeatAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  bool _wasActive = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );

    _scaleAnimation = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween<double>(begin: 1.0, end: 1.3)
            .chain(CurveTween(curve: Curves.easeOut)),
        weight: 30,
      ),
      TweenSequenceItem(
        tween: Tween<double>(begin: 1.3, end: 0.9)
            .chain(CurveTween(curve: Curves.easeInOut)),
        weight: 20,
      ),
      TweenSequenceItem(
        tween: Tween<double>(begin: 0.9, end: 1.15)
            .chain(CurveTween(curve: Curves.easeInOut)),
        weight: 25,
      ),
      TweenSequenceItem(
        tween: Tween<double>(begin: 1.15, end: 1.0)
            .chain(CurveTween(curve: Curves.easeIn)),
        weight: 25,
      ),
    ]).animate(_controller);

    _wasActive = widget.isActive;
  }

  @override
  void didUpdateWidget(covariant _HeartBeatAnimation oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isActive && !_wasActive) {
      _controller.forward(from: 0);
    }
    _wasActive = widget.isActive;
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _scaleAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: widget.child,
        );
      },
    );
  }
}
