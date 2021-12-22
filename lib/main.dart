import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:monitor_ia/src/providers/cambiar_contrasena_provider.dart';
import 'package:monitor_ia/src/providers/seleccion_encuesta_page_provider.dart';
import 'package:monitor_ia/src/providers/show_notifications_provider.dart';
import 'package:monitor_ia/src/providers/tutorial_management_provider.dart';
import 'package:provider/provider.dart';
import 'package:monitor_ia/src/models/push_notification_model.dart';

import 'package:monitor_ia/src/providers/principal_page_provider.dart';
import 'package:monitor_ia/src/utils/app_localizations.dart';
import 'package:monitor_ia/src/providers/image_provider.dart';
import 'package:monitor_ia/src/providers/login_provider.dart';
import 'package:monitor_ia/src/providers/notifications_provider.dart';
import 'package:monitor_ia/src/providers/survey_provider.dart';
import 'package:monitor_ia/src/providers/ui_provider.dart';
import 'package:monitor_ia/src/routes/routes.dart';
import 'package:monitor_ia/src/services/push_notifications_service.dart';
import 'package:monitor_ia/src/shared_preferences/preferencias_usuario.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await PushNotificationService.initializeApp();
  final prefs = new PreferenciasUsuario();
  await prefs.initPrefs();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((_) {
    runApp(MyApp());
  });
}

class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final notiProvider = NotificationsProvider();
  final showNotiProvider = ShowNotificationsProvider();

  @override
  void initState() {
    super.initState();
    showNotiProvider.initializePushNotifications();
    _listenForPushNotifications();
  }

  _listenForPushNotifications(){
    PushNotificationService.messagesStream.listen((message) async {

      final notification = new PushNotification(
          title: message.notification.title,
          contenido: message.notification.body,
          prioridad: message.data['prioridad'],
          fechaDeEnvio: message.data['fechaDeEntrega'],
          fechaDeEntrega: DateTime.now().toUtc().toIso8601String()
      );

      //TODO: Ver la manera de actualizar la pantalla de notificaciones justo cuando llega una nueva notificacion
      notiProvider.newNotification(notification);

      showNotiProvider.showNotification(
          1,
          message.notification.title,
          message.notification.body,
          message.data.toString()
      );

    });
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle( SystemUiOverlayStyle.light );
    return LoginProvider(
      child: MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => new UiProvider()),
          ChangeNotifierProvider(create: (_) => new SurveyProvider()),
          ChangeNotifierProvider(create: (_) => new NotificationsProvider()),
          ChangeNotifierProvider(create: (_) => new PrincipalPageProvider()),
          ChangeNotifierProvider(create: (_) => new ImageProviderApp()),
          ChangeNotifierProvider(create: (_) => new TutorialManagementProvider()),
          ChangeNotifierProvider(create: (_) => new CambiarContrasenaProvider()),
          ChangeNotifierProvider(create: (_) => new SeleccionEncuestaProvider()),
        ],
        child: GestureDetector(
          onTap: (){
            WidgetsBinding.instance.focusManager.primaryFocus?.unfocus();
          },
          child: MaterialApp(
              localizationsDelegates: [
                // A class which loads the translations from JSON files
                AppLocalizations.delegate,
                // Built-in localization of basic text for Material widgets
                GlobalMaterialLocalizations.delegate,
                // Built-in localization for text direction LTR/RTL
                GlobalWidgetsLocalizations.delegate,
              ],
              supportedLocales: [
                Locale('es', 'MX'),
                Locale('en', 'US')
              ],
              // Returns a locale which will be used by the app
              localeResolutionCallback: (locale, supportedLocales) {
                // Check if the current device locale is supported
                for (var supportedLocale in supportedLocales) {
                  if (supportedLocale.languageCode == locale.languageCode &&
                      supportedLocale.countryCode == locale.countryCode) {
                    return supportedLocale;
                  }
                }
                // If the locale of the device is not supported, use the first one
                // from the list (Spanish, in this case).
                return supportedLocales.first;
              },
              debugShowCheckedModeBanner: false,
              title: 'Spaces',
              initialRoute: '/',
              routes: getApplicationRoutes(),
              theme: ThemeData(
                primaryColor: Colors.blueAccent,
              )
          ),
        ),
      ),
    );
  }
}
