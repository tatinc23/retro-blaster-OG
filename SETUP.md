# Retro Blaster — iOS Setup Guide

This covers building the Retro Blaster iOS WKWebView wrapper in Xcode. The web game requires no setup — just open `docs/index.html`.

## Prerequisites

- Xcode 15+
- Apple Developer account (required to run on device or submit to App Store)

## Open in Xcode

1. Clone the repo:
   ```bash
   git clone https://github.com/tatinc23/retro-blaster.git
   cd retro-blaster
   open CallemiguelShooter.xcodeproj
   ```
2. Xcode opens the iOS wrapper project for Retro Blaster. Some Xcode file paths and target names still use the legacy internal `CallemiguelShooter` name.

## Set Your Team ID

1. Click the project root (blue icon) → select the app target → **Signing & Capabilities**
2. Under **Team**, select your Apple Developer account

   Or manually: open `CallemiguelShooter.xcodeproj/project.pbxproj` and replace `REPLACE_WITH_TEAM_ID` with your 10-character Team ID (found at developer.apple.com → Account → Membership).

## Add App Icon

Add a 1024×1024 PNG named `AppIcon.png` to:
`CallemiguelShooter/Assets.xcassets/AppIcon.appiconset/`

Update `Contents.json` in that folder:
```json
{
  "images": [{"filename": "AppIcon.png", "idiom": "universal", "platform": "ios", "size": "1024x1024"}],
  "info": {"author": "xcode", "version": 1}
}
```

## Run on Simulator

1. Select any iPhone simulator in the Xcode toolbar
2. Press ▶ to build and run

## Run on Device

1. Connect your iPhone via USB and select it in the Xcode toolbar
2. Press ▶ (requires Team ID set above)

## Submit to App Store

1. Product → Archive
2. Distribute App → App Store Connect → Upload
3. In App Store Connect: Category = Games → Action, Age rating = 4+

## Notes

- **In-app purchases:** Not implemented. The iOS wrapper loads the web game directly — there is no payment integration in this repo.
- **Game source:** The game lives entirely in `docs/index.html`. Changes there are automatically picked up by the WebView.
