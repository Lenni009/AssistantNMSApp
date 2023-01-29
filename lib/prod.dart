import 'package:flutter/material.dart';

import 'app.dart';
import 'env.dart';
import 'assistantAppsSettings.dart';
import 'env/environmentSettings.dart';

Future main() async {
  EnvironmentSettings env = EnvironmentSettings(
    baseApi: 'https://api.nmsassistant.com',
    remoteConfigsConfigId: '4fa400a4',
    donationsEnabled: false,
    isProduction: true,

    // AssistantApps
    assistantAppsApiUrl: assistantAppsApiUrl,
    assistantAppsAppGuid: assistantAppsAppGuid,
    currentWhatIsNewGuid: currentWhatIsNewGuid,

    // from env.dart
    remoteConfigsApiKey: remoteConfigsApiKey,
    patreonOAuthClientId: patreonOAuthClientId,
    wiredashProjectId: wiredashProjectId,
    wiredashSecret: wiredashSecret,
  );
  WidgetsFlutterBinding.ensureInitialized();
  runApp(AssistantNMS(env));
}
