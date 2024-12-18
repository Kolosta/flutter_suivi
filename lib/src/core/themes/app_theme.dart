import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

import 'app_color.dart';
import 'app_font.dart';

class AppTheme {
  AppTheme._();

  static ThemeData data(bool isDark) {
    final colorScheme = isDark ? darkColorScheme : lightColorScheme;

    return ThemeData(
      colorScheme: colorScheme,
      brightness: colorScheme.brightness,
      visualDensity: VisualDensity.adaptivePlatformDensity,
      fontFamily: GoogleFonts.inter().fontFamily,
      scaffoldBackgroundColor: colorScheme.primaryContainer,
      // colorSchemeSeed: isDark ? const Color(0xFF84BF72) : const Color(0xFF75164F),


      textTheme: TextTheme(
        displayLarge: GoogleFonts.inter(fontSize: 57.sp, fontWeight: FontWeight.bold, color: colorScheme.onSurface),
        displayMedium: GoogleFonts.inter(fontSize: 45.sp, fontWeight: FontWeight.bold, color: colorScheme.onSurface),
        displaySmall: GoogleFonts.inter(fontSize: 36.sp, fontWeight: FontWeight.bold, color: colorScheme.onSurface),

        headlineLarge: GoogleFonts.inter(fontSize: 32.sp, fontWeight: FontWeight.bold, color: colorScheme.onSurface),
        headlineMedium: GoogleFonts.inter(fontSize: 28.sp, fontWeight: FontWeight.bold, color: colorScheme.onSurface),
        headlineSmall: GoogleFonts.inter(fontSize: 24.sp, fontWeight: FontWeight.bold, color: colorScheme.onSurface),

        titleLarge: GoogleFonts.inter(fontSize: 22.sp, fontWeight: FontWeight.bold, color: colorScheme.onSurface),
        titleMedium: GoogleFonts.inter(fontSize: 16.sp, fontWeight: FontWeight.bold, color: colorScheme.onSurface),
        titleSmall: GoogleFonts.inter(fontSize: 14.sp, fontWeight: FontWeight.bold, color: colorScheme.onSurface),

        bodyLarge: GoogleFonts.inter(fontSize: 16.sp, fontWeight: FontWeight.normal, color: colorScheme.onSurface),
        bodyMedium: GoogleFonts.inter(fontSize: 14.sp, fontWeight: FontWeight.normal, color: colorScheme.onSurface),
        bodySmall: GoogleFonts.inter(fontSize: 12.sp, fontWeight: FontWeight.normal, color: colorScheme.onSurface),

        labelLarge: GoogleFonts.inter(fontSize: 13.sp, fontWeight: FontWeight.normal, color: colorScheme.onSurfaceVariant),
        labelMedium: GoogleFonts.inter(fontSize: 11.sp, fontWeight: FontWeight.normal, color: colorScheme.onSurfaceVariant),
        labelSmall: GoogleFonts.inter(fontSize: 10.sp, fontWeight: FontWeight.normal, color: colorScheme.onSurfaceVariant),
      ),

      appBarTheme: AppBarTheme(
        backgroundColor: colorScheme.primary,
        centerTitle: true,
        elevation: 2.h,
        titleTextStyle: AppFont.emphasizeBold.copyWith(color: colorScheme.onPrimary),
        iconTheme: IconThemeData(color: colorScheme.onPrimary),
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: colorScheme.secondary,
        // foregroundColor: isDark ? Colors.white : Colors.black,
        foregroundColor: colorScheme.onSurface,
        elevation: 2.h,
        extendedTextStyle: AppFont.regular,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: colorScheme.primary,
          foregroundColor: colorScheme.onPrimary,
          // iconColor: Colors.green,
          // overlayColor: Colors.red,
          // surfaceTintColor: Colors.blue,
          elevation: 2.h,
          textStyle: AppFont.emphasize,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(6.r),
          ),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          // primary: colorScheme.primary,
          textStyle: AppFont.emphasize,
          foregroundColor: colorScheme.secondary,
          iconColor: colorScheme.secondary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(6.r),
          ),
        ),
      ),
      iconButtonTheme: IconButtonThemeData(
        style: IconButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(6.r),
          ),
          foregroundColor: colorScheme.secondary,
        ),
      ),
      progressIndicatorTheme: ProgressIndicatorThemeData(
        color: colorScheme.secondary,
      ),
      iconTheme: IconThemeData(
        color: colorScheme.onSurface,
      ),

      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.r),
          borderSide: BorderSide(
            color: colorScheme.outline,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(6.r),
          borderSide: BorderSide(
            color: colorScheme.secondary,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(6.r),
          borderSide: BorderSide(
            color: colorScheme.outline,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(6.r),
          borderSide: BorderSide(
            color: colorScheme.error,
          ),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(6.r),
          borderSide: BorderSide(
            color: colorScheme.error,
          ),
        ),
        iconColor: colorScheme.onSurfaceVariant,
        errorStyle: TextStyle(color: colorScheme.error, fontWeight: FontWeight.normal,),
        labelStyle: TextStyle(color: colorScheme.onSurface, fontWeight: FontWeight.normal,),
        focusColor: colorScheme.secondary,
        floatingLabelStyle: TextStyle(color: colorScheme.secondary, fontWeight: FontWeight.bold),
        hintStyle: TextStyle(color: colorScheme.secondary,fontWeight: FontWeight.normal,),
        helperStyle: TextStyle(color: colorScheme.secondary, fontWeight: FontWeight.normal,),
        // counterStyle: TextStyle(color: colorScheme.secondary, fontWeight: FontWeight.normal,),
        // prefixStyle: TextStyle(color: colorScheme.secondary, fontWeight: FontWeight.normal,),
        // suffixStyle: TextStyle(color: colorScheme.secondary, fontWeight: FontWeight.normal,),
        // floatingLabelStyle: TextStyle(color: colorScheme.secondary, fontWeight: FontWeight.normal,),

        // contentPadding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 15.w),
      ),

      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        selectedLabelStyle: const TextStyle(
          fontSize: 13.5,
          fontWeight: FontWeight.w600,
        ),
        unselectedLabelStyle: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w400,
        ),
        // selectedIconTheme: IconThemeData(
        //   // color: isDark ? AppColor.primaryDark : AppColor.primaryLight,
        //   color: colorScheme.secondaryFixed,
        // ),
        unselectedIconTheme: IconThemeData(
          // color: isDark ? AppColor.onPrimaryDark : AppColor.onPrimaryLight,
          color: colorScheme.onPrimary,
        ),
        // selectedItemColor: colorScheme.secondaryFixed,
        selectedItemColor: colorScheme.secondaryFixed,
        unselectedItemColor: colorScheme.onPrimary,
        backgroundColor: colorScheme.primary,
      ),

      cardTheme: CardTheme(
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        // color: colorScheme.surface,
        surfaceTintColor: colorScheme.surface,
      ),
      dividerTheme: DividerThemeData(
        color: colorScheme.outline,
        thickness: 1.h,
        space: 8,
      ),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: colorScheme.secondary,
        showCloseIcon: true,
        // closeIconColor: Theme.of(context).colorScheme.onSecondary,
        dismissDirection: DismissDirection.up,
        actionTextColor: colorScheme.onSecondary,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}
