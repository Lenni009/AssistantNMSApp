; Script generated by the Inno Setup Script Wizard.
; SEE THE DOCUMENTATION FOR DETAILS ON CREATING INNO SETUP SCRIPT FILES!

#define MyAppName "Assistant for No Man's Sky"
#define MyAppVersion "2.15.0"
#define MyAppPublisher "AssistantApps"
#define MyAppURL "https://nmsassistant.com/"
#define MyAppExeName "assistantnms_app.exe"

[Setup]
; NOTE: The value of AppId uniquely identifies this application. Do not use the same AppId value in installers for other applications.
; (To generate a new GUID, click Tools | Generate GUID inside the IDE.)
AppId={{A8C3391C-5D14-4B8F-8010-E69C3D1C4DE5}
AppName={#MyAppName}
AppVersion={#MyAppVersion}
;AppVerName={#MyAppName} {#MyAppVersion}
AppPublisher={#MyAppPublisher}
AppPublisherURL={#MyAppURL}
AppSupportURL={#MyAppURL}
AppUpdatesURL={#MyAppURL}
DefaultDirName={autopf64}\AssistantNMS
DisableProgramGroupPage=yes
LicenseFile=C:\Development\Projects\AssistantNMS\assistantnms_app\installers\LICENCE.txt
; Uncomment the following line to run in non administrative install mode (install for current user only.)
;PrivilegesRequired=lowest
OutputDir=C:\Development\Projects\AssistantNMS\assistantnms_app\installers
OutputBaseFilename=AssistantNMS_setup
SetupIconFile=C:\Development\Projects\AssistantNMS\assistantnms_app\installers\favicon.ico
Compression=lzma
SolidCompression=yes
WizardStyle=modern

[Languages]
Name: "english"; MessagesFile: "compiler:Default.isl"
Name: "brazilianportuguese"; MessagesFile: "compiler:Languages\BrazilianPortuguese.isl"
Name: "dutch"; MessagesFile: "compiler:Languages\Dutch.isl"
Name: "french"; MessagesFile: "compiler:Languages\French.isl"
Name: "german"; MessagesFile: "compiler:Languages\German.isl"
Name: "italian"; MessagesFile: "compiler:Languages\Italian.isl"
Name: "japanese"; MessagesFile: "compiler:Languages\Japanese.isl"
Name: "norwegian"; MessagesFile: "compiler:Languages\Norwegian.isl"
Name: "polish"; MessagesFile: "compiler:Languages\Polish.isl"
Name: "portuguese"; MessagesFile: "compiler:Languages\Portuguese.isl"
Name: "russian"; MessagesFile: "compiler:Languages\Russian.isl"
Name: "spanish"; MessagesFile: "compiler:Languages\Spanish.isl"

[Tasks]
Name: "desktopicon"; Description: "{cm:CreateDesktopIcon}"; GroupDescription: "{cm:AdditionalIcons}"; Flags: unchecked

[Files]
Source: "C:\Development\Projects\AssistantNMS\assistantnms_app\build\windows\runner\Release\{#MyAppExeName}"; DestDir: "{app}"; Flags: ignoreversion
Source: "C:\Development\Projects\AssistantNMS\assistantnms_app\build\windows\runner\Release\bitsdojo_window_windows_plugin.lib"; DestDir: "{app}"; Flags: ignoreversion
Source: "C:\Development\Projects\AssistantNMS\assistantnms_app\build\windows\runner\Release\connectivity_plus_plugin.dll"; DestDir: "{app}"; Flags: ignoreversion
Source: "C:\Development\Projects\AssistantNMS\assistantnms_app\build\windows\runner\Release\dynamic_color_plugin.dll"; DestDir: "{app}"; Flags: ignoreversion
Source: "C:\Development\Projects\AssistantNMS\assistantnms_app\build\windows\runner\Release\flutter_secure_storage_windows_plugin.dll"; DestDir: "{app}"; Flags: ignoreversion
Source: "C:\Development\Projects\AssistantNMS\assistantnms_app\build\windows\runner\Release\flutter_windows.dll"; DestDir: "{app}"; Flags: ignoreversion
Source: "C:\Development\Projects\AssistantNMS\assistantnms_app\build\windows\runner\Release\assistantnms_app.exp"; DestDir: "{app}"; Flags: ignoreversion
Source: "C:\Development\Projects\AssistantNMS\assistantnms_app\build\windows\runner\Release\assistantnms_app.lib"; DestDir: "{app}"; Flags: ignoreversion
Source: "C:\Development\Projects\AssistantNMS\assistantnms_app\build\windows\runner\Release\platform_device_id_windows_plugin.dll"; DestDir: "{app}"; Flags: ignoreversion
Source: "C:\Development\Projects\AssistantNMS\assistantnms_app\build\windows\runner\Release\url_launcher_windows_plugin.dll"; DestDir: "{app}"; Flags: ignoreversion
Source: "C:\Development\Projects\AssistantNMS\assistantnms_app\build\windows\runner\Release\flutter_localization_plugin.dll"; DestDir: "{app}"; Flags: ignoreversion
Source: "C:\Development\Projects\AssistantNMS\assistantnms_app\build\windows\runner\Release\share_plus_plugin.dll"; DestDir: "{app}"; Flags: ignoreversion
Source: "C:\Development\Projects\AssistantNMS\assistantnms_app\build\windows\runner\Release\data\*"; DestDir: "{app}\data"; Flags: ignoreversion recursesubdirs createallsubdirs
; NOTE: Don't use "Flags: ignoreversion" on any shared system files

[Icons]
Name: "{autoprograms}\{#MyAppName}"; Filename: "{app}\{#MyAppExeName}"
Name: "{autodesktop}\{#MyAppName}"; Filename: "{app}\{#MyAppExeName}"; Tasks: desktopicon

[Run]
Filename: "{app}\{#MyAppExeName}"; Description: "{cm:LaunchProgram,{#StringChange(MyAppName, '&', '&&')}}"; Flags: nowait postinstall skipifsilent

