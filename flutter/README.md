# Ahead

The Application for daily work check-in.
<hr>

### This project should be used Flutter this version:

```
Flutter 3.0.1 • channel stable • https://github.com/flutter/flutter.git
Framework • revision fb57da5f94 (9 hours ago) • 2022-05-19 15:50:29 -0700
Engine • revision caaafc5604
Tools • Dart 2.17.1 • DevTools 2.12.2
```
# First Time Setup

1. Download Flutter SDK version [2.8.1](https://storage.googleapis.com/flutter_infra_release/releases/stable/macos/flutter_macos_2.8.1-stable.zip)

1. Extract and place Flutter SDK somewhere then setup path follow this [document](https://flutter.dev/docs/get-started/install/macos#update-your-path)

1. Update your Xcode from App Store (Don't use Beta version) then run
    ```bash
    sudo xcode-select --switch /Applications/Xcode.app/Contents/Developer
    sudo xcodebuild -runFirstLaunch
    ```
1. Install cocoapods version 1.11.2 with command 
    ```bash
    sudo gem install -n /usr/local/bin cocoapods -v 1.11.2
    ```
1. Install [Android Studio](https://developer.android.com/studio) then open it and install Dart, Flutter plugin
   
1. Run `flutter doctor` again then do as it suggest