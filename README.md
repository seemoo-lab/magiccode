# MagicCode

<p align="center" style="display: flex; gap: 4px; flex-wrap: nowrap;">
  <img src="https://github.com/user-attachments/assets/a72a80dd-0600-47d7-b0af-1784e6257e3b" alt="IMG_4055-portrait" style="width: 24%; height: auto;" />
  <img src="https://github.com/user-attachments/assets/a27e3931-a0b4-4c60-ab23-8102b6d23e82" alt="IMG_4056-portrait" style="width: 24%; height: auto;" />
  <img src="https://github.com/user-attachments/assets/47090641-ee3c-409a-820a-00b494780772" alt="IMG_4060-portrait" style="width: 24%; height: auto;" />
  <img src="https://github.com/user-attachments/assets/fc12b4dd-9f31-446d-b9c1-fce584181db2" alt="IMG_4059-portrait" style="width: 24%; height: auto;" />
</p>

MagicCode is an app that mocks parts of the Apple Watch pairing process using Apple's private VisualPairing framework. This project builds on top of https://github.com/insidegui/VisualPairingHack and is part of the artifacts for *Watch Your Back: Smartwatch Impersonation Attacks in Apple's iOS Ecosystem* to be published at NDSS 2027.

## Prerequisites

To build and test the app for yourself, you need:
- an Apple account
- a computer running macOS with [Xcode](developer.apple.com/xcode/) installed
- an iPhone running iOS 15.6 or later

## Build

Building using Xcode should be straightforward. Import the project into Xcode and connect your iPhone. In the project settings under *signing and capabilities*, update the team to your personal team and/or change the app's bundle identifier if prompted. Then run the app on your target iPhone.

If prompted, follow Xcode instructions to set up a personal development team and/or change the app's bundle identifier.

> [!NOTE]
> While the app will launch in the iOS Simulator, scanning actual codes only works on real iPhones.

## Pre-built binaries

If you have an iPhone running iOS 15.6 or later with [TrollStore](https://github.com/opa334/TrollStore) or [TrollStore Lite](https://havoc.app/package/trollstorelite) installed, you can skip the Xcode setup and directly install the `magiccode.tipa` archive in [build](build).

## Test

To test the scanning feature, you may want to run the app on two phones simultaneously or try scanning one of the [sample videos](samples). Make sure your display is sufficiently bright when scanning the code. You should see a popup showing Apple Watch version details and Bluetooth pairing information as show in the screenshots above.  

If you have a real Apple Watch at hand that you don't mind resetting, you can also scan the code it displays during pairing.