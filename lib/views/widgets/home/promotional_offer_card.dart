import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:biteflow/models/promotional_offer.dart';
import 'package:intl/intl.dart';

class PromotionalOfferCard extends StatelessWidget {
  final PromotionalOffer offer;
  final VoidCallback onTap;
  
  const PromotionalOfferCard({
    super.key,
    required this.offer,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Card(
      margin: EdgeInsets.only(right: 12.w),  // Increased from 8.w
      elevation: 4,
      shadowColor: Colors.black26,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.r),  // Increased from 8.r
        side: BorderSide(
          color: theme.colorScheme.outline.withOpacity(0.1),
          width: 1,
        ),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(10.r),  // Increased from 8.r
        child: Container(
          width: 180.w,  // Increased from 140.w
          padding: EdgeInsets.all(10.w),  // Increased from 8.w
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (offer.imageUrl.isNotEmpty) ...[
                Stack(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8.r),  // Increased from 6.r
                      child: Image.network(
                        offer.imageUrl,
                        height: 90.h,  // Increased from 60.h
                        width: double.infinity,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) => Container(
                          height: 90.h,  // Increased from 60.h
                          width: double.infinity,
                          color: theme.colorScheme.surfaceContainerHighest,
                          child: Icon(
                            Icons.image_not_supported_outlined,
                            size: 24.sp,  // Increased from 20.sp
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      top: 6.h,  // Increased from 4.h
                      right: 6.w,  // Increased from 4.w
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 6.w,  // Increased from 4.w
                          vertical: 3.h,  // Increased from 2.h
                        ),
                        decoration: BoxDecoration(
                          color: theme.colorScheme.primary,
                          borderRadius: BorderRadius.circular(12.r),  // Increased from 8.r
                        ),
                        child: Text(
                          '${offer.discount}% OFF',  // Added 'OFF' back
                          style: theme.textTheme.labelSmall?.copyWith(
                            color: theme.colorScheme.onPrimary,
                            fontWeight: FontWeight.bold,
                            fontSize: 10.sp,  // Increased from 8.sp
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 8.h),  // Increased from 6.h
              ],
              Text(
                offer.title,
                style: theme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                  fontSize: 14.sp,  // Increased from 12.sp
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              SizedBox(height: 4.h),  // Increased from 2.h
              Row(
                children: [
                  Icon(
                    Icons.access_time_rounded,
                    size: 14.sp,  // Increased from 10.sp
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                  SizedBox(width: 4.w),  // Increased from 2.w
                  Expanded(
                    child: Text(
                      'Valid until ${DateFormat('MMM dd').format(offer.endDate)}',  // Added 'Valid until' back
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                        fontSize: 10.sp,  // Increased from 8.sp
                      ),
                    ),
                  ),
                ],
              ),
              if (offer.description.isNotEmpty) ...[
                SizedBox(height: 6.h),  // Increased from 4.h
                Text(
                  offer.description,
                  style: theme.textTheme.bodySmall?.copyWith(
                    fontSize: 10.sp,  // Increased from 8.sp
                    height: 1.3,  // Increased from 1.2
                  ),
                  maxLines: 2,  // Increased from 1
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}