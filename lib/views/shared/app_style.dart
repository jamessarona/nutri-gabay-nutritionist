import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

TextStyle appstyle(double size, Color color, FontWeight fw) {
  return GoogleFonts.montserrat(
    fontSize: size,
    color: color,
    fontWeight: fw,
  );
}

TextStyle appstyleWithHt(double size, Color color, FontWeight fw, double ht) {
  return GoogleFonts.montserrat(
    fontSize: size,
    color: color,
    fontWeight: fw,
    height: ht,
  );
}

const MaterialColor customColor = MaterialColor(0xff8bc24a, <int, Color>{
  10: Color(0xfffdc30a), //custom Orange
  20: Color(0xfffee185),
  30: Color(0xffc5e1a4),
  40: Color(0xffed9376),
  50: Color(0xfffc4342),
  60: Color(0xffb2ce91),
  70: Color(0xfffbe5ae),
});
