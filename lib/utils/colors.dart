import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';

class MColors {
  static const Color primaryPurple = const Color(0xFF57A773);
  static const Color primaryWhite = const Color(0xFFFFFFFF);
  static const Color primaryWhiteSmoke = const Color(0xFFF5F5F5);
  static const Color primaryPlatinum = const Color(0xFFE5E4E2);
  static const Color textDark = const Color(0xFF444444);
  static const Color textGrey = const Color(0xFF808080);
  static const Color lightGrey = const Color(0xFFD0D0D0);
  static const Color appBarDark = const Color(0xFF0B0320);
  static const Color dashBlue = const Color(0xFFDFF0FC);
  static const Color dashPurple = const Color(0xFFE2DDF9);
  static const Color dashAmber = const Color(0xFFF2E4D7);
}

//app bar
Widget primaryAppBar(
    Widget? leading,
    Widget title,
    Color backgroundColor,
    PreferredSizeWidget? bottom,
    bool centerTile,
    List<Widget> actions,
    ) {
  return AppBar(
    brightness: Brightness.light,
    elevation: 0.0,
    backgroundColor: backgroundColor,
    leading: leading,
    title: title,
    bottom: bottom,
    centerTitle: centerTile,
    actions: actions,
  );
}

Widget primarySliverAppBar(
    Widget leading,
    Widget title,
    Color backgroundColor,
    PreferredSizeWidget bottom,
    bool centerTile,
    bool floating,
    bool pinned,
    List<Widget> actions,
    double expandedHeight,
    Widget flexibleSpace,
    ) {
  return SliverAppBar(
    brightness: Brightness.light,
    elevation: 0.0,
    backgroundColor: backgroundColor,
    leading: leading,
    title: title,
    bottom: bottom,
    centerTitle: centerTile,
    floating: floating,
    pinned: pinned,
    actions: actions,
    expandedHeight: expandedHeight,
    flexibleSpace: flexibleSpace,
  );
}

// FONTS

TextStyle boldFont(Color? color, double? size) {
  return GoogleFonts.montserrat(
    color: color,
    fontSize: size,
    fontWeight: FontWeight.w600,
  );
}

TextStyle normalFont(Color? color, double? size) {
  return GoogleFonts.montserrat(
    color: color,
    fontSize: size,
  );
}

//Widgets

Widget primaryContainer(
    Widget containerChild,
    ) {
  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 20.0),
    color: MColors.primaryWhiteSmoke,
    child: containerChild,
  );
}

Widget primaryButtonPurple(
  Widget buttonChild,
  void Function()? onPressed,
) {
  return SizedBox(
    width: double.infinity,
    height: 50.0,
    child: RawMaterialButton(
      elevation: 0.0,
      hoverElevation: 0.0,
      focusElevation: 0.0,
      highlightElevation: 0.0,
      fillColor: MColors.primaryPurple,
      child: buttonChild,
      onPressed: onPressed,
      shape: RoundedRectangleBorder(
        borderRadius: new BorderRadius.circular(10.0),
      ),
    ),
  );
}

//WIDGETS

Widget primaryButtonWhiteSmoke(
  Widget buttonChild,
  void Function() onPressed,
) {
  return SizedBox(
    width: double.infinity,
    height: 50.0,
    child: RawMaterialButton(
      elevation: 0.0,
      hoverElevation: 0.0,
      focusElevation: 0.0,
      highlightElevation: 0.0,
      fillColor: MColors.primaryWhiteSmoke,
      child: buttonChild,
      onPressed: onPressed,
      shape: RoundedRectangleBorder(
        borderRadius: new BorderRadius.circular(10.0),
      ),
    ),
  );
}

Widget progressIndicator(Color color) {
  return Container(
    color: MColors.primaryWhiteSmoke,
    child: Center(
      child: CupertinoActivityIndicator(
        radius: 12.0,
      ),
    ),
  );
}

// Text fields
Widget primaryTextField(
    TextEditingController? controller,
    String? initialValue,
    String? labelText,
    void Function(String?)? onsaved,
    bool enabled,
    String? Function(String?)? validator,
    bool obscureText,
    bool autoValidate,
    bool enableSuggestions,
    TextInputType keyboardType,
    List<TextInputFormatter>? inputFormatters,
    Widget? suffix,
    double textfieldBorder,
    ) {
  return TextFormField(
    controller: controller,
    initialValue: initialValue,
    onSaved: onsaved,
    enabled: enabled,
    validator: validator,
    obscureText: obscureText,
    keyboardType: keyboardType,
    inputFormatters: inputFormatters,
    enableSuggestions: enableSuggestions,
    style: normalFont(
      enabled == true ? MColors.textDark : MColors.textGrey,
      16.0,
    ),
    cursorColor: MColors.primaryPurple,
    decoration: InputDecoration(
      suffixIcon: Padding(
        padding: EdgeInsets.only(
          right: suffix == null ? 0.0 : 15.0,
          left: suffix == null ? 0.0 : 15.0,
        ),
        child: suffix,
      ),
      labelText: labelText,
      labelStyle: normalFont(null, 14.0),
      contentPadding: EdgeInsets.symmetric(horizontal: 25.0),
      fillColor: MColors.primaryWhite,
      floatingLabelBehavior: FloatingLabelBehavior.never,
      filled: true,
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.0),
        borderSide: BorderSide(
          color: textfieldBorder == 0.0 ? Colors.transparent : MColors.textGrey,
          width: textfieldBorder,
        ),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.0),
        borderSide: const BorderSide(
          color: Colors.red,
          width: 1.0,
        ),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.0),
        borderSide: const BorderSide(
          color: Colors.red,
          width: 1.0,
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.0),
        borderSide: const BorderSide(
          color: MColors.primaryPurple,
          width: 1.0,
        ),
      ),
    ),
  );
}

Widget backgroundDismiss(AlignmentGeometry alignment) {
  return Container(
    decoration: BoxDecoration(
      color: MColors.primaryWhiteSmoke,
      borderRadius: BorderRadius.all(
        Radius.circular(10.0),
      ),
    ),
    padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
    alignment: alignment,
    child: Container(
      height: double.infinity,
      width: 50.0,
      decoration: BoxDecoration(
        color: Colors.red,
        borderRadius: BorderRadius.all(
          Radius.circular(10.0),
        ),
      ),
      child: Icon(
        Icons.delete_outline,
        color: Colors.white,
      ),
    ),
  );
}
