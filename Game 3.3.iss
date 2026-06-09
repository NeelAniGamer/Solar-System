; ════════════════════════════════════════════════════════════════════════════
; INNO SETUP SCRIPT FOR SOLAR SYSTEM ENGINE V3.3
; Includes Automatic Previous Version Detection & Clean Upgrade
; ════════════════════════════════════════════════════════════════════════════

[Setup]
; App Information
AppName=Solar System Engine
AppVersion=3.3
AppPublisher=Ansh & Neel
AppCopyright=Copyright © 2026 Ansh & Neel

; Using A Static AppId Ensures Upgrades Target The Same Registry Key
AppId=Solar System Engine

; Folder & Output Settings
DefaultDirName={autopf}\SolarSystemEngine
DefaultGroupName=Solar System Engine
OutputBaseFilename=SolarSystemEngine_v3.3_Setup

; Compression For A Smaller Installer File
Compression=lzma2/ultra
SolidCompression=yes

; Visuals & Behaviour
WizardStyle=modern
DisableWelcomePage=no
CloseApplications=yes

; Require Windows 10/11
MinVersion=10.0

[Tasks]
Name: "desktopicon"; Description: "{cm:CreateDesktopIcon}"; GroupDescription: "{cm:AdditionalIcons}"; Flags: unchecked

[Files]
; The Main Executable
Source: "dist\main\main.exe"; DestDir: "{app}"; Flags: ignoreversion

; All Background Libraries, Chromium Files, And Assets
Source: "dist\main\*"; DestDir: "{app}"; Flags: ignoreversion recursesubdirs createallsubdirs

[Icons]
; Start Menu Shortcut
Name: "{group}\Solar System Engine"; Filename: "{app}\main.exe"
; Desktop Shortcut
Name: "{autodesktop}\Solar System Engine"; Filename: "{app}\main.exe"; Tasks: desktopicon

[Run]
; Launch After Installation
Filename: "{app}\main.exe"; Description: "{cm:LaunchProgram,Solar System Engine}"; Flags: nowait postinstall skipifsilent

[Code]
// ════════════════════════════════════════════════════════════════════════════
// UPGRADE DETECTION LOGIC
// ════════════════════════════════════════════════════════════════════════════

function GetUninstallString(): String;
var
  sUnInstPath: String;
  sUnInstallString: String;
begin
  sUnInstPath := 'Software\Microsoft\Windows\CurrentVersion\Uninstall\Solar System Engine_is1';
  sUnInstallString := '';
  if not RegQueryStringValue(HKLM, sUnInstPath, 'UninstallString', sUnInstallString) then
    RegQueryStringValue(HKCU, sUnInstPath, 'UninstallString', sUnInstallString);
  Result := sUnInstallString;
end;

function IsUpgrade(): Boolean;
begin
  Result := (GetUninstallString() <> '');
end;

function InitializeSetup(): Boolean;
var
  iResultCode: Integer;
  sUnInstallString: String;
begin
  if IsUpgrade() then
  begin
    // Ask User If They Want To Upgrade Or Proceed Silently
    if MsgBox('A Previous Version Of Solar System Engine Was Detected.' + #13#10 + 'Do You Want To Upgrade It Now?', mbConfirmation, MB_YESNO) = IDYES then
    begin
      sUnInstallString := GetUninstallString();
      sUnInstallString := RemoveQuotes(sUnInstallString);
      // Silently Run The Old Uninstaller
      Exec(sUnInstallString, '/SILENT /NORESTART /SUPPRESSMSGBOXES', '', SW_HIDE, ewWaitUntilTerminated, iResultCode);
    end;
  end;
  
  Result := True;
end;