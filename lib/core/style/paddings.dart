import 'package:clean_architecture_template/core/util/pixel_sizer.dart';
import 'package:flutter/cupertino.dart';

// Custom Paddings
abstract class CPaddings {
  // Zero padding
  static EdgeInsets zero = EdgeInsets.zero;

  // horizontals
  static EdgeInsets horizontal4 = EdgeInsets.symmetric(horizontal: 4.pw);
  static EdgeInsets horizontal6 = EdgeInsets.symmetric(horizontal: 6.pw);
  static EdgeInsets horizontal8 = EdgeInsets.symmetric(horizontal: 8.pw);
  static EdgeInsets horizontal10 = EdgeInsets.symmetric(horizontal: 10.pw);
  static EdgeInsets horizontal12 = EdgeInsets.symmetric(horizontal: 12.pw);
  static EdgeInsets horizontal14 = EdgeInsets.symmetric(horizontal: 14.pw);
  static EdgeInsets horizontal16 = EdgeInsets.symmetric(horizontal: 16.pw);
  static EdgeInsets horizontal20 = EdgeInsets.symmetric(horizontal: 20.pw);
  static EdgeInsets horizontal24 = EdgeInsets.symmetric(horizontal: 24.pw);
  static EdgeInsets horizontal28 = EdgeInsets.symmetric(horizontal: 28.pw);
  static EdgeInsets horizontal30 = EdgeInsets.symmetric(horizontal: 30.pw);
  static EdgeInsets horizontal32 = EdgeInsets.symmetric(horizontal: 32.pw);
  static EdgeInsets horizontal34 = EdgeInsets.symmetric(horizontal: 34.pw);
  static EdgeInsets horizontal44 = EdgeInsets.symmetric(horizontal: 44.pw);
  static EdgeInsets horizontal48 = EdgeInsets.symmetric(horizontal: 48.pw);

  // verticals
  static EdgeInsets vertical2 = EdgeInsets.symmetric(vertical: 2.ph);
  static EdgeInsets vertical4 = EdgeInsets.symmetric(vertical: 4.ph);
  static EdgeInsets vertical6 = EdgeInsets.symmetric(vertical: 6.ph);
  static EdgeInsets vertical8 = EdgeInsets.symmetric(vertical: 8.ph);
  static EdgeInsets vertical10 = EdgeInsets.symmetric(vertical: 10.ph);
  static EdgeInsets vertical12 = EdgeInsets.symmetric(vertical: 12.ph);
  static EdgeInsets vertical14 = EdgeInsets.symmetric(vertical: 14.ph);
  static EdgeInsets vertical16 = EdgeInsets.symmetric(vertical: 16.ph);
  static EdgeInsets vertical18 = EdgeInsets.symmetric(vertical: 18.ph);
  static EdgeInsets vertical20 = EdgeInsets.symmetric(vertical: 20.ph);
  static EdgeInsets vertical22 = EdgeInsets.symmetric(vertical: 22.ph);
  static EdgeInsets vertical24 = EdgeInsets.symmetric(vertical: 24.ph);
  static EdgeInsets vertical30 = EdgeInsets.symmetric(vertical: 30.ph);
  static EdgeInsets vertical44 = EdgeInsets.symmetric(vertical: 44.ph);
  static EdgeInsets vertical84 = EdgeInsets.symmetric(vertical: 84.ph);

  // vertical-horizontal
  static EdgeInsets v20h90 =
      EdgeInsets.symmetric(vertical: 20.ph, horizontal: 90.pw);
  static EdgeInsets v16h24 =
      EdgeInsets.symmetric(vertical: 16.ph, horizontal: 24.pw);
  static EdgeInsets v14h16 =
      EdgeInsets.symmetric(vertical: 14.ph, horizontal: 16.pw);
  static EdgeInsets v12h24 =
      EdgeInsets.symmetric(vertical: 12.ph, horizontal: 24.pw);
  static EdgeInsets v12h20 =
      EdgeInsets.symmetric(vertical: 12.ph, horizontal: 20.pw);
  static EdgeInsets v8h12 =
      EdgeInsets.symmetric(vertical: 8.ph, horizontal: 12.pw);

  // all
  static EdgeInsets all3 =
      EdgeInsets.symmetric(vertical: 3.ph, horizontal: 3.pw);
  static EdgeInsets all4 =
      EdgeInsets.symmetric(vertical: 4.ph, horizontal: 4.pw);
  static EdgeInsets all5 =
      EdgeInsets.symmetric(vertical: 5.ph, horizontal: 5.pw);
  static EdgeInsets all8 =
      EdgeInsets.symmetric(vertical: 8.ph, horizontal: 8.pw);
  static EdgeInsets all10 =
      EdgeInsets.symmetric(vertical: 10.ph, horizontal: 10.pw);
  static EdgeInsets all12 =
      EdgeInsets.symmetric(vertical: 12.ph, horizontal: 12.pw);
  static EdgeInsets all14 =
      EdgeInsets.symmetric(vertical: 14.ph, horizontal: 14.pw);
  static EdgeInsets all16 =
      EdgeInsets.symmetric(vertical: 16.ph, horizontal: 16.pw);
  static EdgeInsets all18 =
      EdgeInsets.symmetric(vertical: 18.ph, horizontal: 3.pw);
  static EdgeInsets all20 =
      EdgeInsets.symmetric(vertical: 20.ph, horizontal: 20.pw);
  static EdgeInsets all24 =
      EdgeInsets.symmetric(vertical: 24.ph, horizontal: 24.pw);

  // only
  static EdgeInsets bottom4 = EdgeInsets.only(bottom: 4.ph);
  static EdgeInsets top24 = EdgeInsets.only(top: 24.ph);
}
