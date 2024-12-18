import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class AppFont {
  AppFont._();

  // static TextStyle normal = GoogleFonts.inter(fontWeight: FontWeight.normal);
  // static TextStyle bold = GoogleFonts.inter(fontWeight: FontWeight.bold);

  //static FontFmalicy GoogleFonts.inter().fontFamily,
  static final fontFamily = GoogleFonts.inter().fontFamily;

  static TextStyle regular = GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.normal);
  static TextStyle regularBold = GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.bold);
  static TextStyle regularGray = GoogleFonts.inter(fontSize: 14, color: Colors.grey[800]);
  static TextStyle regularBoldGray = GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.grey);

  static TextStyle emphasize = GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.normal);
  static TextStyle emphasizeBold = GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.bold);
  static TextStyle emphasizeGray = GoogleFonts.inter(fontSize: 16, color: Colors.grey[800]);
  static TextStyle emphasizeBoldGray = GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.grey);
}

// extension AppFontSize on TextStyle {
//   TextStyle get s12 {
//     return copyWith(fontSize: 12.sp);
//   }
//
//   TextStyle get s14 {
//     return copyWith(fontSize: 14.sp);
//   }
//
//   TextStyle get s16 {
//     return copyWith(fontSize: 16.sp);
//   }
//
//   TextStyle get s25 {
//     return copyWith(fontSize: 25.sp);
//   }
// }