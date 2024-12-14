import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:biteflow/core/constants/theme_constants.dart';
import 'package:biteflow/models/restaurant.dart';

class RestaurantCard extends StatelessWidget {
  final Restaurant restaurant;
  
  const RestaurantCard({
    required this.restaurant,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 120.w,  // Reduced from 160.w
      margin: EdgeInsets.only(right: (ThemeConstants.defaultPadding * 0.75).w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10.r),  // Reduced from 12.r
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8.r,  // Reduced from 10.r
            offset: Offset(0, 4.h),  // Reduced from 5.h
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(10.r),  // Reduced from 12.r
              topRight: Radius.circular(10.r),  // Reduced from 12.r
            ),
            child: Stack(
              children: [
                Image.network(
                  restaurant.imageUrl,
                  width: 120.w,  // Reduced from 160.w
                  height: 90.h,  // Reduced from 120.h
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Container(
                    width: 120.w,  // Reduced from 160.w
                    height: 90.h,  // Reduced from 120.h
                    color: ThemeConstants.greyColor.withOpacity(0.1),
                    child: Icon(
                      Icons.restaurant,
                      size: 24.sp,  // Reduced from 32.sp
                      color: ThemeConstants.greyColor,
                    ),
                  ),
                ),
                if (restaurant.isTableAvailable)
                  Positioned(
                    top: 6.h,  // Reduced from 8.h
                    right: 6.w,  // Reduced from 8.w
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 6.w,  // Reduced from 8.w
                        vertical: 3.h,  // Reduced from 4.h
                      ),
                      decoration: BoxDecoration(
                        color: ThemeConstants.successColor,
                        borderRadius: BorderRadius.circular(12.r),  // Reduced from 16.r
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.table_bar,
                            color: ThemeConstants.whiteColor,
                            size: 10.sp,  // Reduced from 12.sp
                          ),
                          SizedBox(width: 3.w),  // Reduced from 4.w
                          Text(
                            'Available',
                            style: TextStyle(
                              color: ThemeConstants.whiteColor,
                              fontSize: 8.sp,  // Reduced from 10.sp
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.all(9.w),  // Reduced from 12.w
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  restaurant.name,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 12.sp,  // Reduced from 14.sp
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 3.h),  // Reduced from 4.h
                Row(
                  children: [
                    Icon(
                      Icons.location_on,
                      size: 10.sp,  // Reduced from 12.sp
                      color: ThemeConstants.greyColor,
                    ),
                    SizedBox(width: 3.w),  // Reduced from 4.w
                    Expanded(
                      child: Text(
                        restaurant.location,
                        style: TextStyle(
                          color: ThemeConstants.greyColor,
                          fontSize: 10.sp,  // Reduced from 12.sp
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 6.h),  // Reduced from 8.h
                Row(
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 6.w,  // Reduced from 8.w
                        vertical: 3.h,  // Reduced from 4.h
                      ),
                      decoration: BoxDecoration(
                        color: ThemeConstants.primaryColor,
                        borderRadius: BorderRadius.circular(
                          (ThemeConstants.defaultBorderRadious * 0.75).r / 3,
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.star,
                            size: 10.sp,  // Reduced from 12.sp
                            color: ThemeConstants.whiteColor,
                          ),
                          SizedBox(width: 3.w),  // Reduced from 4.w
                          Text(
                            restaurant.rating.toStringAsFixed(1),
                            style: TextStyle(
                              color: ThemeConstants.whiteColor,
                              fontSize: 10.sp,  // Reduced from 12.sp
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}