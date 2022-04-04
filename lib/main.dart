import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:supabase_quickstart/pages/add_offer.dart';
import 'package:supabase_quickstart/pages/getting_started/login_screen.dart';
import 'package:supabase_quickstart/pages/getting_started/register_screen.dart';
import 'package:supabase_quickstart/pages/tab_screens/tabLayout.dart';
import 'package:supabase_quickstart/utils/supabase_conf.dart';
import 'pages/tab_screens/account_page.dart';
import 'pages/getting_started/intro_screen.dart';
import 'pages/splash_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
      url: supabase_url,
      anonKey: supabase_anon_key);

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Supabase Flutter',
      theme: ThemeData.light().copyWith(
        primaryColor: Colors.green,
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            onPrimary: Colors.white,
            primary: Colors.green,
          ),
        ),
      ),
      initialRoute: '/',
      routes: <String, WidgetBuilder>{
        '/': (_) => const SplashPage(),
        '/intro': (_) => const IntroScreen(),
        '/login': (_) => const LoginScreen(),
        '/account': (_) => const AccountPage(),
        '/register': (_) => const RegisterScreen(),
        '/tabs': (_) => const TabLayout(),
        '/addoffer': (_) => const AddOfferScreen(),
      },
    );
  }
}
