import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:rrhh/pages/mapas_page.dart';
import 'package:rrhh/providers/UiProvider.dart';
import 'package:rrhh/src/home/home.dart';
import 'package:rrhh/src/home_star/home_star.dart';
import 'package:rrhh/src/home/listTrabajadorServer.dart';
import 'package:rrhh/src/tema/primary.dart';

import 'home/MyCardView.dart';
import 'home/homeAccionCampo.dart';
import 'home/homeAccionPacking.dart';
import 'home/homeListLiderazgo.dart';
import 'home/homeListLiderazgo_campo.dart';
import 'home/navegar.dart';
import 'login/login.dart';
import 'home/homeCampo.dart';

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    /*
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        statusBarColor: Primary.white.withOpacity(0.3),
        statusBarIconBrightness: Brightness.dark,
        systemNavigationBarIconBrightness: Brightness.light
      ),
      child: MaterialApp(
        title: 'RRHH',
        debugShowCheckedModeBanner: false,
        home: Login(),
        theme: ThemeData(
          fontFamily: 'Quicksand',
          platform: TargetPlatform.android,
        ),
        initialRoute: 'login',
        routes: {
          'mapa' : ( _ ) => MapasPage(),
          'login' : ( _ ) => Login(),
          'home'  : ( _ ) => homeStar(),
          'registroPacking'  : ( _ ) => packingHome(),
          'registroCampo'  : ( _ ) => campoHome(),
        },
      ),
    );
  }
  */
    return MultiProvider(providers: [
      ChangeNotifierProvider(create: (_) => UiProvider()),
    ],

      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'QR Reader',
        initialRoute: 'login',
        routes: {
       //   'mapa': (_) => MapasPage(),
          'login': (_) => Login(),
          'home': (_) => homeStar(),
          'registroPacking': (_) => packingHome(),
          'registroCampo': (_) => campoHome(),
          'listApisss': (_) => MyHomePageTests(),
          'listLidirazgo': (_) => HomeListLiderazgo(),
          'listLidirazgoCampo': (_) => HomeListLiderazgoCampo(),
          'navegar': (_) => HomeScreenTestna(),
          'planAccion':(_) => HomeAccionPacking(),
          'planAccionCampo':(_) => HomeAccionCampo(),
        },
        theme: ThemeData(
          fontFamily: 'Quicksand',
          platform: TargetPlatform.android,
        ),
        home: Login(),
      ),
    );
  }
}