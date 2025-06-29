import 'package:flutter/material.dart';
import 'package:auto_route/auto_route.dart';
import 'package:sizer/sizer.dart';
import 'package:quickalert/quickalert.dart';
import '../../../core/app_colors.dart';
import '../../../services/google_auth_service.dart';
import '../../../routes/router.dart';

class LogoutSection extends StatelessWidget {
  const LogoutSection({super.key});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 5.h), // Added bottom spacing
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton.icon(
          onPressed: () {
            _showLogoutDialog(context);
          },
          icon: const Icon(
            Icons.logout,
            color: Colors.white,
          ),
          label: Text(
            'Logout',
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
              color: Colors.white,
            ),
          ),
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.quizRed,
            foregroundColor: Colors.white,
            padding: EdgeInsets.symmetric(vertical: 2.h),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            elevation: 2,
          ),
        ),
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    QuickAlert.show(
      context: context,
      type: QuickAlertType.error,
      title: 'Logout',
      confirmBtnText: 'Yes',
      cancelBtnText: 'Cancel',
      confirmBtnColor: AppColors.error,
      showCancelBtn: true,
      titleColor: Theme.of(context).textTheme.headlineSmall?.color ?? Colors.black87,
      textColor: Theme.of(context).textTheme.bodyMedium?.color ?? Colors.black54,
      widget: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Are you sure you want to logout?',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              fontFamily: 'Plus Jakarta Sans',
              color: Theme.of(context).textTheme.bodyMedium?.color ?? Colors.black54,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
      onConfirmBtnTap: () async {
        Navigator.of(context).pop(); // Close the alert first
        
        // Show loading alert
        QuickAlert.show(
          context: context,
          type: QuickAlertType.loading,
          title: 'Logging out...',
          titleColor: Theme.of(context).textTheme.headlineSmall?.color ?? Colors.black87,
          widget: Text(
            'Please wait',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              fontFamily: 'Plus Jakarta Sans',
              color: Theme.of(context).textTheme.bodyMedium?.color ?? Colors.black54,
            ),
            textAlign: TextAlign.center,
          ),
          barrierDismissible: false,
        );
        
        try {
          await GoogleAuthService.signOut();
          
          // Close loading alert and navigate to login immediately
          if (context.mounted) {
            Navigator.of(context).pop();
            
            // Navigate to login page immediately
            context.router.replaceAll([LoginRoute()]);
            
            // Show success alert on the login page
            Future.delayed(const Duration(milliseconds: 300), () {
              if (context.mounted) {
                QuickAlert.show(
                  context: context,
                  type: QuickAlertType.success,
                  title: 'Logout Successful',
                  titleColor: Theme.of(context).textTheme.headlineSmall?.color ?? Colors.black87,
                  widget: Text(
                    'You have been logged out successfully',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontFamily: 'Plus Jakarta Sans',
                      color: Theme.of(context).textTheme.bodyMedium?.color ?? Colors.black54,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  autoCloseDuration: const Duration(milliseconds: 200),
                  showConfirmBtn: false,
                );
              }
            });
          }
        } catch (e) {
          // Close loading alert
          if (context.mounted) {
            Navigator.of(context).pop();
            
            // Show error alert
            QuickAlert.show(
              context: context,
              type: QuickAlertType.error,
              title: 'Logout Failed',
              confirmBtnText: 'OK',
              confirmBtnColor: AppColors.error,
              titleColor: Theme.of(context).textTheme.headlineSmall?.color ?? Colors.black87,
              widget: Text(
                'An error occurred while logging out. Please try again.',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontFamily: 'Plus Jakarta Sans',
                  color: Theme.of(context).textTheme.bodyMedium?.color ?? Colors.black54,
                ),
                textAlign: TextAlign.center,
              ),
            );
          }
        }
      },
    );
  }
}
