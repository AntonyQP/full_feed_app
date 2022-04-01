import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:full_feed_app/providers/diet_provider.dart';
import 'package:full_feed_app/providers/patient_provider.dart';
import 'package:full_feed_app/providers/user_provider.dart';
import 'package:full_feed_app/view/page/authentication/splash_screen.dart';
import 'package:full_feed_app/view_model/diet_view_model.dart';
import 'package:full_feed_app/view_model/logged_in_view_model.dart';
import 'package:full_feed_app/view_model/login_view_model.dart';
import 'package:full_feed_app/view_model/patient_view_model.dart';
import 'package:full_feed_app/view_model/profile_view_model.dart';
import 'package:full_feed_app/view_model/register_view_model.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]).then((_) {
    runApp(const MyApp());
  });
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  MyAppState createState() => MyAppState();
}


class MyAppState extends State<MyApp> {
  late StreamChatClient client;

  @override
  void initState() {
    client = StreamChatClient(
      '4u4qb3jxyjpa',
      logLevel: Level.WARNING,
    );
    super.initState();
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [

          Provider(create: (ctx) => ProfileViewModel()),

          ChangeNotifierProvider(create: (ctx) => UserProvider()),
          ChangeNotifierProvider(create: (ctx) => DietProvider()),
          ChangeNotifierProvider(create: (ctx) => PatientProvider()),

          ChangeNotifierProvider(create: (ctx) => LoginViewModel()),
          ChangeNotifierProvider(create: (ctx) => RegisterViewModel()),
          ChangeNotifierProvider(create: (ctx) => LoggedInViewModel()),
          ChangeNotifierProvider(create: (ctx) => DietViewModel()),
          ChangeNotifierProvider(create: (ctx) => PatientViewModel())
        ],
        child: MaterialApp(
            localizationsDelegates: const [
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: const [
              Locale('en', ''),
            ],
            title: 'Full Feed',
            theme: ThemeData(
                textTheme: GoogleFonts.latoTextTheme(Theme.of(context).textTheme)
            ),
            builder: (context, child){
              return StreamChat(
                child: child,
                client: client,
              );
            },
            home: const SplashScreen()
        )
    );
  }
}
