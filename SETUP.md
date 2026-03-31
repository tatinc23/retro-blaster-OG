# Calle Miguel Shooter — iOS Setup Guide

## Open in Xcode
1. Open Xcode 15+
2. File → Open → select `/tmp/CallemiguelShooter-iOS/CallemiguelShooter.xcodeproj`

## Add Your Team ID (required to run on device or submit)
1. Click the project root (blue icon) → select **CallemiguelShooter** target → **Signing & Capabilities**
2. Under **Team**, select your Apple Developer account
   - Or open `CallemiguelShooter.xcodeproj/project.pbxproj` and replace both `REPLACE_WITH_TEAM_ID` with your 10-character Team ID (found at developer.apple.com → Account → Membership)

## Add Stripe Payment Links
Open `CallemiguelShooter/StripeHandler.swift` and replace the 3 placeholder URLs with your real Stripe Payment Links.

In Stripe Dashboard, set the "After payment" redirect URL for each Payment Link to:
- 50 gems link  → `callemiguel://stripe-success?gems=50`
- 120 gems link → `callemiguel://stripe-success?gems=120`
- 300 gems link → `callemiguel://stripe-success?gems=300`

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

## Test on Simulator
1. Select any iPhone simulator in Xcode toolbar
2. ▶ Build & Run — game loads fullscreen. Shop shows "Stripe not configured yet." until links are added.

## Test on Device
1. Connect iPhone via USB, select it in Xcode toolbar
2. ▶ Build & Run (requires Team ID set above)

## Submit to App Store
1. Product → Archive
2. Distribute App → App Store Connect → Upload
3. In App Store Connect: Category = Games → Action, Age rating = 4+, add Privacy Policy URL

## External Payment Note
This app uses Stripe Payment Links opened in Safari (SFSafariViewController).
Compliant with App Store guidelines as of 2025 for US apps (Epic v. Apple ruling).
No StoreKit/IAP required.
