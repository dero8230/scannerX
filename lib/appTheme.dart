import 'package:flutter/material.dart';

const Color inActiveIconColor = Color(0xFFB6B6B6);
const kPrimaryColor = Color(0xFF5C5EDD);
const kPrimaryLightColor = Color(0xFFFFECDF);
const primaryColor = Color(0xFF2697FF);
const secondaryColor = Color(0xFF2A2D3E);
const bgColor = Color(0xFF212332);
const kBgColor = Color(0xfff5f5f5);
const kBgColorDark = Color(0xFF2D2B2B);
const defaultPadding = 16.0;
const kPrimaryGradientColor = LinearGradient(
  begin: Alignment.topLeft,
  end: Alignment.bottomRight,
  colors: [Color(0xFFFFA53E), Color(0xFFFF7643)],
);
const kSecondaryColor = Color(0xFF979797);
const kTextColor = Color(0xFF757575);
final kTextStyle = TextStyle(
  color: Colors.grey[100],
  fontWeight: FontWeight.w500,
);
final kIconTheme = IconThemeData(
  color: Colors.grey[100],
);
const Map<int, Color> materialColor = {
  50: kPrimaryColor,
  100: kPrimaryColor,
  200: kPrimaryColor,
  300: kPrimaryColor,
  400: kPrimaryColor,
  500: kPrimaryColor,
  600: kPrimaryColor,
  700: kPrimaryColor,
  800: kPrimaryColor,
  900: kPrimaryColor,
};
MaterialColor kPrimaryMaterialColor = MaterialColor(
  kPrimaryColor.value,
  materialColor,
);
AppBarTheme appBarTheme = AppBarTheme(
  color: Colors.white.withOpacity(0),
  elevation: 0,
  toolbarHeight: 1,
  iconTheme: const IconThemeData(color: kPrimaryColor),
);
AppBarTheme appBarThemeDark = AppBarTheme(
  color: Colors.black.withOpacity(0),
  elevation: 0,
  toolbarHeight: 1,
  iconTheme: const IconThemeData(color: kPrimaryColor),
);
ElevatedButtonThemeData elevatedButtonTheme = ElevatedButtonThemeData(
  style: ElevatedButton.styleFrom(
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(20),
    ),
    textStyle: const TextStyle(
      color: Colors.white,
      fontSize: 16,
    ),
  ),
);
const kFloatingActionButtonTheme = FloatingActionButtonThemeData(
  backgroundColor: kPrimaryColor,
);
const kPageTransitionsTheme = PageTransitionsTheme(
  builders: {
    TargetPlatform.android: CustomTransitionBuilder(),
    TargetPlatform.iOS: CustomTransitionBuilder(),
  },
);
SnackBarThemeData kSnackBarTheme = SnackBarThemeData(
  behavior: SnackBarBehavior.fixed,
  backgroundColor: kPrimaryColor.withOpacity(0.8),
  contentTextStyle: const TextStyle(
    color: Colors.white,
    fontSize: 16,
  ),
);

final appTheme = ThemeData(
    floatingActionButtonTheme: kFloatingActionButtonTheme,
    brightness: Brightness.light,
    scaffoldBackgroundColor: kBgColor,
    snackBarTheme: kSnackBarTheme,
    pageTransitionsTheme: kPageTransitionsTheme,
    iconTheme: kIconTheme,
    appBarTheme: appBarTheme,
    primaryColor: kPrimaryColor,
    primarySwatch: kPrimaryMaterialColor,
    elevatedButtonTheme: elevatedButtonTheme);

final appThemeDark = ThemeData(
    floatingActionButtonTheme: kFloatingActionButtonTheme,
    brightness: Brightness.dark,
    scaffoldBackgroundColor: kBgColorDark,
    snackBarTheme: kSnackBarTheme,
    pageTransitionsTheme: kPageTransitionsTheme,
    iconTheme: kIconTheme,
    appBarTheme: appBarThemeDark,
    primaryColor: kPrimaryColor,
    primarySwatch: kPrimaryMaterialColor,
    elevatedButtonTheme: elevatedButtonTheme);

class CustomTransitionBuilder extends PageTransitionsBuilder {
  const CustomTransitionBuilder();

  @override
  Widget buildTransitions<T>(
    PageRoute<T> route,
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    return _CustomTransitionBuilder(routeAnimation: animation, child: child);
  }
}

class _CustomTransitionBuilder extends StatelessWidget {
  const _CustomTransitionBuilder({
    Key? key,
    required Animation<double> routeAnimation,
    required this.child,
  })  : animation = routeAnimation,
        super(key: key);
  final begin = const Offset(1, 0);
  final end = Offset.zero;
  final curve = Curves.ease;
  final Animation<double> animation;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return SlideTransition(
      position: animation.drive(Tween(begin: begin, end: end).chain(
        CurveTween(curve: curve),
      )),
      child: child,
    );
  }
}
